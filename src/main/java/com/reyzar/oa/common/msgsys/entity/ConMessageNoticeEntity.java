package com.reyzar.oa.common.msgsys.entity;

import java.util.Date;

import com.reyzar.oa.domain.BaseEntity;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class ConMessageNoticeEntity extends BaseEntity {

	private Integer id; // 主键
	private Integer initiator; // 发起人
	private Date startTime; // 启动时间：从何时开始提醒
	private Date endTime; // 结束时间：此时间点过后不再推送消息
	private Integer pushCount; // 推送次数  小于0或空值：无限次（结束条件视结束时间与是否结束字段为准） 0：结束推送
	private String pushTarget; // 推送对象 0：用户 1：部门 2：全公司
	private String users; // 推送对象为用户时，用户的ID集合
	private String depts; // 推送对象为部门时，部门的ID集合
	private String pushType; // 推送类型 0：文本内容 1：跳转链接
	private String title; // 推送消息的标题
	private String content; // 推送消息的内容
	private String forwardUrl; // 跳转链接：点击标题跳转到此链接
	private String isEnd; // 0：未结束，直到到达结束时间为止 1：已结束
	private String relId; // 此字段保存的可能是业务表ID、自定义数据等。根据此字段找到记录进行修改数据，如更改结束时间、是否结束。此字段非必须，根据具体情况使用。
	private String noticeType; // 提醒类型 0：工作提醒 1：流程提醒 2：公告信息 3：消息提醒（如私信）

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setInitiator(Integer initiator) {
		this.initiator = initiator;
	}
	
	public Integer getInitiator() {
		return this.initiator;
	}
	
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	
	public Date getStartTime() {
		return this.startTime;
	}
	
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	
	public Date getEndTime() {
		return this.endTime;
	}
	
	public void setPushCount(Integer pushCount) {
		this.pushCount = pushCount;
	}
	
	public Integer getPushCount() {
		return this.pushCount;
	}
	
	public void setPushTarget(String pushTarget) {
		this.pushTarget = pushTarget;
	}
	
	public String getPushTarget() {
		return this.pushTarget;
	}
	
	public void setUsers(String users) {
		this.users = users;
	}
	
	public String getUsers() {
		return this.users;
	}
	
	public void setDepts(String depts) {
		this.depts = depts;
	}
	
	public String getDepts() {
		return this.depts;
	}
	
	public void setPushType(String pushType) {
		this.pushType = pushType;
	}
	
	public String getPushType() {
		return this.pushType;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTitle() {
		return this.title;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public String getContent() {
		return this.content;
	}
	
	public void setForwardUrl(String forwardUrl) {
		this.forwardUrl = forwardUrl;
	}
	
	public String getForwardUrl() {
		return this.forwardUrl;
	}
	
	public void setIsEnd(String isEnd) {
		this.isEnd = isEnd;
	}
	
	public String getIsEnd() {
		return this.isEnd;
	}
	
	public void setRelId(String relId) {
		this.relId = relId;
	}
	
	public String getRelId() {
		return this.relId;
	}

	public String getNoticeType() {
		return noticeType;
	}

	public void setNoticeType(String noticeType) {
		this.noticeType = noticeType;
	}
	
}