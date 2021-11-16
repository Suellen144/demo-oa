package com.reyzar.oa.domain;

import java.util.Date;
import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdWorkReportAttach extends BaseEntity {

	private Integer id; // 主键
	private Integer workReportId; // 工作汇报表主键
	private Integer projectId; // 归属项目
	private Date workDate; // 工作当天日期
	private Double workTime; // 工时
	private String description; // 工作内容
	
	private SaleProjectManage project;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setWorkReportId(Integer workReportId) {
		this.workReportId = workReportId;
	}
	
	public Integer getWorkReportId() {
		return this.workReportId;
	}
	
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}
	
	public Integer getProjectId() {
		return this.projectId;
	}
	
	public void setWorkDate(Date workDate) {
		this.workDate = workDate;
	}
	
	public Date getWorkDate() {
		return this.workDate;
	}
	
	public void setWorkTime(Double workTime) {
		this.workTime = workTime;
	}
	
	public Double getWorkTime() {
		return this.workTime;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getDescription() {
		return this.description;
	}

	public SaleProjectManage getProject() {
		return project;
	}

	public void setProject(SaleProjectManage project) {
		this.project = project;
	}
	
}