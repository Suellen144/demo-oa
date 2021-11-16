package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class FinTravelreimburseAttach extends BaseEntity {

	private Integer id; // 主键ID
	private Integer travelreimburseId; // 出差报销主键
	private Date date; // 日期
	private Date beginDate; // 出发日期
	private Date endDate; // 离开日期
	private String place; // 地点
	private String startPoint; // 出发地
	private String destination; // 目的地
	private Double cost; // 费用
	private Double actReimburse; // 实报
	private Double foodSubsidy; // 餐费补贴
	private Double trafficSubsidy; // 交通补贴
	private String reason; // 事由
	private String detail; // 明细
	private Integer projectId; // 项目主键
	private String conveyance; // 交通工具
	private Double dayRoom; // 天*房
	private String type; // 类别 0：城际交通费 1：住宿费 2：市内交通费 3：接待餐费 4：补贴
	
	private SaleProjectManage project;
//	private Integer investId; // 费用归属主键
	private FinInvest invest;
	private Integer attachInvestId; //附表费用归属主键
	private String attachInvestIdStr; //附表费用归属主键（多项）

	public Integer getAttachInvestId() {
		return attachInvestId;
	}

	public void setAttachInvestId(Integer attachInvestId) {
		this.attachInvestId = attachInvestId;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setTravelreimburseId(Integer travelreimburseId) {
		this.travelreimburseId = travelreimburseId;
	}
	
	public Integer getTravelreimburseId() {
		return this.travelreimburseId;
	}
	
	public void setDate(Date date) {
		this.date = date;
	}
	
	public Date getDate() {
		return this.date;
	}
	
	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}
	
	public Date getBeginDate() {
		return this.beginDate;
	}
	
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	
	public Date getEndDate() {
		return this.endDate;
	}
	
	public void setPlace(String place) {
		this.place = place;
	}
	
	public String getPlace() {
		return this.place;
	}
	
	public void setStartPoint(String startPoint) {
		this.startPoint = startPoint;
	}
	
	public String getStartPoint() {
		return this.startPoint;
	}
	
	public void setDestination(String destination) {
		this.destination = destination;
	}
	
	public String getDestination() {
		return this.destination;
	}
	
	public void setCost(Double cost) {
		this.cost = cost;
	}
	
	public Double getCost() {
		return this.cost;
	}
	
	public void setActReimburse(Double actReimburse) {
		this.actReimburse = actReimburse;
	}
	
	public Double getActReimburse() {
		return this.actReimburse;
	}
	
	public void setFoodSubsidy(Double foodSubsidy) {
		this.foodSubsidy = foodSubsidy;
	}
	
	public Double getFoodSubsidy() {
		return this.foodSubsidy;
	}
	
	public void setTrafficSubsidy(Double trafficSubsidy) {
		this.trafficSubsidy = trafficSubsidy;
	}
	
	public Double getTrafficSubsidy() {
		return this.trafficSubsidy;
	}
	
	public void setReason(String reason) {
		this.reason = reason;
	}
	
	public String getReason() {
		return this.reason;
	}
	
	public void setDetail(String detail) {
		this.detail = detail;
	}
	
	public String getDetail() {
		return this.detail;
	}
	
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}
	
	public Integer getProjectId() {
		return this.projectId;
	}
	
	public void setConveyance(String conveyance) {
		this.conveyance = conveyance;
	}
	
	public String getConveyance() {
		return this.conveyance;
	}
	
	public void setDayRoom(Double dayRoom) {
		this.dayRoom = dayRoom;
	}
	
	public Double getDayRoom() {
		return this.dayRoom;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getType() {
		return this.type;
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

//	public Integer getInvestId() {
//		return investId;
//	}

//	public void setInvestId(Integer investId) {
//		this.investId = investId;
//	}

	@Override
	public String toString() {
		return "FinTravelreimburseAttach [id=" + id + ", reason=" + reason + ", detail=" + detail + "]";
	}

	public String getAttachInvestIdStr() {
		return attachInvestIdStr;
	}

	public void setAttachInvestIdStr(String attachInvestIdStr) {
		this.attachInvestIdStr = attachInvestIdStr;
	}
	
}