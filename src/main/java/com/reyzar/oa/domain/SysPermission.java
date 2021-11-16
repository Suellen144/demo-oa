package com.reyzar.oa.domain;

@SuppressWarnings("serial")
public class SysPermission extends BaseEntity {

	private Integer id; // 主键ID
	private Integer menuId; // 菜单主键
	private String code; // 权限代码
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getMenuId() {
		return menuId;
	}
	public void setMenuId(Integer menuId) {
		this.menuId = menuId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}

}