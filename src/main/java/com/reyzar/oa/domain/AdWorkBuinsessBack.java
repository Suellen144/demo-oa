package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class AdWorkBuinsessBack {

	private Integer id;
	private Integer userId;//执行用户ID
	private Integer workBusinessId;//商务ID
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date createDate; // 退回时间
	private String content;//批注
	private SysUser sysUser;
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
	public Integer getWorkBusinessId() {
		return workBusinessId;
	}
	public void setWorkBusinessId(Integer workBusinessId) {
		this.workBusinessId = workBusinessId;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
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
