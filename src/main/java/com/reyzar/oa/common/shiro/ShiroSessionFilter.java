package com.reyzar.oa.common.shiro;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.UserFilter;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysUserService;

/** 
* @ClassName: ShiroSessionFilter 
* @Description: Session过期验证
* @author Lin 
* @date 2017年1月18日 下午4:42:42 
*  
*/
@Component
public class ShiroSessionFilter extends UserFilter {

	@Override
	protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
        if (isLoginRequest(request, response)) {
            return true;
        } else {
            Subject subject = getSubject(request, response);
            if(subject.isRemembered()) {
    			ISysUserService sysUserService = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext()).getBean(ISysUserService.class);
    			SysUser user = sysUserService.findByAccount(subject.getPrincipal().toString()); 
    			UsernamePasswordToken token = new UsernamePasswordToken(user.getAccount(), user.getPassword(), true);
    			try {
    				subject.login(token);
    				subject.getSession().setAttribute("user", user);
    			} catch(AuthenticationException ae) {
    				token.clear();
    				return false;
    			}
    		}
            
            
            return super.isAccessAllowed(request, response, mappedValue);
        }
    }
	
	@Override
    protected boolean onAccessDenied(ServletRequest request,
        ServletResponse response) throws Exception {
        
		HttpServletRequest req = WebUtils.toHttp(request);
        String xmlHttpRequest = req.getHeader("X-Requested-With");
        if ( xmlHttpRequest != null )
            if ( xmlHttpRequest.equalsIgnoreCase("XMLHttpRequest") )  {
            	HttpServletResponse res = WebUtils.toHttp(response);
            	res.setHeader("sessionstatus", "timeout"); // 在响应头设置session状态
                res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return false;
        }
    
        return super.onAccessDenied(request, response);
    }
}
