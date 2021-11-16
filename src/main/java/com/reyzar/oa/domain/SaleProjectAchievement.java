package com.reyzar.oa.domain;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;

@SuppressWarnings("serial")
public class SaleProjectAchievement extends BaseEntity {

	private Integer id; // 主键
	private Integer projectManageId; // 项目Id
	private Integer deptId; // 部门ID
	private String deptName;//部门名称
	private SysUser principal; // 项目成员
	private Integer userId; // 成员Id
	private String userName; //成员姓名
	private String performanceContribution; // 业绩贡献度
	private String allocations; // 提成额度
	private String performanceRank; // 业绩排名
	private AdRecord adRecord; //职位


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

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public SysUser getPrincipal() {
		return principal;
	}

	public void setPrincipal(SysUser principal) {
		this.principal = principal;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public String getPerformanceContribution() {
		return performanceContribution;
	}

	public void setPerformanceContribution(String performanceContribution) {
		this.performanceContribution = performanceContribution;
	}

	public String getPerformanceRank() {
		return performanceRank;
	}

	public void setPerformanceRank(String performanceRank) {
		this.performanceRank = performanceRank;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public AdRecord getAdRecord() {
		return adRecord;
	}

	public void setAdRecord(AdRecord adRecord) {
		this.adRecord = adRecord;
	}

	public String getAllocations() {
		return allocations;
	}

	public void setAllocations(String allocations) {
		this.allocations = allocations;
	}
}