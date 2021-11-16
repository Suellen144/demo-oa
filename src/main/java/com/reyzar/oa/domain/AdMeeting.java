package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdMeeting extends BaseEntity {

	private Integer id; // 
	private Integer userId; // 
	private Integer deptId; // 
	private String number;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 填写时间
	private String presenters; // 主持人
	private String participant; // 参与人员
	private String theme; // 主题
	private String comment; // 内容
	private String userids; // 用户ID组
	private String status; //状态
	
	private SysUser applicant; // 流程发起人
	private SysDept dept;

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
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setPresenters(String presenters) {
		this.presenters = presenters;
	}
	
	public String getPresenters() {
		return this.presenters;
	}
	
	public void setParticipant(String participant) {
		this.participant = participant;
	}
	
	public String getParticipant() {
		return this.participant;
	}
	
	public void setTheme(String theme) {
		this.theme = theme;
	}
	
	public String getTheme() {
		return this.theme;
	}
	
	public void setComment(String comment) {
		this.comment = comment;
	}
	
	public String getComment() {
		return this.comment;
	}
	
	public void setUserids(String userids) {
		this.userids = userids;
	}
	
	public String getUserids() {
		return this.userids;
	}

	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
}