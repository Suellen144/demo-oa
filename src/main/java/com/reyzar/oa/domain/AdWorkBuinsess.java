package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdWorkBuinsess extends BaseEntity {

	private Integer id; // 主键ID
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 申请日期
	private Integer userId; // 创建人用户ID
	private Integer deptId; // 创建人部门ID
	private String type; // 类型
	private String status; // 状态
	private SysUser applicant; 
	private SysDept dept;
	private List<AdWorkBuinsessAttach> buinsessAttachsList;
	private List<AdWorkBuinsessBack> buinsessBacksList;
	public List<AdWorkBuinsessBack> getBuinsessBacksList() {
		return buinsessBacksList;
	}
	public void setBuinsessBacksList(List<AdWorkBuinsessBack> buinsessBacksList) {
		this.buinsessBacksList = buinsessBacksList;
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

	public SysUser getApplicant() {
		return applicant;
	}

	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}

	public List<AdWorkBuinsessAttach> getBuinsessAttachsList() {
		return buinsessAttachsList;
	}

	public void setBuinsessAttachsList(List<AdWorkBuinsessAttach> buinsessAttachsList) {
		this.buinsessAttachsList = buinsessAttachsList;
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
	
}