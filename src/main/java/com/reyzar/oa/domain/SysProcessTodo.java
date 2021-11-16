package com.reyzar.oa.domain;

import java.util.List;

@SuppressWarnings("serial")
public class SysProcessTodo extends BaseEntity {

	private Integer id; // 主键ID
	private Integer companyId; // 公司主键，关联部门表中的公司
	private String process; // 流程，如leave(请假流程)、travel(出差流程)等
	
	private List<SysProcessTodoNode> nodeList; // 流程相关节点

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
	}
	
	public Integer getCompanyId() {
		return this.companyId;
	}
	
	public void setProcess(String process) {
		this.process = process;
	}
	
	public String getProcess() {
		return this.process;
	}

	public List<SysProcessTodoNode> getNodeList() {
		return nodeList;
	}

	public void setNodeList(List<SysProcessTodoNode> nodeList) {
		this.nodeList = nodeList;
	}
	
}