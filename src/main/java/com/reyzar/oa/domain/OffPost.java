package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class OffPost extends BaseEntity{
	private Integer id;
	private Integer userId;			//发表人Id
	private Integer forumId;		//版块ID
	private String title;			//标题
	private String content;			//内容
	private String postEvent;		//事件
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime;			//创建时间
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date lastReplyTime;		//最后回复时间
	private Integer lastReplyId;	//最后回复人ID
	private String lastReplyName;	//最后回复人名
	private Integer replyCount;		//回复总数
	private Integer status;			//状态（加精、置顶）
	private Integer audit;			//审核状态
	private List<OffReply> replies;
	private SysUser user;
	private OffForum forum;
	
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
	public Integer getForumId() {
		return forumId;
	}
	public void setForumId(Integer forumId) {
		this.forumId = forumId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getPostEvent() {
		return postEvent;
	}
	public void setPostEvent(String postEvent) {
		this.postEvent = postEvent;
	}
	public Date getLastReplyTime() {
		return lastReplyTime;
	}
	public void setLastReplyTime(Date lastReplyTime) {
		this.lastReplyTime = lastReplyTime;
	}
	public Integer getLastReplyId() {
		return lastReplyId;
	}
	public void setLastReplyId(Integer lastReplyId) {
		this.lastReplyId = lastReplyId;
	}
	public String getLastReplyName() {
		return lastReplyName;
	}
	public void setLastReplyName(String lastReplyName) {
		this.lastReplyName = lastReplyName;
	}
	public Integer getReplyCount() {
		return replyCount;
	}
	public void setReplyCount(Integer replyCount) {
		this.replyCount = replyCount;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getAudit() {
		return audit;
	}
	public void setAudit(Integer audit) {
		this.audit = audit;
	}
	public List<OffReply> getReplies() {
		return replies;
	}
	public void setReplies(List<OffReply> replies) {
		this.replies = replies;
	}
	public SysUser getUser() {
		return user;
	}
	public void setUser(SysUser user) {
		this.user = user;
	}
	public Date getApplyTime() {
		return applyTime;
	}
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	public OffForum getForum() {
		return forum;
	}
	public void setForum(OffForum forum) {
		this.forum = forum;
	}
	
}
