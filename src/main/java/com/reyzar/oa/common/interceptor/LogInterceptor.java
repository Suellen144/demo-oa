package com.reyzar.oa.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.reyzar.oa.common.util.UserUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

/** 
* @ClassName: LogInterceptor 
* @Description: 访问日志拦截器，记录HTTP请求
* @author Lin 
* @date 2016年8月16日 下午4:46:19 
*  
*/
public class LogInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	/*	try {
			if (modelAndView != null){
					String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
					String viewName = modelAndView.getViewName();
					boolean ismobile = UserUtils.CheckMobile.check(userAgent);
					StringBuffer buffer = new StringBuffer(viewName);
					int add = buffer.indexOf("add");
					int list = buffer.indexOf("list");

			}
		} catch (Exception e) {
			e.printStackTrace();
		}*/
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
	}

}
