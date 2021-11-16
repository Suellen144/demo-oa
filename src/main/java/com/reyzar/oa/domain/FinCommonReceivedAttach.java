package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class FinCommonReceivedAttach extends BaseEntity {
	private Integer id; // 主键ID
	private Integer commonReceivedId;
	private Integer projectManageId;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date date; // 日期
	private String reason; // 事由
	private String money; // 报销人
	private String type; // 收款银行卡号
	private String payAccount; // 收款账户
	private String payCompany; // 收款单位
	private String costProperty; // 費用性质
	private Integer deptId;
	private SysDept dept;
	
	private SaleProjectManage projectManage;
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getCommonReceivedId() {
		return commonReceivedId;
	}

	public void setCommonReceivedId(Integer commonReceivedId) {
		this.commonReceivedId = commonReceivedId;
	}

	public Integer getProjectManageId() {
		return projectManageId;
	}

	public void setProjectManageId(Integer projectManageId) {
		this.projectManageId = projectManageId;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getMoney() {
		return money;
	}

	public void setMoney(String money) {
		this.money = money;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPayAccount() {
		return payAccount;
	}

	public void setPayAccount(String payAccount) {
		this.payAccount = payAccount;
	}

	public String getPayCompany() {
		return payCompany;
	}

	public void setPayCompany(String payCompany) {
		this.payCompany = payCompany;
	}

	public String getCostProperty() {
		return costProperty;
	}

	public void setCostProperty(String costProperty) {
		this.costProperty = costProperty;
	}
	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}

	
}