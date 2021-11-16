package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class NumSerial extends BaseEntity {

	private Integer id; // 主键ID
	private String number; // 流水号如：0001
	private String barginCode; // 完整流水号如：RZ20170009S
	private String barginType; // 合同类型
	private String isUsered; // 是否被使用 1：已被使用 0：没有
	private String isCancel; // 是否作废 1：是 0：否
	private Integer userId;//创建人ID
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setNumber(String number) {
		this.number = number;
	}
	
	public String getNumber() {
		return this.number;
	}
	
	public void setBarginCode(String barginCode) {
		this.barginCode = barginCode;
	}
	
	public String getBarginCode() {
		return this.barginCode;
	}
	
	public void setBarginType(String barginType) {
		this.barginType = barginType;
	}
	
	public String getBarginType() {
		return this.barginType;
	}
	
	public void setIsUsered(String isUsered) {
		this.isUsered = isUsered;
	}
	
	public String getIsUsered() {
		return this.isUsered;
	}
	
	public void setIsCancel(String isCancel) {
		this.isCancel = isCancel;
	}
	
	public String getIsCancel() {
		return this.isCancel;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	
	
}