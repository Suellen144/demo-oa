package com.reyzar.oa.domain;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class SysProcessTodoNode extends BaseEntity {

	private Integer id; // 主键ID
	private Integer processTodoId; // 流程待办表主键
	private String node; // 节点
	private Integer handlerId; // 任务办理人主键
	
	private SysUser handler; // 任务办理人

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setProcessTodoId(Integer processTodoId) {
		this.processTodoId = processTodoId;
	}
	
	public Integer getProcessTodoId() {
		return this.processTodoId;
	}
	
	public void setNode(String node) {
		this.node = node;
	}
	
	public String getNode() {
		return this.node;
	}
	
	public void setHandlerId(Integer handlerId) {
		this.handlerId = handlerId;
	}
	
	public Integer getHandlerId() {
		return this.handlerId;
	}

	public SysUser getHandler() {
		return handler;
	}

	public void setHandler(SysUser handler) {
		this.handler = handler;
	}
	
}