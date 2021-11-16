package com.reyzar.oa.domain;

import com.reyzar.oa.common.dto.RecordExcelDTO;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class AdrewardAttach extends BaseEntity {

	private Integer id; //
	private Integer rewardId; // 关联主表ID
	private Integer userId;//用户ID
	private Integer dpetId;//部门IDx
	private String wages; // 基本月薪
	private String score; // 考核分数
	private Integer userBarginId; // 关联的业务提成
	private String coefficient; // 奖励系数
	private String businessreward; // 业务提成
	private String otherreward; // 其他奖金
	private String totalreward; // 留任奖总额

	private AdRecord record;
	private RecordExcelDTO recordExcelDTO;
	private AdRecordSalaryHistory salary;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setRewardId(Integer rewardId) {
		this.rewardId = rewardId;
	}
	
	public Integer getRewardId() {
		return this.rewardId;
	}
	
	public String getWages() {
		return wages;
	}

	public void setWages(String wages) {
		this.wages = wages;
	}

	public String getScore() {
		return score;
	}

	public void setScore(String score) {
		this.score = score;
	}
	
	public void setUserBarginId(Integer userBarginId) {
		this.userBarginId = userBarginId;
	}
	
	public Integer getUserBarginId() {
		return this.userBarginId;
	}
	
	public void setCoefficient(String coefficient) {
		this.coefficient = coefficient;
	}
	
	public String getCoefficient() {
		return this.coefficient;
	}
	
	public void setBusinessreward(String businessreward) {
		this.businessreward = businessreward;
	}
	
	public String getBusinessreward() {
		return this.businessreward;
	}
	
	public void setOtherreward(String otherreward) {
		this.otherreward = otherreward;
	}
	
	public String getOtherreward() {
		return this.otherreward;
	}
	
	public void setTotalreward(String totalreward) {
		this.totalreward = totalreward;
	}
	
	public String getTotalreward() {
		return this.totalreward;
	}

	public AdRecord getRecord() {
		return record;
	}

	public void setRecord(AdRecord record) {
		this.record = record;
	}


	public AdRecordSalaryHistory getSalary() {
		return salary;
	}

	public void setSalary(AdRecordSalaryHistory salary) {
		this.salary = salary;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getDpetId() {
		return dpetId;
	}

	public void setDpetId(Integer dpetId) {
		this.dpetId = dpetId;
	}

	public RecordExcelDTO getRecordExcelDTO() {
		return recordExcelDTO;
	}

	public void setRecordExcelDTO(RecordExcelDTO recordExcelDTO) {
		this.recordExcelDTO = recordExcelDTO;
	}
}