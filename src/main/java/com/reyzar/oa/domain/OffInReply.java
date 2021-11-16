package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class OffInReply extends BaseEntity{

	private Integer id;
	private Integer replyId;		//回复Id
	private Integer userId;			//用户ID
	private String unickName;		//用户昵称
	private String avaUrl;			//用户头像
	private Integer ruserId;		//被回复人ID
	private String runickname;		//被回复人昵称
	private String content;			//回复内容
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date replyTime;			//回复时间
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getReplyId() {
		return replyId;
	}
	public void setReplyId(Integer replyId) {
		this.replyId = replyId;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public String getUnickName() {
		return unickName;
	}
	public void setUnickName(String unickName) {
		this.unickName = unickName;
	}
	public Integer getRuserId() {
		return ruserId;
	}
	public void setRuserId(Integer ruserId) {
		this.ruserId = ruserId;
	}
	public String getRunickname() {
		return runickname;
	}
	public void setRunickname(String runickname) {
		this.runickname = runickname;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getReplyTime() {
		return replyTime;
	}
	public void setReplyTime(Date replyTime) {
		this.replyTime = replyTime;
	}
	public String getAvaUrl() {
		return avaUrl;
	}
	public void setAvaUrl(String avaUrl) {
		this.avaUrl = avaUrl;
	}
	
}
