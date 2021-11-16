package com.reyzar.oa.domain;

import java.lang.String;

@SuppressWarnings("serial")
public class AddressBook extends BaseEntity {

	private String gsName;   //公司名称
	private String code;     //公司代码
	private String xzm;      //项目组
	
	private String userId;   //用户id
	private String deptId;   //部门id
	private String deptName; //部门名称
	private String name;     //姓名
	private String position; //岗位
	private String phone;    //电话
	private String email;    //邮箱
	
	public String getGsName() {
		return gsName;
	}
	public void setGsName(String gsName) {
		this.gsName = gsName;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getXzm() {
		return xzm;
	}
	public void setXzm(String xzm) {
		this.xzm = xzm;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getDeptId() {
		return deptId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	
}