package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class FinPayAttach extends BaseEntity {

	private Integer id; // 
	private Integer payId; // 收款主键ID
	private Double payBill; // 
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date payDate; // 
	private Integer isSend; //

	private SaleProjectManage projectManage;
	private FinPay finPay;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setPayId(Integer payId) {
		this.payId = payId;
	}
	
	public Integer getPayId() {
		return this.payId;
	}
	
	public void setPayBill(Double payBill) {
		this.payBill = payBill;
	}
	
	public Double getPayBill() {
		return this.payBill;
	}
	
	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	
	public Date getPayDate() {
		return this.payDate;
	}
	
	public void setIsSend(Integer isSend) {
		this.isSend = isSend;
	}
	
	public Integer getIsSend() {
		return this.isSend;
	}

	public FinPay getFinPay() {
		return finPay;
	}

	public void setFinPay(FinPay finPay) {
		this.finPay = finPay;
	}

	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}
}