package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdTravelAttach extends BaseEntity {

	private Integer id; // 主键ID
	private Integer travelId; // 出差管理ID
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date beginDate; // 起始日期
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date endDate; // 结束日期
	private String place; // 出差地点
	private String task; // 出差事由
	private String vehicle; // 交通工具

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setTravelId(Integer travelId) {
		this.travelId = travelId;
	}
	
	public Integer getTravelId() {
		return this.travelId;
	}
	
	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}
	
	public Date getBeginDate() {
		return this.beginDate;
	}
	
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	public Date getEndDate() {
		return this.endDate;
	}
	
	public void setPlace(String place) {
		this.place = place;
	}
	
	public String getPlace() {
		return this.place;
	}
	
	public void setTask(String task) {
		this.task = task;
	}
	
	public String getTask() {
		return this.task;
	}
	
	public void setVehicle(String vehicle) {
		this.vehicle = vehicle;
	}
	
	public String getVehicle() {
		return this.vehicle;
	}
	
}