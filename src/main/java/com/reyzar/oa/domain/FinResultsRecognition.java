package com.reyzar.oa.domain;

import java.util.Date;

/**
    *       收入确认与业绩贡献 类
 * @author lijd
 *
 */
@SuppressWarnings("serial")
public class FinResultsRecognition  extends BaseEntity {

	private Integer id;
	private Double confirmAmount;//确认金额
	private Double resultsAmount;//业绩贡献
	private Integer revenueRecognitionId;//收入确认表id
	private Date shareDate;//分摊日期
	private Integer saleBarginManageId;//合同id
	private Integer isShown;//是否显示到页面 (1:显示 2不显示)
	private SaleBarginManage saleBarginManage;//合同对象
	private String confirmPeople;//确认人
	private Integer finInvoicedId;//发票id
	
	private String cumulative;//用来接收累计
	private Date endShareDate;//作为查询范围
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

	public Double getResultsAmount() {
		return resultsAmount;
	}

	public void setResultsAmount(Double resultsAmount) {
		this.resultsAmount = resultsAmount;
	}

	public Integer getRevenueRecognitionId() {
		return revenueRecognitionId;
	}

	public void setRevenueRecognitionId(Integer revenueRecognitionId) {
		this.revenueRecognitionId = revenueRecognitionId;
	}

	public Date getShareDate() {
		return shareDate;
	}

	public void setShareDate(Date shareDate) {
		this.shareDate = shareDate;
	}

	public Integer getSaleBarginManageId() {
		return saleBarginManageId;
	}

	public void setSaleBarginManageId(Integer saleBarginManageId) {
		this.saleBarginManageId = saleBarginManageId;
	}

	public Integer getIsShown() {
		return isShown;
	}

	public void setIsShown(Integer isShown) {
		this.isShown = isShown;
	}

	public SaleBarginManage getSaleBarginManage() {
		return saleBarginManage;
	}

	public void setSaleBarginManage(SaleBarginManage saleBarginManage) {
		this.saleBarginManage = saleBarginManage;
	}

	public String getConfirmPeople() {
		return confirmPeople;
	}

	public void setConfirmPeople(String confirmPeople) {
		this.confirmPeople = confirmPeople;
	}

	public String getCumulative() {
		return cumulative;
	}

	public void setCumulative(String cumulative) {
		this.cumulative = cumulative;
	}

	public Integer getFinInvoicedId() {
		return finInvoicedId;
	}

	public void setFinInvoicedId(Integer finInvoicedId) {
		this.finInvoicedId = finInvoicedId;
	}

	public Date getEndShareDate() {
		return endShareDate;
	}

	public void setEndShareDate(Date endShareDate) {
		this.endShareDate = endShareDate;
	}

}
