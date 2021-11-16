package com.reyzar.oa.common.constant;

import java.io.*;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import com.google.common.collect.Maps;

/** 
* @ClassName: SystemConstant 
* @Description: TODO
* @author Lin 
* @date 2017年3月16日 下午3:02:25 
*  
*/
public class SystemConstant {

	private static Map<String, String> dataMap = Maps.newHashMap();
	
	static {
		Properties prop = new Properties();   
        InputStream in = PermissionConstant.class.getResourceAsStream("/oa.properties");
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
            	dataMap.put(entry.getKey().toString(), entry.getValue().toString());
            }
        } catch (IOException e) {
            e.printStackTrace();  
        }
	}
	
	public static String getValue(String key) {
		return dataMap.get(key);
	}
}
