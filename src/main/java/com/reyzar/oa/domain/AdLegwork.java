package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.String;
import java.lang.Integer;

/**
 * 
* @Description: 外勤申请
* @author zhouShaoFeng
*
 */
@SuppressWarnings("serial")
public class AdLegwork extends BaseEntity {

	private Integer id; // 
	private Integer userId; //
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date startTime; // 开始时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endTime; // 结束时间
	private String place; //外勤地点
	private String reason; //缘由
	private String categorize; 
	private String applyPeople; //申请人
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date createDate; // 创建时间
	private String createBy; //创建人
	private Integer deleted;//删除标志
/*	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date applyTime; // 申请时间
*/	
	private String deptName; // 所在部门名称
	
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
	public String getPlace() {
		return place;
	}
	public void setPlace(String place) {
		this.place = place;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public String getCreateBy() {
		return createBy;
	}
	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}
	public String getCategorize() {
		return categorize;
	}
	public void setCategorize(String categorize) {
		this.categorize = categorize;
	}
	public String getApplyPeople() {
		return applyPeople;
	}
	public void setApplyPeople(String applyPeople) {
		this.applyPeople = applyPeople;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public Integer getDeleted() {
		return deleted;
	}
	public void setDeleted(Integer deleted) {
		this.deleted = deleted;
	}
	
}