package com.reyzar.oa.domain;

import java.util.Date;

@SuppressWarnings("serial")
public class SaleTicketConfirmation extends BaseEntity {

	private Integer id; // 主键
	private Date ticketDate;//收票时间
	private Double ticketLines;//收票额
	private String rate;//税率
	private Double deductionLines;//抵扣额
	private Integer ticketUserId;//收票人
	private SysUser sysUser;//
	private Integer barginManageId;//合同id
	private Integer issubmit; //区分保存和提交
	
	private String cumulative;//用于累计标识
	private String userName;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Date getTicketDate() {
		return ticketDate;
	}
	public void setTicketDate(Date ticketDate) {
		this.ticketDate = ticketDate;
	}
	public Double getTicketLines() {
		return ticketLines;
	}
	public void setTicketLines(Double ticketLines) {
		this.ticketLines = ticketLines;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	public Double getDeductionLines() {
		return deductionLines;
	}
	public void setDeductionLines(Double deductionLines) {
		this.deductionLines = deductionLines;
	}
	public Integer getTicketUserId() {
		return ticketUserId;
	}
	public void setTicketUserId(Integer ticketUserId) {
		this.ticketUserId = ticketUserId;
	}
	public SysUser getSysUser() {
		return sysUser;
	}
	public void setSysUser(SysUser sysUser) {
		this.sysUser = sysUser;
	}
	public Integer getBarginManageId() {
		return barginManageId;
	}
	public void setBarginManageId(Integer barginManageId) {
		this.barginManageId = barginManageId;
	}
	public Integer getIssubmit() {
		return issubmit;
	}
	public void setIssubmit(Integer issubmit) {
		this.issubmit = issubmit;
	}
	public String getCumulative() {
		return cumulative;
	}
	public void setCumulative(String cumulative) {
		this.cumulative = cumulative;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	
}
