package com.reyzar.oa.domain;

import java.lang.String;

import java.lang.Integer;

@SuppressWarnings("serial")
public class Responsibility extends BaseEntity {

	private Integer id; // 主键
	private Integer deptId; // 部门主键
	private String content;//岗位职责
	private Integer titleOrContent;//区别是部门还是角色
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getDeptId() {
		return deptId;
	}
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getTitleOrContent() {
		return titleOrContent;
	}
	public void setTitleOrContent(Integer titleOrContent) {
		this.titleOrContent = titleOrContent;
	}
	
}