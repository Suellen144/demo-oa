package com.reyzar.oa.domain; 

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;



/**
 * 
 * @Description: 
 * @author Lairongfa
 * @date 2016年9月9日 上午10:13:20 
 *
 */
public class AdAttendance extends BaseEntity{
	
	private static final long serialVersionUID = 1L;
	private Integer id; //主键ID
	private String name;//姓名
	private String dept;//部门名
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private String date; // 日期
	private String startTime; // 签到时间
	private String endTime; // 签退时间
	private String latetime; //迟到时长
	private String beforlateTime; //早退时长
	private String isFlag;//判断是否是节假日
	private Double leaveTime;//请假那天工作时间
	private Double restTime;//调休时间
	private String leaveType;//请假类型
	private Double leaveFlag;//请假时间
	
	private boolean isTrave;//是否有推迟出差
	private boolean isLeave;//是否推迟请假
	private boolean isRest;//是否推迟休假
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getLatetime() {
		return latetime;
	}
	public void setLatetime(String latetime) {
		this.latetime = latetime;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getIsFlag() {
		return isFlag;
	}
	public void setIsFlag(String isFlag) {
		this.isFlag = isFlag;
	}
	public Double getLeaveTime() {
		return leaveTime;
	}
	public void setLeaveTime(Double leaveTime) {
		this.leaveTime = leaveTime;
	}
	
	public Double getRestTime() {
		return restTime;
	}
	public void setRestTime(Double restTime) {
		this.restTime = restTime;
	}
	
	public String getLeaveType() {
		return leaveType;
	}
	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}
	public Double getLeaveFlag() {
		return leaveFlag;
	}
	public void setLeaveFlag(Double leaveFlag) {
		this.leaveFlag = leaveFlag;
	}
	
	public String getBeforlateTime() {
		return beforlateTime;
	}
	public void setBeforlateTime(String beforlateTime) {
		this.beforlateTime = beforlateTime;
	}
	public Boolean getIsTrave() {
		return isTrave;
	}
	public void setIsTrave(Boolean isTrave) {
		this.isTrave = isTrave;
	}
	public Boolean getIsLeave() {
		return isLeave;
	}
	public void setIsLeave(Boolean isLeave) {
		this.isLeave = isLeave;
	}
	public Boolean getIsRest() {
		return isRest;
	}
	public void setIsRest(Boolean isRest) {
		this.isRest = isRest;
	}
	@Override
	public String toString() {
		return "AdAttendance [id=" + id + ", name=" + name + ", dept=" + dept + ", date=" + date + ", startTime="
				+ startTime + ", endTime=" + endTime + ", latetime=" + latetime + ", beforlateTime=" + beforlateTime
				+ ", isFlag=" + isFlag + ", leaveTime=" + leaveTime + ", restTime=" + restTime + ", leaveType="
				+ leaveType + ", leaveFlag=" + leaveFlag + ", isTrave=" + isTrave + ", isLeave=" + isLeave + ", isRest="
				+ isRest + "]";
	}
	
	
}
 