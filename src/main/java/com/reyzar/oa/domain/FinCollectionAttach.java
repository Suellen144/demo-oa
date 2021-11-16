package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Collection;
import java.util.Date;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class FinCollectionAttach extends BaseEntity {

	private Integer id; // 
	private Integer collectionId; // 收款主键ID
	private Double collectionBill; // 
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date collectionDate; // 
	private Integer isSend; //

	private SaleProjectManage projectManage;
	private FinCollection finCollection;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setCollectionId(Integer collectionId) {
		this.collectionId = collectionId;
	}
	
	public Integer getCollectionId() {
		return this.collectionId;
	}
	
	public void setCollectionBill(Double collectionBill) {
		this.collectionBill = collectionBill;
	}
	
	public Double getCollectionBill() {
		return this.collectionBill;
	}
	
	public void setCollectionDate(Date collectionDate) {
		this.collectionDate = collectionDate;
	}
	
	public Date getCollectionDate() {
		return this.collectionDate;
	}
	
	public void setIsSend(Integer isSend) {
		this.isSend = isSend;
	}
	
	public Integer getIsSend() {
		return this.isSend;
	}

	public FinCollection getFinCollection() {
		return finCollection;
	}

	public void setFinCollection(FinCollection finCollection) {
		this.finCollection = finCollection;
	}

	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}
}