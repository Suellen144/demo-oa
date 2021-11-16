package com.reyzar.oa.common.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

/** 
* @ClassName: WorkReportExcelDTO 
* @Description: 工作汇报工时统计DTO
* @author Lin 
* @date 2017年1月4日 上午10:50:28 
*  
*/
public class RecordExcelDTO {

	private static final long serialVersionUID = 1L;
	
	private Integer serialNumber;//id
	private String name;//姓名
	private String education;//文化程度
	private String major;//专业
	private String majorName;//专业技术职称
	private String phone;//电话
	private String idcard;//身份证
	private String email;//邮箱
	private String dept; // 所属部门
	private String position;//职位
	private Integer entrystatus; //入职状态 
	private String status;//存储入职状态，在职，离职····
	private String school;//毕业院校
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date entryTime;//入职时间
	private String time;//入职时间格式化
	private Date leaveTime;//离职日期
	private String leaveTimes;//离职日期格式化
	
	public Integer getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(Integer serialNumber) {
		this.serialNumber = serialNumber;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getEducation() {
		return education;
	}
	public void setEducation(String education) {
		this.education = education;
	}
	public String getMajor() {
		return major;
	}
	public void setMajor(String major) {
		this.major = major;
	}
	public String getMajorName() {
		return majorName;
	}
	public void setMajorName(String majorName) {
		this.majorName = majorName;
	}
	
	
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getIdcard() {
		return idcard;
	}
	public void setIdcard(String idcard) {
		this.idcard = idcard;
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getSchool() {
		return school;
	}
	public void setSchool(String school) {
		this.school = school;
	}
	
	public Integer getEntrystatus() {
		return entrystatus;
	}
	public void setEntrystatus(Integer entrystatus) {
		this.entrystatus = entrystatus;
	}
	public Date getEntryTime() {
		return entryTime;
	}
	public void setEntryTime(Date entryTime) {
		this.entryTime = entryTime;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public Date getLeaveTime() {
		return leaveTime;
	}
	public void setLeaveTime(Date leaveTime) {
		this.leaveTime = leaveTime;
	}
	public String getLeaveTimes() {
		return leaveTimes;
	}
	public void setLeaveTimes(String leaveTimes) {
		this.leaveTimes = leaveTimes;
	}
	
}
