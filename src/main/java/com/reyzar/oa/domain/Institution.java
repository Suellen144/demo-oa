package com.reyzar.oa.domain;

import java.lang.String;
import java.util.List;
import java.lang.Integer;

@SuppressWarnings("serial")
public class Institution extends BaseEntity {

	private String id; // 主键
	private String parentId; // 父部门主键
	private String name; // 公司名称
	private String code; // 公司代码
	private Integer sort; //排序序号
	private String is_undo; //是否撤销
	private String is_dept; //是否为部门 0：是   1否
	private String gwzz;//岗位职责
	private String qxdy;//权限定义
	private String role_id;//角色id
	
	private List<Institution> children;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
	}
	public String getGwzz() {
		return gwzz;
	}
	public void setGwzz(String gwzz) {
		this.gwzz = gwzz;
	}
	public String getQxdy() {
		return qxdy;
	}
	public void setQxdy(String qxdy) {
		this.qxdy = qxdy;
	}
	public List<Institution> getChildren() {
		return children;
	}
	public void setChildren(List<Institution> children) {
		this.children = children;
	}
	public String getIs_undo() {
		return is_undo;
	}
	public void setIs_undo(String is_undo) {
		this.is_undo = is_undo;
	}
	public String getRole_id() {
		return role_id;
	}
	public void setRole_id(String role_id) {
		this.role_id = role_id;
	}
	public String getIs_dept() {
		return is_dept;
	}
	public void setIs_dept(String is_dept) {
		this.is_dept = is_dept;
	}
	
}