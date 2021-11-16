package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdPayAdjustment extends BaseEntity{

	
	private Integer id;
	private Integer recordId;
	private String basePay;				//基本工资
	private String meritPay;			//绩效工资
	private String agePay;				//工龄工资
	private String lunchSubsidy;		//午餐补贴
	private String computerSubsidy;		//电脑补贴
	private String accumulationFund;	//公积金
	private String total;				//合计
	private String payReason;			//调薪原因
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date changeDate;			//调薪日期
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getRecordId() {
		return recordId;
	}
	public void setRecordId(Integer recordId) {
		this.recordId = recordId;
	}
	public String getBasePay() {
		return basePay;
	}
	public void setBasePay(String basePay) {
		this.basePay = basePay;
	}
	public String getMeritPay() {
		return meritPay;
	}
	public void setMeritPay(String meritPay) {
		this.meritPay = meritPay;
	}
	public String getAgePay() {
		return agePay;
	}
	public void setAgePay(String agePay) {
		this.agePay = agePay;
	}
	public String getLunchSubsidy() {
		return lunchSubsidy;
	}
	public void setLunchSubsidy(String lunchSubsidy) {
		this.lunchSubsidy = lunchSubsidy;
	}
	public String getComputerSubsidy() {
		return computerSubsidy;
	}
	public void setComputerSubsidy(String computerSubsidy) {
		this.computerSubsidy = computerSubsidy;
	}
	
	public String getAccumulationFund() {
		return accumulationFund;
	}
	public void setAccumulationFund(String accumulationFund) {
		this.accumulationFund = accumulationFund;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getPayReason() {
		return payReason;
	}
	public void setPayReason(String payReason) {
		this.payReason = payReason;
	}
	public Date getChangeDate() {
		return changeDate;
	}
	public void setChangeDate(Date changeDate) {
		this.changeDate = changeDate;
	}
	
	
}
