package com.reyzar.oa.domain;

import java.util.List;

@SuppressWarnings("serial")
public class SysRole extends BaseEntity {

	private Integer id; // 主键ID
	private String name; // 角色名
	private String enname; // 角色英文名
	private String enabled; // 是否启用 1：是 0：否
	private Integer deptId; // 部门id
	private Integer index;//序号
	
	private List<SysMenu> menuList;
	private List<SysPermission> permissionList;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setEnname(String enname) {
		this.enname = enname;
	}
	
	public String getEnname() {
		return this.enname;
	}
	
	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}
	
	public String getEnabled() {
		return this.enabled;
	}

	public List<SysMenu> getMenuList() {
		return menuList;
	}

	public void setMenuList(List<SysMenu> menuList) {
		this.menuList = menuList;
	}

	public List<SysPermission> getPermissionList() {
		return permissionList;
	}

	public void setPermissionList(List<SysPermission> permissionList) {
		this.permissionList = permissionList;
	}

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public Integer getIndex() {
		return index;
	}

	public void setIndex(Integer index) {
		this.index = index;
	}

}