package com.reyzar.oa.domain;

import java.util.Date;
import java.lang.Integer;

@SuppressWarnings("serial")
public class OffNoticeRead extends BaseEntity {

	private Integer id; // 主键ID
	private Integer userId; // 用户主键
	private Integer noticeId; // 公告主键
	private Date readTime; // 阅读时间

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
	
	public void setNoticeId(Integer noticeId) {
		this.noticeId = noticeId;
	}
	
	public Integer getNoticeId() {
		return this.noticeId;
	}
	
	public void setReadTime(Date readTime) {
		this.readTime = readTime;
	}
	
	public Date getReadTime() {
		return this.readTime;
	}
	
}