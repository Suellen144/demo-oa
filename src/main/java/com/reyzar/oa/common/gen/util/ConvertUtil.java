package com.reyzar.oa.common.gen.util;

import java.util.HashMap;
import java.util.Map;

/** 
* @ClassName: ConvertUtil 
* @Description: 类型转换类
* @author Lin 
* @date 2016年5月24日 下午12:06:26 
*  
*/
public class ConvertUtil {

	/**
	 * typeMap
	 * 		key: 数据库字段类型
	 * 		value:  Map<String, String>
	 * 					  key: Java数据类型名，如Integer
	 * 					value: Java数据类型全限定名，如java.lang.Integer
	 * 	
	 * */
	private static Map<String, Map<String, String>> typeMap = 
			new HashMap<String, Map<String, String>>();
	
	static {
		// Integer 类型
		Map<String, String> intMap = new HashMap<String, String>();
		intMap.put("Integer", "java.lang.Integer");
		typeMap.put("TINYINT", intMap);
		typeMap.put("SMALLINT", intMap);
		typeMap.put("MEDIUMINT", intMap);
		typeMap.put("INT", intMap);
		typeMap.put("INTEGER", intMap);

		// Long 类型
		Map<String, String> longMap = new HashMap<String, String>();
		longMap.put("Long", "java.lang.Long");
		typeMap.put("BIGINT", longMap);
		typeMap.put("NUMBER", longMap);
		
		// Double 类型
		Map<String, String> doubleMap = new HashMap<String, String>();
		doubleMap.put("Double", "java.lang.Double");
		typeMap.put("FLOAT", doubleMap);
		typeMap.put("DOUBLE", doubleMap);
		typeMap.put("DECIMAL", doubleMap);
		
		// String 类型
		Map<String, String> stringMap = new HashMap<String, String>();
		stringMap.put("String", "java.lang.String");
		typeMap.put("CHAR", stringMap);
		typeMap.put("VARCHAR", stringMap);
		typeMap.put("TINYTEXT", stringMap);
		typeMap.put("TEXT", stringMap);
		typeMap.put("MEDIUMTEXT", stringMap);
		typeMap.put("LONGTEXT", stringMap);
		
		// Date 类型
		Map<String, String> dateMap = new HashMap<String, String>();
		dateMap.put("Date", "java.util.Date");
		typeMap.put("DATE", dateMap);
		typeMap.put("TIME", dateMap);
		typeMap.put("DATETIME", dateMap);
		typeMap.put("TIMESTAMP", dateMap);
	}
	
	/**
	 * DB字段类型转换为Java数据类型
	 * @param DB字段类型 
	 * */
	public static Map<String, String> getActualType(String dbType) {
		return typeMap.get(dbType.toUpperCase());
	}
	
	/**
	 * 将字符串中“_”后面的字母转为大写
	 * @param text
	 * */
	public static String underlineToUpper(String text) {
		if(text == null || "".equals(text.trim())) {
			return "";
		}
		
		StringBuilder sb = new StringBuilder(text);
		if(text.indexOf("_") > -1) {
			String[] sp = text.split("_");
			int loc = 0;
			for(String str : sp) {
				if(loc == 0) {
					loc++;
					continue ;
				}
				str = (str.charAt(0)+"").toUpperCase() + str.substring(1);
				sp[loc++] = str;
			}
			sb.delete(0, sb.length());
			for(String str : sp) {
				sb.append(str);
			}
		}
		
		return sb.toString();
	}
}
