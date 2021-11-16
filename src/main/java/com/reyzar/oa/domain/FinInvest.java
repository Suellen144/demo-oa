package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class FinInvest extends BaseEntity {

	private Integer id; // 主键ID
	private String value; // 费用归属（单位或个人）

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setValue(String value) {
		this.value = value;
	}
	
	public String getValue() {
		return this.value;
	}
	
}