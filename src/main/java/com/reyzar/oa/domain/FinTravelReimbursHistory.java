package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class FinTravelReimbursHistory extends BaseEntity {

	private Integer id; // 主键ID
	private Integer userId; // 用户主键
	private String type; // 0：收款人 1：银行 2：银行卡号 3：开户行地址
	private String value; // 

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getType() {
		return this.type;
	}
	
	public void setValue(String value) {
		this.value = value;
	}
	
	public String getValue() {
		return this.value;
	}
	
}