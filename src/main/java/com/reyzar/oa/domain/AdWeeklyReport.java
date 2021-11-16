package com.reyzar.oa.domain;

import java.util.Date;
import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdWeeklyReport extends BaseEntity {

	private Integer id; // 主键
	private Integer month; // 周报填写月份
	private Integer number; // 当月第几份周报
	private Integer projectId; // 归属项目
	private Integer userId; // 周报作者
	private Date workDate; // 工作当天日期
	private Double workTime; // 工时
	private String description; // 工作内容
	private String categorize; // 标识不同记录为同一批周报
	private String status; // 审核状态 0：未审核 1：已审核
	
	private SysUser author;
	private SaleProjectManage project;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setMonth(Integer month) {
		this.month = month;
	}
	
	public Integer getMonth() {
		return this.month;
	}
	
	public void setNumber(Integer number) {
		this.number = number;
	}
	
	public Integer getNumber() {
		return this.number;
	}
	
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}
	
	public Integer getProjectId() {
		return this.projectId;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
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
	
	public void setCategorize(String categorize) {
		this.categorize = categorize;
	}
	
	public String getCategorize() {
		return this.categorize;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}

	public SysUser getAuthor() {
		return author;
	}

	public void setAuthor(SysUser author) {
		this.author = author;
	}

	public SaleProjectManage getProject() {
		return project;
	}

	public void setProject(SaleProjectManage project) {
		this.project = project;
	}
	
}