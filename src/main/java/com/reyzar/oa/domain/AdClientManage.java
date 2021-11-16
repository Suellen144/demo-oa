package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdClientManage extends BaseEntity {

	private Integer id; // 主键ID
	private Integer deptId; // 
	private Integer userId; // 
	private Integer preClientId; // 前负责人ID
	private Integer clientId; // 负责人ID
	private String clientName; // 客户姓名
	private String company; // 所在单位
	private String dept; //所处部门
	private String address; // 地址
	private Integer projectId; // 关联项目ID
	private String clientPosition; // 客户职位
	private String clientPhone; // 客户联系方式
	private String email; // 邮箱
	private SysUser user;
	private SysUser preUser;
	private SaleProjectManage projectManage;
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
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public void setPreClientId(Integer preClientId) {
		this.preClientId = preClientId;
	}
	
	public Integer getPreClientId() {
		return this.preClientId;
	}
	
	public void setClientId(Integer clientId) {
		this.clientId = clientId;
	}
	
	public Integer getClientId() {
		return this.clientId;
	}
	
	public void setClientName(String clientName) {
		this.clientName = clientName;
	}
	
	public String getClientName() {
		return this.clientName;
	}
	
	public void setCompany(String company) {
		this.company = company;
	}
	
	public String getCompany() {
		return this.company;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getAddress() {
		return this.address;
	}
	
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}
	
	public Integer getProjectId() {
		return this.projectId;
	}
	
	public void setClientPosition(String clientPosition) {
		this.clientPosition = clientPosition;
	}
	
	public String getClientPosition() {
		return this.clientPosition;
	}
	
	public void setClientPhone(String clientPhone) {
		this.clientPhone = clientPhone;
	}
	
	public String getClientPhone() {
		return this.clientPhone;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getEmail() {
		return this.email;
	}

	public SysUser getUser() {
		return user;
	}

	public void setUser(SysUser user) {
		this.user = user;
	}

	public SysUser getPreUser() {
		return preUser;
	}

	public void setPreUser(SysUser preUser) {
		this.preUser = preUser;
	}

	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}
	
}