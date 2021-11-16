package com.reyzar.oa.common.constant;

import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.util.SpringContextUtils;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.service.ad.IAdPositionService;

/** 
* @ClassName: PositionConstant 
* @Description: 职位常量 保存各种职位代码
* @author Lin 
* @date 2016年9月22日 下午5:32:04 
*  
*/
public class PositionConstant {
	
	private static IAdPositionService positionService = SpringContextUtils.getBean(IAdPositionService.class);
	private static Map<String, List<AdPosition>> nodePositionMap = Maps.newHashMap();
	
	static {   
        Properties prop = new Properties();   
        InputStream in = PermissionConstant.class.getResourceAsStream("/position.properties");
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new InputStreamReader(in, "UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		Map<String, Set<String>> dataMap = Maps.newHashMap();
        try {   
            prop.load(reader);  
            Set<Entry<Object, Object>> entrySet = prop.entrySet();
            for(Entry<Object, Object> entry : entrySet) {
            	Set<String> value = dataMap.get(entry.getValue().toString());
            	if(value == null) {
            		value = Sets.newHashSet();
            	}
            	value.add(entry.getKey().toString());
            	dataMap.put(entry.getValue().toString(), value);
            }
            
            List<AdPosition> positionList = positionService.findAll();
    		if(positionList != null && positionList.size() > 0) {
    			for(AdPosition position : positionList) {
    				Set<String> actNodeName = dataMap.get(position.getName());
    				if(actNodeName != null && actNodeName.size() > 0) {
    					for(String name : actNodeName) {
    						List<AdPosition> tempList = nodePositionMap.get(name);
    						if(tempList == null) {
    							tempList = Lists.newArrayList();
    							nodePositionMap.put(name, tempList);
    						}
    						tempList.add(position);
    					}
    				}
    			}
    		}
        } catch (IOException e) {
            e.printStackTrace();  
        }
    }
	
	public static List<AdPosition> getPositionList(String key) {
		return nodePositionMap.get(key); 
	}
}
