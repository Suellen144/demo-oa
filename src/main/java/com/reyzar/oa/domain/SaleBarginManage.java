package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.util.List;
import java.lang.String;
import java.lang.Integer;

@SuppressWarnings("serial")
public class SaleBarginManage extends BaseEntity {

	private Integer id; // 主键
	private String processInstanceId; // 流程实例
	private Integer projectManageId; // 项目管理ID
	private String title;
	private Integer deptId; // 发起人所属部门ID
	private Integer userId; // 发起人ID
	private Date applyTime; // 发起时间
	private String barginName; // 合同名称
	private String barginCode; // 合同编号
	private String barginType; // 合同类型
	private String barginDescribe; // 合同描述
	private String company; // 签订单位名称
	private Double totalMoney; // 合同总金额
	private Double receivedMoney; // 已收金额
	private Double unreceivedMoney; // 未收金额
	private Double invoiceMoney;//开票金额
	private Double advancesReceived;//预收款
	private Double accountReceived;//应收款
 	/*private Double receivedInvoice; // 收款已开发票
	private Double unreceivedInvoice; // 收款未开发票
*/	private Double payReceivedInvoice; // 付款已收发票
	private Double payUnreceivedInvoice; // 付款未收发票
	private Double unInvoice;//未收发票
	private Double payMoney; // 已付金额
	private Double unpayMoney; // 未付金额
	private Date startTime; // 合同开始时间
	private Date endTime; // 合同结束时间
	private String attachName; // 附件原文件名
	private String attachments; // 附件
	private String status; // 状态  0：提交申请 1：部门经理审批····
	private String remark;  //合同作废备注

	private SysDept dept;
	private SysUser sysUser;
	private SaleProjectManage projectManage;
	
	private	List<FinCollection> collectionList;
	private List<FinPay> payList;
	
	//项目管理模块 添加 
	private Integer isNewProject;//是否新项目管理模块创建(0:否1:是)
	private Double channelExpense;//渠道费用额度
	private Double contribution;//业绩贡献
	private Double commissionAmount;//提成额度
	
	private Double confirmAmount;//页面显示统计 收入金额
	private Double channelCost;//页面显示统计 渠道费用（已支付）
	private Double allocations;//页面显示统计 提成额度
	private Double resultsAmount;//页面显示统计 业绩贡献
	private String userName;
	
	private String companyPeople; //签订单位联系人
	private String companyPhone;//签订单位联系电话
	private String barginExplain; // 合同说明

	private String attachName2; // 合同附件原文件名
	private String attachments2; // 合同附件
	private String barginConfirm; // 是否已确认

	private String position1; // 职位条件1
	private String position2; // 职位条件2
	private String position3; // 职位条件3

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
	
	public void setProjectManageId(Integer projectManageId) {
		this.projectManageId = projectManageId;
	}
	
	public Integer getProjectManageId() {
		return this.projectManageId;
	}
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setBarginName(String barginName) {
		this.barginName = barginName;
	}
	
	public String getBarginName() {
		return this.barginName;
	}
	
	public void setBarginCode(String barginCode) {
		this.barginCode = barginCode;
	}
	
	public String getBarginCode() {
		return this.barginCode;
	}
	
	public void setBarginType(String barginType) {
		this.barginType = barginType;
	}
	
	public String getBarginType() {
		return this.barginType;
	}
	
	public void setBarginDescribe(String barginDescribe) {
		this.barginDescribe = barginDescribe;
	}
	
	public String getBarginDescribe() {
		return this.barginDescribe;
	}
	
	public void setCompany(String company) {
		this.company = company;
	}
	
	public String getCompany() {
		return this.company;
	}
	
	public void setTotalMoney(Double totalMoney) {
		this.totalMoney = totalMoney;
	}
	
	public Double getTotalMoney() {
		return this.totalMoney;
	}
	
	public void setReceivedMoney(Double receivedMoney) {
		this.receivedMoney = receivedMoney;
	}
	
	public Double getReceivedMoney() {
		return this.receivedMoney;
	}
	
	public void setUnreceivedMoney(Double unreceivedMoney) {
		this.unreceivedMoney = unreceivedMoney;
	}
	
	public Double getUnreceivedMoney() {
		return this.unreceivedMoney;
	}
	
	
	
	/*public Double getReceivedInvoice() {
		return receivedInvoice;
	}

	public void setReceivedInvoice(Double receivedInvoice) {
		this.receivedInvoice = receivedInvoice;
	}

	public Double getUnreceivedInvoice() {
		return unreceivedInvoice;
	}

	public void setUnreceivedInvoice(Double unreceivedInvoice) {
		this.unreceivedInvoice = unreceivedInvoice;
	}*/

	public Double getPayReceivedInvoice() {
		return payReceivedInvoice;
	}

	public void setPayReceivedInvoice(Double payReceivedInvoice) {
		this.payReceivedInvoice = payReceivedInvoice;
	}

	public Double getPayUnreceivedInvoice() {
		return payUnreceivedInvoice;
	}

	public void setPayUnreceivedInvoice(Double payUnreceivedInvoice) {
		this.payUnreceivedInvoice = payUnreceivedInvoice;
	}

	public Double getPayMoney() {
		return payMoney;
	}

	public void setPayMoney(Double payMoney) {
		this.payMoney = payMoney;
	}

	public Double getUnpayMoney() {
		return unpayMoney;
	}

	public void setUnpayMoney(Double unpayMoney) {
		this.unpayMoney = unpayMoney;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
	
	public Date getStartTime() {
		return this.startTime;
	}
	
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	
	public Date getEndTime() {
		return this.endTime;
	}
	
	public void setAttachName(String attachName) {
		this.attachName = attachName;
	}
	
	public String getAttachName() {
		return this.attachName;
	}
	
	public void setAttachments(String attachments) {
		this.attachments = attachments;
	}
	
	public String getAttachments() {
		return this.attachments;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}

	public SysUser getSysUser() {
		return sysUser;
	}

	public void setSysUser(SysUser sysUser) {
		this.sysUser = sysUser;
	}

	public SaleProjectManage getProjectManage() {
		return projectManage;
	}

	public void setProjectManage(SaleProjectManage projectManage) {
		this.projectManage = projectManage;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	

	public Double getInvoiceMoney() {
		return invoiceMoney;
	}

	public void setInvoiceMoney(Double invoiceMoney) {
		this.invoiceMoney = invoiceMoney;
	}
	
	public Double getAdvancesReceived() {
		return advancesReceived;
	}

	public void setAdvancesReceived(Double advancesReceived) {
		this.advancesReceived = advancesReceived;
	}

	public Double getAccountReceived() {
		return accountReceived;
	}

	public void setAccountReceived(Double accountReceived) {
		this.accountReceived = accountReceived;
	}


	public List<FinCollection> getCollectionList() {
		return collectionList;
	}

	public void setCollectionList(List<FinCollection> collectionList) {
		this.collectionList = collectionList;
	}

	public List<FinPay> getPayList() {
		return payList;
	}

	public void setPayList(List<FinPay> payList) {
		this.payList = payList;
	}
	

	public Double getUnInvoice() {
		return unInvoice;
	}

	public void setUnInvoice(Double unInvoice) {
		this.unInvoice = unInvoice;
	}
	
	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Integer getIsNewProject() {
		return isNewProject;
	}

	public void setIsNewProject(Integer isNewProject) {
		this.isNewProject = isNewProject;
	}

	public Double getChannelExpense() {
		return channelExpense;
	}

	public void setChannelExpense(Double channelExpense) {
		this.channelExpense = channelExpense;
	}

	public Double getContribution() {
		return contribution;
	}

	public void setContribution(Double contribution) {
		this.contribution = contribution;
	}

	public Double getCommissionAmount() {
		return commissionAmount;
	}

	public void setCommissionAmount(Double commissionAmount) {
		this.commissionAmount = commissionAmount;
	}

	public Double getConfirmAmount() {
		return confirmAmount;
	}

	public void setConfirmAmount(Double confirmAmount) {
		this.confirmAmount = confirmAmount;
	}

	public Double getChannelCost() {
		return channelCost;
	}

	public void setChannelCost(Double channelCost) {
		this.channelCost = channelCost;
	}

	public Double getAllocations() {
		return allocations;
	}

	public void setAllocations(Double allocations) {
		this.allocations = allocations;
	}

	public Double getResultsAmount() {
		return resultsAmount;
	}

	public void setResultsAmount(Double resultsAmount) {
		this.resultsAmount = resultsAmount;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getCompanyPeople() {
		return companyPeople;
	}

	public void setCompanyPeople(String companyPeople) {
		this.companyPeople = companyPeople;
	}

	public String getCompanyPhone() {
		return companyPhone;
	}

	public void setCompanyPhone(String companyPhone) {
		this.companyPhone = companyPhone;
	}

	public String getBarginExplain() {
		return barginExplain;
	}

	public void setBarginExplain(String barginExplain) {
		this.barginExplain = barginExplain;
	}

	public String getAttachName2() {
		return attachName2;
	}

	public void setAttachName2(String attachName2) {
		this.attachName2 = attachName2;
	}

	public String getAttachments2() {
		return attachments2;
	}

	public void setAttachments2(String attachments2) {
		this.attachments2 = attachments2;
	}

	public String getBarginConfirm() {
		return barginConfirm;
	}

	public void setBarginConfirm(String barginConfirm) {
		this.barginConfirm = barginConfirm;
	}

	public String getPosition1() {
		return position1;
	}

	public void setPosition1(String position1) {
		this.position1 = position1;
	}

	public String getPosition2() {
		return position2;
	}

	public void setPosition2(String position2) {
		this.position2 = position2;
	}

	public String getPosition3() {
		return position3;
	}

	public void setPosition3(String position3) {
		this.position3 = position3;
	}

	@Override
	public String toString() {
		return "SaleBarginManage [id=" + id + ", processInstanceId=" + processInstanceId + ", projectManageId="
				+ projectManageId + ", title=" + title + ", deptId=" + deptId + ", userId=" + userId + ", applyTime="
				+ applyTime + ", barginName=" + barginName + ", barginCode=" + barginCode + ", barginType=" + barginType
				+ ", barginDescribe=" + barginDescribe + ", company=" + company + ", totalMoney=" + totalMoney
				+ ", receivedMoney=" + receivedMoney + ", unreceivedMoney=" + unreceivedMoney 
				+ ", payReceivedInvoice="
				+ payReceivedInvoice + ", payUnreceivedInvoice=" + payUnreceivedInvoice + ", payMoney=" + payMoney
				+ ", unpayMoney=" + unpayMoney + ", startTime=" + startTime + ", endTime=" + endTime + ", attachName="
				+ attachName + ", attachments=" + attachments + ", status=" + status + ", dept=" + dept + ", sysUser="
				+ sysUser + ", projectManage=" + projectManage + ", barginExplain=" + barginExplain + ", attachName2="
				+ attachName2 + ", attachments2=" + attachments2 + ", barginConfirm=" + barginConfirm + ", position1="
				+ position1 + ", position2=" + position2 + ", position3=" + position3 + "]";
	}
	
}