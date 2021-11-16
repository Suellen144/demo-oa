package com.reyzar.oa.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Value;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.Page;
import com.google.common.collect.Maps;
import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: BaseController 
* @Description: 父控制器，提供一些Controller的公共方法
* @author Lin 
* @date 2016年6月3日 上午11:50:33 
*  
*/
public abstract class BaseController {
	
	@Value("${pageNum}")
	protected Integer pageNum;
	@Value("${pageSize}")
	protected Integer pageSize;
	
	/**
	 * 将请求中的参数解析为Map
	 * @param request
	 * @return
	 * */
	protected Map<String, Object> parseRequestMap(HttpServletRequest request) {
		Map<String, Object> resultMap = Maps.newHashMap();
		Map<String, String[]> originMap = request.getParameterMap();
		
		Set<String> keys = originMap.keySet();
		for(String key : keys) {
			String[] value = originMap.get(key);
			if(value.length == 1 && !"".equals(value[0])) {
				resultMap.put(key, value[0]);
			} else if(value.length > 1) {
				resultMap.put(key, value);
			}
			
		}
		
		return resultMap;
	}
	
	/**
	 * 将请求中的参数解析为分页需要的Map
	 * @param requestMap
	 * @return
	 * */
	@SuppressWarnings("unchecked")
	protected Map<String, Object> parsePageMap(Map<String, Object> requestMap) {
		
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		List<Map<String, Object>> pageData = (List<Map<String, Object>>) requestMap.get("pageData");
		Map<String, Object> orderColumns = (LinkedHashMap<String, Object>) requestMap.get("orderColumns");
		Map<String, Object> searchMap = (Map<String, Object>) requestMap.get("search") != null ? (HashMap<String, Object>) requestMap.get("search") : new HashMap<String, Object>();

		paramsMap.putAll(searchMap);
		for(Map<String, Object> tempMap : pageData) {
			paramsMap.put(tempMap.get("name").toString(), tempMap.get("value"));
		}
		
		int pageNum = paramsMap.get("iDisplayStart") != null ? Integer.valueOf(paramsMap.get("iDisplayStart").toString()) : 0;
		int pageSize = paramsMap.get("iDisplayLength") != null ? Integer.valueOf(paramsMap.get("iDisplayLength").toString()) : 0;
		pageNum = pageNum == 0 ? this.pageNum : pageNum;
		pageSize = pageSize == 0 ? this.pageSize : pageSize;
		
		paramsMap.put("pageNum", pageNum);
		paramsMap.put("pageSize", pageSize);
		paramsMap.put("orderColumns", orderColumns);
		
		return paramsMap;
	}
	
	/**
	 * 构造表格需要的JSON数据
	 * @param paramsMap
	 * @param data
	 * @return
	 * */
	protected <T> Map<String, Object> buildTableData(Map<String, Object> paramsMap, Page<T> data) {
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("sEcho", Integer.valueOf(paramsMap.get("sEcho").toString()));
		dataMap.put("iTotalRecords", data.getTotal());
		dataMap.put("iTotalDisplayRecords", data.getTotal());
		dataMap.put("aaData", data.getResult());
		
		return dataMap;
	}
	
	/**
	 * 返回JSON格式字符串到请求端
	 * @param response
	 * @param object
	 * @return
	 * */
	protected String renderJSONString(HttpServletResponse response, Object object) {
		try {
			String resText = JSON.toJSONString(object);
			response.reset();
	        response.setContentType("application/json");
	        response.setCharacterEncoding("utf-8");
			response.getWriter().print(resText);
			
			return resText;
		} catch (IOException e) {
			return null;
		}
	}
	
	/**
	 * 
	* @Title: getUser
	* @Description: 获取当前登录用户
	* @param @return
	* @return SysUser
	* @throws
	 */
	protected SysUser getUser() {
		Subject subject = SecurityUtils.getSubject();
		return (SysUser)subject.getSession().getAttribute("user");
	}
}