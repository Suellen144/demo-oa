package com.reyzar.oa.domain; 

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.alibaba.fastjson.annotation.JSONField;

/**
 * 
 * @Description: 
 * @author Lairongfa
 * @date 2017年6月15日 下午2:05:14 
 *
 */
@SuppressWarnings("serial")
public class AdWorkMarketAttach extends BaseEntity{
	private Integer id; 
	private Integer workMarketId; //主键ID
	private Integer responsibleUserId; //客户拜访主键ID
	private String responsibleUserName;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date workDate;
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date startTime;
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endTime;
	private String company;
	private String clientName;
	private String clientPosition;
	private String clientPhone;
	private String level;
	private String content;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getWorkMarketId() {
		return workMarketId;
	}
	public void setWorkMarketId(Integer workMarketId) {
		this.workMarketId = workMarketId;
	}
	public Integer getResponsibleUserId() {
		return responsibleUserId;
	}
	public void setResponsibleUserId(Integer responsibleUserId) {
		this.responsibleUserId = responsibleUserId;
	}
	public Date getWorkDate() {
		return workDate;
	}
	public void setWorkDate(Date workDate) {
		this.workDate = workDate;
	}
	public Date getStartTime() {
		return startTime;
	}
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	public Date getEndTime() {
		return endTime;
	}
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getClientName() {
		return clientName;
	}
	public void setClientName(String clientName) {
		this.clientName = clientName;
	}
	public String getClientPosition() {
		return clientPosition;
	}
	public void setClientPosition(String clientPosition) {
		this.clientPosition = clientPosition;
	}
	public String getClientPhone() {
		return clientPhone;
	}
	public void setClientPhone(String clientPhone) {
		this.clientPhone = clientPhone;
	}
	public String getLevel() {
		return level;
	}
	public void setLevel(String level) {
		this.level = level;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getResponsibleUserName() {
		return responsibleUserName;
	}
	public void setResponsibleUserName(String responsibleUserName) {
		this.responsibleUserName = responsibleUserName;
	}
	
	
}
 