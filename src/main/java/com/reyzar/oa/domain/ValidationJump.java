package com.reyzar.oa.domain;

/**
 * 用于验证待办事项
 *
 */
public class ValidationJump {

	private String module;//模块
	private Integer isNewProject;//是否新项目管理模块创建
	private String type;//跳转类型
	private Integer isNewProcess;
	public String getModule() {
		return module;
	}
	public void setModule(String module) {
		this.module = module;
	}
	public Integer getIsNewProject() {
		return isNewProject;
	}
	public void setIsNewProject(Integer isNewProject) {
		this.isNewProject = isNewProject;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Integer getIsNewProcess() {
		return isNewProcess;
	}
	public void setIsNewProcess(Integer isNewProcess) {
		this.isNewProcess = isNewProcess;
	}
	
	
}
