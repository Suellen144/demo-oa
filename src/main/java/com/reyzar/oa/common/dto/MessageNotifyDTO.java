package com.reyzar.oa.common.dto;

import java.util.Date;

import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: MessageNotifyDTO 
* @Description: 消息通知机制的传输对象
* @author Lin 
* @date 2016年8月22日 下午6:09:53 
*  
*/
public class MessageNotifyDTO {

	private Integer id; // 主键
	private Integer initiatorId; // 发起人
	private SysUser initiator; // 发起人
	private String pushType; // 推送类型 0：文本内容 1：跳转链接
	private String title; // 推送消息的标题
	private String content; // 推送消息的内容
	private String forwardUrl; // 跳转链接：点击标题跳转到此链接
	private String noticeType; // 提醒类型 0：工作提醒 1：流程提醒 2：公告信息 3：消息提醒（如私信）
	private String createBy; // 创建人
	private Date createDate; // 创建时间
	private String updateBy; // 更新者
	private Date updateDate; // 更新时间
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getInitiatorId() {
		return initiatorId;
	}
	public void setInitiatorId(Integer initiatorId) {
		this.initiatorId = initiatorId;
	}
	public SysUser getInitiator() {
		return initiator;
	}
	public void setInitiator(SysUser initiator) {
		this.initiator = initiator;
	}
	public String getPushType() {
		return pushType;
	}
	public void setPushType(String pushType) {
		this.pushType = pushType;
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
	public String getForwardUrl() {
		return forwardUrl;
	}
	public void setForwardUrl(String forwardUrl) {
		this.forwardUrl = forwardUrl;
	}
	public String getNoticeType() {
		return noticeType;
	}
	public void setNoticeType(String noticeType) {
		this.noticeType = noticeType;
	}
	public String getCreateBy() {
		return createBy;
	}
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public String getUpdateBy() {
		return updateBy;
	}
	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	
	@Override
	public String toString() {
		return "MessageNotifyDTO [id=" + id + ", initiatorId=" + initiatorId + ", initiator=" + initiator
				+ ", pushType=" + pushType + ", title=" + title + ", content=" + content + ", forwardUrl=" + forwardUrl
				+ ", noticeType=" + noticeType + ", createBy=" + createBy + ", createDate=" + createDate + ", updateBy="
				+ updateBy + ", updateDate=" + updateDate + "]";
	}
	
}
