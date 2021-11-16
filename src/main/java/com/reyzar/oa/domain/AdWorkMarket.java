package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;
import java.lang.String;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdWorkMarket extends BaseEntity {

	private Integer id; // 主键ID
	private Integer userId; // 创建人用户ID
	private Integer deptId; // 创建人部门ID\
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 
	private String type; // 类型
	private String status; // 状态
	private List<AdWorkMarketAttach> marketAttachsList;
	private List<AdWorkMarketBack> marketBacksList;
	private SysUser applicant; 
	private SysDept dept;
	
	
	public List<AdWorkMarketBack> getMarketBacksList() {
		return marketBacksList;
	}

	public void setMarketBacksList(List<AdWorkMarketBack> marketBacksList) {
		this.marketBacksList = marketBacksList;
	}

	public SysUser getApplicant() {
		return applicant;
	}

	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}


	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getType() {
		return this.type;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}

	public List<AdWorkMarketAttach> getMarketAttachsList() {
		return marketAttachsList;
	}

	public void setMarketAttachsList(List<AdWorkMarketAttach> marketAttachsList) {
		this.marketAttachsList = marketAttachsList;
	}
	
}