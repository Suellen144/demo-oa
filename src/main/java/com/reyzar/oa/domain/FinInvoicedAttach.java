package com.reyzar.oa.domain;

import java.lang.Double;
import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class FinInvoicedAttach extends BaseEntity {

	private Integer id; // 
	private Integer invoicedId; // 发票主ID
	private String name; // 
	private String model; // 型号
	private String unit; // 单位
	private String number; // 数量
	private Double price; // 
	private Double money; // 金额
	private String excise; //
	private Double exciseMoney; //
	private Double levied; //价税小计
	private Double totalMoney; // 合计

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setInvoicedId(Integer invoicedId) {
		this.invoicedId = invoicedId;
	}
	
	public Integer getInvoicedId() {
		return this.invoicedId;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setModel(String model) {
		this.model = model;
	}
	
	public String getModel() {
		return this.model;
	}
	
	public void setUnit(String unit) {
		this.unit = unit;
	}
	
	public String getUnit() {
		return this.unit;
	}
	
	public void setNumber(String number) {
		this.number = number;
	}
	
	public String getNumber() {
		return this.number;
	}
	
	public void setPrice(Double price) {
		this.price = price;
	}
	
	public Double getPrice() {
		return this.price;
	}
	
	public void setMoney(Double money) {
		this.money = money;
	}
	
	public Double getMoney() {
		return this.money;
	}
	
	public void setExcise(String excise) {
		this.excise = excise;
	}
	
	public String getExcise() {
		return this.excise;
	}
	
	public void setExciseMoney(Double exciseMoney) {
		this.exciseMoney = exciseMoney;
	}
	
	public Double getExciseMoney() {
		return this.exciseMoney;
	}
	
	public void setTotalMoney(Double totalMoney) {
		this.totalMoney = totalMoney;
	}
	
	public Double getTotalMoney() {
		return this.totalMoney;
	}
	public Double getLevied() {
		return levied;
	}

	public void setLevied(Double levied) {
		this.levied = levied;
	}
	
}