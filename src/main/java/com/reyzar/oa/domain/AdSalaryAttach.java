package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;
import java.util.Date;

import com.reyzar.oa.common.dto.RecordExcelDTO;
import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdSalaryAttach extends BaseEntity {

	private Integer id; // 
	private Integer salaryId; // 
	private Integer userId; // 
	private Integer deptId; // 部门ID
	private String personAmplitude; // 个人期望
	private String manageAmplitude; // 部门经理调幅
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date  lastdate;
	private String oldSalary;
	private String lastDateString;
	private String finallyAmplitude; // 最终调幅
	private String finallySalary; // 计划月薪
	private String score; // 考核分数
	private SysDept dept; // 关联部门
	private SysUser user; // 
	
	private AdRecord record;
	private RecordExcelDTO recordExcelDTO;
	private AdRecordSalaryHistory salary;
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setSalaryId(Integer salaryId) {
		this.salaryId = salaryId;
	}
	
	public Integer getSalaryId() {
		return this.salaryId;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setPersonAmplitude(String personAmplitude) {
		this.personAmplitude = personAmplitude;
	}
	
	public String getPersonAmplitude() {
		return this.personAmplitude;
	}
	
	public void setManageAmplitude(String manageAmplitude) {
		this.manageAmplitude = manageAmplitude;
	}
	
	public String getManageAmplitude() {
		return this.manageAmplitude;
	}
	
	public void setFinallyAmplitude(String finallyAmplitude) {
		this.finallyAmplitude = finallyAmplitude;
	}
	
	public String getFinallyAmplitude() {
		return this.finallyAmplitude;
	}
	
	public void setFinallySalary(String finallySalary) {
		this.finallySalary = finallySalary;
	}
	
	public String getFinallySalary() {
		return this.finallySalary;
	}
	
	public void setScore(String score) {
		this.score = score;
	}
	
	public String getScore() {
		return this.score;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}

	public SysUser getUser() {
		return user;
	}

	public void setUser(SysUser user) {
		this.user = user;
	}

	public AdRecord getRecord() {
		return record;
	}

	public void setRecord(AdRecord record) {
		this.record = record;
	}

	public Date getLastdate() {
		return lastdate;
	}

	public void setLastdate(Date lastdate) {
		this.lastdate = lastdate;
	}

	public AdRecordSalaryHistory getSalary() {
		return salary;
	}

	public void setSalary(AdRecordSalaryHistory salary) {
		this.salary = salary;
	}

	public String getOldSalary() {
		return oldSalary;
	}

	public void setOldSalary(String oldSalary) {
		this.oldSalary = oldSalary;
	}

	public RecordExcelDTO getRecordExcelDTO() {
		return recordExcelDTO;
	}

	public void setRecordExcelDTO(RecordExcelDTO recordExcelDTO) {
		this.recordExcelDTO = recordExcelDTO;
	}

	public String getLastDateString() {
		return lastDateString;
	}

	public void setLastDateString(String lastDateString) {
		this.lastDateString = lastDateString;
	}
}