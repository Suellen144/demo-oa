package com.reyzar.oa.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysUserService;

/** 
* @ClassName: LoginFilter 
* @Description: 判断用户登录，用以实现Shiro rememberme
* @author Lin 
* @date 2016年6月27日 上午10:35:37 
*  
*/
@SuppressWarnings("unused")
//@WebFilter(filterName="loginFilter", urlPatterns={"/manage/*"})
public class LoginFilter implements Filter {

	private FilterConfig filterConfig;
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		Subject subject = SecurityUtils.getSubject();
		if(subject.isRemembered()) {
			ISysUserService sysUserService = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext()).getBean(ISysUserService.class);
			SysUser user = sysUserService.findByAccount(subject.getPrincipal().toString()); 
			UsernamePasswordToken token = new UsernamePasswordToken(user.getAccount(), user.getPassword(), true);
			try {
				subject.login(token);
				subject.getSession().setAttribute("user", user);
			} catch(AuthenticationException ae) {
				token.clear();
				((HttpServletResponse) response).sendRedirect("manage/common/login");
			}
		}
		
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {}
	
}
