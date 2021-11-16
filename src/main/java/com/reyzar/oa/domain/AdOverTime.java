package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.lang.String;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

/*加班申请*/

@SuppressWarnings("serial")
public class AdOverTime extends BaseEntity {

	private Integer id; // 主键ID
	private String processInstanceId; // 流程ID
	private Integer userId; // 用户ID
	private Integer deptId; // 部门ID
	private String title; // 流程表单的头部公司标识
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date startTime; // 开始时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endTime; // 结束时间
	private String reason; // 加班缘由
	private Integer days; // 天数
	private Double hours; // 小时数
	private String status; // 申请状态
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 申请时间
	
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

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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