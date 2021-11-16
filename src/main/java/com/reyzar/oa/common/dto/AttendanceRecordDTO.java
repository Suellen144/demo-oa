package com.reyzar.oa.common.dto;

import java.util.Date;
import java.util.Map;

import org.springframework.format.annotation.DateTimeFormat;

public class AttendanceRecordDTO {
		private Integer count;//序号
		private Integer userId;//用户ID
		private String userNmae;//姓名
		private String deptName;//部门
		@DateTimeFormat(pattern="yyyy-MM-dd")
		private Date becomeDate;//转正时间
		@DateTimeFormat(pattern="yyyy-MM-dd")
		private Date entryTime;//入职时间
		private Integer numberLate;//迟到次数
		private Integer layTime;//迟到总时间（分钟）
		private Double  nuPunchCard;//未打卡次数
		private Double absent;//旷工次数
		private Integer legalDays;//法定节日天数
		private Double schuqin;//实际出勤
		private Double eememberPay;//记薪天数时间
		private Double thisOverTime;//本月加班时间
		private Double thisRestTime;//本月补休时间
		private Double lastRemainTime;//上月剩余加班时间
		private Double sumRemainOverTime;//累计剩余加班时间
		private Map<String, Object> leaveType;
		private Integer entryStatus;//就职状态
		private boolean isTrave;//是否有推迟出差
		private boolean isLeave;//是否推迟请假
		private boolean isRest;//是否推迟休假
		private Integer sum;//是否推迟休假
		
		private String remarks;//备注
		
		private Double legal;//国家假日
		private Double accreditDays;//派驻天数
		
		private Double leaveFlag;//本月请假时间
		private Double restTimeConvert;//本月补休时间（折算）
		public Integer getUserId() {
			return userId;
		}
		public void setUserId(Integer userId) {
			this.userId = userId;
		}
		public String getUserNmae() {
			return userNmae;
		}
		public void setUserNmae(String userNmae) {
			this.userNmae = userNmae;
		}
		public String getDeptName() {
			return deptName;
		}
		public void setDeptName(String deptName) {
			this.deptName = deptName;
		}
		public Date getEntryTime() {
			return entryTime;
		}
		public void setEntryTime(Date entryTime) {
			this.entryTime = entryTime;
		}
		public Integer getNumberLate() {
			return numberLate;
		}
		public void setNumberLate(Integer numberLate) {
			this.numberLate = numberLate;
		}
		public Integer getLayTime() {
			return layTime;
		}
		public void setLayTime(Integer layTime) {
			this.layTime = layTime;
		}
		
		public Double getNuPunchCard() {
			return nuPunchCard;
		}
		public void setNuPunchCard(Double nuPunchCard) {
			this.nuPunchCard = nuPunchCard;
		}
		
		public Double getAbsent() {
			return absent;
		}
		public void setAbsent(Double absent) {
			this.absent = absent;
		}
		public Integer getLegalDays() {
			return legalDays;
		}
		public void setLegalDays(Integer legalDays) {
			this.legalDays = legalDays;
		}
		
		public Double getSchuqin() {
			return schuqin;
		}
		public void setSchuqin(Double schuqin) {
			this.schuqin = schuqin;
		}
		
		public Double getEememberPay() {
			return eememberPay;
		}
		public void setEememberPay(Double eememberPay) {
			this.eememberPay = eememberPay;
		}
		public Double getThisOverTime() {
			return thisOverTime;
		}
		public void setThisOverTime(Double thisOverTime) {
			this.thisOverTime = thisOverTime;
		}
		public Double getThisRestTime() {
			return thisRestTime;
		}
		public void setThisRestTime(Double thisRestTime) {
			this.thisRestTime = thisRestTime;
		}
		public Double getLastRemainTime() {
			return lastRemainTime;
		}
		public void setLastRemainTime(Double lastRemainTime) {
			this.lastRemainTime = lastRemainTime;
		}
		public Double getSumRemainOverTime() {
			return sumRemainOverTime;
		}
		public void setSumRemainOverTime(Double sumRemainOverTime) {
			this.sumRemainOverTime = sumRemainOverTime;
		}
		public Map<String, Object> getLeaveType() {
			return leaveType;
		}
		public void setLeaveType(Map<String, Object> leaveType) {
			this.leaveType = leaveType;
		}
		public Date getBecomeDate() {
			return becomeDate;
		}
		public void setBecomeDate(Date becomeDate) {
			this.becomeDate = becomeDate;
		}
		public Integer getEntryStatus() {
			return entryStatus;
		}
		public void setEntryStatus(Integer entryStatus) {
			this.entryStatus = entryStatus;
		}
		public Integer getCount() {
			return count;
		}
		public void setCount(Integer count) {
			this.count = count;
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
		public Integer getSum() {
			return sum;
		}
		public void setSum(Integer sum) {
			this.sum = sum;
		}
		public void setTrave(boolean isTrave) {
			this.isTrave = isTrave;
		}
		public void setLeave(boolean isLeave) {
			this.isLeave = isLeave;
		}
		public void setRest(boolean isRest) {
			this.isRest = isRest;
		}
		public String getRemarks() {
			return remarks;
		}
		public void setRemarks(String remarks) {
			this.remarks = remarks;
		}
		public Double getLegal() {
			return legal;
		}
		public void setLegal(Double legal) {
			this.legal = legal;
		}
		public Double getAccreditDays() {
			return accreditDays;
		}
		public void setAccreditDays(Double accreditDays) {
			this.accreditDays = accreditDays;
		}
		public Double getLeaveFlag() {
			return leaveFlag;
		}
		public void setLeaveFlag(Double leaveFlag) {
			this.leaveFlag = leaveFlag;
		}
		public Double getRestTimeConvert() {
			return restTimeConvert;
		}
		public void setRestTimeConvert(Double restTimeConvert) {
			this.restTimeConvert = restTimeConvert;
		}
		
	}
