package com.reyzar.oa.domain;

import java.lang.Integer;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdKpi extends BaseEntity {

	private Integer id; // 主键ID
	private Integer deptId; // 部门
	@DateTimeFormat(pattern="yyyy-MM")
	private Date date; // 考核年月
	private String time;
	private Integer status; //状态
	
	private List<AdKpiAttach> kpiAttachsList;  //部门下绩效考核项集合

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setDate(Date date) {
		this.date = date;
	}
	
	public Date getDate() {
		return this.date;
	}

	public List<AdKpiAttach> getKpiAttachsList() {
		return kpiAttachsList;
	}

	public void setKpiAttachsList(List<AdKpiAttach> kpiAttachsList) {
		this.kpiAttachsList = kpiAttachsList;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	
}