package com.reyzar.oa.common.constant;

import com.google.common.collect.Maps;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

/** 
* @ClassName: deptUtilsConstant
* @Description: 公司部门ID
*  
*/
public class deptUtilsConstant {

	private static Map<String, String> deptMap = Maps.newHashMap();

	static {
		Properties prop = new Properties();
		InputStream in = PermissionConstant.class.getResourceAsStream("/deptUtils.properties");
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new InputStreamReader(in, "UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		try {
			prop.load(reader);
			Set<Entry<Object, Object>> entrySet = prop.entrySet();
			for(Entry<Object, Object> entry : entrySet) {
				deptMap.put(entry.getKey().toString(), entry.getValue().toString());
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static String getDeptId(String key) {
		return deptMap.get(key);
	}
}
