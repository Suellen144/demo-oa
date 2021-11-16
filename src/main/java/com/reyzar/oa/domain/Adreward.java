package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;
import java.util.List;

@SuppressWarnings("serial")
public class Adreward extends BaseEntity {

	private Integer id; //
	private String processInstanceId; // 流程ID
	private String title; //标题
	private Integer userId; //
	private Integer deptId; //
	private String status; // 申请状态
	private String encrypted; // 是否加密
	private AdRecord record;
	private SysDept dept; // 关联部门
	private List<AdrewardAttach> adrewardAttachList;


	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getProcessInstanceId() {
		return processInstanceId;
	}

	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getEncrypted() {
		return encrypted;
	}

	public void setEncrypted(String encrypted) {
		this.encrypted = encrypted;
	}

	public AdRecord getRecord() {
		return record;
	}

	public void setRecord(AdRecord record) {
		this.record = record;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}

	public List<AdrewardAttach> getAdrewardAttachList() {
		return adrewardAttachList;
	}

	public void setAdrewardAttachList(List<AdrewardAttach> adrewardAttachList) {
		this.adrewardAttachList = adrewardAttachList;
	}
}