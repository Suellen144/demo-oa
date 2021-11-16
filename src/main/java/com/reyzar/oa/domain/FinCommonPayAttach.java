package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class FinCommonPayAttach extends BaseEntity {
	private Integer id; // 主键ID
	private Integer commonPayId;
	private Integer projectManageId;//项目ID
	private Integer attachDeptId;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date date; // 日期
	private String reason; // 事由
	private String money; // 报销人
	private String type; // 收款银行卡号
	private String receivedAccount; // 收款账户
	private String receivedCompany; // 收款单位
	private String costProperty; // 費用性质
	private Integer deptId;
	private SysDept dept;
	
	private FinCommonPay commonPay;
	private SaleProjectManage projectManage;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getCommonPayId() {
		return commonPayId;
	}

	public void setCommonPayId(Integer commonPayId) {
		this.commonPayId = commonPayId;
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

	public String getReceivedAccount() {
		return receivedAccount;
	}

	public void setReceivedAccount(String receivedAccount) {
		this.receivedAccount = receivedAccount;
	}

	public String getReceivedCompany() {
		return receivedCompany;
	}

	public void setReceivedCompany(String receivedCompany) {
		this.receivedCompany = receivedCompany;
	}

	public FinCommonPay getCommonPay() {
		return commonPay;
	}

	public void setCommonPay(FinCommonPay commonPay) {
		this.commonPay = commonPay;
	}

	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}

	public String getCostProperty() {
		return costProperty;
	}

	public void setCostProperty(String costProperty) {
		this.costProperty = costProperty;
	}


	public Integer getAttachDeptId() {
		return attachDeptId;
	}

	public void setAttachDeptId(Integer attachDeptId) {
		this.attachDeptId = attachDeptId;
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