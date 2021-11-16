package com.reyzar.oa.common.util;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;


/**
 * WebUtil.java
 * @author LWY
 * @2018-6-22
 */
public class WebUtil {
	/**
	 * 将Request请求中的所有参数转换成Map<String,String>对象
	 * 
	 * @param requestParametersMap
	 * @return result
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map paramsToMap(Map requestParametersMap) {
		Iterator it = requestParametersMap.entrySet().iterator();
		Map result = new HashMap();
		while (it.hasNext()) {
			Entry entry = (Entry) it.next();
			String[] value = (String[]) entry.getValue();
			if (value.length == 1) {
				result.put(entry.getKey(), value[0]
						.equalsIgnoreCase("'undefined'") ? null : value[0]);
			} else {
				result.put(entry.getKey(), value);
			}
		}
		return result;
	}
	
	/**
	 * 分页参数处理
	 * 
	 * @param obj
	 * @return
	 */
	public static Map<String, Object> pagerManager(Map<String, Object> obj,int count){
		int page = Integer.valueOf(obj.get("page").toString());
		int rows = Integer.valueOf(obj.get("rows").toString());
		int begin = (page - 1) * rows;// 0 10
		int end = page * rows;// 10 20
		int pages = count / rows + (count % rows > 0 ? 1 : 0);
		obj.put("begin", begin);
		obj.put("end", end);
		obj.put("pages", pages);
		return obj;
	}
	/**
	 * 分页处理
	 * @param param
	 * @return
	 */
	public static Map<String,String> params4Paging(Map<String,String> param){
		String page = param.get("page");
		String rows = param.get("rows");
		int intPage = Integer.parseInt((page==null||page=="0")?"1":page);
		int number = Integer.parseInt(rows==null||rows=="0"?"10":rows);
		int start = (intPage-1)*number+1;
		int end = (start + number)-1;
		param.put("start", start+"");
		param.put("end", end+"");
		return param;
	}
}
