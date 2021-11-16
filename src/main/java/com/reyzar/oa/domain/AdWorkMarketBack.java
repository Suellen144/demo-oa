package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class AdWorkMarketBack {

	private Integer id;
	private Integer userId;//执行用户ID
	private Integer workMarketId;//拜访ID
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
	public Integer getWorkMarketId() {
		return workMarketId;
	}
	public void setWorkMarketId(Integer workMarketId) {
		this.workMarketId = workMarketId;
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
