package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdUserCar extends BaseEntity {

	private Integer id; // 
	private String processInstanceId; // 
	private String title; // 
	private Integer userId; // 
	private Integer deptId; // 
	private String desitination; // 目的地
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date startTime; // 开始时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endTime; // 返回时间
	private String reason; // 用车缘由
	private String status; // 
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 
	
	private SysUser applicant; // 流程发起人
	private SysDept dept;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	
	public String getProcessInstanceId() {
		return this.processInstanceId;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTitle() {
		return this.title;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setDesitination(String desitination) {
		this.desitination = desitination;
	}
	
	public String getDesitination() {
		return this.desitination;
	}
	
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	
	public Date getStartTime() {
		return this.startTime;
	}
	
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	
	public Date getEndTime() {
		return this.endTime;
	}
	
	public void setReason(String reason) {
		this.reason = reason;
	}
	
	public String getReason() {
		return this.reason;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}

	public SysUser getApplicant() {
		return applicant;
	}

	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}
	
}