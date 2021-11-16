package com.reyzar.oa.common.constant;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import com.google.common.collect.Maps;

/** 
* @ClassName: DataPermissionModuleConstant 
* @Description: 映射数据权限模块的名称，用于查找该模块的数据权限数据
* @author Lin 
* @date 2016年9月19日 下午5:56:54 
*  
*/
public class DataPermissionModuleConstant {

	private static Map<String, String> dataMap = Maps.newHashMap();
	
	public final static String WORK_REPORT = "workreport";
	public final static String LEAVE = "leave";
	public final static String TRAVEL = "travel";
	public final static String TRAVEL_REIMBURSE = "travelReimburse";
	public final static String REIMBURSE = "reimburse";
	public final static String LEGWORK = "legwork";
	public final static String RECORD = "record";
	public final static String KPI = "kpi";
	public final static String MANAGER = "manager";
	public final static String OVERTIME = "overtime";
	public final static String BARGIN = "bargain";
	public final static String Seal = "seal";
	public final static String usercar = "usercar";
	public final static String MARKET = "market";
	public final static String COLLECTION = "collection";
	public final static String PAY = "pay";
	public final static String SALARY = "salary";
	public final static String SALARY_HISTORY = "salaryHistory";
	/*public final static String ENTRY_APPLY = "entryApply";*/
	public final static String COMMON_RECEIVED = "commonReceived";
	public final static String COMMON_PAY = "commonPay";
	public final static String MEETING = "meeting";
	public final static String Client ="client";
	

	static {   
        Properties prop = new Properties();   
        InputStream in = PermissionConstant.class.getResourceAsStream("/data-permission.properties");
        BufferedReader reader = new BufferedReader(new InputStreamReader(in));
		try {
			reader = new BufferedReader(new InputStreamReader(in, "UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
        try {   
            prop.load(reader);  
            Set<Entry<Object, Object>> entrySet = prop.entrySet();
            for(Entry<Object, Object> entry : entrySet) {
            	dataMap.put(entry.getKey().toString(), entry.getValue().toString());
            }
        } catch (IOException e) {   
            e.printStackTrace();   
        }
    }
	
	/**
	 * 获取权限代码的中文名
	 * */
	public static String getValue(String key) {
		return dataMap.get(key);
	}
	
	/**
	 * 获取所有的权限代码的中文名
	 */
	public static List<String> getValues() {
		return new ArrayList<String>(dataMap.values());
	}
}
