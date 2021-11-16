package com.reyzar.oa.domain;

import java.lang.Integer;
import java.util.List;

@SuppressWarnings("serial")
public class SaleBarginUserAnnual extends BaseEntity {

	private Integer id; // 主键
	private Integer annual; // 年度

	private List<SaleBarginUserAnnualAttach> barginAttachs;

	private List<SaleBarginManage> saleBarginManageList;
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getAnnual() {
		return annual;
	}

	public void setAnnual(Integer annual) {
		this.annual = annual;
	}

	public List<SaleBarginUserAnnualAttach> getBarginAttachs() {
		return barginAttachs;
	}

	public void setBarginAttachs(List<SaleBarginUserAnnualAttach> barginAttachs) {
		this.barginAttachs = barginAttachs;
	}

	public List<SaleBarginManage> getSaleBarginManageList() {
		return saleBarginManageList;
	}

	public void setSaleBarginManageList(List<SaleBarginManage> saleBarginManageList) {
		this.saleBarginManageList = saleBarginManageList;
	}
}