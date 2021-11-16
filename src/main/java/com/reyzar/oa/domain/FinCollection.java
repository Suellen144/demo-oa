package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.util.List;
import java.lang.String;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class FinCollection extends BaseEntity {

	private Integer id; // 
	private String processInstanceId; // 
	private String status; // 
	private Integer title; // 所属公司字段
	private Integer userId; // 
	private Integer deptId; // 
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 
	private Integer barginId; // 合同ID
	private Integer projectId;//项目ID
	private String totalPay; // 总金额
	private String applyPay; // 申请金额
	private String applyProportion; // 申请比例
	private String payCompany; // 付款单位
	private Integer isInvoiced; // 是否开发票
	private Integer invoicedId; // 发票ID
	private Double bill; // 开票金额
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date billDate; // 开票日期
	private Double coollection; // 收款总金额
	private String collectionType; //收款类型
	private String reason;
	private Integer isSend; //
	private String attachName;//文件名称
	private String attachments;//附件
	
	private SysUser applicant; // 流程发起人
	private SysDept dept;
	private FinInvoiced invoiced;//发票
	private String emailUid;//流程用户的ID

	private SaleBarginManage barginManage;
	private SaleProjectManage projectManage;
	private List<FinInvoicedAttach>  invoicedAttachList;
	private List<FinCollectionAttach> collectionAttachList;

	private Double collectionBill; //收款金額
	//项目管理模块 新增字段
	private Double commissionBase;//提成基数
	private String commissionProportion;//提成比例
	private Double allocations;//分配额度
	private Double channelCost;//渠道费用
	private Double receiving;//已收款
	private Double notReceiving;//未收款
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date collectionDate;//收款时间
	private Integer isNewProject;//是否新项目管理模块创建的收款数据 (0:否1:是)
	private Integer isOldData;//是否旧数据，用于详情显示 (0:是1:否)
	private Integer isNewProcess;//是否走新流程;
	private String isOk;
	private String position;

	private Double purchase;//采购成本
	private Double taxes;//税金
	private Double relationship;//攻关费
	private Double other;//其他

	private List<FinCollectionMembers> finCollectionMembers;
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	
	public String getProcessInstanceId() {
		return this.processInstanceId;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}
	
	public void setTitle(Integer title) {
		this.title = title;
	}
	
	public Integer getTitle() {
		return this.title;
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
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setBarginId(Integer barginId) {
		this.barginId = barginId;
	}
	
	public Integer getBarginId() {
		return this.barginId;
	}
	
	public void setTotalPay(String totalPay) {
		this.totalPay = totalPay;
	}
	
	public String getTotalPay() {
		return this.totalPay;
	}
	
	public void setApplyPay(String applyPay) {
		this.applyPay = applyPay;
	}
	
	public String getApplyPay() {
		return this.applyPay;
	}
	
	public void setApplyProportion(String applyProportion) {
		this.applyProportion = applyProportion;
	}
	
	public String getApplyProportion() {
		return this.applyProportion;
	}
	
	public void setPayCompany(String payCompany) {
		this.payCompany = payCompany;
	}
	
	public String getPayCompany() {
		return this.payCompany;
	}
	
	public void setIsInvoiced(Integer isInvoiced) {
		this.isInvoiced = isInvoiced;
	}
	
	public Integer getIsInvoiced() {
		return this.isInvoiced;
	}
	
	public void setInvoicedId(Integer invoicedId) {
		this.invoicedId = invoicedId;
	}
	
	public Integer getInvoicedId() {
		return this.invoicedId;
	}
	
	public void setBill(Double bill) {
		this.bill = bill;
	}
	
	public Double getBill() {
		return this.bill;
	}
	
	public void setBillDate(Date billDate) {
		this.billDate = billDate;
	}
	
	public Date getBillDate() {
		return this.billDate;
	}
	
	public void setCoollection(Double coollection) {
		this.coollection = coollection;
	}
	
	public Double getCoollection() {
		return this.coollection;
	}
	
	public void setIsSend(Integer isSend) {
		this.isSend = isSend;
	}
	
	public Integer getIsSend() {
		return this.isSend;
	}

	public SysUser getApplicant() {
		return applicant;
	}

	public void setApplicant(SysUser applicant) {
		this.applicant = applicant;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}

	public List<FinCollectionAttach> getCollectionAttachList() {
		return collectionAttachList;
	}

	public void setCollectionAttachList(List<FinCollectionAttach> collectionAttachList) {
		this.collectionAttachList = collectionAttachList;
	}

	public FinInvoiced getInvoiced() {
		return invoiced;
	}

	public void setInvoiced(FinInvoiced invoiced) {
		this.invoiced = invoiced;
	}

	public List<FinInvoicedAttach> getInvoicedAttachList() {
		return invoicedAttachList;
	}

	public void setInvoicedAttachList(List<FinInvoicedAttach> invoicedAttachList) {
		this.invoicedAttachList = invoicedAttachList;
	}

	public SaleBarginManage getBarginManage() {
		return barginManage;
	}

	public void setBarginManage(SaleBarginManage barginManage) {
		this.barginManage = barginManage;
	}

	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}

	public Integer getProjectId() {
		return projectId;
	}

	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}

	public String getEmailUid() {
		return emailUid;
	}

	public void setEmailUid(String emailUid) {
		this.emailUid = emailUid;
	}

	public String getAttachName() {
		return attachName;
	}

	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}

	public String getAttachments() {
		return attachments;
	}

	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}

	public String getCollectionType() {
		return collectionType;
	}

	public void setCollectionType(String collectionType) {
		this.collectionType = collectionType;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public Double getCollectionBill() {
		return collectionBill;
	}

	public void setCollectionBill(Double collectionBill) {
		this.collectionBill = collectionBill;
	}

	public Double getCommissionBase() {
		return commissionBase;
	}

	public void setCommissionBase(Double commissionBase) {
		this.commissionBase = commissionBase;
	}

	public String getCommissionProportion() {
		return commissionProportion;
	}

	public void setCommissionProportion(String commissionProportion) {
		this.commissionProportion = commissionProportion;
	}

	public Double getAllocations() {
		return allocations;
	}

	public void setAllocations(Double allocations) {
		this.allocations = allocations;
	}

	public Double getChannelCost() {
		return channelCost;
	}

	public void setChannelCost(Double channelCost) {
		this.channelCost = channelCost;
	}

	public Double getReceiving() {
		return receiving;
	}

	public void setReceiving(Double receiving) {
		this.receiving = receiving;
	}

	public Double getNotReceiving() {
		return notReceiving;
	}

	public void setNotReceiving(Double notReceiving) {
		this.notReceiving = notReceiving;
	}

	public Date getCollectionDate() {
		return collectionDate;
	}

	public void setCollectionDate(Date collectionDate) {
		this.collectionDate = collectionDate;
	}

	public Integer getIsNewProject() {
		return isNewProject;
	}

	public void setIsNewProject(Integer isNewProject) {
		this.isNewProject = isNewProject;
	}

	public List<FinCollectionMembers> getFinCollectionMembers() {
		return finCollectionMembers;
	}

	public void setFinCollectionMembers(List<FinCollectionMembers> finCollectionMembers) {
		this.finCollectionMembers = finCollectionMembers;
	}

	public Integer getIsOldData() {
		return isOldData;
	}

	public void setIsOldData(Integer isOldData) {
		this.isOldData = isOldData;
	}

	public Integer getIsNewProcess() {
		return isNewProcess;
	}

	public void setIsNewProcess(Integer isNewProcess) {
		this.isNewProcess = isNewProcess;
	}

	public String getIsOk() {
		return isOk;
	}

	public void setIsOk(String isOk) {
		this.isOk = isOk;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public Double getPurchase() {
		return purchase;
	}

	public void setPurchase(Double purchase) {
		this.purchase = purchase;
	}

	public Double getTaxes() {
		return taxes;
	}

	public void setTaxes(Double taxes) {
		this.taxes = taxes;
	}

	public Double getRelationship() {
		return relationship;
	}

	public void setRelationship(Double relationship) {
		this.relationship = relationship;
	}

	public Double getOther() {
		return other;
	}

	public void setOther(Double other) {
		this.other = other;
	}
}