package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class FinCommonPay extends BaseEntity {
	private Integer id; // 主键ID
	private String processInstanceId; // 流程实例ID
	private String status;
	private Integer userId; // 流程发起人用户主键
	private Integer deptId; // 部门主键
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 填报日期
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date voucherTime; // 制表月份
	private String payCompany; // 付款单位
	private String attachName; // 附件原文件名
	private String attachments; // 附件
	private String encrypted; // 标记是否被加密过 y:是 n:否
	
	private SysDept dept; // 关联部门
	private SysUser user; // 流程发起人
	private List<FinCommonPayAttach> commonPayAttachs;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getProcessInstanceId() {
		return processInstanceId;
	}
	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public Integer getDeptId() {
		return deptId;
	}
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	public Date getApplyTime() {
		return applyTime;
	}
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	public String getPayCompany() {
		return payCompany;
	}
	public void setPayCompany(String payCompany) {
		this.payCompany = payCompany;
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
	public String getEncrypted() {
		return encrypted;
	}
	public void setEncrypted(String encrypted) {
		this.encrypted = encrypted;
	}
	public SysDept getDept() {
		return dept;
	}
	public void setDept(SysDept dept) {
		this.dept = dept;
	}
	public SysUser getUser() {
		return user;
	}
	public void setUser(SysUser user) {
		this.user = user;
	}
	public List<FinCommonPayAttach> getCommonPayAttachs() {
		return commonPayAttachs;
	}
	public void setCommonPayAttachs(List<FinCommonPayAttach> commonPayAttachs) {
		this.commonPayAttachs = commonPayAttachs;
	}
	public Date getVoucherTime() {
		return voucherTime;
	}
	public void setVoucherTime(Date voucherTime) {
		this.voucherTime = voucherTime;
	}

	
}