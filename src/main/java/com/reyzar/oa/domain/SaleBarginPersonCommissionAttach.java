package com.reyzar.oa.domain;

import java.lang.Double;
import java.lang.Integer;
import java.math.BigDecimal;

@SuppressWarnings("serial")
public class SaleBarginPersonCommissionAttach extends BaseEntity {

	private Integer id; // 主键
	private Integer commissionId; // 主表ID
	private Integer deptId; // 部门ID
	private String deptName;//部门名称
	private Integer userId; // 用户ID
	private String userName;//用户名称
	private Double userCommissionPercent;//用户年度提成比例
	private BigDecimal userCommission; // 用户年度提成

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setCommissionId(Integer commissionId) {
		this.commissionId = commissionId;
	}
	
	public Integer getCommissionId() {
		return this.commissionId;
	}
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Double getUserCommissionPercent() {
		return userCommissionPercent;
	}

	public void setUserCommissionPercent(Double userCommissionPercent) {
		this.userCommissionPercent = userCommissionPercent;
	}

	public BigDecimal getUserCommission() {
		return userCommission;
	}

	public void setUserCommission(BigDecimal userCommission) {
		this.userCommission = userCommission;
	}
}