package com.reyzar.oa.domain;

import java.util.Date;

@SuppressWarnings("serial")
public class JobManager extends BaseEntity {

	private String jobName; // 定时任务名称
	private String jobDesc; // 定时任务描述
	private String serverIp; // 服务器ip
	private String onOff; //任务开关
	private Date updateDate; // 修改时间
	
	public String getJobName() {
		return jobName;
	}
	public void setJobName(String jobName) {
		this.jobName = jobName;
	}
	public String getJobDesc() {
		return jobDesc;
	}
	public void setJobDesc(String jobDesc) {
		this.jobDesc = jobDesc;
	}
	public String getServerIp() {
		return serverIp;
	}
	public void setServerIp(String serverIp) {
		this.serverIp = serverIp;
	}
	public String getOnOff() {
		return onOff;
	}
	public void setOnOff(String onOff) {
		this.onOff = onOff;
	}
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	
}