package com.reyzar.oa.domain;

import java.lang.Double;
import java.lang.Integer;
import java.math.BigDecimal;
import java.text.DecimalFormat;

@SuppressWarnings("serial")
public class SaleBarginUserAnnualAttach extends BaseEntity {

	private Integer id; // 主键
	private Integer annualId; // 主表ID
	private Integer barginId; // 合同主键ID
	private Integer commissionId; //个人提成表的主表ID
	private Double barginAnnualCommissionPercent;//合同年度提成比例
	private BigDecimal barginAnnualCommission; // 合同年度提成
	private BigDecimal barginAnnualIncome; // 合同年度收入
	private BigDecimal barginAnnualPay; // 合同年度支出
	private Integer barginAnnual; // 合同年度
	private Integer userId; // 用户主键ID
	private Double userCommission; // 用户年度提成


	private SaleBarginManage saleBarginManage;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setAnnualId(Integer annualId) {
		this.annualId = annualId;
	}
	
	public Integer getAnnualId() {
		return this.annualId;
	}
	
	public void setBarginId(Integer barginId) {
		this.barginId = barginId;
	}
	
	public Integer getBarginId() {
		return this.barginId;
	}

	public BigDecimal getBarginAnnualIncome() {
		return barginAnnualIncome;
	}

	public void setBarginAnnualIncome(BigDecimal barginAnnualIncome) {
		this.barginAnnualIncome = barginAnnualIncome;
	}

	public BigDecimal getBarginAnnualPay() {
		return barginAnnualPay;
	}

	public void setBarginAnnualPay(BigDecimal barginAnnualPay) {
		this.barginAnnualPay = barginAnnualPay;
	}

	public void setBarginAnnual(Integer barginAnnual) {
		this.barginAnnual = barginAnnual;
	}
	
	public Integer getBarginAnnual() {
		return this.barginAnnual;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public void setUserCommission(Double userCommission) {
		this.userCommission = userCommission;
	}
	
	public Double getUserCommission() {
		return this.userCommission;
	}

	public SaleBarginManage getSaleBarginManage() {
		return saleBarginManage;
	}

	public void setSaleBarginManage(SaleBarginManage saleBarginManage) {
		this.saleBarginManage = saleBarginManage;
	}

	public Integer getCommissionId() {
		return commissionId;
	}

	public void setCommissionId(Integer commissionId) {
		this.commissionId = commissionId;
	}

	public Double getBarginAnnualCommissionPercent() {
		return barginAnnualCommissionPercent;
	}

	public void setBarginAnnualCommissionPercent(Double barginAnnualCommissionPercent) {
		this.barginAnnualCommissionPercent = barginAnnualCommissionPercent;
	}

	public BigDecimal getBarginAnnualCommission() {
		return barginAnnualCommission;
	}

	public void setBarginAnnualCommission(BigDecimal barginAnnualCommission) {
		this.barginAnnualCommission = barginAnnualCommission;
	}
}