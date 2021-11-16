package com.reyzar.oa.common.dto;

public class BarginProfitDTO {

	private String projectName;
	private Double sellTotal;//销售总金额
	private Double buyerTotal;//采购总金额
	private Double fee;//费用
	private Double margin;//利润
	public Double getSellTotal() {
		return sellTotal;
	}
	public void setSellTotal(Double sellTotal) {
		this.sellTotal = sellTotal;
	}
	
	public Double getBuyerTotal() {
		return buyerTotal;
	}
	public void setBuyerTotal(Double buyerTotal) {
		this.buyerTotal = buyerTotal;
	}
	public Double getFee() {
		return fee;
	}
	public void setFee(Double fee) {
		this.fee = fee;
	}
	public Double getMargin() {
		return margin;
	}
	public void setMargin(Double margin) {
		this.margin = margin;
	}
	public String getProjectName() {
		return projectName;
	}
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	
	
	
}
