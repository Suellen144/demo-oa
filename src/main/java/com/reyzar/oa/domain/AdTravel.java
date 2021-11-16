package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdTravel extends BaseEntity {

	private Integer id; // 主键ID
	private String processInstanceId; // 流程实例ID
	private Integer userId; // 出差人员用户主键
	private String travelerName; //出差人员姓名
	private String title;
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date applyTime; // 申请时间
	private Double budget; // 费用预算
	private String status; // 审批状态
	private String attachName; // 附件原文件名
	private String attachments; // 附件
	private String comment; // 备注

	private SysUser applicant; // 流程发起人
	private List<AdTravelAttach> travelAttachList;
	
	private String travelResult; // 出差结果
	private String isProcess; // 是否新流程

	public String getTravelerName() {
		return travelerName;
	}

	public void setTravelerName(String travelerName) {
		this.travelerName = travelerName;
	}

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
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setBudget(Double budget) {
		this.budget = budget;
	}
	
	public Double getBudget() {
		return this.budget;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}
	
	public String getAttachName() {
		return attachName;
	}

	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}

	public String getAttachments() {
		return attachments;
	}

	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}
	
	public String getComment() {
		return this.comment;
	}

	public SysUser getApplicant() {
		return applicant;
	}

	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}

	public List<AdTravelAttach> getTravelAttachList() {
		return travelAttachList;
	}

	public void setTravelAttachList(List<AdTravelAttach> travelAttachList) {
		this.travelAttachList = travelAttachList;
	}

	public String getTravelResult() {
		return travelResult;
	}

	public void setTravelResult(String travelResult) {
		this.travelResult = travelResult;
	}

	public String getIsProcess() {
		return isProcess;
	}

	public void setIsProcess(String isProcess) {
		this.isProcess = isProcess;
	}	
	
	
}