package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdDirectoryManage extends BaseEntity {

	private Integer id; // 主键ID
	private Integer parentId; // 上级主键
	private String parentsId; // 上级主键集合
	private String name; // 目录名
	private String deptIds; // 部门ID集，部门内才可以查看此目录的文件
	private String comment; // 备注

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	
	public Integer getParentId() {
		return this.parentId;
	}
	
	public void setParentsId(String parentsId) {
		this.parentsId = parentsId;
	}
	
	public String getParentsId() {
		return this.parentsId;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setDeptIds(String deptIds) {
		this.deptIds = deptIds;
	}
	
	public String getDeptIds() {
		return this.deptIds;
	}
	
	public void setComment(String comment) {
		this.comment = comment;
	}
	
	public String getComment() {
		return this.comment;
	}
	
}