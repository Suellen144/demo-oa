package com.reyzar.oa.domain;

import java.util.List;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

@SuppressWarnings("serial")
public class SysMenu extends BaseEntity {

	private Integer id; // 主键ID
	private Integer parentId; // 上一级父主键
	private String parentsId; // 父主键的集合
	@NotNull
	private String name; // 菜单名
	private String url; // URL
	private String enabled; // 是否启用菜单
	private String icon; // ICON图标
	@Min(value=0)
	private Integer sort; // 排序，数字从大到小优先
	private String permission; // 菜单权限，用“,”分隔多个权限。空值时代表全部权限
	
	private List<SysMenu> children;
	private List<SysPermission> permissionList;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getParentId() {
		return parentId;
	}

	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}

	public String getParentsId() {
		return parentsId;
	}

	public void setParentsId(String parentsId) {
		this.parentsId = parentsId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getEnabled() {
		return enabled;
	}

	public void setEnabled(String enabled) {
		this.enabled = enabled;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getPermission() {
		return permission;
	}

	public void setPermission(String permission) {
		this.permission = permission;
	}

	public List<SysMenu> getChildren() {
		return children;
	}

	public void setChildren(List<SysMenu> children) {
		this.children = children;
	}

	public List<SysPermission> getPermissionList() {
		return permissionList;
	}

	public void setPermissionList(List<SysPermission> permissionList) {
		this.permissionList = permissionList;
	}

	@Override
	public String toString() {
		return "SysMenu [id=" + id + ", parentId=" + parentId + ", parentsId=" + parentsId + ", name=" + name + ", url="
				+ url + ", enabled=" + enabled + ", icon=" + icon + ", sort=" + sort + ", permission=" + permission
				+ ", children=" + children + ", permissionList=" + permissionList + "]";
	}

}