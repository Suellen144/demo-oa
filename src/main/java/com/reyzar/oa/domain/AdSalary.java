package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;
import java.lang.String;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdSalary extends BaseEntity {

	private Integer id; // 
	private String processInstanceId; // 流程ID
	private Integer userId; // 
	private Integer deptId; // 部门ID
	private String tittle; // 标题
	private Integer company; // 公司标志
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 申请时间
	private String status; // 申请状态
	private SysDept dept; // 关联部门
	private SysUser applicant; // 流程发起人
	private String deptIdList;
	private String encrypted;// 标记是否被加密过 y:是 n:否
	private List<AdSalaryAttach> salaryAttachList; 
	private List<SysDept> deptList;
	private String value;
	private String name;
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	
	public String getProcessInstanceId() {
		return this.processInstanceId;
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
	
	public void setTittle(String tittle) {
		this.tittle = tittle;
	}
	
	public String getTittle() {
		return this.tittle;
	}
	
	public void setCompany(Integer company) {
		this.company = company;
	}
	
	public Integer getCompany() {
		return this.company;
	}
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}

	public List<AdSalaryAttach> getSalaryAttachList() {
		return salaryAttachList;
	}

	public void setSalaryAttachList(List<AdSalaryAttach> salaryAttachList) {
		this.salaryAttachList = salaryAttachList;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}

	public SysUser getApplicant() {
		return applicant;
	}

	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}

	public String getEncrypted() {
		return encrypted;
	}

	public void setEncrypted(String encrypted) {
		this.encrypted = encrypted;
	}

	public String getDeptIdList() {
		return deptIdList;
	}

	public void setDeptIdList(String deptIdList) {
		this.deptIdList = deptIdList;
	}

	public List<SysDept> getDeptList() {
		return deptList;
	}

	public void setDeptList(List<SysDept> deptList) {
		this.deptList = deptList;
	}
	
}