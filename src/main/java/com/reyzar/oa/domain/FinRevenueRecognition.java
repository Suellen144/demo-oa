package com.reyzar.oa.domain;

import java.util.Date;

/**
    *      收入确认实体类
 * @author lijd
 *
 */
@SuppressWarnings("serial")
public class FinRevenueRecognition  extends BaseEntity {

	private Integer id;
	private Double confirmAmount;//确认金额
	private Double resultsContribution;//业绩贡献
	private String confirmWay;//确认方式 (1：一次性确认 2：分摊)
	private Date confirmDate;//确认时间
	private Date shareStartDate;//分摊开始日期
	private Date shareEndDate;//分摊结束日期
	private String isBeenConfirmed;//是否已确认(0否 1是)
	private Integer saleBarginManageId;//合同id
	private Integer finInvoicedId;//发票id
	private FinInvoiced finInvoiced;//发票对象
	private SaleBarginManage saleBarginManage;//合同对象
	private String confirmPeople;//确认人
	private Integer isJob;//是否已执行job 0否，1是
	
	private String cumulative;//用来接收累计
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Double getConfirmAmount() {
		return confirmAmount;
	}
	public void setConfirmAmount(Double confirmAmount) {
		this.confirmAmount = confirmAmount;
	}
	public String getConfirmWay() {
		return confirmWay;
	}
	public void setConfirmWay(String confirmWay) {
		this.confirmWay = confirmWay;
	}
	public Date getShareStartDate() {
		return shareStartDate;
	}
	public void setShareStartDate(Date shareStartDate) {
		this.shareStartDate = shareStartDate;
	}
	public Date getShareEndDate() {
		return shareEndDate;
	}
	public void setShareEndDate(Date shareEndDate) {
		this.shareEndDate = shareEndDate;
	}
	public String getIsBeenConfirmed() {
		return isBeenConfirmed;
	}
	public void setIsBeenConfirmed(String isBeenConfirmed) {
		this.isBeenConfirmed = isBeenConfirmed;
	}
	public Integer getSaleBarginManageId() {
		return saleBarginManageId;
	}
	public void setSaleBarginManageId(Integer saleBarginManageId) {
		this.saleBarginManageId = saleBarginManageId;
	}
	public Integer getFinInvoicedId() {
		return finInvoicedId;
	}
	public void setFinInvoicedId(Integer finInvoicedId) {
		this.finInvoicedId = finInvoicedId;
	}
	public FinInvoiced getFinInvoiced() {
		return finInvoiced;
	}
	public void setFinInvoiced(FinInvoiced finInvoiced) {
		this.finInvoiced = finInvoiced;
	}
	public SaleBarginManage getSaleBarginManage() {
		return saleBarginManage;
	}
	public void setSaleBarginManage(SaleBarginManage saleBarginManage) {
		this.saleBarginManage = saleBarginManage;
	}
	public Date getConfirmDate() {
		return confirmDate;
	}
	public void setConfirmDate(Date confirmDate) {
		this.confirmDate = confirmDate;
	}
	public String getConfirmPeople() {
		return confirmPeople;
	}
	public void setConfirmPeople(String confirmPeople) {
		this.confirmPeople = confirmPeople;
	}
	public Double getResultsContribution() {
		return resultsContribution;
	}
	public void setResultsContribution(Double resultsContribution) {
		this.resultsContribution = resultsContribution;
	}
	public String getCumulative() {
		return cumulative;
	}
	public void setCumulative(String cumulative) {
		this.cumulative = cumulative;
	}
	public Integer getIsJob() {
		return isJob;
	}
	public void setIsJob(Integer isJob) {
		this.isJob = isJob;
	}
	
	
}
