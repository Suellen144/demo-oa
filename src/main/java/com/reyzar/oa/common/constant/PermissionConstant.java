package com.reyzar.oa.common.constant;

import java.io.*;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import com.google.common.collect.Maps;
import com.reyzar.oa.common.util.BeanUtils;

/** 
* @ClassName: PermissionConstant 
* @Description: 权限代码与中文映射
* @author Lin 
* @date 2016年8月16日 下午3:00:57 
*  
*/
public class PermissionConstant {
	
	private static Map<String, String> permissionMap = Maps.newHashMap();

	static {   
        Properties prop = new Properties();   
        InputStream in = PermissionConstant.class.getResourceAsStream("/permission-map.properties");
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
            	permissionMap.put(entry.getKey().toString(), entry.getValue().toString());
            }
        } catch (IOException e) {   
            e.printStackTrace();   
        }
    }
	
	/**
	 * 获取权限代码的中文名
	 * */
	public static String getValue(String key) {
		return permissionMap.get(key);
	}
	
	/**
	 * 获取副本
	 * */
	public static Map<String, String> getClone() {
		Map<String, String> cloneMap = Maps.newHashMap();
		for(String key : permissionMap.keySet()) {
			cloneMap.put(key, permissionMap.get(key));
		}
		
		return cloneMap;
	}
}
