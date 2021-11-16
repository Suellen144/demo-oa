package com.reyzar.oa.domain;

import java.util.List;

@SuppressWarnings("serial")
public class AdWorkReport extends BaseEntity {

	private Integer id; // 主键
	private Integer userId; // 周报作者
	private Integer month; // 周报填写月份
	private Integer number; // 当月第几份周报
	private String weekPlan; // 周计划
	private String monthPlan; // 月计划
	private String monthSummary; // 月总结
	private String status; // 审核状态 0：未审核 1：已审核
	
	private SysUser author;
	private List<AdWorkReportAttach> workReportAttachList;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
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
	
	public void setWeekPlan(String weekPlan) {
		this.weekPlan = weekPlan;
	}
	
	public String getWeekPlan() {
		return this.weekPlan;
	}
	
	
	
	public String getMonthSummary() {
		return monthSummary;
	}

	public void setMonthSummary(String monthSummary) {
		this.monthSummary = monthSummary;
	}

	public void setMonthPlan(String monthPlan) {
		this.monthPlan = monthPlan;
	}
	
	public String getMonthPlan() {
		return this.monthPlan;
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

	public List<AdWorkReportAttach> getWorkReportAttachList() {
		return workReportAttachList;
	}

	public void setWorkReportAttachList(List<AdWorkReportAttach> workReportAttachList) {
		this.workReportAttachList = workReportAttachList;
	}
	
}