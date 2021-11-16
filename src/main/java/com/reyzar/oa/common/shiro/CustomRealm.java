package com.reyzar.oa.common.shiro;

import java.util.List;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.reyzar.oa.domain.SysPermission;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysRoleService;
import com.reyzar.oa.service.sys.ISysUserService;

/** 
* @ClassName: CustomRealm 
* @Description: 自定义Realm
* @author Lin 
* @date 2016年5月19日 下午6:39:48 
*  
*/
@Component
public class CustomRealm extends AuthorizingRealm {
	@Autowired
	private ISysUserService sysUserService;
	@Autowired
	private ISysRoleService roleService;

	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		String account = (String)principals.getPrimaryPrincipal();  
        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        
        SysUser sysUser = sysUserService.findByAccount(account);
        if(sysUser != null && sysUser.getRoleList() != null) {
        	List<SysRole> roleList = sysUser.getRoleList();
        	if(roleList != null) {
        		for(SysRole role : roleList) {
        			if("1".equals(role.getEnabled())) {
        				info.addRole(role.getEnname());
        				
        				SysRole tempRole = roleService.findById(role.getId());
        				if(tempRole.getPermissionList() != null) {
        					for(SysPermission permission : tempRole.getPermissionList()) {
        						info.addStringPermission(permission.getCode());
        					}
        				}
        			}
        		}
        	}
        }
		return info;
	}

	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authcToken) throws AuthenticationException {
		UsernamePasswordToken token = (UsernamePasswordToken) authcToken;
		String account = token.getUsername();
		char[] password = token.getPassword();
		
		SimpleAuthenticationInfo info = null;
		SysUser sysUser = sysUserService.findByAccount(account);
		if (sysUser != null) {
			String pwd = new String(password);
			if(pwd.equals(sysUser.getPassword())) {
				info = new SimpleAuthenticationInfo(account, password, getName());
			} else {
				throw new IncorrectCredentialsException("密码错误！");
			}
		} else {
			throw new UnknownAccountException("用户名错误！");
		}
		
		return info;
	}

	/**
	 * 清除所有的缓存信息
	 * */
	public void clearAllCachedInfo() {  
	    Cache<Object, AuthorizationInfo> cache = getAuthorizationCache();  
	    if (cache != null) {  
	        for (Object key : cache.keys()) {  
	            cache.remove(key);  
	        }  
	    }  
	}
	
	/**
	 * 
	* @Title: reloadAuthorizing
	* @Description: 刷新指定用户的权限信息
	  @param account
	* @return void
	 */
	public void reloadAuthorizing(String account) {  
        Subject subject = SecurityUtils.getSubject();   
        String realmName = subject.getPrincipals().getRealmNames().iterator().next();   
        SimplePrincipalCollection principals = new SimplePrincipalCollection(account, realmName);   
        subject.runAs(principals);   
        getAuthorizationCache().remove(subject.getPrincipals());   
        subject.releaseRunAs();
    }  
	
	/**
	* @Title: refreshUserInSession
	* @Description: 刷新Session中的用户信息
	  @param account 用户帐号
	* @return void
	 */
	public void refreshUserInSession(String account) {
		Subject subject = SecurityUtils.getSubject();
		subject.getSession().setAttribute("user", sysUserService.findByAccount(account));
	}
}
