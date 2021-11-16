package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdArbeitsvertrag extends BaseEntity{
	private Integer id;
	private Integer recordId; 
	private Integer company;  //公司
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date beginDate;	 //起始时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endDate;	 //结束时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date signDate;	//签订日期
	private int barginType;  //合同性质
	private String  signReason;  //签约说明
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
	public Integer getCompany() {
		return company;
	}
	public void setCompany(Integer company) {
		this.company = company;
	}
	public Date getBeginDate() {
		return beginDate;
	}
	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public Date getSignDate() {
		return signDate;
	}
	public void setSignDate(Date signDate) {
		this.signDate = signDate;
	}
	public int getBarginType() {
		return barginType;
	}
	public void setBarginType(int barginType) {
		this.barginType = barginType;
	}
	public String getSignReason() {
		return signReason;
	}
	public void setSignReason(String signReason) {
		this.signReason = signReason;
	}
	
}
