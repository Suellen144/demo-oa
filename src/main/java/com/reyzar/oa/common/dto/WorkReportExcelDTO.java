package com.reyzar.oa.common.dto;

/** 
* @ClassName: WorkReportExcelDTO 
* @Description: 工作汇报工时统计DTO
* @author Lin 
* @date 2017年1月4日 上午10:50:28 
*  
*/
public class WorkReportExcelDTO {

	private String name;
	private String dept;
	private String project;
	private Double workTime;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getProject() {
		return project;
	}
	public void setProject(String project) {
		this.project = project;
	}
	public Double getWorkTime() {
		return workTime;
	}
	public void setWorkTime(Double workTime) {
		this.workTime = workTime;
	}
	
}
