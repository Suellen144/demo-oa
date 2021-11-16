package com.reyzar.oa.common.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.reyzar.oa.domain.BaseEntity;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;

@SuppressWarnings("serial")
public class WorkManageDTO extends BaseEntity {

	private Integer id;
	private Integer userId;
	private Integer deptId;
	private String type;
	private String status;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 申请日期
	
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date workDate;
	private SysUser applicant ;
	private SysUser	principal;
	private	SysDept dept;
	
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
	public Integer getDeptId() {
		return deptId;
	}
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Date getApplyTime() {
		return applyTime;
	}
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	public SysDept getDept() {
		return dept;
	}
	public void setDept(SysDept dept) {
		this.dept = dept;
	}
	public SysUser getApplicant() {
		return applicant;
	}
	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public SysUser getPrincipal() {
		return principal;
	}
	public void setPrincipal(SysUser principal) {
		this.principal = principal;
	}
	public Date getWorkDate() {
		return workDate;
	}
	public void setWorkDate(Date workDate) {
		this.workDate = workDate;
	}

	
	
}
