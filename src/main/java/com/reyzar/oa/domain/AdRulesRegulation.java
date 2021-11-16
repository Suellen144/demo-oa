package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdRulesRegulation extends BaseEntity {

	private Integer id; // 主键ID
	private Integer outlineId; // 大纲主键
	private String publicContent; // 发布内容
	private String unpublicContent; // 未发布内容
	private String publicStatus; // 发布状态

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setOutlineId(Integer outlineId) {
		this.outlineId = outlineId;
	}
	
	public Integer getOutlineId() {
		return this.outlineId;
	}
	
	public void setPublicContent(String publicContent) {
		this.publicContent = publicContent;
	}
	
	public String getPublicContent() {
		return this.publicContent;
	}
	
	public void setUnpublicContent(String unpublicContent) {
		this.unpublicContent = unpublicContent;
	}
	
	public String getUnpublicContent() {
		return this.unpublicContent;
	}
	
	public void setPublicStatus(String publicStatus) {
		this.publicStatus = publicStatus;
	}
	
	public String getPublicStatus() {
		return this.publicStatus;
	}
	
}