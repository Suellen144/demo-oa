package com.reyzar.oa.domain;

import java.util.Date;
import java.lang.String;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdSeal extends BaseEntity {

	private Integer id; // 
	private String processInstanceId; // 
	private String title; // 
	private String company;
	private String sealType;
	private String apply;
	private Integer userId; //
	private Integer deptId; // 
	private String attachments; // 附件
	private String attachName; // 附件原文件名
	private String reason; // 事由
	private String status; // 状态
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
	
	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}
	
	public String getAttachments() {
		return this.attachments;
	}
	
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	
	public String getAttachName() {
		return this.attachName;
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

	public String getSealType() {
		return sealType;
	}

	public void setSealType(String sealType) {
		this.sealType = sealType;
	}


	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getApply() {
		return apply;
	}

	public void setApply(String apply) {
		this.apply = apply;
	}


}