package com.reyzar.oa.common.util;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.shiro.CustomRealm;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.domain.SysDataPermission;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysMenu;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysDataPermissionService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysMenuService;
import com.reyzar.oa.service.sys.ISysRoleService;
import com.reyzar.oa.service.sys.ISysUserService;

/** 
* @ClassName: UserUtils 
* @Description: 用户工具类，用户相关操作
* @author Lin 
* @date 2016年8月15日 下午5:19:54 
*  
*/
public class UserUtils {
	
	private static ISysUserService userService = SpringContextUtils.getBean(ISysUserService.class);
	private static ISysMenuService menuService = SpringContextUtils.getBean(ISysMenuService.class);
	private static ISysDeptService deptService = SpringContextUtils.getBean(ISysDeptService.class);
	private static ISysRoleService roleService = SpringContextUtils.getBean(ISysRoleService.class);
	private static ISysDataPermissionService dataPermissionService = SpringContextUtils.getBean(ISysDataPermissionService.class);
	private static CustomRealm customRealm = SpringContextUtils.getBean(CustomRealm.class);

	/**
	* @Title: getDataPermission
	* @Description: 获取指定用户的数据权限，有返回列表则查询列表下所有数据，没有则查询个人数据
	* @param @param user
	* @return Set<Integer> 部门ID列表
	* @throws
	 */
	public static Set<Integer> getDataPermission(SysUser user, Integer moduleId) {
		Set<Integer> deptIdSet = Sets.newHashSet();
		if(moduleId == -1) {
			return deptIdSet;
		}
		
		// 第一次判断用户角色
		if(user.getRoleList() == null || user.getRoleList().size() <= 0) {
			user = userService.findById(user.getId());
		}
		// 第二次判断用户角色
		if(user.getRoleList() != null && user.getRoleList().size() > 0) {
			List<Integer> roleIdList = Lists.newArrayList();
			for(SysRole role : user.getRoleList()) {
				if("1".equals(role.getEnabled())) {
					roleIdList.add(role.getId());
				}
			}
			if(roleIdList.size() > 0) {
				List<SysDataPermission> dataPermissionList = dataPermissionService.findByRoleIdAndMenuId(roleIdList, moduleId);
				for(SysDataPermission dataPermission : dataPermissionList) {
					String deptIds = dataPermission.getDeptIds(); 
					if( deptIds != null 
							&& !"".equals(deptIds.trim()) ) {
						if(deptIds.indexOf(",") > -1) {
							for(String id : deptIds.split(",")) {
								deptIdSet.add(Integer.valueOf(id));
							}
						} else {
							deptIdSet.add(Integer.valueOf(deptIds));
						}
					}
				}
			}
		}
		
		return deptIdSet;
	}
	
	public static Set<Integer> getDataPermission(SysUser user, String moduleName) {
		return getDataPermission(user, findModuleId(moduleName));	
	}
	
	private static Integer findModuleId(String moduleName) {
		SysMenu menu = menuService.findByName(moduleName);
		if(menu == null) {
			return -1;
		} else {
			return menu.getId();
		}
	}
	
	/**
	* @Title: getCurrUser
	* @Description: 获取当前登录用户
	* @return SysUser
	* @throws
	 */
	public static SysUser getCurrUser() {
		try {
			Subject subject = SecurityUtils.getSubject();
			SysUser user = (SysUser)subject.getSession().getAttribute("user");
			if(user == null) {
				subject.logout();
			}
			return user; 
		} catch(Exception e) {}
		return null;
	}
	
	/**
	* @Title: isHavePermission
	* @Description: 判断对指定模块是否有数据权限存在
	* @return boolean true 有权限
	* 					false 无权限
	* @throws
	 */
	public static boolean isHavePermission(SysUser user, String moduleName) {
		boolean result = false;
		
		SysMenu menu = menuService.findByName(moduleName);
		if(menu != null) {
			// 第一次判断用户角色
			if(user.getRoleList() == null || user.getRoleList().size() <= 0) {
				user = userService.findById(user.getId());
			}
			// 第二次判断用户角色
			if(user.getRoleList() != null && user.getRoleList().size() > 0) {
				List<Integer> roleIdList = Lists.newArrayList();
				for(SysRole role : user.getRoleList()) {
					if("1".equals(role.getEnabled())) {
						roleIdList.add(role.getId());
					}
				}
				if(roleIdList.size() > 0) {
					result = dataPermissionService.isHavePermission(roleIdList, menu.getId());
				}
			}
		}
		
		return result;
	}

	/***
	 * 获取该用户所负责的用户id
	 * @param user
	 * @return
	 */
	public static Set<Integer> getPrincipalIdList(SysUser user){
		List<Integer> userList=userService.findIdByPrincipalId(user);
		Set<Integer> userSet=new HashSet<Integer>(userList);
		return userSet;
	}
	/**
	* @Title: getCompanyByUser
	* @Description: 获取用户所在公司
	  @param user
	* @return SysDept
	 */
	public static SysDept getCompanyByUser(SysUser user) {
		if( user.getDeptId() != null ) {
			SysDept dept = deptService.findById(user.getDeptId());
			String[] ids = dept.getNodeLinks().split(",");
			List<Integer> idList = Lists.newArrayList();
			for(String idstr : ids) {
				idList.add(Integer.valueOf(idstr));
			}
			
			List<SysDept> tempList = deptService.findByIds(idList);
			for(SysDept temp : tempList) {
				if(temp.getLevel() != null && temp.getLevel() == 1) {
					return temp;
				}
			}
		}
		
		return null;
	}


	/*此处校验页面请求是否来自移动端*/
	public static class CheckMobile {

		static final String phoneReg = "\\b(ip(hone|od)|android|opera m(ob|in)i"
				+"|windows (phone|ce)|blackberry"
				+"|s(ymbian|eries60|amsung)|p(laybook|alm|rofile/midp"
				+"|laystation portable)|nokia|fennec|htc[-_]"
				+"|mobile|up.browser|[1-4][0-9]{2}x[1-4][0-9]{2})\\b";
		static final String tableReg = "\\b(ipad|tablet|(Nexus 7)|up.browser"
				+"|[1-4][0-9]{2}x[1-4][0-9]{2})\\b";

		//移动设备正则匹配：手机端、平板
		final static Pattern phonePat = Pattern.compile(phoneReg, Pattern.CASE_INSENSITIVE);
		final static Pattern tablePat = Pattern.compile(tableReg, Pattern.CASE_INSENSITIVE);

		/**
		 * 检测是否是移动设备访问
		 *
		 * @Title: check
		 * @Date : 2014-7-7 下午01:29:07
		 * @param userAgent 浏览器标识
		 * @return true:移动设备接入，false:pc端接入
		 */
		@SuppressWarnings("unused")
		public static boolean check(String userAgent){
			if(null == userAgent){
				userAgent = "";
			}
			// 匹配
			Matcher matcherPhone = phonePat.matcher(userAgent);
			Matcher matcherTable = tablePat.matcher(userAgent);
			if(matcherPhone.find() || matcherTable.find()){
				return true;
			} else {
				return false;
			}
		}
	}
	
/**
 * -------------------------- 以下与Shiro相关 --------------------------------------
 * */
	
	/***
	* @Title: refreshShiroCache
	* @Description: 更新Shiro权限缓存（赋予新权限后，调用此方法刷新所有用户的权限）
	* @param 
	* @return void
	* @throws
	 */
	public static void refreshShiroCache() {
		customRealm.getAuthenticationCache().clear();
		customRealm.getAuthorizationCache().clear();
	}
	
	
	public static Map<String, Object> userByRole(SysUser user,Map<String, Object> params) {
		if(user.getRoleList()!=null) {
			List<Integer> ids=new ArrayList<Integer>();
			List<Integer> roleIds=new ArrayList<Integer>();
			for(int i=0;i<user.getRoleList().size();i++) {
				SysRole sysRole=user.getRoleList().get(i);
				//获取当前登录人角色
				roleIds.add(sysRole.getDeptId());
			}
			List<SysRole> sysRoles=roleService.findByRoleId(user.getId());
			for (int i = 0; i < sysRoles.size(); i++) {
				if(sysRoles.get(i).getId() == 82) {
					roleIds = new ArrayList<Integer>();
					roleIds.add(3);
					List<SysDept> sysDept=deptService.findByParentid(3);
					for (int s = 0; s < sysDept.size(); s++) {
						roleIds.add(sysDept.get(s).getId());
					}
				}
				if(sysRoles.get(i).getId() == 51) {
					roleIds = new ArrayList<Integer>();
				}
				if(sysRoles.get(i).getId() == 97) {
					roleIds = new ArrayList<Integer>();
				}
			}
			if(user.getDeptId() == 4) {
				roleIds = new ArrayList<Integer>();
			}
			//根据当前登录人 获取他能查看的人员数据
			List<SysUser> sysUsers=userService.findByDeptIds(roleIds);
			for(int j=0;j<sysUsers.size();j++) {
				ids.add(sysUsers.get(j).getId());
			}
			if(ids!=null && ids.size()>0) {
				params.put("idStr", ids);
			}else {
				//去除行政
				if(user.getDeptId()!=4 && user.getId() != 2) {
					params.put("userIdCurrent", user.getId());
				}
			}
		}
		return params;
	}
}
