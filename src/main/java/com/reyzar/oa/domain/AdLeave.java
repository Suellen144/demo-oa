package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdLeave extends BaseEntity {

	private Integer id; // 主键ID
	private String processInstanceId; // 流程实例主键
	private String title; // 流程表单的头部公司标识
	private Integer userId; // 用户主键
	private Integer deptId; // 部门主键
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date startTime; // 请假起始时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endTime; // 请假结束时间
	private String leaveType; // 请假类型
	private Integer days; // 请假的天数
	private Double hours; // 请假的小时数
	private String reason; // 请假理由
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 申请日期
	private String attachName; // 附件原文件名
	private String attachments; // 附件
	private String status; // 审批状态
	private Date backTime; // 销假时间
	private String backWay; // 销假方式 0：自动 1：手动

	private SysUser applicant; // 流程发起人
	private SysDept dept;
	private String isOk; //是否有项目经理
	
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
	
	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
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
	
	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}
	
	public String getLeaveType() {
		return this.leaveType;
	}
	
	public void setDays(Integer days) {
		this.days = days;
	}
	
	public Integer getDays() {
		return this.days;
	}
	
	public void setHours(Double hours) {
		this.hours = hours;
	}
	
	public Double getHours() {
		return this.hours;
	}
	
	public void setReason(String reason) {
		this.reason = reason;
	}
	
	public String getReason() {
		return this.reason;
	}
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	
	public String getAttachName() {
		return this.attachName;
	}
	
	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}
	
	public String getAttachments() {
		return this.attachments;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}
	
	public Date getBackTime() {
		return backTime;
	}

	public void setBackTime(Date backTime) {
		this.backTime = backTime;
	}

	public String getBackWay() {
		return backWay;
	}

	public void setBackWay(String backWay) {
		this.backWay = backWay;
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

	public String getIsOk() {
		return isOk;
	}

	public void setIsOk(String isOk) {
		this.isOk = isOk;
	}
	
	
}