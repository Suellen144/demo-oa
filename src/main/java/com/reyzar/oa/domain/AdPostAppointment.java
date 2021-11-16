package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdPostAppointment extends BaseEntity {

	
	private Integer id;
	private Integer recordId;
	private Integer company;	//公司
	private Integer dept;		//部门
	private Integer projectTeam;//项目组
	private Integer station;	//岗位
	private Integer appoint;	//任免
	private String postReason;	//调岗原因
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date postDate;		//调岗日期
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getRecordId() {
		return recordId;
	}
	public void setRecordId(Integer recordId) {
		this.recordId = recordId;
	}
	public Integer getCompany() {
		return company;
	}
	public void setCompany(Integer company) {
		this.company = company;
	}
	public Integer getDept() {
		return dept;
	}
	public void setDept(Integer dept) {
		this.dept = dept;
	}
	public Integer getProjectTeam() {
		return projectTeam;
	}
	public void setProjectTeam(Integer projectTeam) {
		this.projectTeam = projectTeam;
	}
	public Integer getStation() {
		return station;
	}
	public void setStation(Integer station) {
		this.station = station;
	}
	public Integer getAppoint() {
		return appoint;
	}
	public void setAppoint(Integer appoint) {
		this.appoint = appoint;
	}
	public String getPostReason() {
		return postReason;
	}
	public void setPostReason(String postReason) {
		this.postReason = postReason;
	}
	public Date getPostDate() {
		return postDate;
	}
	public void setPostDate(Date postDate) {
		this.postDate = postDate;
	}
	
}
