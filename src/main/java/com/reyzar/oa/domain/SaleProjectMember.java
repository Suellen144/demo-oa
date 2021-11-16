package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class SaleProjectMember extends BaseEntity {

	private Integer id; // 主键
	private Integer userId; // 成员Id
	private String resultsProportion; // 业绩比例
	private String commissionProportion; // 提成比例
	private Integer projectManageId; // 项目Id
	private Integer sorting; //按照页面成员排序
	
	private SysUser principal; // 项目成员

	private Integer projectHistoryId; //历史项目Id
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
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

	public Integer getProjectManageId() {
		return projectManageId;
	}

	public void setProjectManageId(Integer projectManageId) {
		this.projectManageId = projectManageId;
	}

	public Integer getSorting() {
		return sorting;
	}

	public void setSorting(Integer sorting) {
		this.sorting = sorting;
	}

	public SysUser getPrincipal() {
		return principal;
	}

	public void setPrincipal(SysUser principal) {
		this.principal = principal;
	}

	public Integer getProjectHistoryId() {
		return projectHistoryId;
	}

	public void setProjectHistoryId(Integer projectHistoryId) {
		this.projectHistoryId = projectHistoryId;
	}
}