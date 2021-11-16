package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class FinReimburseAttach extends BaseEntity {

	private Integer id; // 主键ID
	private Integer reimburseId; // 通用报销主键
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date date; // 日期
	private String place; // 地点
	private Integer projectId; // 项目主键
	private String reason; // 事由
	private String type; // 类别
	private Double money; // 金额
	private Double actReimburse; // 实报
	private String detail; // 明细
	private Integer investId; // 费用归属主键
	private String investIdStr; //费用归属主键字符串
	
	private SaleProjectManage project;
	private FinInvest invest;

	private Integer state;//用于财务统计 区别差旅和通用
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setReimburseId(Integer reimburseId) {
		this.reimburseId = reimburseId;
	}
	
	public Integer getReimburseId() {
		return this.reimburseId;
	}
	
	public void setDate(Date date) {
		this.date = date;
	}
	
	public Date getDate() {
		return this.date;
	}
	
	public void setPlace(String place) {
		this.place = place;
	}
	
	public String getPlace() {
		return this.place;
	}
	
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}
	
	public Integer getProjectId() {
		return this.projectId;
	}
	
	public void setReason(String reason) {
		this.reason = reason;
	}
	
	public String getReason() {
		return this.reason;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getType() {
		return this.type;
	}
	
	public void setMoney(Double money) {
		this.money = money;
	}
	
	public Double getMoney() {
		return this.money;
	}
	
	public Double getActReimburse() {
		return actReimburse;
	}

	public void setActReimburse(Double actReimburse) {
		this.actReimburse = actReimburse;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}
	
	public String getDetail() {
		return this.detail;
	}
	
	public void setInvestId(Integer investId) {
		this.investId = investId;
	}
	
	public Integer getInvestId() {
		return this.investId;
	}

	public SaleProjectManage getProject() {
		return project;
	}

	public void setProject(SaleProjectManage project) {
		this.project = project;
	}

	public FinInvest getInvest() {
		return invest;
	}

	public void setInvest(FinInvest invest) {
		this.invest = invest;
	}

	public String getInvestIdStr() {
		return investIdStr;
	}

	public void setInvestIdStr(String investIdStr) {
		this.investIdStr = investIdStr;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}
	
}