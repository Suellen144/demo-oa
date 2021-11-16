package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class SysDataPermission extends BaseEntity {

	private Integer id; // 主键ID
	private Integer roleId; // 角色ID
	private Integer menuId; // 菜单ID
	private String deptIds; // 部门ID集合，在有数据权限要求的模块。该值代表可以访问相应部门的数据

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}
	
	public Integer getRoleId() {
		return this.roleId;
	}
	
	public void setMenuId(Integer menuId) {
		this.menuId = menuId;
	}
	
	public Integer getMenuId() {
		return this.menuId;
	}
	
	public void setDeptIds(String deptIds) {
		this.deptIds = deptIds;
	}
	
	public String getDeptIds() {
		return this.deptIds;
	}
	
}