package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdFileManage extends BaseEntity {

	private Integer id; // 主键ID
	private Integer directoryId; // 所属目录
	private String name; // 文件名
	private String originName; // 原始文件名
	private String filePath; // 文件所保存路径
	private String deptIds; // 部门ID集，部门内才可以查看此文件
	private String type; // 文件分类
	private String comment; // 备注

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public Integer getDirectoryId() {
		return directoryId;
	}

	public void setDirectoryId(Integer directoryId) {
		this.directoryId = directoryId;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setOriginName(String originName) {
		this.originName = originName;
	}
	
	public String getOriginName() {
		return this.originName;
	}
	
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
	public String getFilePath() {
		return this.filePath;
	}
	
	public void setDeptIds(String deptIds) {
		this.deptIds = deptIds;
	}
	
	public String getDeptIds() {
		return this.deptIds;
	}
	
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}
	
	public String getComment() {
		return this.comment;
	}
	
}