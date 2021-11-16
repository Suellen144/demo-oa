package com.reyzar.oa.common.dto;


import com.reyzar.oa.domain.SaleProjectManage;

public class StatiscsBarginOtherDTO {

	private Integer id; // 主键
	private Integer projectManageId;
	
	private Double totalMoneyS; // 销售合同总金额
	private Double receivedMoney; // 已收金额
	private Double unreceivedMoney; // 未收金额
	private Double invoiceMoney;//开票金额
	private Double advancesReceived;//预收款
	private Double accountReceived;//应收款
	
	private Double totalMoneyB; // 采购合同总金额
	private Double payMoney; // 已付金额
	private Double payBill; // 实际已付款金额
	private Double unpayMoney; // 未付金额
	private Double unReceivedInvoice;//未收发票
	private Double payReceivedInvoice; // 付款已收发票
	private Double payUnreceivedInvoice; // 付款未收发票
	
	private SaleProjectManage projectManage;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getProjectManageId() {
		return projectManageId;
	}

	public void setProjectManageId(Integer projectManageId) {
		this.projectManageId = projectManageId;
	}

	public Double getTotalMoneyS() {
		return totalMoneyS;
	}

	public void setTotalMoneyS(Double totalMoneyS) {
		this.totalMoneyS = totalMoneyS;
	}

	public Double getReceivedMoney() {
		return receivedMoney;
	}

	public void setReceivedMoney(Double receivedMoney) {
		this.receivedMoney = receivedMoney;
	}

	public Double getUnreceivedMoney() {
		return unreceivedMoney;
	}

	public void setUnreceivedMoney(Double unreceivedMoney) {
		this.unreceivedMoney = unreceivedMoney;
	}

	public Double getInvoiceMoney() {
		return invoiceMoney;
	}

	public void setInvoiceMoney(Double invoiceMoney) {
		this.invoiceMoney = invoiceMoney;
	}

	public Double getAdvancesReceived() {
		return advancesReceived;
	}

	public void setAdvancesReceived(Double advancesReceived) {
		this.advancesReceived = advancesReceived;
	}

	public Double getAccountReceived() {
		return accountReceived;
	}

	public void setAccountReceived(Double accountReceived) {
		this.accountReceived = accountReceived;
	}

	public Double getTotalMoneyB() {
		return totalMoneyB;
	}

	public void setTotalMoneyB(Double totalMoneyB) {
		this.totalMoneyB = totalMoneyB;
	}

	public Double getPayMoney() {
		return payMoney;
	}

	public void setPayMoney(Double payMoney) {
		this.payMoney = payMoney;
	}

	public Double getUnpayMoney() {
		return unpayMoney;
	}

	public void setUnpayMoney(Double unpayMoney) {
		this.unpayMoney = unpayMoney;
	}

	public Double getUnReceivedInvoice() {
		return unReceivedInvoice;
	}

	public void setUnReceivedInvoice(Double unReceivedInvoice) {
		this.unReceivedInvoice = unReceivedInvoice;
	}

	public Double getPayReceivedInvoice() {
		return payReceivedInvoice;
	}

	public void setPayReceivedInvoice(Double payReceivedInvoice) {
		this.payReceivedInvoice = payReceivedInvoice;
	}

	public Double getPayUnreceivedInvoice() {
		return payUnreceivedInvoice;
	}

	public void setPayUnreceivedInvoice(Double payUnreceivedInvoice) {
		this.payUnreceivedInvoice = payUnreceivedInvoice;
	}

	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}

	public Double getPayBill() {
		return payBill;
	}

	public void setPayBill(Double payBill) {
		this.payBill = payBill;
	}
	
	
	
	
	
	
	
}
