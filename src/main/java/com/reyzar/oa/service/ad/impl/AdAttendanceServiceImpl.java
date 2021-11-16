package com.reyzar.oa.service.ad.impl;

import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.AdAtravelDto;
import com.reyzar.oa.common.dto.AttendanceRecordDTO;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.DateUtils;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.ExportexcelUtil;
import com.reyzar.oa.common.util.JsonMapper;
import com.reyzar.oa.common.util.JsonResult;
import com.reyzar.oa.dao.IAdAttendanceDao;
import com.reyzar.oa.dao.IAdLeaveDao;
import com.reyzar.oa.dao.IAdLegalHolidayDao;
import com.reyzar.oa.dao.IAdLegworkDao;
import com.reyzar.oa.dao.IAdOverTimeDao;
import com.reyzar.oa.dao.IAdTravelDao;
import com.reyzar.oa.domain.AdAttendance;
import com.reyzar.oa.domain.AdLeave;
import com.reyzar.oa.domain.AdLegalHoliday;
import com.reyzar.oa.domain.AdLegwork;
import com.reyzar.oa.domain.AdOverTime;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdAttendanceService;

/**
 * 
 * @Description: 上下班excel导入
 * @author Lairongfa
 * @date 2016年9月9日 上午10:53:47
 *
 */

@Service
@Transactional
public class AdAttendanceServiceImpl implements IAdAttendanceService {
	@Autowired
	IAdAttendanceDao attendancedao;
	@Autowired
	IAdLegalHolidayDao legalHolidayDao;
	@Autowired
	IAdTravelDao travelDao;
	@Autowired
	IAdLegworkDao legworkDao;
	@Autowired
	IAdLeaveDao leaveDao;
	@Autowired
	IAdOverTimeDao overTimeDao;

	/* 根据文件名将excel解析为List对象 */
	@Override
	public List<Map<String, Object>> importexcel(String filename) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			list = ExcelUtil.readExcel(filename);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// 考勤表的入库
	@Override
	public CrudResultDTO save(AdAttendance adAttendance, String uploadpath) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "入库成功！");
		try {
			//每次导入之前清空原来的数据
			attendancedao.delete();
			List<Map<String, Object>> dataList = importexcel(uploadpath);
			List<AdAttendance> tempList = new ArrayList<AdAttendance>();
//			String flagDate = ((String) dataList.get(0).get("3")).substring(0, 7);
			for (Map<String, Object> map : dataList) {
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("userName", map.get("1"));
				AttendanceRecordDTO AttendanceRecord = attendancedao.getAdAttendanceDTO2(param);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				Date inductionTime = new Date();
				//当天入职，判断条件
				String format = "";
				if(!StringUtils.isEmpty(AttendanceRecord)){
					inductionTime = AttendanceRecord.getEntryTime();
					format = sdf.format(inductionTime);
				}
				
				String baginTime = "";
				String endTime = "";
				adAttendance = new AdAttendance();
				adAttendance.setName((String) map.get("1"));
				adAttendance.setDept((String) map.get("2"));
				Date date2=parseStringToDate((String) map.get("3"));
				String date=DateUtils.dateToStr(date2, "yyyy-MM-dd");
				adAttendance.setDate(date);
				baginTime = date + " 09:00";
				endTime = date + " 18:00";
				long minutes = 0;
				long beforminutes = 0;
				if (map.get("4") != null && !"".equals(map.get("4"))) {
					String seDate = (String) map.get("4");
					String[] arr = seDate.split(" ");
					adAttendance.setStartTime(date + " " + arr[0]);
					adAttendance.setEndTime(date + " " + arr[arr.length - 1]);
					String baginDate = date + " " + arr[0];
					String endDate = date + " " + arr[arr.length - 1];
					long minutes1=0;
					//判断入职时间是否等于当天
					if(format.equals(date)){//如果入职时间与打卡时间为同一天，则不进行迟到时长计算
						minutes1 = 0;
					}else{
						minutes1 = getLateTime(baginDate, baginTime,endDate) > 0 ? getLateTime(baginDate, baginTime,endDate) : 0;//迟到时间
					}
					long minutes2 = getDate(endDate, endTime,baginDate) > 0 ? getDate(endDate, endTime,baginDate) :0 ;//早退时间
					minutes = Math.abs(minutes1);
					beforminutes = Math.abs(minutes2);
				}
				adAttendance.setLatetime(String.valueOf(minutes));//迟到分钟
				adAttendance.setBeforlateTime(String.valueOf(beforminutes));//早退分钟
				/*String flag = judgeDate((String) map.get("3"), legalHolidays);//判断是否是法定节假日或休息日
																			//1：代表是休息日        2：代表是法定节假日      3：代表是假前或假后加班时间
				if ("0".equals(flag) && ("".equals(((String) map.get("4"))) || ((String) map.get("4")) == null)) {
					adAttendance.setIsFlag("4");			//4：代表是上班时间，而未打卡
				} else if (("0".equals(flag) || "3".equals(flag)) && (minutes >= 60)) {
					adAttendance.setIsFlag("5");			//5:代表是上班时间已打卡，但是迟到或早退超过60分钟
				} else {
					adAttendance.setIsFlag(flag);
				}*/
				/*if ("".equals(((String) map.get("4"))) || ((String) map.get("4")) == null) {
					adAttendance.setIsFlag("4");			//4：代表是上班时间，而未打卡
				} else if ((minutes+beforminutes) >= 60) {
					adAttendance.setIsFlag("5");			//5:代表是上班时间已打卡，但是迟到或早退超过60分钟
				}*/
				tempList.add(adAttendance);
			}
			attendancedao.save(tempList);
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, e.getMessage());
		}
		return result;
	}
	
	/**
	 * 考勤表的入库(升级版-【支持.xls && .xlsx 导入】,且无需考虑导入的文件路径问题)
	 */
	@Override
	public String save2(Map<String, Object> param,MultipartFile[] uploadfile) {
		JsonResult result = new JsonResult();
		result.setMsg("导入成功!");
		MultipartFile file = uploadfile[0];
		String fileName = file.getOriginalFilename();
		if (file.isEmpty()) {
			result.setError("导入失败!");
		}else if (fileName.toLowerCase().endsWith(".xls") || fileName.toLowerCase().endsWith(".xlsx")){
			try {
				//每次导入之前清空原来的数据
				attendancedao.delete();
				MultipartFile excelFile = uploadfile[0];
				InputStream inputStream = excelFile.getInputStream();
//				Workbook wb = WorkbookFactory.create(inputStream);
				Workbook wb = null;
		        if(fileName.toLowerCase().endsWith(".xlsx")){
		        	wb = new XSSFWorkbook(inputStream);
		        }else if(fileName.toLowerCase().endsWith(".xls")){
		        	wb = new HSSFWorkbook(inputStream);
		        }
				Sheet sheet = wb.getSheetAt(0);
				int lastRows = sheet.getLastRowNum();
				for(int i = 0; i <= lastRows; i++){
					Row row = sheet.getRow(i);
					if(i!=0 && row != null){
						String name = null;
						Cell nameCell = row.getCell(0);
						name = getStringCelVal(nameCell);
						
						String dept = null;
						Cell deptCell = row.getCell(1);
						dept = getStringCelVal(deptCell);
						
						String date = null;
						Cell dateCell = row.getCell(2);
						date = getStringCelVal(dateCell);
						
						String time = null;
						Cell timeCell = row.getCell(3);
						time = getStringCelVal(timeCell);
						
//						System.out.println("姓名："+name+",部门："+dept+",日期："+date+",时间："+time);
						
						Map<String, Object> param2 = new HashMap<String, Object>();
						param2.put("userName", name);
						AttendanceRecordDTO AttendanceRecord = attendancedao.getAdAttendanceDTO2(param2);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						Date inductionTime = new Date();
						//当天入职，判断条件
						String format = "";
						if(!StringUtils.isEmpty(AttendanceRecord)){
							inductionTime = AttendanceRecord.getEntryTime();
							format = sdf.format(inductionTime);
						}
						
						String baginTime = "";
						String endTime = "";
						Map<String,Object> mapParam = new HashMap<String,Object>();
						mapParam.put("name", name);
						mapParam.put("dept", dept);
						
						Date date2 = parseStringToDate(date);
						String date3 = DateUtils.dateToStr(date2, "yyyy-MM-dd");
						mapParam.put("date", date3);
						baginTime = date3 + " 09:00";
						endTime = date3 + " 18:00";
						long minutes = 0;
						long beforminutes = 0;
						
						if (time != null && !"".equals(time)) {
							String seDate = time;
							String[] arr = seDate.split(" ");
							//判断当天在OA里是否出差，如果出差，则不储存开始时间和结束时间
							//出差表查询
							Map<String, Object> generalMap = new HashMap<String, Object>();
							generalMap.put("userName", name);
							generalMap.put("generalMonth", date3.substring(0, 7));  
							List<AdAtravelDto> adAtravelDtos = travelDao.findByAdAttendanceName(generalMap);
							boolean isSave=false;
							for (int j = 0; j < adAtravelDtos.size(); j++) {
								if(DateUtils.isEffectiveDate(DateUtils.strToDate("yyyy-MM-dd HH:mm",date3+" 00:00"), adAtravelDtos.get(j).getBeginDate(), adAtravelDtos.get(j).getEndDate())) {
									isSave=true;
								}
							}
							if(!isSave) {
								mapParam.put("startTime", date3 + " " + arr[0]);
								mapParam.put("endTime", date3 + " " + arr[arr.length - 1]);
							}
							String baginDate = date3 + " " + arr[0];
							String endDate = date3 + " " + arr[arr.length - 1];
							long minutes1 = 0;
							//判断入职时间是否等于当天
							if(format.equals(date3)){  //如果入职时间与打卡时间为同一天，则不进行迟到时长计算
								minutes1 = 0;
							}else{
								minutes1 = getLateTime(baginDate, baginTime,endDate) > 0 ? getLateTime(baginDate, baginTime,endDate) : 0;  //迟到时间
							}
							long minutes2 = getDate(endDate, endTime,baginDate) > 0 ? getDate(endDate, endTime,baginDate) :0 ;  //早退时间
							minutes = Math.abs(minutes1);
							beforminutes = Math.abs(minutes2);
						}
						mapParam.put("latetime", String.valueOf(minutes));  //迟到分钟
						mapParam.put("beforlateTime", String.valueOf(beforminutes));  //早退分钟
						mapParam.put("isFlag", null);
						//保存
						attendancedao.save2(mapParam);
					}
				}
				System.out.println("成功导入考勤数据"+lastRows+"条！");
				result.setTotal(lastRows);
			}catch (Exception e) {
				result.setError("读取文件错误：" + e.getMessage());
				e.printStackTrace();
			}
		}else{
			result.setError("导入文件必须是扩展名为：.xls或.xlsx的Excel文件!");
		}
		return JsonMapper.toJsonString(result);
	}
	
	private String getStringCelVal(Cell cell){
		String value = null;
		if(cell != null){
			if(cell.getCellType() != Cell.CELL_TYPE_STRING){
				DataFormatter formatter = new DataFormatter();
				value = formatter.formatCellValue(cell);
			}else{
				value = cell.getStringCellValue();
			}
		}
		return value;
	}

	//得出早退时间
	public long getDate(String baginDate, String baginTime,String endDate) throws ParseException {
		SimpleDateFormat sfd = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		Date d1 = sfd.parse(baginDate);
		Date d2 = sfd.parse(baginTime);
		long diff = 0;
		Date d3=DateUtils.strToDate("yyyy-MM-dd HH:mm", endDate);
		if(d1.getTime() == d3.getTime()){
			return (long)((1000*4*60*60)/(1000 * 60));
		}
		String day = DateUtils.dateToStr(d1, "yyyy-MM-dd");
		//请假开始时间小于或等于当天12:30
		if(d1.getTime() <= DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 12:30").getTime()){
			diff = DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 12:30").getTime() - d1.getTime() + (1000*60*4*60);// 这样得到的差值是微秒级别
		//请假开始时间大于当天14:00	
		}else if(d1.getTime() > DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 14:00").getTime()){
			diff = (long)(d2.getTime() - d1.getTime());
		}else{
			diff = (1000*60*4*60);// 这样得到的差值是微秒级别
		}
		long minutes = (diff) / (1000 * 60);
		return minutes;
	}
	
	// 得出迟到时间
	public long getLateTime(String baginDate, String baginTime,String endDate) throws ParseException {
			long diff = 0;
			SimpleDateFormat sfd = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date d1 = sfd.parse(baginDate);  //第一次打卡时间
			Date d2 = sfd.parse(baginTime);  //上班时间9:00
			String day = DateUtils.dateToStr(d1, "yyyy-MM-dd");
			Date d3 = DateUtils.strToDate("yyyy-MM-dd HH:mm", endDate);  //最后一次打卡时间
			if(d1.getTime() == d3.getTime()){
				return (long)(1000*3.5*60*60)/(1000 * 60);
			}
			if(d1.getTime() <= DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 12:30").getTime()){//如果小于或等于12:30
				diff = d1.getTime() - d2.getTime();// 这样得到的差值是微秒级别      拿第一次打卡时间减去上班 时间9：00
			}else if(d1.getTime()>DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 14:00").getTime()){//如果大于中午14:00
				diff = (long)(d1.getTime() - DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 14:00").getTime() + (1000*3.5*60*60));
			}else{
				diff = (long)(1000*3.5*60*60);
			}
			long minutes = (diff) / (1000 * 60);
			return minutes;
		}

	// 判断是否是法定假日或休息日或假后加班日
	public List<AdAttendance> judgeDate(List<AdAttendance> adAttendances, List<AdLegalHoliday> legalHolidays) throws ParseException {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		for (AdAttendance adAttendance : adAttendances) {
			String flag = "0";
			Date dateCheck = format.parse(adAttendance.getDate());
			Calendar c = Calendar.getInstance();
			c.setTime(dateCheck);
			if ((c.get(Calendar.DAY_OF_WEEK) == 1) || (c.get(Calendar.DAY_OF_WEEK) - 1 == 6)) {
				flag = "1";
			}
			for (AdLegalHoliday adLegalHoliday : legalHolidays) {
				Calendar cl = Calendar.getInstance();
				Calendar c2 = Calendar.getInstance();
				cl.setTime(adLegalHoliday.getEndDate());
				c2.setTime(adLegalHoliday.getStartDate());
				if (dateCheck.getTime() >= adLegalHoliday.getStartDate().getTime()
						&& dateCheck.getTime() <= adLegalHoliday.getEndDate().getTime()) {
					//打卡时间  大于等于  假日开始时间  并且  打卡时间 小于等于 假日结束时间
					flag = "2";
					break;
				} else {
					if(adLegalHoliday.getBeforeLeave() != null && !"".equals(adLegalHoliday.getBeforeLeave())){
						String beforeDate = format.format(adLegalHoliday.getBeforeLeave());//假前加班
						if (adAttendance.getDate().equals(beforeDate)) {
							flag = "3";
							break;
						}
					}
					if(adLegalHoliday.getAfterLeave() != null && !"".equals(adLegalHoliday.getAfterLeave())){
						String afterDate = format.format(adLegalHoliday.getAfterLeave());  //假后加班
						if (adAttendance.getDate().equals(afterDate)) {
							flag = "3";
							break;
						}
					}
				}
			}
			if(flag == "1"){
				adAttendance.setLatetime("0");
				adAttendance.setBeforlateTime("0");
			}
			if ("0".equals(flag) && (adAttendance.getStartTime() == null)) {
				adAttendance.setIsFlag("4");  //4：代表是上班时间，而未打卡
			} else if (("0".equals(flag) || "3".equals(flag)) && ((Integer.parseInt(adAttendance.getLatetime()) + Integer.parseInt(adAttendance.getBeforlateTime())) >= 60)) {
				adAttendance.setIsFlag("5");  //5:代表是上班时间已打卡，但是迟到或早退超过60分钟
			} else {
				adAttendance.setIsFlag(flag);
			}
		}
		return adAttendances;
	}

	//得出考勤表
	@Override
	public CrudResultDTO getList() {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "获取数据成功！");
		List<String> userNames = attendancedao.getAdAttendanceName();  //获取人员考勤名字
		Map<String, Object> paramMap = Maps.newHashMap();
		if (userNames.size() > 0) {
			paramMap.put("userNames", userNames);
		}
		List<AttendanceRecordDTO> attendanceRecordDTOs = attendancedao.getAdAttendanceDTO(paramMap);  //展示数据
		List<AdAttendance> adAttendances = attendancedao.getAdattendance();  //在考勤机上导入数据
		Map<String, Object> paramsMap1 = Maps.newHashMap();
		String month = "";
		if(adAttendances.size() > 0){
			//获取年月
			month = adAttendances.get(0).getDate().substring(0, 7);
			paramsMap1.put("dateBelongs", month);
			/*paramsMap1.put("dateBelongs", "");*/
		}
		List<AdLegalHoliday> legalHolidays1 = legalHolidayDao.getLegalHolidays(paramsMap1);
		try {
			adAttendances = judgeDate(adAttendances,legalHolidays1);  //判断是否是法定假日或休息日或假后加班日
		} catch (ParseException e) {
			e.printStackTrace();
		}
		//attendancedao.batchUpdate(adAttendances);
		
		Map<String, Object> generalMap = Maps.newHashMap();
		List<Integer> userIds = Lists.newArrayList();
		if (attendanceRecordDTOs.size() > 0) {
			for (AttendanceRecordDTO aDto : attendanceRecordDTOs) {
				userIds.add(aDto.getUserId());
			}
		}
		generalMap.put("userIds", userIds);
		generalMap.put("generalMonth", month);  //查找与该月对应的数据
		List<AdAtravelDto> adAtravelDtos = travelDao.findByParam(generalMap);
		List<AdLegwork> legworks = legworkDao.findByParam(generalMap);
		List<AdLeave> leaves = leaveDao.findByParam(generalMap);
		
		adAttendances = checkLegWork(adAttendances, legworks);	//外勤[考勤机上导入的数据与系统中的外勤数据进行校验]
		adAttendances = checkTravel(adAttendances, adAtravelDtos);  //出差[考勤机上导入的数据与系统中的出差数据进行校验]
		adAttendances = checkLeave(adAttendances, leaves);  //请假[考勤机上导入的数据与系统中的请假数据进行校验]
		attendanceRecordDTOs = sum(adAttendances,attendanceRecordDTOs);  //考勤机校验后的数据与需要展示的数据进行统计 
		List<AdAttendance> attendanceList = adAttendances;
		attendanceRecordDTOs = statAttendance(attendanceList, attendanceRecordDTOs, generalMap);  //查找统计
		
		String beginDate = attendanceList.get(0).getDate().substring(5);
		String endDate = attendanceList.get(attendanceList.size() - 1).getDate().substring(5);
		String year = attendanceList.get(0).getDate().substring(0, 4);
		String calcMonth = attendanceList.get(0).getDate().substring(5, 7);
		Integer saleDays = calcDays(year, calcMonth,adAttendances.get(adAttendances.size() - 1).getDate());
		
		//法定节假日判断
		Map<String, Object> paramsMap = Maps.newHashMap();
		paramsMap.put("dateBelongs", attendanceList.get(0).getDate().substring(0, 7));  //属于法定假日时间
		List<AdLegalHoliday> legalHolidays = legalHolidayDao.getHolidays(paramsMap);  //法定假日
		Integer legal = 0;
		if (legalHolidays.size() > 0) {
			for (AdLegalHoliday adLegalHoliday : legalHolidays) {
				legal += adLegalHoliday.getNumberDays();//放假天数
			}
		}
		
		Map<String, Object> map = Maps.newHashMap();
		map.put("beginDate", beginDate);//考勤统计时段起
		map.put("endDate", endDate);//考勤统计时段止
		map.put("year", year);//年
		map.put("calcMonth", calcMonth);//月
		map.put("saleDays", saleDays);//满勤天数
		
		map.put("legal", legal);//法定 放假天数
		map.put("legalHolidays", legalHolidays);//法定假日
		
		if("市场部".equals(attendanceRecordDTOs.get(0).getDeptName())){
			List<SysUser> users = attendancedao.findUser();
			for (AttendanceRecordDTO attendanceRecordDTO : attendanceRecordDTOs) {
				boolean flag = true;
				for (SysUser sysUser : users) {
					if(attendanceRecordDTO.getUserNmae().equals(sysUser.getName())){
						flag = false;
						break;
					}
				}
				if(flag){
					attendanceRecordDTO.setLayTime(0);
					attendanceRecordDTO.setNumberLate(0);
				}
			}
		}
		for (AttendanceRecordDTO attendanceRecordDTO : attendanceRecordDTOs) {
			if((attendanceRecordDTO.getSchuqin() + legal + calcDayByTime(attendanceRecordDTO.getThisRestTime())) > saleDays) {
				attendanceRecordDTO.setEememberPay((double)saleDays);
			}else {
				attendanceRecordDTO.setEememberPay((double)(attendanceRecordDTO.getSchuqin()+ legal + calcDayByTime(attendanceRecordDTO.getRestTimeConvert())));
			}
			for (AdLegalHoliday adLegalHoliday : legalHolidays) {
				if(attendanceRecordDTO.getEntryTime().getTime()>adLegalHoliday.getEndDate().getTime()
					&& attendanceRecordDTO.getEntryTime().getTime() != (adLegalHoliday.getAfterLeave() == null?0:adLegalHoliday.getAfterLeave().getTime())){
					//入职时间 小于 假期结束日期  并且 入职时间 不等于 假后加班时间
					attendanceRecordDTO.setEememberPay(attendanceRecordDTO.getSchuqin() +calcDayByTime(attendanceRecordDTO.getLeaveFlag())+ calcDayByTime(attendanceRecordDTO.getRestTimeConvert()));
				}else{
					double days = (double)(attendanceRecordDTO.getSchuqin() + legal +calcDayByTime(attendanceRecordDTO.getLeaveFlag())+ calcDayByTime(attendanceRecordDTO.getRestTimeConvert()));
					attendanceRecordDTO.setEememberPay(days);  //设置记薪天数
				}
			}
		}
		map.put("attendanceRecordDTOs", attendanceRecordDTOs);
		result = new CrudResultDTO(CrudResultDTO.SUCCESS, map);
		return result;
	}
	
	@SuppressWarnings("unused")
	private static List<Date> dateSplit(java.util.Date start, Date end) throws Exception {
		if (!start.before(end))
			throw new Exception("开始时间应该在结束时间之后");
		    Long spi = end.getTime() - start.getTime();
		    Long step = spi / (24 * 60 * 60 * 1000);// 相隔天数

		    List<Date> dateList = new ArrayList<Date>();
		    dateList.add(end);
		    for (int i = 1; i <= step; i++) {
		    	dateList.add(new Date(dateList.get(i - 1).getTime() - (24 * 60 * 60 * 1000)));// 比上一天减一
		    }
		return dateList;
	}
	
	//
	public List<AttendanceRecordDTO> sum(List<AdAttendance> unAdAttendances,List<AttendanceRecordDTO> attendanceRecordDTOs){
		for (AttendanceRecordDTO attendanceRecordDTO : attendanceRecordDTOs) {//遍历需要进行展示的数据
			int sum = 0;
			for (AdAttendance adAttendance : unAdAttendances) {//遍历 考勤机校验后的数据
				if(attendanceRecordDTO.getUserNmae().equals(adAttendance.getName())){//如果需要展示数据的用户名等于 考勤机校验后数据的名字
					if(!"1".equals(adAttendance.getIsFlag())&&!"2".equals(adAttendance.getIsFlag())){//判断是否节假日 0：否 
						sum++;
					}
				}
			}
			attendanceRecordDTO.setSum(sum);
		}
		return attendanceRecordDTOs;
	}
	
	// 与外勤进行匹配
	public List<AdAttendance> checkLegWork(List<AdAttendance> unAdAttendances, List<AdLegwork> legworks) {
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		for (AdAttendance adAttendance : unAdAttendances) {//遍历考勤机上导入的数据
			for (AdLegwork adLegwork : legworks) {//遍历系统中的外勤数据
				//如果外勤开始时间<=导入的外勤开始时间    并且   外勤结束时间>=导入的外勤开始时间  并且  导入的外勤名字等于申请外勤人的名字
				if (DateUtils.dateToDate(adLegwork.getStartTime(), "yyyy-MM-dd").getTime() <= DateUtils.strToDate("yyyy-MM-dd", adAttendance.getDate()).getTime()
						&&DateUtils.dateToDate(adLegwork.getEndTime(), "yyyy-MM-dd").getTime() >= DateUtils.strToDate("yyyy-MM-dd", adAttendance.getDate()).getTime()
						&& adAttendance.getName().equals(adLegwork.getApplyPeople())) {
 					if(adAttendance.getStartTime() !="" && !"".equals(adAttendance.getStartTime())){  //开始时间不为空
						adAttendance.setIsFlag("0");//判断是否是节假日
						adAttendance.setLatetime("0");//迟到时长
						adAttendance.setBeforlateTime("0");//早退时长
					}else{
						adAttendance.setIsFlag("0");
						adAttendance.setLatetime(Integer.parseInt(adAttendance.getLatetime()) - calcMinute(adLegwork.getStartTime(), adLegwork.getEndTime())+"");
						adAttendance.setBeforlateTime("0");
					}
				}
			}
		}
		return unAdAttendances;
	}

	//计算时间
	public int calcMinute(Date startDate,Date endDate){
		int minute=(int) ((endDate.getTime()-startDate.getTime())/(1000*60));
		return minute;
	}
	
	// 与出差进行匹配
	public List<AdAttendance> checkTravel(List<AdAttendance> unAdAttendances, List<AdAtravelDto> adAtravelDtos) {
		SimpleDateFormat sfd = new SimpleDateFormat("yyyy-MM-dd");
		try {
			for (AdAtravelDto atravelDto : adAtravelDtos) {  //遍历出差数据
				String startTime = sfd.format(atravelDto.getBeginDate());
				String endTime = sfd.format(atravelDto.getEndDate());
				Date startDate = sfd.parse(startTime);
				Date endDate = sfd.parse(endTime);
				for (AdAttendance adAttendance : unAdAttendances) {  //遍历考勤机导入的数据
					if(adAttendance.getName().equals(atravelDto.getUserName())){  //如果考勤机导入的名字等于出差的用户名
						Date checkDate = sfd.parse(adAttendance.getDate());
						//如果考勤机导入的时间>=出差开始时间  并且  考勤机导入的时间<=出差结束时间
						if(checkDate.getTime() >= startDate.getTime() && checkDate.getTime() <= endDate.getTime()){
							if (( !"1".equals(adAttendance.getIsFlag()) && !"2".equals(adAttendance.getIsFlag()) || "3".equals(adAttendance.getIsFlag()))) {
								adAttendance.setIsFlag("7");  //用于计算出差天数
								adAttendance.setLatetime("0");
								adAttendance.setBeforlateTime("0");
							}else if("1".equals(adAttendance.getIsFlag())){
								adAttendance.setIsFlag("8");  //用于计算出差天数
								adAttendance.setLatetime("0");
								adAttendance.setBeforlateTime("0");
							}else if("2".equals(adAttendance.getIsFlag())){
								adAttendance.setIsFlag("9");  //用于计算出差天数
								adAttendance.setLatetime("0");
								adAttendance.setBeforlateTime("0");
							}
							if(adAttendance.getStartTime() != null && !"".equals(adAttendance.getStartTime()) &&
								adAttendance.getEndTime() != null && !"".equals(adAttendance.getEndTime()) &&
								!adAttendance.getStartTime().equals(adAttendance.getEndTime())){
								adAttendance.setIsTrave(true);
							}
						}
					}
				}
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return unAdAttendances;
	}

	// 与请假进行匹配
	public List<AdAttendance> checkLeave(List<AdAttendance> unAdAttendances, List<AdLeave> leaves) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		for (AdAttendance attendance : unAdAttendances) {  //遍历导入的请假数据
			Double restTime = 0.0;
			Double leaveTime = 0.0;
			for (AdLeave adLeave : leaves) {  //遍历系统中的请假数据
				Date checkDate;
				try {
					checkDate = sdf.parse(attendance.getDate());
					String startTime = sdf.format(adLeave.getStartTime());
					String endTime = sdf.format(adLeave.getEndTime());
					Date startDate = sdf.parse(startTime);
					Date endDate = sdf.parse(endTime);
					//如果导入的时间（即与导入的每一天数据进行比较）>=请假开始时间    并且   导入的时间<=结束时间   并且   导入的名字=请假人的名字  并且   是否节假日  不等于1
					if (checkDate.getTime() >= startDate.getTime() && checkDate.getTime() <= endDate.getTime()
							&& attendance.getName().equals(adLeave.getApplicant().getName()) && !"1".equals(attendance.getIsFlag())) {
							//设置该天请假时间
							leaveTime = calcHoure(attendance, adLeave);  //算出每天的请假时间
							if ("2".equals(adLeave.getLeaveType())) {  //2：调休
								if (adLeave.getDays() != null) {  //请假天数不为空
									if (adLeave.getDays() >= 1) {  //请假天数大于等于1
										restTime = restTime + (7.5 * adLeave.getDays());  //按每天7.5小时计算
									} else {
										restTime += adLeave.getHours();  //小时相加
									}
								} else {  //请假天数为空
									restTime += adLeave.getHours();  //只需把小时相加即可
								}
								attendance.setLeaveTime(7.5);  //设置请假那天工作时间
							}
							//if (adLeave.getDays() != null) {  //请假天数不为空
							if (adLeave.getDays() >= 1 ) {  //请假天数>=1
								attendance.setLeaveTime(7.5 - (7.5 * adLeave.getDays()));  //请假那天的工作时间
								//attendance.setLeaveTime(0.0);
							} else { //请假天数小于1
								/*if(attendance.getLeaveFlag() != 7.5) {
									attendance.setLeaveTime(attendance.getLeaveFlag() - adLeave.getHours());
								}else {*/
									attendance.setLeaveTime(7.5 - adLeave.getHours());  //请假那天的工作时间
								//}
							}
							/*}else{//请假天数小于1
								attendance.setLeaveTime(7.5 - adLeave.getHours());  //请假那天的工作时间
							}*/
						attendance.setLeaveType(adLeave.getLeaveType());  //设置请假类型
						if(attendance.getLeaveFlag()!=null && attendance.getLeaveFlag()!=0.0) {
							if(checkDate.getTime() == startDate.getTime()) {
								attendance.setLeaveFlag(leaveTime+attendance.getLeaveFlag());  //设置请假时长
								attendance.setLeaveTime(7.5 - attendance.getLeaveFlag());
							}
						}else
							attendance.setLeaveFlag(leaveTime);  //设置请假时长
						//迟到时长!=0，并且 大于30分钟
						if(!"0".equals(attendance.getLatetime()) && Integer.parseInt(attendance.getLatetime()) > 30){
							//如果请假结束时间大于签到时间
							if(adLeave.getEndTime().getTime() > DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getStartTime()).getTime()){
								attendance.setLatetime("0");
							}else{
								//请假结束时间为12:30
								if(DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getDate()+" 12:30").getTime() == adLeave.getEndTime().getTime()){
									//签到时间小于等于14:00
									if(DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getStartTime()).getTime() <= DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getDate()+" 14:00").getTime()){
										attendance.setLatetime("0");
									}else{
										SimpleDateFormat sfd = new SimpleDateFormat("yyyy-MM-dd HH:mm");
										Date d1 = sfd.parse(attendance.getStartTime());
										String day = DateUtils.dateToStr(d1, "yyyy-MM-dd");
										Date d2 = sfd.parse(day+" 14:00");
										//如果打卡时间大于等于当天下午上班时间，则 打卡时间减去下午上班时间
										if(d1.getTime()>=d2.getTime()) {
											attendance.setLatetime((d1.getTime()-d2.getTime())/ (1000 * 60)+"");
										}
										//attendance.setLatetime(getDate(attendance.getStartTime(), DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm"), DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm"))+"");
									}
								}else{
									attendance.setLatetime(getDate(attendance.getStartTime(), DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm"), DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm"))+"");
								}
							}
						}
						if(!"0".equals(attendance.getBeforlateTime())){  //早退时长 !=0
							//如果请假开始时间小于签退时间
							if(adLeave.getStartTime().getTime() < DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getEndTime()).getTime()){
								attendance.setBeforlateTime("0");
							//如果签退时间>=12:30   并且  < 14：:00  并且  请假开始时间==14：00
							}else if((DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getEndTime()).getTime() >= DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getDate()+" 12:30").getTime())&&
								(DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getEndTime()).getTime() < DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getDate()+" 14:00").getTime()) &&
								(adLeave.getStartTime().getTime() == DateUtils.strToDate("yyyy-MM-dd HH:mm", attendance.getDate()+" 14:00").getTime())){
								attendance.setBeforlateTime("0");  //设置早退时长为0
							}else{
								attendance.setBeforlateTime(getDate(DateUtils.dateToStr(adLeave.getStartTime(), "yyyy-MM-dd HH:mm"), attendance.getEndTime(), attendance.getStartTime())+"");
							}
						}
						/*adLeave.setDays(0);  //重置请假天数
						adLeave.setHours(0.0);  //重置请假小时
*/						attendance.setIsFlag("6");  //判断是否是节假日
						//签到时间不为空 并且 签退时间不为空 并且 签到时间不等于签退时间
						if(attendance.getStartTime() != null && !"".equals(attendance.getStartTime()) &&
							attendance.getEndTime() != null && !"".equals(attendance.getEndTime()) &&
							!attendance.getStartTime().equals(attendance.getEndTime())){
							//计算每天的上班时间
							double flagHour = hourOfDay(attendance.getDate(), attendance.getStartTime(), attendance.getEndTime());
							if(flagHour >= 7){  //大于7小时
								if("2".equals(adLeave.getLeaveType())){  //请假类型为2：调休
									attendance.setIsRest(true);  //是否推迟休假
								}else{
									attendance.setIsLeave(true);  //是否推迟请假
								}
							}
						}
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			attendance.setRestTime(restTime);  //设置调休时间
		}
		return unAdAttendances;
	}

	// 考勤表的更新
	public void updateAttendance(List<AdAttendance> adAttendances) {
		attendancedao.batchUpdate(adAttendances);
	}

	// 查找统计
	public List<AttendanceRecordDTO> statAttendance(List<AdAttendance> attendanceList,
			List<AttendanceRecordDTO> attendanceRecordDTOs, Map<String, Object> generalMap) {
		//查询本月加班记录
		List<AdOverTime> overTimes = overTimeDao.findByParam(generalMap);  
		//查询本月请假记录
		List<AdLeave> leaves = leaveDao.findByParam(generalMap);  
		//查询本月假期
		List<AdLegalHoliday> legalHolidays = legalHolidayDao.getLegalHolidays(generalMap); 
		//查询本月请假记录
		List<AdLeave> flagLeave = leaveDao.findLeaveByParam(generalMap);  
		//attendanceList = checkLeave(attendanceList, leaves);
		//获取年月
		String searchDate = (String) generalMap.get("generalMonth");
		String flag = ((String) generalMap.get("generalMonth")).substring(0, 7);
		searchDate = searchDate + "-01 00:00:00";
		generalMap.put("generalMonth", searchDate);
		//查询本月之前的加班记录
		List<AdOverTime> oldOverTimes = overTimeDao.findAllByParam(generalMap);  
		//查询本月前调休请假记录
		List<AdLeave> restLeave = leaveDao.findRestByParam(generalMap);
		//获取年
		generalMap.put("generalMonth", searchDate.substring(0, 4));
		//查询本年假记录
		List<AdLeave> thisYearLeave = leaveDao.findYearLeave(generalMap);  
		//查询去年假记录
		generalMap.put("generalMonth", Integer.parseInt(searchDate.substring(0, 4))-1);
		List<AdLeave> lastYearLeave = leaveDao.findYearLeave(generalMap);  
		for (AttendanceRecordDTO attendanceRecordDTO : attendanceRecordDTOs) {
			int countLateTime = 0;  //迟到、早退时间总和
			int countLate = 0;  //迟到、早退次数
			Double schuqin = 0.0;  //实际上班
			Double nuPunchCard = 0.0;  //未打卡次数
			Double restTime = 0.0;  //调休时间
			Double overTime = 0.0;  //本月加班时间
			Double oldOverTime = 0.0;  //上月加班时间
			Double oldRestTime = 0.0;  //上月调休时间
			Double practice = 0.0;  //实习天数
			Double tryOn = 0.0;  //试用天数
			Double positive = 0.0;  //转正天数
			Double travelDays = 0.0;  //出差天数
			String remarks = "";
			Map<String, Object> leaveDays = Maps.newHashMap();
			boolean isSameYear = false;
			boolean isSameMonth = false;
			Calendar calendar = Calendar.getInstance();  //试用到期日期
			SimpleDateFormat sDateFormat = new SimpleDateFormat("yyy-MM-dd");
			SimpleDateFormat sDateFormat2 = new SimpleDateFormat("yyyy-MM");
			Calendar calendar4 = Calendar.getInstance();
			calendar4.setTime(DateUtils.dateToDate(attendanceRecordDTO.getEntryTime(), "yyyy-MM"));
			calendar4.add(Calendar.MONTH, 3);
			@SuppressWarnings("unused")
			boolean isEquality = false; //是否在试用期（true：在; false: 不在）
			calendar.setTime(attendanceRecordDTO.getEntryTime());
			calendar.add(Calendar.MONTH, 3);//试用期结束
			Calendar calendar2 = Calendar.getInstance();
			try {
				calendar2.setTime(sDateFormat2.parse(flag));
				isSameYear = calendar.get(Calendar.YEAR) == calendar2.get(Calendar.YEAR);
				isSameMonth = isSameYear && calendar.get(Calendar.MONTH) >= calendar2.get(Calendar.MONTH);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			if(calendar4.getTime().getTime() > calendar2.getTime().getTime()){
				isEquality = true;
			}
			
			Double casualLeave = 0.0;//事假
			Double sickLeave = 0.0;//病假
			Double marriageLeave = 0.0;//婚假
			Double maternityLeave = 0.0;//产假
			Double paternityLeave = 0.0;//陪产假
			Double funeralLeave = 0.0;//丧假
			Double yearLeave = 0.0;//年假
			//因分上午3.5下午4 为了合并成一天，先进行效验
			double leaveFlag=0.0;
			double leaveFlagSum=0.0;
			double paternityLeave1 = 0.0;//陪产假 1
			for (AdAttendance adAttendance : attendanceList) {
				if (attendanceRecordDTO.getUserNmae().equals(adAttendance.getName())) {
				try {
					if(!"9".equals(adAttendance.getIsFlag()) && !"8".equals(adAttendance.getIsFlag()) && !"2".equals(adAttendance.getIsFlag()) && !"1".equals(adAttendance.getIsFlag()) 
							&& attendanceRecordDTO.getEntryTime().getTime() <= sDateFormat.parse(adAttendance.getDate()).getTime()){
					if(!"".equals(adAttendance.getLeaveFlag()) && adAttendance.getLeaveFlag() != null){
						//如果有陪产假，则需要减去陪产假小时
						for(AdLegalHoliday AdLegalHoliday:legalHolidays) {
							if(DateUtils.isEffectiveDate(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 00:00"), AdLegalHoliday.getStartDate(), AdLegalHoliday.getEndDate())) {
								paternityLeave1+=7.5;
								break;
							}
						}
							double leaveTime=7.5-adAttendance.getLeaveFlag();//获取请假那天工作时间
								leaveFlag+=adAttendance.getLeaveFlag();
								if(leaveFlag>=7.5 || leaveFlag==7) {
									if(leaveTime==0 || leaveTime==3.5||leaveTime==4)
										leaveFlagSum+=7.5;
									else
										leaveFlagSum+=leaveFlag;
									if(leaveFlag!=8 & leaveFlag!=7) {
										leaveFlag=leaveFlag%7.5;
									}else
										leaveFlag=0.0;
								}
							}
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				}
			}
			leaveFlag=leaveFlag+leaveFlagSum;
			for (AdAttendance adAttendance : attendanceList) {
				if (attendanceRecordDTO.getUserNmae().equals(adAttendance.getName())) {
					try {
						/*int latetime = Integer.parseInt(adAttendance.getLatetime());
						int beforlateTime = Integer.parseInt(adAttendance.getBeforlateTime());
						int sum = latetime + beforlateTime;
						Double date = (double)sum/60;*/
						if(!"9".equals(adAttendance.getIsFlag()) && !"8".equals(adAttendance.getIsFlag()) && !"2".equals(adAttendance.getIsFlag()) && !"1".equals(adAttendance.getIsFlag()) 
								&& attendanceRecordDTO.getEntryTime().getTime() <= sDateFormat.parse(adAttendance.getDate()).getTime()){
							//计算
//							if(!"".equals(adAttendance.getLeaveFlag()) && adAttendance.getLeaveFlag() != null){
//								schuqin = (7.5 - adAttendance.getLeaveFlag()) + schuqin;
//							}else{
								if((adAttendance.getStartTime() != null && adAttendance.getEndTime() != null) || "6".equals(adAttendance.getIsFlag())) {
									schuqin += 7.5;
								}else {
									//判断没有签到开始和签到结束时间的日期是否周末
									//如果不是，则去外勤和出差表查询是否有数据，有的话则算出勤
									//if(!DateUtils.isWeekend(adAttendance.getDate())){
										boolean isPersonnel=false;
										//获取date外勤数据
										AdLegwork adLegwork=new AdLegwork();
										List<AdLegwork> adLegworkList=legworkDao.findByAdAttendance(attendanceRecordDTO.getUserId(),adAttendance.getDate());
										for (int i = 0; i < adLegworkList.size(); i++) {
											adLegwork=adLegworkList.get(i);
											//外勤开始时间小于等于正常上班时间,结束时间大于等于正常下班时间，则是全天外勤
											if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 09:00").getTime()>=
													DateUtils.strToDate("yyyy-MM-dd HH:mm",DateUtils.dateToStr(adLegwork.getStartTime(),"yyyy-MM-dd HH:mm")).getTime()
													&&DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 18:00").getTime()<=
													DateUtils.strToDate("yyyy-MM-dd HH:mm",DateUtils.dateToStr(adLegwork.getEndTime(),"yyyy-MM-dd HH:mm")).getTime()){
												schuqin += 7.5;
												isPersonnel=true;
											}else if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 09:00").getTime()>=
												DateUtils.strToDate("yyyy-MM-dd HH:mm",DateUtils.dateToStr(adLegwork.getStartTime(),"yyyy-MM-dd HH:mm")).getTime()
												&&DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 18:00").getTime()<=
														DateUtils.strToDate("yyyy-MM-dd HH:mm",DateUtils.dateToStr(adLegwork.getEndTime(),"yyyy-MM-dd HH:mm")).getTime()) {
												//如果外勤开始时间大于正常上班时间并且 外勤结束时间大于正常下班时间，则是下午外勤
												Map<String,Long> map=DateUtils.getDatePoor(adLegwork.getEndTime(), adLegwork.getStartTime());
												Long hour=map.get("hour");
												Long min=map.get("min");
												if(min == 30)
													schuqin += hour+0.5;
												else
													schuqin += hour;
												isPersonnel=true;
											}else if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 09:00").getTime()>=
													DateUtils.strToDate("yyyy-MM-dd HH:mm",DateUtils.dateToStr(adLegwork.getStartTime(),"yyyy-MM-dd HH:mm")).getTime()
													&&DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 18:00").getTime()>=
															DateUtils.strToDate("yyyy-MM-dd HH:mm",DateUtils.dateToStr(adLegwork.getEndTime(),"yyyy-MM-dd HH:mm")).getTime()){
												//如果外勤开始时间小于正常上班时间并且 外勤结束时间小于正常下班时间，则是上午外勤
												Map<String,Long> map=DateUtils.getDatePoor(adLegwork.getEndTime(), adLegwork.getStartTime());
												Long hour=map.get("hour");
												Long min=map.get("min");
												if(min == 30)
													schuqin += hour+0.5;
												else
													schuqin += hour;
												isPersonnel=true;
											}
										}
										if(!isPersonnel) {
											//出差表查询
											generalMap.put("userId", attendanceRecordDTO.getUserId());
											generalMap.put("generalMonth", adAttendance.getDate().substring(0, 7));  //查找与该天对应的数据
											List<AdAtravelDto> adAtravelDtos = travelDao.findByAdAttendance(generalMap);
											for (int i = 0; i < adAtravelDtos.size(); i++) {
												if(DateUtils.isEffectiveDate(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 00:00"), adAtravelDtos.get(i).getBeginDate(), adAtravelDtos.get(i).getEndDate())) {
													schuqin += 7.5;
													break;
												}
											}
										}
									//}
								}
							//}
						}
					} catch (ParseException e2) {
						e2.printStackTrace();
					}
					if(adAttendance.getIsFlag().equals("7") || adAttendance.getIsFlag().equals("8") || "9".equals(adAttendance.getIsFlag())){
						travelDays += 1;
					}
					if(attendanceRecordDTO.getEntryTime().getTime() < DateUtils.strToDate("yyyy-MM-dd",adAttendance.getDate()).getTime()){
						if ("4".equals(adAttendance.getIsFlag()) ) {
							nuPunchCard++;
						}
						if("5".equals(adAttendance.getIsFlag())){
							if(adAttendance.getStartTime().equals(adAttendance.getEndTime())){
								remarks += adAttendance.getDate().substring(8,10 )+"、";
								//签到时间大于等于12:30 并且小于等于14:00
								if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 12:30").getTime() <= DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime() &&
									DateUtils.strToDate( "yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime() <= DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 14:00").getTime()){  
									nuPunchCard++;
									adAttendance.setLatetime("0");
									adAttendance.setBeforlateTime("0");
								//签到时间小于12:30
								}else if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 12:30").getTime() > DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime()){
									nuPunchCard += 0.5;
									//签到时间小于等于09:00
									if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 09:00").getTime() >= DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime()){
										adAttendance.setLatetime("0");
										adAttendance.setBeforlateTime("0");
									}else{
										adAttendance.setLatetime(calcMitue(adAttendance.getStartTime(),adAttendance.getDate()+" 09:00")+"");
										adAttendance.setBeforlateTime("0");
									}
								//签到时间大于14:00
								}else if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 14:00").getTime() < DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime()){
									nuPunchCard += 0.5;
									//签到时间小于等于18:00
									if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 18:00").getTime() >= DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime()){
										adAttendance.setLatetime("0");
										adAttendance.setBeforlateTime(calcMitue(adAttendance.getDate()+" 18:00",adAttendance.getStartTime())+"");
									}else{
										adAttendance.setLatetime("0");
										adAttendance.setBeforlateTime("0");
									}
								}
							}else{
								if(Integer.parseInt(adAttendance.getLatetime()) >= 210){
									nuPunchCard += 0.5;
									adAttendance.setLatetime(Integer.parseInt(adAttendance.getLatetime())-210+"");
								}
								if(Integer.parseInt(adAttendance.getBeforlateTime()) >= 240){
									nuPunchCard += 0.5;
									adAttendance.setBeforlateTime(Integer.parseInt(adAttendance.getBeforlateTime())-240+"");
								}
							}
						}
					}
					/*restTime += adAttendance.getRestTime();*/
					if(attendanceRecordDTO.getEntryStatus() == 1){  //实习期
						practice = schuqin;
					}
					if(!"1".equals(attendanceRecordDTO.getEntryStatus()) && isSameMonth && (((!"".equals(adAttendance.getStartTime()) && adAttendance.getStartTime() != null) && 
							(!"".equals(adAttendance.getEndTime()) && adAttendance.getEndTime() != null)) || "7".equals(adAttendance.getIsFlag()) || 
							"8".equals(adAttendance.getIsFlag()) || "9".equals(adAttendance.getIsFlag()) || "6".equals(adAttendance.getIsFlag()))){
						Calendar calendar3 = Calendar.getInstance();
						try {
							calendar3.setTime(sDateFormat.parse(adAttendance.getDate()));
							if(calendar3.before(calendar)){ 
								tryOn += 1;
							}else { 
								if(adAttendance.getIsFlag() != "1") {
									positive += 1;
								}
							}
						} catch (ParseException e) {
							e.printStackTrace();
						}
					}
					
					if("0".equals(adAttendance.getLeaveType())){
						casualLeave += adAttendance.getLeaveFlag();
					}else if("3".equals(adAttendance.getLeaveType())){
						sickLeave += adAttendance.getLeaveFlag();
					}else if("4".equals(adAttendance.getLeaveType())){
						marriageLeave += adAttendance.getLeaveFlag();
					}else if("5".equals(adAttendance.getLeaveType())){
						maternityLeave += adAttendance.getLeaveFlag();
					}else if("6".equals(adAttendance.getLeaveType())){
						paternityLeave  += adAttendance.getLeaveFlag();
					}else if("7".equals(adAttendance.getLeaveType())||"8".equals(adAttendance.getLeaveType())){
						funeralLeave += adAttendance.getLeaveFlag();
					}else if("1".equals(adAttendance.getLeaveType())){
						yearLeave += adAttendance.getLeaveFlag();
					}
					if(adAttendance.getIsTrave()){
						attendanceRecordDTO.setIsTrave(true);
					}
					if(adAttendance.getIsLeave()){
						attendanceRecordDTO.setIsLeave(true);
					}
					if(adAttendance.getIsRest()){
						attendanceRecordDTO.setIsRest(true);
					}
					if (!"0".equals(adAttendance.getLatetime())) {
						//判断迟到，如果上班卡时间大于上午正常上班时间，则验证是否请假或者调休
						boolean isFlagLeave=false;
						if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime() > DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 09:00").getTime()) {
							for (AdLeave adLeave : flagLeave) {
								if (attendanceRecordDTO.getUserNmae().equals(adLeave.getApplicant().getName())) {
									isFlagLeave=DateUtils.isEffectiveDate(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()),
											adLeave.getStartTime(), adLeave.getEndTime());
								}
							}
						}
						if(!isFlagLeave){
							countLateTime += Integer.parseInt(adAttendance.getLatetime());
							countLate++;
						}
					}
					if(!"0".equals(adAttendance.getBeforlateTime())){
						//判断早退，如果下班卡时间小于正常下班时间，则验证是否请假或者调休
						boolean isFlagLeave=false;
						if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getEndTime()).getTime() < DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 18:00").getTime()) {
							for (AdLeave adLeave : flagLeave) {
								if (attendanceRecordDTO.getUserNmae().equals(adLeave.getApplicant().getName())) {
									if(DateUtils.strToDate("yyyy-MM-dd",adAttendance.getStartTime()).getTime() == DateUtils.strToDate("yyyy-MM-dd",DateUtils.dateToStr(adLeave.getStartTime(),"yyyy-MM-dd HH:mm")).getTime()) {
										//下班卡时间小于上班时间，则下班未打卡
										if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getEndTime()).getTime()<DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getDate()+" 09:00").getTime()) {
											if(DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getStartTime()).getTime() < adLeave.getStartTime().getTime()
													&&DateUtils.strToDate("yyyy-MM-dd HH:mm",adAttendance.getEndTime()).getTime() < adLeave.getEndTime().getTime()) {
												isFlagLeave=true;
											}
										}
									}
								}
							}
						}
						if(!isFlagLeave){
						countLateTime += Integer.parseInt(adAttendance.getBeforlateTime());
						countLate++;
						}
					}
				}
			}
			if(schuqin>=leaveFlag)
			schuqin=schuqin-leaveFlag;
//			if(schuqin>paternityLeave1 && paternityLeave!=0.0)
//			schuqin=schuqin-(paternityLeave-paternityLeave1);
			for (AdOverTime adOverTime : overTimes) {//本月加班时间
				if (attendanceRecordDTO.getUserNmae().equals(adOverTime.getApplicant().getName())) {
					double count = 0;
					if (adOverTime.getDays() != null) {
						if (adOverTime.getDays() > 1 || adOverTime.getDays() == 1) {
							count= 7.5;
						} else {
							count= adOverTime.getHours();
						}
					}else{
						count= adOverTime.getHours();
					}
					if(checkOverTime(adOverTime, legalHolidays)){//判断加班时间是否为法定放假时间
						count *= 3;
					}
					overTime += count;
				}
			}

			for (AdOverTime adOverTime : oldOverTimes) {//本月前加班时间
				if (attendanceRecordDTO.getUserNmae().equals(adOverTime.getApplicant().getName())) {
					double count = 0;
					if (adOverTime.getDays() != null) {
						if (adOverTime.getDays() > 1 || adOverTime.getDays() == 1) {
							count = 7.5*adOverTime.getDays();
						} else {
							count = adOverTime.getHours();
						}
					}else {
						count = adOverTime.getHours();
					}
					if(checkOverTime(adOverTime, legalHolidays)){
						count *= 3;
					}
					oldOverTime += count;
				}
			}

			for (AdLeave adLeave : restLeave) {//本月前的调休时间
				if (attendanceRecordDTO.getUserNmae().equals(adLeave.getApplicant().getName())) {
					/*if (adLeave.getDays() != null) {
						if (adLeave.getDays() > 1 || adLeave.getDays() == 1) {
							oldRestTime += 7.5;
						} else {
							oldRestTime += adLeave.getHours();
						}
					}else {
						oldRestTime += adLeave.getHours();
					}*/
					oldRestTime += calcHoure(DateUtils.dateToStr(adLeave.getStartTime(), "yyyy-MM-dd HH:mm"),DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm"),legalHolidays);
				}
			}
		
			for (AdLeave adLeave : flagLeave) {//本月的调休时间
				if (attendanceRecordDTO.getUserNmae().equals(adLeave.getApplicant().getName())) {
					if("2".equals(adLeave.getLeaveType())){
						restTime += calcHoure(DateUtils.dateToStr(adLeave.getStartTime(), "yyyy-MM-dd HH:mm:ss"),DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm:ss"),legalHolidays);	
					}
				}
			}
			leaveDays.put("casualLeave", calcDayByTime(casualLeave));//事假天数
			leaveDays.put("sickLeave", calcDayByTime(sickLeave));//病假
			leaveDays.put("marriageLeave", calcDayByTime(marriageLeave));//婚假
			leaveDays.put("maternityLeave", calcDayByTime(maternityLeave));//产假
			leaveDays.put("paternityLeave", calcDayByTime(paternityLeave));//陪产假
			leaveDays.put("funeralLeave", calcDayByTime(funeralLeave));//丧假
			leaveDays.put("yearLeave", calcDayByTime(yearLeave));//年假
			//leaveDays=createLeaveMap(attendanceRecordDTO,flagLeave,searchDate);
//			leaveDays.put("practice", practice);
			/*if(isEquality){
				tryOn=calcDayByTime(schuqin);
			}*/
			leaveDays.put("tryOn", tryOn);//试用天数
			leaveDays.put("practice", practice);//实习天数
			leaveDays.put("positive", positive);//转正天数
			leaveDays.put("traveDays",travelDays);//出差天数
			leaveDays.put("thisYearLeave", calaYearLeave(attendanceRecordDTO, thisYearLeave, legalHolidays));  //本年累休年假
			leaveDays.put("lastYearLeave", calaYearLeave(attendanceRecordDTO, lastYearLeave, legalHolidays));  //去年累休年假
			
			if(attendanceRecordDTO.getEntryStatus() != 1 && attendanceRecordDTO.getEntryStatus() != 2){  //在职状态不为：实习、试用 
				Date start = DateUtils.dateToDate(attendanceRecordDTO.getEntryTime(), "yyyy-MM-dd");
				Date end = DateUtils.dateToDate(new Date(), "yyyy-MM-dd");
				int years = (int)((end.getTime() - start.getTime()) / (1000*3600*24))/365;  //已入职几年
				double years2 = (double)((end.getTime() - start.getTime()) / (1000*3600*24))/365;  //已入职几年【精确到小数点】
				
				Date start2 = DateUtils.dateToDate(attendanceRecordDTO.getEntryTime(), "yyyy");
				Date end2 = DateUtils.dateToDate(new Date(), "yyyy");
				String yearsi = new SimpleDateFormat("yyyy").format(start2);
				String yearsi2 = new SimpleDateFormat("yyyy").format(end2);
				String yearsLastDay22 = new SimpleDateFormat("yyyy").format(start2)+"-12-31";//入职年最后一天
				Date yearsLastDay2;
				int days2 = 0;
				int days3 = 0;
				try {
					yearsLastDay2 = new SimpleDateFormat("yyyy-MM-dd").parse(yearsLastDay22);
					days2 = (int)((yearsLastDay2.getTime() - start.getTime()) / (1000*3600*24));  //当年剩余日历天数
					days3 = (int)((end.getTime() - start.getTime()) / (1000*3600*24));  //入职至今多少天
					if(days3>365)
						days3=365;
				} catch (Exception e) {
					e.printStackTrace();
				} 
				double h = 0.0;
				double h2 = 0.0;
				if(years < 1){
					leaveDays.put("shouldYearLeave", 0);
				}else if(years == 1){
					//H=5*(入职当年剩余日历天数/365);//H尾数小于0.5时舍去，大于0.5但小于1时取0.5
					String years22 = new Double(years2).toString();
					int years222 = Integer.parseInt(years22.substring(years22.indexOf(".")+1,years22.indexOf(".")+2));
					if(years222 >= 5){
						if(yearsi.equals(yearsi2)){
							h = (double)5*days3/365;
							String a = new Double(h).toString();
							int i = Integer.parseInt(a.substring(0,a.indexOf(".")));
							int ii = Integer.parseInt(a.substring(a.indexOf(".")+1,a.indexOf(".")+2));
							if(ii >= 5){
								h2 = i + 0.5;
							}else{
								h2 = i;
							}
							leaveDays.put("shouldYearLeave", h2);
						}else{
							leaveDays.put("shouldYearLeave", 5);
						}
					}else{
						h = (double)5*days3/365;
						String a = new Double(h).toString();
						int i = Integer.parseInt(a.substring(0,a.indexOf(".")));
						int ii = Integer.parseInt(a.substring(a.indexOf(".")+1,a.indexOf(".")+2));
						if(ii >= 5){
							h2 = i + 0.5;
						}else{
							h2 = i;
						}
						leaveDays.put("shouldYearLeave", h2);
					}
				}else if(1 < years && years < 10){
					leaveDays.put("shouldYearLeave", 5);
				}else if(years == 10){
					//H=5+5*(入职当年剩余日历天数/365);//H尾数小于0.5时舍去，大于0.5但小于1时取0.5
					String years22 = new Double(years2).toString();
					int years222 = Integer.parseInt(years22.substring(years22.indexOf(".")+1,years22.indexOf(".")+2));
					if(years222 >= 5){
						h = (double)5*days2/365;
						String a = new Double(h).toString();
						int i = Integer.parseInt(a.substring(0,a.indexOf(".")));
						int ii = Integer.parseInt(a.substring(a.indexOf(".")+1,a.indexOf(".")+2));
						if(ii >= 5){
							h2 = i + 0.5;
						}else{
							h2 = i;
						}
						leaveDays.put("shouldYearLeave", 5+h2);
					}else{
						h = (double)5*days2/365;
						String a = new Double(h).toString();
						int i = Integer.parseInt(a.substring(0,a.indexOf(".")));
						h2 = i;
						leaveDays.put("shouldYearLeave", 5+h2);
					}
				}else if(10 < years && years < 20){
					leaveDays.put("shouldYearLeave", 10);
				}else if(years == 20){
					//H=10+5*(入职当年剩余日历天数/365);//H尾数小于0.5时舍去，大于0.5但小于1时取0.5
					String years22 = new Double(years2).toString();
					int years222 = Integer.parseInt(years22.substring(years22.indexOf(".")+1,years22.indexOf(".")+2));
					if(years222 >= 5){
						h = (double)5*days2/365;
						String a = new Double(h).toString();
						int i = Integer.parseInt(a.substring(0,a.indexOf(".")));
						int ii = Integer.parseInt(a.substring(a.indexOf(".") + 1,a.indexOf(".")+2));
						if(ii >= 5){
							h2 = i + 0.5;
						}else{
							h2 = i;
						}
						leaveDays.put("shouldYearLeave", 10 + h2);
					}else{
						h = (double)5*days2/365;
						String a = new Double(h).toString();
						int i = Integer.parseInt(a.substring(0,a.indexOf(".")));
						h2 = i;
						leaveDays.put("shouldYearLeave", 10 + h2);
					}
				}else if(years > 20){
					leaveDays.put("shouldYearLeave", 15);
				}
				
				//本年已休年假
				leaveDays.put("alreadyYearLeave", calaYearLeave(attendanceRecordDTO, thisYearLeave, legalHolidays));
				//本年剩余年假
				Double shouldYearLeave=new Double(leaveDays.get("shouldYearLeave").toString());
				Double annualLeave=calaYearLeave(attendanceRecordDTO, thisYearLeave,legalHolidays);
				if(shouldYearLeave > annualLeave)
					leaveDays.put("residueYearLeave", shouldYearLeave - annualLeave);
				else
					leaveDays.put("residueYearLeave",0.0);
			}else{
				//本年应休年假天数
				leaveDays.put("shouldYearLeave", 0);
				//本年已休年假天数
				leaveDays.put("alreadyYearLeave", 0);
				//本年剩余年假天数
				leaveDays.put("residueYearLeave", 0);
			}
			
			attendanceRecordDTO.setLeaveType(leaveDays);  //统计请假类型的天数
			if(oldOverTime >= oldRestTime) {
				attendanceRecordDTO.setLastRemainTime(oldOverTime - oldRestTime);
			}else {
				attendanceRecordDTO.setLastRemainTime((double)0);
			}
			if((overTime + (oldOverTime - oldRestTime)) >= restTime) {
				attendanceRecordDTO.setSumRemainOverTime((overTime + (oldOverTime - oldRestTime)) - restTime);
			}else {
				attendanceRecordDTO.setSumRemainOverTime((double)0);
			}
			attendanceRecordDTO.setThisRestTime(restTime);  //本月调休时间
			int forenoon=0; //记录上午是否请假
			int afternoon=0;//记录下午是否请假
			double restTimeConvert=0.0;//调休折算时间
			for (AdLeave adLeave : flagLeave) {//折算本月调休时间
				if (attendanceRecordDTO.getUserNmae().equals(adLeave.getApplicant().getName())) {
					if("2".equals(adLeave.getLeaveType())){
						double dob= calcHoure(DateUtils.dateToStr(adLeave.getStartTime(), "yyyy-MM-dd HH:mm:ss"),DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm:ss"),legalHolidays);	
						if(dob == 3.5 || dob%7.5 ==3.5) {
							if(forenoon == 0) {
								forenoon=1;
								restTimeConvert+=dob;
							}else {
								forenoon=0;
								restTimeConvert+=dob+0.5;
							}
						}else if(dob == 4 || dob%7.5 ==4) {
							if(afternoon == 0) {
								afternoon=1;
								restTimeConvert+=dob;
							}else {
								afternoon=0;
								restTimeConvert+=dob-0.5;
							}
						}else
							restTimeConvert+=dob;
					}
				}
			}
			attendanceRecordDTO.setRestTimeConvert(restTimeConvert);
			attendanceRecordDTO.setThisOverTime(overTime);  //本月加班时间
			attendanceRecordDTO.setLayTime(countLateTime);
			attendanceRecordDTO.setNumberLate(countLate);
			attendanceRecordDTO.setSchuqin(calcDayByTime(schuqin));
			attendanceRecordDTO.setAbsent(nuPunchCard);  //旷工天数
			attendanceRecordDTO.setNuPunchCard(nuPunchCard * 2);  //未打卡次数
			attendanceRecordDTO.setRemarks(remarks + "打卡异常");
			attendanceRecordDTO.setLeaveFlag(marriageLeave+maternityLeave+funeralLeave+yearLeave+(paternityLeave-paternityLeave1));
		}
		return attendanceRecordDTOs;
	};

	//计算累计已休年假
	public Double calaYearLeave(AttendanceRecordDTO attendanceRecordDTO, List<AdLeave> flagLeave, List<AdLegalHoliday> legalHolidays){
		Double yearLeave = 0.0;
		for (AdLeave adLeave : flagLeave) {
			if((attendanceRecordDTO).getUserNmae().equals(adLeave.getApplicant().getName())){
				//yearLeave+=calcTime(adLeave.getDays(), adLeave.getHours());
				yearLeave += calcHoure(DateUtils.dateToStr(adLeave.getStartTime(), "yyyy-MM-dd HH:mm"), DateUtils.dateToStr(adLeave.getEndTime(), "yyyy-MM-dd HH:mm"), legalHolidays);
			}
		}
		return calcDayByTime(yearLeave);  //通过小时数计算天数
	}
	
	public Map<String, Object> createLeaveMap(AttendanceRecordDTO attendanceRecordDTO, List<AdLeave> flagLeave, String searchDate){
		Double casualLeave = 0.0;  //事假
		Double sickLeave = 0.0;  //病假
		Double marriageLeave = 0.0;  //婚假
		Double maternityLeave = 0.0;  //产假
		Double funeralLeave = 0.0;  //丧假
		Double yearLeave = 0.0;
		for (AdLeave adLeave : flagLeave) {
			if((attendanceRecordDTO).getUserNmae().equals(adLeave.getApplicant().getName())){
				//查看是否有跨月请假
				//1、判断开始时间是否是在本月之前
				//2、判断结束时间是否在本月之后
				if("0".equals(adLeave.getLeaveType())){
					casualLeave += calcTime(adLeave.getDays(), adLeave.getHours());
				}else if("3".equals(adLeave.getLeaveType())){
					sickLeave += calcTime(adLeave.getDays(), adLeave.getHours());
				}else if("4".equals(adLeave.getLeaveType())){
					marriageLeave += calcTime(adLeave.getDays(), adLeave.getHours());
				}else if("5".equals(adLeave.getLeaveType())){
					maternityLeave += calcTime(adLeave.getDays(), adLeave.getHours());
				}else if("7".equals(adLeave.getLeaveType())){
					funeralLeave += calcTime(adLeave.getDays(), adLeave.getHours());
				}else if("1".equals(adLeave.getLeaveType())){
					yearLeave += calcTime(adLeave.getDays(), adLeave.getHours());
				}
			}
		}
		Map<String, Object> leaveDays = Maps.newHashMap();
		leaveDays.put("casualLeave", calcDayByTime(casualLeave));
		leaveDays.put("sickLeave", calcDayByTime(sickLeave));
		leaveDays.put("marriageLeave", calcDayByTime(marriageLeave));
		leaveDays.put("maternityLeave", calcDayByTime(maternityLeave));
		leaveDays.put("funeralLeave", calcDayByTime(funeralLeave));
		leaveDays.put("yearLeave", calcDayByTime(yearLeave));
		return leaveDays;
	}
	
	//算出每天的请假时间
	public Double calcHoure(AdAttendance adAttendance, AdLeave adLeave){
		Double houre = 0.0;
		String dateTime = adAttendance.getDate();
		String normFlag = "yyyy-MM-dd HH:mm";
		Date normAMstart = DateUtils.strToDate(normFlag ,dateTime+" 09:00" );//上午上班时间
		Date normAMend = DateUtils.strToDate(normFlag,dateTime+" 12:30");//上午下班时间
		Date normPMstart = DateUtils.strToDate(normFlag, dateTime+" 14:00");//下午上班时间
		Date normPMend = DateUtils.strToDate(normFlag,dateTime+" 18:00");//下午下班时间
		
		Date leaveStart = DateUtils.dateToDate(adLeave.getStartTime(), "yyyy-MM-dd");
		Date leaveEnd = DateUtils.dateToDate(adLeave.getEndTime(), "yyyy-MM-dd");
		Date attendanceDate = DateUtils.strToDate("yyyy-MM-dd",adAttendance.getDate());
		//判断请假开始日期是否是今天
		if(leaveStart.getTime() == attendanceDate.getTime()){
			//开始时间是今日 
			//1、请假开始时间为上午
			//2、请假时间为下午
			if(adLeave.getStartTime().getTime() >= normAMstart.getTime() && adLeave.getStartTime().getTime() <= normAMend.getTime()){//请假时间在上午
				if(leaveEnd.getTime() == attendanceDate.getTime()){//判断结束时间是否是在本日
					//1、请假结束时间在上午
					//2、请假结束时间在下午
					if(adLeave.getEndTime().getTime() >= normAMstart.getTime() && adLeave.getEndTime().getTime() <= normAMend.getTime()){
						houre = (double)((adLeave.getEndTime().getTime()-adLeave.getStartTime().getTime())/(1000*60*60*1.0));
					}else if(adLeave.getEndTime().getTime() >= normPMstart.getTime() && adLeave.getEndTime().getTime() <= normPMend.getTime()){
						houre = (double)(((normAMend.getTime() - adLeave.getStartTime().getTime()))/(1000*60*60*1.0));
						houre += (adLeave.getEndTime().getTime() - normPMstart.getTime())/(1000*60*60*1.0);
					}
				}else{
					houre = (double)((normAMend.getTime() - adLeave.getStartTime().getTime())/(1000*60*60*1.0))+4;
				}
			//请假时间在下午
			}else if(adLeave.getStartTime().getTime() >= normPMstart.getTime() && adLeave.getStartTime().getTime() <= normPMend.getTime()){  
				if(leaveEnd.getTime() == attendanceDate.getTime()){
					houre = (double)((adLeave.getEndTime().getTime() - adLeave.getStartTime().getTime())/(1000*60*60*1.0));
				}else{
					houre = (double)((normPMend.getTime() - adLeave.getStartTime().getTime())/(1000*60*60*1.0));
				}
			}
		}else{
			//开始时间不是本日
			//判断结束时间是否是本日
			if(leaveEnd.getTime() == attendanceDate.getTime()){
				//1、请假结束时间在上午
				//2、请假结束时间在下午
				if(adLeave.getEndTime().getTime() >= normAMstart.getTime() && adLeave.getEndTime().getTime() <= normAMend.getTime()){
					houre = (double)((adLeave.getEndTime().getTime() - normAMstart.getTime())/(1000*60*60*1.0));
				}else if(adLeave.getEndTime().getTime() >= normPMstart.getTime() && adLeave.getEndTime().getTime() <= normPMend.getTime()){
					houre = (double)((adLeave.getEndTime().getTime()-normPMstart.getTime())/(1000*60*60*1.0))+3.5;
				}else if(adLeave.getEndTime().getTime() > normPMend.getTime()){
					houre = 7.5;
				}
			}else{//开始时间和结束时间都不是本日，则说明请假一天
				houre = 7.5;
			}
		}
		return houre;
	}
	
	//通过小时数计算天数
	public Double calcDayByTime(Double hours){
		Double day = 0.0;
		if(hours > 7.5){
			day = (double) ((int)(hours*10)/(int)(7.5*10));
			hours = hours - 7.5*day;
			if(hours == 3.5|| hours == 4){
				day += 0.5;
			}else{
				day = (day + (Math.round((hours/7.5)*10)/(double)10));
			}
		}else if(hours == 7.5){
			day = 1.0;
		}else{
			if(hours == 3.5|| hours == 4){
				day += 0.5;
			}else{
				day = (day + (Math.round((hours/7.5)*10)/(double)10));
			}
		}
		return day;
	}
	
	public Double calcTime(Integer days, Double hours){
		Double calcResult = 0.0;
		if (days != null) {
			if (days > 1 || days == 1) {
				calcResult = calcResult+(7.5*days);
			} else {
				calcResult += hours;
			}
		}else {
			calcResult += hours;
		}
		return calcResult;
	}

	
	// 计算每个月工作天数
	public Integer calcDays(String year, String months, String lastDay) {
		int count = 0;
		int month = Integer.parseInt(months);
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, Integer.parseInt(year));
		cal.set(Calendar.MONTH, month - 1);
		cal.set(Calendar.DATE, 1);
		
		Calendar cal2 = Calendar.getInstance();
		cal2.setTime(DateUtils.strToDate("yyyy-MM-dd",lastDay));
		while (cal.get(Calendar.MONTH) < month && cal.get(Calendar.DAY_OF_MONTH) <= cal2.get(Calendar.DAY_OF_MONTH)) {
			int day = cal.get(Calendar.DAY_OF_WEEK);

			if (!(day == Calendar.SUNDAY || day == Calendar.SATURDAY)) {
				count++;
			}
			cal.add(Calendar.DATE, 1);
		}
		return count;
	}

	// 计算加班时间、补休时间
	public List<AdAttendance> calcOverTime(List<AdAttendance> adAttendances, List<AdOverTime> overTimes) {
		return adAttendances;
	}
	
	// 算出请假时间
	public Double calcHoure(String startTime, String endTime, List<AdLegalHoliday> legalHolidays) {
		Double houre = 0.0;
		String normFlag = "yyyy-MM-dd HH:mm";
		// 请假开始、结束时间
		Date startDate = DateUtils.strToDate(normFlag, startTime);
		Date endDate = DateUtils.strToDate(normFlag, endTime);
		String dateTime = "";
		// 判断请假开始时间和结束时间是否是在同一天
		if(DateUtils.dateToDate(startDate, "yyyy-MM-dd").getTime() == DateUtils.dateToDate(endDate, "yyyy-MM-dd").getTime()) {
			dateTime = DateUtils.dateToStr(startDate, "yyyy-MM-dd");
			Date normAMstart = DateUtils.strToDate(normFlag, dateTime + " 09:00");  // 上午上班时间
			Date normAMend = DateUtils.strToDate(normFlag, dateTime + " 12:30");  // 上午下班时间
			Date normPMstart = DateUtils.strToDate(normFlag, dateTime + " 14:00");  // 下午上班时间
			Date normPMend = DateUtils.strToDate(normFlag, dateTime + " 18:00");  // 下午下班时间
			//开始时间是今日
			//1、请假开始时间为上午
			//2、请假时间为下午
			if (startDate.getTime() <= normAMend.getTime()) {// 请假时间在上午
				//1、请假结束时间在上午
				//2、请假结束时间在下午
				if (endDate.getTime() >= normAMstart.getTime() && endDate.getTime() <= normAMend.getTime()) {
					if(startDate.getTime() < normAMstart.getTime()){
						houre = (double)((endDate.getTime() - normAMstart.getTime()) / (1000 * 60 * 60 * 1.0));
					}else{
						houre = (double)((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 1.0));
					}
				} else if (endDate.getTime() >= normPMstart.getTime() && endDate.getTime() <= normPMend.getTime()) {
					if(startDate.getTime() < normAMstart.getTime()){
						houre = (double)((normAMend.getTime() - normAMstart.getTime()) / (1000 * 60 * 60 * 1.0));
					}else{
						houre = (double)(((normAMend.getTime() - startDate.getTime())) / (1000 * 60 * 60 * 1.0));
					}
					houre += (endDate.getTime() - normPMstart.getTime()) / (1000 * 60 * 60 * 1.0);
				}
			} else if (startDate.getTime() >= normPMstart.getTime() && startDate.getTime() <= normPMend.getTime()) {// 请假时间在下午
				houre = (double)((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 1.0));
			}
		} else {// 开始时间和结束时间不在同一天
			// 1、计算出开始当天请假时间
			// 2、计算后面所请时间
			dateTime=DateUtils.dateToStr(startDate, "yyyy-MM-dd");
			Date normAMstart = DateUtils.strToDate(normFlag, dateTime + " 09:00");  //上午上班时间
			Date normAMend = DateUtils.strToDate(normFlag, dateTime + " 12:30");  //上午下班时间
			Date normPMstart = DateUtils.strToDate(normFlag, dateTime + " 14:00");  //下午上班时间
			Date normPMend = DateUtils.strToDate(normFlag, dateTime + " 18:00");  //下午下班时间
			if (startDate.getTime() >= normAMstart.getTime() && startDate.getTime() <= normAMend.getTime()) {  //请假时间在上午
				houre = (double)(((normAMend.getTime() - startDate.getTime())) / (1000 * 60 * 60 * 1.0))+4;
			} else if (startDate.getTime() >= normPMstart.getTime() && startDate.getTime() <= normPMend.getTime()) {  //请假时间在下午
				houre = (double)((normPMend.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 1.0));
			}
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(DateUtils.dateToDate(startDate, "yyyy-MM-dd"));
			calendar.add(Calendar.DAY_OF_MONTH, +1);
			Calendar calendar2 = Calendar.getInstance();
			calendar2.setTime(DateUtils.dateToDate(endDate, "yyyy-MM-dd"));
			while(calendar.getTime().getTime() <= calendar2.getTime().getTime()){
				dateTime = DateUtils.dateToStr(calendar.getTime(), "yyyy-MM-dd");
				normAMstart = DateUtils.strToDate(normFlag, dateTime + " 09:00");  //上午上班时间
				normAMend = DateUtils.strToDate(normFlag, dateTime + " 12:30");  //上午下班时间
				normPMstart = DateUtils.strToDate(normFlag, dateTime + " 14:00");  //下午上班时间
				normPMend = DateUtils.strToDate(normFlag, dateTime + " 18:00");  //下午下班时间
				//判断是否是休息日或法定假日
				if(checkDateRest(calendar.getTime(),legalHolidays)){
					//1、该天与结束日期相等
					if(calendar.getTime().getTime() == calendar2.getTime().getTime()){
						// 1、请假结束时间在上午
						// 2、请假结束时间在下午
						if (endDate.getTime() >= normAMstart.getTime() && endDate.getTime() <= normAMend.getTime()) {
							houre += (double) ((endDate.getTime() - normAMstart.getTime()) / (1000 * 60 * 60 * 1.0));
						} else if (endDate.getTime() >= normPMstart.getTime()&& endDate.getTime() <= normAMend.getTime()) {
							houre += (endDate.getTime() - normPMstart.getTime()) / (1000 * 60 * 60 * 1.0)+3.5;
						}else{
							houre += 7.5;
						}
					}else{	//2、该天与结束日期不相等
						houre += 7.5;
					}
				}
				calendar.add(Calendar.DAY_OF_MONTH, +1);
			}
		}
		return houre;
	}
		
	// 判断请假开始时间与结束时间是否为休息日或法定休息日
	public boolean checkDateRest(Date checkTime, List<AdLegalHoliday> legalHolidays) {
		boolean flag = true;
		Calendar calendar = Calendar.getInstance();
		Date check = DateUtils.dateToDate(checkTime, "yyyy-MM-dd");
		calendar.setTime(check);

		for (AdLegalHoliday adLegalHoliday : legalHolidays) {
			Calendar cl = Calendar.getInstance();
			Calendar c2 = Calendar.getInstance();
			cl.setTime(adLegalHoliday.getEndDate());
			c2.setTime(adLegalHoliday.getStartDate());
				
			if (check.getTime() >= adLegalHoliday.getStartDate().getTime() && check.getTime() <= adLegalHoliday.getEndDate().getTime()) {
				return false;
			} else {
				if ((calendar.get(Calendar.DAY_OF_WEEK) == 1) || (calendar.get(Calendar.DAY_OF_WEEK) - 1 == 6)) {
					flag=false;
					if (adLegalHoliday.getBeforeLeave() != null && !"".equals(adLegalHoliday.getBeforeLeave())) {
						if (check.getTime() == adLegalHoliday.getBeforeLeave().getTime()) {
							flag=true;
						}
					}
					if (adLegalHoliday.getAfterLeave() != null && !"".equals(adLegalHoliday.getAfterLeave())) {
						if (check.getTime() == adLegalHoliday.getAfterLeave().getTime()) {
							flag=true;
						}
					}
				}
			}
		}
		return flag;
	}

	@Override
	public void exportExcel(ServletOutputStream out) {
		try {
			CrudResultDTO result = getList();
			@SuppressWarnings("unchecked")
			Map<String, Object> resultMap = (Map<String, Object>) result.getResult();
			@SuppressWarnings("unchecked")
			List<AttendanceRecordDTO> dataList = (List<AttendanceRecordDTO>) resultMap.get("attendanceRecordDTOs");
			@SuppressWarnings("unchecked")
			List<AdLegalHoliday> legalHolidays = (List<AdLegalHoliday>) resultMap.get("legalHolidays");
//			Calendar calendar =  Calendar.getInstance();
			int i = 0;
			if("市场部".equals(dataList.get(0).getDeptName())){
				List<SysUser> users = attendancedao.findUser();
				for (AttendanceRecordDTO attendanceRecordDTO : dataList) {
					boolean flag = true;
					for (SysUser sysUser : users) {
						if(attendanceRecordDTO.getUserNmae().equals(sysUser.getName())){
							flag = false;
							break;
						}
					}
					if(flag){
						attendanceRecordDTO.setLayTime(0);
						attendanceRecordDTO.setNumberLate(0);
					}
					attendanceRecordDTO.setCount(i+1);
					i++;
				}
			}else{
				for (AttendanceRecordDTO attendanceRecordDTO : dataList) {
					attendanceRecordDTO.setCount(i+1);
					i++;
				}
			}
			for (AttendanceRecordDTO attendanceRecordDTO : dataList) {
				for (AdLegalHoliday adLegalHoliday : legalHolidays) {
					if(attendanceRecordDTO.getEntryTime().getTime() > adLegalHoliday.getEndDate().getTime()
						&& attendanceRecordDTO.getEntryTime().getTime() != (adLegalHoliday.getAfterLeave() == null?0:adLegalHoliday.getAfterLeave().getTime())){
						attendanceRecordDTO.setEememberPay(attendanceRecordDTO.getSchuqin() +calcDayByTime(attendanceRecordDTO.getLeaveFlag())+ calcDayByTime(attendanceRecordDTO.getRestTimeConvert()));
					}else{
						double days = (double)(attendanceRecordDTO.getSchuqin()+(int)resultMap.get("legal") +calcDayByTime(attendanceRecordDTO.getLeaveFlag())+ calcDayByTime(attendanceRecordDTO.getRestTimeConvert()));
						attendanceRecordDTO.setEememberPay(days);
					}
				}
				if("打卡异常".equals(attendanceRecordDTO.getRemarks())){
					attendanceRecordDTO.setRemarks("");
				}
			}
			Context context = new Context();
			context.putVar("year", resultMap.get("year"));
			context.putVar("calcMonth", resultMap.get("calcMonth") );
			context.putVar("beginDate", resultMap.get("beginDate"));
			context.putVar("endDate", resultMap.get("endDate"));
			context.putVar("saleDays", resultMap.get("saleDays"));
			context.putVar("legal", resultMap.get("legal") );
			context.putVar("dataList", dataList);
			ExcelUtil.export("attendance.xls", out, context);
		} catch (Exception e) {
			e.printStackTrace();
			throw  new BusinessException();
		}
	}
	
	@Override
	public void exportExcel2(HttpServletResponse response) {
		try {
			CrudResultDTO result = getList();
			@SuppressWarnings("unchecked")
			Map<String, Object> resultMap = (Map<String, Object>) result.getResult();
			@SuppressWarnings("unchecked")
			List<AttendanceRecordDTO> dataList = (List<AttendanceRecordDTO>) resultMap.get("attendanceRecordDTOs");
			@SuppressWarnings("unchecked")
			List<AdLegalHoliday> legalHolidays = (List<AdLegalHoliday>) resultMap.get("legalHolidays");
//			Calendar calendar =  Calendar.getInstance();
			int i = 0;
			if("市场部".equals(dataList.get(0).getDeptName())){
				List<SysUser> users = attendancedao.findUser();
				for (AttendanceRecordDTO attendanceRecordDTO : dataList) {
					boolean flag = true;
					for (SysUser sysUser : users) {
						if(attendanceRecordDTO.getUserNmae().equals(sysUser.getName())){
							flag=false;
							break;
						}
					}
					if(flag){
						attendanceRecordDTO.setLayTime(0);
						attendanceRecordDTO.setNumberLate(0);
					}
					attendanceRecordDTO.setCount(i+1);
					i++;
				}
			}else{
				for (AttendanceRecordDTO attendanceRecordDTO : dataList) {
					attendanceRecordDTO.setCount(i+1);
					i++;
				}
			}
			for (AttendanceRecordDTO attendanceRecordDTO : dataList) {
				for (AdLegalHoliday adLegalHoliday : legalHolidays) {
					if(attendanceRecordDTO.getEntryTime().getTime() > adLegalHoliday.getEndDate().getTime()
							&& attendanceRecordDTO.getEntryTime().getTime() != (adLegalHoliday.getAfterLeave() == null ? 0:adLegalHoliday.getAfterLeave().getTime())){
						attendanceRecordDTO.setEememberPay(attendanceRecordDTO.getSchuqin() +calcDayByTime(attendanceRecordDTO.getLeaveFlag())+ calcDayByTime(attendanceRecordDTO.getRestTimeConvert()));
					}else{
						double days = (double)(attendanceRecordDTO.getSchuqin() + (int)resultMap.get("legal") +calcDayByTime(attendanceRecordDTO.getLeaveFlag())+ calcDayByTime(attendanceRecordDTO.getRestTimeConvert()));
						attendanceRecordDTO.setEememberPay(days);
					}
				}
				if("打卡异常".equals(attendanceRecordDTO.getRemarks())){
					attendanceRecordDTO.setRemarks("");
				}
			}
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("year", resultMap.get("year"));
			map.put("calcMonth", resultMap.get("calcMonth"));
			map.put("beginDate", resultMap.get("beginDate"));
			map.put("endDate", resultMap.get("endDate"));
			//满勤天数=满勤天数-国家假日
			int saleDays = Integer.parseInt(resultMap.get("saleDays").toString());
			int legal = Integer.parseInt(resultMap.get("legal").toString());
			map.put("saleDays", saleDays-legal);  //满勤天数
			
			//设置国家假日
			for (AttendanceRecordDTO attendanceRecordDTO : dataList) {
				attendanceRecordDTO.setLegal(Double.parseDouble(resultMap.get("legal").toString()));
			}
			
			//去年累休年假
			int parseInt = Integer.parseInt((String)resultMap.get("year"));
			map.put("lastYear", parseInt - 1);

			//文件名
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String fileName = "考勤记录-" + sdf.format(new Date());
			//导出
			ExportexcelUtil.expRptDataToExcel2(response, this.getClass().getResource("doc/attendance.xls"), dataList, fileName,map);
		} catch (Exception e) {
			e.printStackTrace();
			throw  new BusinessException();
		}
	}
	
	//判断加班时间是否为法定放假时间
	public boolean checkOverTime(AdOverTime overTime, List<AdLegalHoliday> legalHolidays){
		boolean flag = false;
		Date startOver = DateUtils.dateToDate(overTime.getStartTime(), "yyyy-MM-dd");
		for (AdLegalHoliday adLegalHoliday : legalHolidays) {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(adLegalHoliday.getLegal());
			calendar.add(Calendar.DAY_OF_MONTH, adLegalHoliday.getNumberDays()-1);
			//如果加班时间大于等于节假日时间  并且 小于等于节假日 
			if(startOver.getTime() >= adLegalHoliday.getLegal().getTime()
				&& startOver.getTime() <= calendar.getTime().getTime()){
				return true;
			}
		}
		return flag;
	}
	
	private Date parseStringToDate(String date) throws ParseException{    
	        Date result = null;    
	        String parse = date;    
	        parse = parse.replaceFirst("^[0-9]{4}([^0-9]?)", "yyyy$1");    
	        parse = parse.replaceFirst("^[0-9]{2}([^0-9]?)", "yy$1");    
	        parse = parse.replaceFirst("([^0-9]?)[0-9]{1,2}([^0-9]?)", "$1MM$2");    
	        parse = parse.replaceFirst("([^0-9]?)[0-9]{1,2}( ?)", "$1dd$2");    
	        SimpleDateFormat format = new SimpleDateFormat(parse);    
	        result = format.parse(date);    
	        return result;    
	    }  
	
	//计算每天的上班时间
	public Double hourOfDay(String day, String startTime, String endTime){
		Double hour = 0.0;
		Date startDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", startTime);
		Date endDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", endTime);
		Date startAMDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 09:00");
		Date endAMDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 12:30");
		Date startPMDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 14:00");
		Date endPMDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", day+" 18:00");
		//判断签到时间是上午还是下午
		if(startDate.getTime() < endAMDate.getTime()){//签到时间为上午
				//判断签到时间是否小于9点
			if(startDate.getTime() < startAMDate.getTime()){
				startDate = startAMDate;
			}
			//判断签退时间是否是上午
			if(endDate.getTime() <= startPMDate.getTime()){
				if(endDate.getTime() <= endAMDate.getTime()){
					hour = (double)((endDate.getTime() - startDate.getTime())/(1000*60*60*1.0));
				}else{
					hour = (double)((endAMDate.getTime() - startDate.getTime())/(1000*60*60*1.0));
				}
			}else{
				if(endDate.getTime() > startPMDate.getTime()){
					if(endDate.getTime() > endPMDate.getTime()){
						endDate = endPMDate;
					}
					hour = (double)(((endAMDate.getTime() - startDate.getTime()) + (endDate.getTime() - startPMDate.getTime()))/(1000*60*60*1.0));
				}
			}
		}else{
			if(startDate.getTime() <= startPMDate.getTime()){
				startDate = startPMDate;
			}
			if(endDate.getTime() > startPMDate.getTime()){
				if(endDate.getTime() > endAMDate.getTime()){
					endDate = endPMDate;
				}
				hour = (double)(((endDate.getTime()-startDate.getTime()))/(1000*60*60*1.0));
			}
		}
		return hour;
	}
	
	public Integer calcMitue(String startDate, String endDate){
//		int minute=0;
		Date d1 = DateUtils.strToDate("yyyy-MM-dd HH:mm", startDate );
		Date d2 = DateUtils.strToDate("yyyy-MM-dd HH:mm", endDate);
			
		return (int)((d1.getTime() - d2.getTime())/(1000*60));
	}

	@Override
	public List<AdAttendance> queryAttendanceData() {
		List<AdAttendance> list = attendancedao.queryAttendanceData();
		return list;
	}
	
}
