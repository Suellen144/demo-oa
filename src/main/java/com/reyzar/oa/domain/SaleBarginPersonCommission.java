package com.reyzar.oa.domain;

import java.lang.Integer;
import java.util.List;

@SuppressWarnings("serial")
public class SaleBarginPersonCommission extends BaseEntity {

	private Integer id; // 主键

	private List<SaleBarginPersonCommissionAttach>  commissionAttachList;


	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}

	public List<SaleBarginPersonCommissionAttach> getCommissionAttachList() {
		return commissionAttachList;
	}

	public void setCommissionAttachList(List<SaleBarginPersonCommissionAttach> commissionAttachList) {
		this.commissionAttachList = commissionAttachList;
	}
}