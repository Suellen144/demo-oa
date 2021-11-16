package com.reyzar.oa.domain;

import java.util.Date;
import java.lang.Integer;

@SuppressWarnings("serial")
public class SaleResearchRecord extends BaseEntity {

	private Integer id; // 主键
	private Integer userId; // 主键
	private Integer projectManageId; // 项目Id
	private Date mtime; //时间
	private double cost; //额度
	
	private SysUser sysUser;
	
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

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public Integer getProjectManageId() {
		return projectManageId;
	}

	public void setProjectManageId(Integer projectManageId) {
		this.projectManageId = projectManageId;
	}

	public Date getMtime() {
		return mtime;
	}

	public void setMtime(Date mtime) {
		this.mtime = mtime;
	}

	public double getCost() {
		return cost;
	}

	public void setCost(double cost) {
		this.cost = cost;
	}

}