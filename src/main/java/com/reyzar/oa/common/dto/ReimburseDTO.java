package com.reyzar.oa.common.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.reyzar.oa.domain.BaseEntity;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: ReimburseDTO 
* @Description: 报销管理DTO
*  
*/
@SuppressWarnings("serial")
public class ReimburseDTO extends BaseEntity {

	private Integer id;
	private Double cost;
	private String name;
	private String processInstanceId;
	private String userId;
	private String orderNo;
	private SysUser applicant; // 流程发起人
	private SysDept dept;
	private String reason;
	private String detail;
	private String status; // 审批状态 
	private Integer kind; //报销类型
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 填报日期
	
	private String projectId;
	private SaleProjectManage project;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getProcessInstanceId() {
		return processInstanceId;
	}
	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public SysUser getApplicant() {
		return applicant;
	}
	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getApplyTime() {
		return applyTime;
	}
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	public Integer getKind() {
		return kind;
	}
	public void setKind(Integer kind) {
		this.kind = kind;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}
	
	public SysDept getDept() {
		return dept;
	}
	public void setDept(SysDept dept) {
		this.dept = dept;
	}
	public String getProjectId() {
		return projectId;
	}
	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	public SaleProjectManage getProject() {
		return project;
	}
	public void setProject(SaleProjectManage project) {
		this.project = project;
	}
	
	public Double getCost() {
		return cost;
	}
	public void setCost(Double cost) {
		this.cost = cost;
	}
	
	@Override
	public String toString() {
		return "ReimburseDTO [id=" + id + ",cost=" + cost + ", name=" + name + ", processInstanceId=" + processInstanceId + ", userId="
				+ userId + ", orderNo=" + orderNo + ", applicant=" + applicant + ", dept=" + dept + ", reason=" + reason
				+ ", detail=" + detail + ", status=" + status + ", kind=" + kind + ", applyTime=" + applyTime
				+ ", projectId=" + projectId + ", project=" + project + "]";
	}	
	
}
