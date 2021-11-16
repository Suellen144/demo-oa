package com.reyzar.oa.common.timer;

import java.math.BigDecimal;
import java.net.InetAddress;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.reyzar.oa.dao.IFinResultsRecognitionDao;
import com.reyzar.oa.dao.IFinRevenueRecognitionDao;
import com.reyzar.oa.dao.JobManagerDao;
import com.reyzar.oa.domain.FinResultsRecognition;
import com.reyzar.oa.domain.FinRevenueRecognition;

@Component
@Lazy(value = false)
public class IncomeAndResults {
	
	@Autowired
	private JobManagerDao jobManagerDao;
	@Autowired
	private IFinRevenueRecognitionDao iFinRevenueRecognitionDao;
	@Autowired
	private IFinResultsRecognitionDao iFinResultsRecognitionDao;
	
	
	
	private final static Logger logger = Logger.getLogger(InsertKpiTimer.class);
	private static String serverIp = null;
	 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
	 
	static {
		// 获取服务器的IP地址，便于后续追踪
		try {
			InetAddress address = InetAddress.getLocalHost();
			serverIp = address.getHostAddress();
		} catch (Exception e) {
			logger.error("获取服务器IP地址有误！！");
			e.printStackTrace();
		}
	}
	
	@Scheduled(cron = "0 0 08 1 * ?")
	public void task() {
		logger.info("job start");
		String jobName = "收入确认与业绩贡献";
		long startTime = new Date().getTime();
		try {
			if (canExecute(jobName)) {
				generateMethods();
				logger.info(jobName + "执行完成，耗时:" + (new Date().getTime() - startTime) + "毫秒！");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void generateMethods() throws ParseException {
		String updateDate="";
		List<FinRevenueRecognition> finRevenueRecognitions=iFinRevenueRecognitionDao.findByConfirmWay();
		if(finRevenueRecognitions!=null && finRevenueRecognitions.size()>0) {
			for (int i = 0; i < finRevenueRecognitions.size(); i++) {
				FinRevenueRecognition finRevenueRecognition=finRevenueRecognitions.get(i);
				if(finRevenueRecognition.getShareStartDate()!=null && finRevenueRecognition.getShareEndDate() !=null) {
					//计算开始到结束一共多少天
				int between=differentDays(finRevenueRecognition.getShareStartDate(),finRevenueRecognition.getShareEndDate());
				Calendar cal = Calendar.getInstance();
				cal.setTime(finRevenueRecognition.getShareStartDate());
				int startYear=cal.get(Calendar.YEAR);
				int startMonth = cal.get(Calendar.MONTH)+1;
				int startDay = cal.get(Calendar.DAY_OF_MONTH);
				Calendar cal1 = Calendar.getInstance();
				cal1.setTime( finRevenueRecognition.getShareEndDate());
				int endYear=cal1.get(Calendar.YEAR);
				int endMonth = cal1.get(Calendar.MONTH)+1;
				int endDay = cal1.get(Calendar.DAY_OF_MONTH);
				//获取一天的确认金额
				double confirmAmount=finRevenueRecognition.getConfirmAmount()/between;
				//获取一天的业绩贡献金额
				double resultsContribution=finRevenueRecognition.getResultsContribution()/between;
				//获取开始时间到当前月份 的上个月最后一天多少天 
				int between1=differentDays(finRevenueRecognition.getShareStartDate(),getNewDateByToMonth(new Date()));
				//获取开始到结束一共几个月
				int month=getMonth(finRevenueRecognition.getShareStartDate(), finRevenueRecognition.getShareEndDate());
					//开始时间到结束时间是同一个月
					if(startMonth==endMonth) {
						FinResultsRecognition finResultsRecognition=new FinResultsRecognition();
						finResultsRecognition.setConfirmAmount(conversionDouble((endDay-startDay)*confirmAmount));
						finResultsRecognition.setResultsAmount(conversionDouble((endDay-startDay)*resultsContribution));
						finResultsRecognition.setRevenueRecognitionId(finRevenueRecognition.getId());
						finResultsRecognition.setShareDate(new Date());
						finResultsRecognition.setSaleBarginManageId(finRevenueRecognition.getSaleBarginManageId());
						finResultsRecognition.setIsShown(1);
						finResultsRecognition.setConfirmPeople("系统分摊确认");
						iFinResultsRecognitionDao.save(finResultsRecognition);
					}else {
						if(between1>0) {
							FinResultsRecognition finResultsRecognition=new FinResultsRecognition();
							finResultsRecognition.setConfirmAmount(conversionDouble(between1*confirmAmount));
							finResultsRecognition.setResultsAmount(conversionDouble(between1*resultsContribution));
							finResultsRecognition.setRevenueRecognitionId(finRevenueRecognition.getId());
							finResultsRecognition.setShareDate(new Date());
							finResultsRecognition.setSaleBarginManageId(finRevenueRecognition.getSaleBarginManageId());
							finResultsRecognition.setIsShown(1);
							finResultsRecognition.setConfirmPeople("系统分摊确认");
							finResultsRecognition.setCreateDate(new Date());
							iFinResultsRecognitionDao.save(finResultsRecognition);
						}
						//循环月份插入数据
						int startMonth1=startMonth+1;
						updateDate=startYear+"";
						for(int j=0;j<month;j++) {
							if(startMonth1 == 13) {
								updateDate=startYear+1+"";
								startMonth1 =01;
							}
							if(startMonth1<endMonth) {
								//获取该月多少天
								int startMonth2 = getDaysByYearMonth(startMonth1);
								FinResultsRecognition finResultsRecognition1=new FinResultsRecognition();
								finResultsRecognition1.setConfirmAmount(conversionDouble(startMonth2*confirmAmount));
								finResultsRecognition1.setResultsAmount(conversionDouble(startMonth2*resultsContribution));
								finResultsRecognition1.setRevenueRecognitionId(finRevenueRecognition.getId());
								finResultsRecognition1.setShareDate(df.parse(updateDate+"-"+startMonth1+"-01"));
								finResultsRecognition1.setSaleBarginManageId(finRevenueRecognition.getSaleBarginManageId());
								finResultsRecognition1.setIsShown(2);
								finResultsRecognition1.setConfirmPeople("系统分摊确认");
								finResultsRecognition1.setCreateDate(new Date());
								iFinResultsRecognitionDao.save(finResultsRecognition1);
								startMonth1++;
							}else if(startMonth1 == endMonth) {
								//如果是月份是等于结束月份，则判断结束月份的1号到结束日期差多少天
								String dateStr2=endYear+"-"+endMonth+"-01";
								//获取结束月份的天数，
								int between3=differentDays(df.parse(dateStr2),finRevenueRecognition.getShareEndDate());
								FinResultsRecognition finResultsRecognition1=new FinResultsRecognition();
								finResultsRecognition1.setConfirmAmount(conversionDouble(between3*confirmAmount));
								finResultsRecognition1.setResultsAmount(conversionDouble(between3*resultsContribution));
								finResultsRecognition1.setRevenueRecognitionId(finRevenueRecognition.getId());
								finResultsRecognition1.setShareDate(df.parse(updateDate+"-"+startMonth1+"-01"));
								finResultsRecognition1.setSaleBarginManageId(finRevenueRecognition.getSaleBarginManageId());
								finResultsRecognition1.setIsShown(2);
								finResultsRecognition1.setConfirmPeople("系统分摊确认");
								finResultsRecognition1.setCreateDate(new Date());
								iFinResultsRecognitionDao.save(finResultsRecognition1);
							}
						}
					}
				}
				//更新 FinRevenueRecognition为已执行job状态
				finRevenueRecognition.setIsJob(1);
				iFinRevenueRecognitionDao.update(finRevenueRecognition);
			}
		}
		//更新 收入确认与业绩贡献表当月的数据为显示状态
		FinResultsRecognition finResultsRecognition=new FinResultsRecognition();
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		finResultsRecognition.setShareDate(df.parse(cal.get(Calendar.YEAR)+"-"+cal.get(Calendar.MONTH)+"-01 00:00:00"));
		finResultsRecognition.setEndShareDate(df.parse(cal.get(Calendar.YEAR)+"-"+cal.get(Calendar.MONTH)+"-01 23:59:59"));
		iFinResultsRecognitionDao.updateByShareDate(finResultsRecognition);
	}
	
	private Boolean canExecute(String jobName) throws Exception {
		int max = 10000;
		int min = (int) Math.round(Math.random() * 8000);
		long sleepTime = Math.round(Math.random() * (max - min));
		String status = "on";
		Thread.sleep(sleepTime);

		if (jobManagerDao.getJobOff(jobName) == 1) {
			Map<String, Object> map = new HashMap<>();
			map.put("jobName", jobName);
			map.put("serverIp", serverIp);
			map.put("status", status);
			jobManagerDao.updateJobStatus(map);
			return true;
		}
		logger.info(jobName + "已被其他服务器执行");
		return false;
	}
	
	@Scheduled(cron = "0 0 23 1 * ?")
	public void change() {
		String jobName = "收入确认与业绩贡献";
		String status = "off";
		Map<String, Object> map = new HashMap<>();
		if(jobManagerDao.getJobOff(jobName) == 0) {
			map.put("jobName", jobName);
			map.put("serverIp", serverIp);
			map.put("status", status);
			jobManagerDao.updateJobStatus(map);
		}
	}
	
	public double conversionDouble(double dbe) {
		BigDecimal b = new BigDecimal(dbe);
		return b.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
	}
	
	/**
     * date2比date1多的天数
     * @param date1    
     * @param date2
     * @return    
     */
    public static int differentDays(Date date1,Date date2){
        Calendar cal1 = Calendar.getInstance();
        cal1.setTime(date1);
        Calendar cal2 = Calendar.getInstance();
        cal2.setTime(date2);
        int day1= cal1.get(Calendar.DAY_OF_YEAR);
        int day2 = cal2.get(Calendar.DAY_OF_YEAR);
        int year1 = cal1.get(Calendar.YEAR);
        int year2 = cal2.get(Calendar.YEAR);
        if(year1 != year2) {   //同一年
            int timeDistance = 0 ;
            for(int i = year1 ; i < year2 ; i ++){
                if(i%4==0 && i%100!=0 || i%400==0) {    //闰年            
                    timeDistance += 366;
                }else {    //不是闰年
                    timeDistance += 365;
                }
            }
            return timeDistance + (day2-day1) ;
        }else {    //不同年
            return day2-day1;
        }
    }
    /**
               * 获取两个日期相差几个月
     * @param start
     * @param end
     * @return
     */
    public static int getMonth(Date start, Date end) {
        if (start.after(end)) {
            Date t = start;
            start = end;
            end = t;
        }
        Calendar startCalendar = Calendar.getInstance();
        startCalendar.setTime(start);
        Calendar endCalendar = Calendar.getInstance();
        endCalendar.setTime(end);
        Calendar temp = Calendar.getInstance();
        temp.setTime(end);
        temp.add(Calendar.DATE, 1);
        int year = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
        int month = endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);
        if ((startCalendar.get(Calendar.DATE) == 1)&& (temp.get(Calendar.DATE) == 1)) {
            return year * 12 + month + 1;
        } else if ((startCalendar.get(Calendar.DATE) != 1) && (temp.get(Calendar.DATE) == 1)) {
            return year * 12 + month;
        } else if ((startCalendar.get(Calendar.DATE) == 1) && (temp.get(Calendar.DATE) != 1)) {
            return year * 12 + month;
        } else {
            return (year * 12 + month - 1) < 0 ? 0 : (year * 12 + month);
        }
    }
	/**
	 * 获取某月多少天
	 * @param month
	 * @return
	 */
    public int getDaysByYearMonth(int month) {
    	Calendar a =Calendar.getInstance();
    	a.set(Calendar.MONTH, month- 1);
    	a.set(Calendar.DATE, 1);
    	a.roll(Calendar.DATE,-1);
    	int maxDate =a.get(Calendar.DATE);
    	return maxDate;
     }
    /**
     * 
               * 描述:获取下一个月的第一天.
     * 
     * @return
     */
    public String getPerFirstDayOfMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, 1);
        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
        return df.format(calendar.getTime());
    }
    /**
     * 
               * 描述:获取本月最后一天
     * 
     * @return
     */
    public static String getMonthLastDay() { 
        Calendar calendar = Calendar.getInstance(); 
        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));  
        return new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime()); 
        } 
    
    public static Date getNewDateByToMonth(Date date) {
		Calendar c = Calendar.getInstance();
		//设置为指定日期
		c.setTime(date);
		//指定日期月份减去一
		c.add(Calendar.MONTH, -1);
		//指定日期月份减去一后的 最大天数
		c.set(Calendar.DATE, c.getActualMaximum(Calendar.DATE));
		//获取最终的时间
		Date lastDateOfPrevMonth = c.getTime();
		return lastDateOfPrevMonth;
    }
    
    public static void main(String[] args) {
		
	}

}
