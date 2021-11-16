package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class OffReply extends BaseEntity{

	private Integer id;
	private Integer userId;		//回复人ID
	private Integer postId;		//帖子ID
	private String content;		//回复内容
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date replyTime;		//回复时间
	private Integer inReplyCount;	//楼中楼总数
	private List<OffInReply> inReplies;
	private SysUser user;
	
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
	public Integer getPostId() {
		return postId;
	}
	public void setPostId(Integer postId) {
		this.postId = postId;
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
	public Integer getInReplyCount() {
		return inReplyCount;
	}
	public void setInReplyCount(Integer inReplyCount) {
		this.inReplyCount = inReplyCount;
	}
	public List<OffInReply> getInReplies() {
		return inReplies;
	}
	public void setInReplies(List<OffInReply> inReplies) {
		this.inReplies = inReplies;
	}
	public SysUser getUser() {
		return user;
	}
	public void setUser(SysUser user) {
		this.user = user;
	}
	
}
