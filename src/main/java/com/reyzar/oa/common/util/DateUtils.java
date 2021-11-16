package com.reyzar.oa.common.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


public class DateUtils {

	/**
	 * 字符串转时间
	 * @param strFormate	字符串格式
	 * @param dateStr		时间字符串
	 * @return
	 */
	public static Date strToDate(String strFormate,String dateStr){
		SimpleDateFormat sdf = new SimpleDateFormat(strFormate);
		try {
			return sdf.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 时间转字符串
	 * @param date  时间
	 * @param formatStr 字符串格式
	 * @return
	 */
	public static String dateToStr(Date date,String formatStr){
		SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
		return sdf.format(date);
	}
	
	/**
	 *时间格式转换
	 * @param date  时间
	 * @param formatStr 字符串格式
	 * @return
	 * **/
	public static Date dateToDate(Date date,String formatStr){
		SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
		String dateStr=sdf.format(date);
		try {
			return sdf.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 判断日期是否周末
	 * @param bDate
	 * @return
	 * @throws ParseException
	 */
	public static boolean isWeekend(String bDate){
		DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
        Date bdate;
        Calendar cal = Calendar.getInstance();
		try {
			bdate = format1.parse(bDate);
			cal.setTime(bdate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		if(cal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || cal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY){
			return true;
		} else{
			return false;
		}
 
 }
/**
     * 判断newDate是否在[startTime, endTime]区间，注意时间格式要一致
     * @param nowTime 当前时间
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return
     */
 public static boolean isEffectiveDate(Date nowTime, Date startTime, Date endTime) {
         if (nowTime.getTime() == startTime.getTime() || nowTime.getTime() == endTime.getTime()) 
               return true;
		 Calendar date = Calendar.getInstance();
		 date.setTime(nowTime);
		 Calendar begin = Calendar.getInstance();
		 begin.setTime(startTime);
		 Calendar end = Calendar.getInstance();
		 end.setTime(endTime);
		if (date.after(begin) && date.before(end))
		return true;
		 else 
		return false;
 }
 /**
  * 获取 两个时间差
  * @param nowDate
  * @param endDate
  * @return
  */
 public static Map<String,Long> getDatePoor(Date endDate, Date nowDate) {
	 	Map<String,Long> map = new HashMap<String,Long>();
	    long nd = 1000 * 24 * 60 * 60;
	    long nh = 1000 * 60 * 60;
	    long nm = 1000 * 60;
	    // 获得两个时间的毫秒时间差异
	    long diff = endDate.getTime() - nowDate.getTime();
	    // 计算差多少天
	    long day = diff / nd;
	    map.put("day", day);
	    // 计算差多少小时
	    long hour = diff % nd / nh;
	    map.put("hour", hour);
	    // 计算差多少分钟
	    long min = diff % nd % nh / nm;
	    map.put("min", min);
	    return map;
	}
}
