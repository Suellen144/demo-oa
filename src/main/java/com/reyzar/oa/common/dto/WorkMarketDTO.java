package com.reyzar.oa.common.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.reyzar.oa.domain.SysUser;

public class WorkMarketDTO {

	private Integer userId;		//拜访人id
	private Integer deptId;		//拜访人部门id
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date workDate; // 日期
	private String content;	//内容
	private SysUser sysUser;
	
	
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
	public Date getWorkDate() {
		return workDate;
	}
	public void setWorkDate(Date workDate) {
		this.workDate = workDate;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public SysUser getSysUser() {
		return sysUser;
	}
	public void setSysUser(SysUser sysUser) {
		this.sysUser = sysUser;
	}
	
	
}
