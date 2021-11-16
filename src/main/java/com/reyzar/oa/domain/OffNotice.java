package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
* @Description: 公告
* @author zhouShaoFeng
* @date 2016年7月15日 下午3:26:43 
*
 */
public class OffNotice extends BaseEntity{

	private static final long serialVersionUID = 1L;
	
	private Integer id;
	private String title; //标题
	private String type; //公告类型
	private String content; //公告内容
	private Integer userId; // 发布者ID
	private String deptIds; // 公告可视范围
	private String attachments; // 附件地址
	private String attachName; // 附件原始文件名
	private String approveStatus; // 审核状态 0：未审核 1：审核通过 2：审核未通过
	private Integer approverId; // 审批人
	private String processInstanceId; // 流程主键ID
	private String comment; //审批意见
	private Boolean isRead; // 是否已阅读
	private Integer publisherId; // 发布部门ID
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm") 
	private Date publishTime; // 发布时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm") 
	private Date actualPublishTime; // 实际发布时间
	private Integer isPublished; // 是否已发送过邮件 1：是 0：否
	
	private SysUser user; //发布者
	private SysDept publishers; // 发布部门
	private SysUser approver; // 审批人 
	private List<SysDept> deptList;
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public SysUser getUser() {
		return user;
	}
	public void setUser(SysUser user) {
		this.user = user;
	}
	public String getDeptIds() {
		return deptIds;
	}
	public void setDeptIds(String deptIds) {
		this.deptIds = deptIds;
	}
	public String getAttachments() {
		return attachments;
	}
	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}
	public String getAttachName() {
		return attachName;
	}
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	public String getApproveStatus() {
		return approveStatus;
	}
	public void setApproveStatus(String approveStatus) {
		this.approveStatus = approveStatus;
	}
	public Integer getApproverId() {
		return approverId;
	}
	public void setApproverId(Integer approverId) {
		this.approverId = approverId;
	}
	public SysUser getApprover() {
		return approver;
	}
	public void setApprover(SysUser approver) {
		this.approver = approver;
	}
	public String getProcessInstanceId() {
		return processInstanceId;
	}
	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	public Boolean getIsRead() {
		return isRead;
	}
	public void setIsRead(Boolean isRead) {
		this.isRead = isRead;
	}
	public List<SysDept> getDeptList() {
		return deptList;
	}
	public void setDeptList(List<SysDept> deptList) {
		this.deptList = deptList;
	}
	public Integer getPublisherId() {
		return publisherId;
	}
	public void setPublisherId(Integer publisherId) {
		this.publisherId = publisherId;
	}
	public SysDept getPublishers() {
		return publishers;
	}
	public void setPublishers(SysDept publishers) {
		this.publishers = publishers;
	}
	public Date getPublishTime() {
		return publishTime;
	}
	public void setPublishTime(Date publishTime) {
		this.publishTime = publishTime;
	}
	public Date getActualPublishTime() {
		return actualPublishTime;
	}
	public void setActualPublishTime(Date actualPublishTime) {
		this.actualPublishTime = actualPublishTime;
	}
	public Integer getIsPublished() {
		return isPublished;
	}
	public void setIsPublished(Integer isPublished) {
		this.isPublished = isPublished;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	
}
