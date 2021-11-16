package com.reyzar.oa.common.exception;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

import com.alibaba.fastjson.JSON;
import com.reyzar.oa.common.dto.CrudResultDTO;

public class CustomExceptionHandler extends SimpleMappingExceptionResolver {
	
	private final static Logger logger = Logger.getLogger(CustomExceptionHandler.class);

	@SuppressWarnings("static-access")
	@Override  
    protected ModelAndView doResolveException(HttpServletRequest request,  
            HttpServletResponse response, Object handler, Exception ex) {
		
		recordLog(request,handler, ex); // 记录异常日志
		// 如果不是异步请求  
        if (!(request.getHeader("accept").indexOf("application/json") > -1 || (request  
                .getHeader("X-Requested-With")!= null && request  
                .getHeader("X-Requested-With").indexOf("XMLHttpRequest") > -1))) {  
            // Apply HTTP status code for error views, if specified.  
            // Only apply it if we're processing a top-level request.
        	
        	// Expose ModelAndView for chosen error view.
        	String viewName = determineViewName(ex, request); 
        	if (viewName != null) {// JSP格式返回  
                Integer statusCode = determineStatusCode(request, viewName);  
                if (statusCode != null) {  
                    applyStatusCodeIfPossible(request, response, statusCode);  
                }  
                return getModelAndView(viewName, ex, request);
        	}
        } else {// AJAX JSON格式返回  
            try {
            	CrudResultDTO resDto = new CrudResultDTO(CrudResultDTO.EXCEPTION, ex.getMessage());
            	response.setContentType("application/json;charset=utf-8");
            	response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                PrintWriter writer = response.getWriter();  
                writer.write(JSON.toJSONString(resDto));  
                writer.flush();  
                writer.close();
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        }  
        return null;  
    } 
	
	/**
	* @Title: recordLog
	* @Description: 记录日志
	* @param handler
	* @throws
	 */
	private void recordLog(HttpServletRequest request, Object handler, Exception ex) {
		StringBuffer sb = new StringBuffer(); 
		if(handler != null && handler instanceof HandlerMethod) {
			HandlerMethod hm = (HandlerMethod) handler;
			String uri = request.getRequestURI();
			String clazz = hm.getBeanType().getName();
			String method = hm.getMethod().getName();
			String exception = ex.getMessage();
			
			sb.append("An error occurred, the detail information in the below!\n");
			sb.append("request url: ").append(uri).append("\n")
				.append("invoke class: ").append(clazz).append("\n")
				.append("invoke method: ").append(method).append("\n")
				.append("exception message: ").append(exception).append("\n");
			
			logger.error(sb.toString());
			sb.delete(0, sb.length());
		}
	}
}
