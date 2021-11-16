package com.reyzar.oa.domain;

@SuppressWarnings("serial")
public class SysProcessTodoNotice extends BaseEntity {

	private Integer id; // 主键
	private Integer userId; // 办理人主键
	private String taskId; // 任务主键
	private String sendDate; // 邮件发送时间，记录什么时候执行的检测任务

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
	
	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}
	
	public String getTaskId() {
		return this.taskId;
	}

	public String getSendDate() {
		return sendDate;
	}

	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}
	
}