package com.reyzar.oa.domain;

/**
 * 发票成员实体
 * @author ljd
 *
 */
@SuppressWarnings("serial")
public class FinInvoiceProjectMembers extends BaseEntity {

	private Integer id;//主键id
	private Integer userId;//用户表id
	private SysUser sysUser;//用户对象
	private String resultsProportion;//业绩比例
	private String commissionProportion;//提成比例
	private Integer finInvoicedId;//发票表id
	private Integer sorting;//排序
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public SysUser getSysUser() {
		return sysUser;
	}
	public void setSysUser(SysUser sysUser) {
		this.sysUser = sysUser;
	}
	public String getResultsProportion() {
		return resultsProportion;
	}
	public void setResultsProportion(String resultsProportion) {
		this.resultsProportion = resultsProportion;
	}
	public String getCommissionProportion() {
		return commissionProportion;
	}
	public void setCommissionProportion(String commissionProportion) {
		this.commissionProportion = commissionProportion;
	}
	public Integer getFinInvoicedId() {
		return finInvoicedId;
	}
	public void setFinInvoicedId(Integer finInvoicedId) {
		this.finInvoicedId = finInvoicedId;
	}
	public Integer getSorting() {
		return sorting;
	}
	public void setSorting(Integer sorting) {
		this.sorting = sorting;
	}
	
}
