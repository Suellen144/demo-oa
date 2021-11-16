package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.lang.String;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdKpiAttach extends BaseEntity {

	private Integer id; // 
	private Integer kpiId; // kpi主键关联ID
	private Integer userId; // 用户ID
	private String  userName; //用户名
	private Integer deptId; // 部门ID
	private String  deptName; //部门名
	private String 	position;//职位
	private Integer status;//状态
	private String userEvaluation; // 
	private Double userScore; // 自评分数
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date userTime;//用户绩效提交时间
	private Double managerScore; // 经理评分
	private String managerEvaluation; // 
	private Double ceoScore; // 公司评分
	private String ceoEvaluation; //公司评语
	private String ceoPraisedPunished; //奖惩
	@DateTimeFormat(pattern="yyyy-MM")
	private Date date; // 考核年月

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setKpiId(Integer kpiId) {
		this.kpiId = kpiId;
	}
	
	public Integer getKpiId() {
		return this.kpiId;
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
	
	public void setUserEvaluation(String userEvaluation) {
		this.userEvaluation = userEvaluation;
	}
	
	public String getUserEvaluation() {
		return this.userEvaluation;
	}
	
	public void setUserScore(Double userScore) {
		this.userScore = userScore;
	}
	
	public Double getUserScore() {
		return this.userScore;
	}
	
	public void setManagerScore(Double managerScore) {
		this.managerScore = managerScore;
	}
	
	public Double getManagerScore() {
		return this.managerScore;
	}
	
	public void setManagerEvaluation(String managerEvaluation) {
		this.managerEvaluation = managerEvaluation;
	}
	
	public String getManagerEvaluation() {
		return this.managerEvaluation;
	}
	
	public void setCeoScore(Double ceoScore) {
		this.ceoScore = ceoScore;
	}
	
	public Double getCeoScore() {
		return this.ceoScore;
	}
	
	public void setDate(Date date) {
		this.date = date;
	}
	
	public Date getDate() {
		return this.date;
	}

	public String getCeoPraisedPunished() {
		return ceoPraisedPunished;
	}

	public void setCeoPraisedPunished(String ceoPraisedPunished) {
		this.ceoPraisedPunished = ceoPraisedPunished;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getCeoEvaluation() {
		return ceoEvaluation;
	}

	public void setCeoEvaluation(String ceoEvaluation) {
		this.ceoEvaluation = ceoEvaluation;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Date getUserTime() {
		return userTime;
	}

	public void setUserTime(Date userTime) {
		this.userTime = userTime;
	}
}