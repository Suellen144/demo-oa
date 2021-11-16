package com.reyzar.oa.domain;

import java.lang.Double;
import java.lang.String;
import java.lang.Integer;
import java.util.Date;
import java.util.List;

@SuppressWarnings("serial")
public class FinInvoiced extends BaseEntity {

	private Integer id;
	private String payname;
	private String paynumber;
	private String payaddress;
	private String payphone;
	private String bankAddress;
	private String bankNumber;
	// 销货公司
	private String collectionCompany;
	private String collectionAddress;
	// 识别号
	private String collectionNumber;
	// 销货开户行
	private String collectionBank;
	// 销货账号
	private String collectionAccount;
	// 销货电话
	private String collectionContact;
	private Double total;
	// 流程发起人
	private SysUser applicant;
	private SysDept dept;
	private List<FinInvoicedAttach> invoicedAttachList;

	//项目管理模块添加
	private SaleBarginManage barginManage;//合同
	private String processInstanceId;//流程实例id
	private Double invoiceAmount;//开票金额
	private String ticketUser;//收票人
	private String ticketPhone;//收票电话
	private Integer sendWay;//寄送方式(1 ：邮送 2：亲送)
	private Integer barginManageId;//合同id
	private Integer isNewProject;//是否新项目管理模块创建的收款数据 (0:否1:是)
	private String attachName;//文件名称
	private String attachments;//附件
	private SaleProjectManage saleProjectManage; //页面显示项目内容需要

	private List<FinInvoiceProjectMembers> finInvoiceProjectMembersList;
	private Integer applyUserId;//申请人
	private String applyUserName;
	private SysUser applyUser;
	private Integer applyUnit;//申请单位
	private String status; //审批状态
	
	private FinRevenueRecognition finRevenueRecognition;//收入确认对象
	private String projectName;//项目名称
	private Date finInvoicedDate; //开票时间

	private Double invoiceAmountTo;//已开票金额
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	

	
	public void setBankAddress(String bankAddress) {
		this.bankAddress = bankAddress;
	}
	
	public String getBankAddress() {
		return this.bankAddress;
	}
	
	public void setBankNumber(String bankNumber) {
		this.bankNumber = bankNumber;
	}
	
	public String getBankNumber() {
		return this.bankNumber;
	}
	
	
	public void setCollectionContact(String collectionContact) {
		this.collectionContact = collectionContact;
	}
	
	public String getCollectionContact() {
		return this.collectionContact;
	}
	
	
	public void setTotal(Double total) {
		this.total = total;
	}
	
	public Double getTotal() {
		return this.total;
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

	public List<FinInvoicedAttach> getInvoicedAttachList() {
		return invoicedAttachList;
	}

	public void setInvoicedAttachList(List<FinInvoicedAttach> invoicedAttachList) {
		this.invoicedAttachList = invoicedAttachList;
	}

	public String getCollectionCompany() {
		return collectionCompany;
	}

	public void setCollectionCompany(String collectionCompany) {
		this.collectionCompany = collectionCompany;
	}

	public String getCollectionAddress() {
		return collectionAddress;
	}

	public void setCollectionAddress(String collectionAddress) {
		this.collectionAddress = collectionAddress;
	}


	public String getCollectionBank() {
		return collectionBank;
	}

	public void setCollectionBank(String collectionBank) {
		this.collectionBank = collectionBank;
	}


	public String getCollectionAccount() {
		return collectionAccount;
	}

	public void setCollectionAccount(String collectionAccount) {
		this.collectionAccount = collectionAccount;
	}

	public String getCollectionNumber() {
		return collectionNumber;
	}

	public void setCollectionNumber(String collectionNumber) {
		this.collectionNumber = collectionNumber;
	}

	public String getPayname() {
		return payname;
	}

	public void setPayname(String payname) {
		this.payname = payname;
	}

	public String getPaynumber() {
		return paynumber;
	}

	public void setPaynumber(String paynumber) {
		this.paynumber = paynumber;
	}

	public String getPayaddress() {
		return payaddress;
	}

	public void setPayaddress(String payaddress) {
		this.payaddress = payaddress;
	}

	public String getPayphone() {
		return payphone;
	}

	public void setPayphone(String payphone) {
		this.payphone = payphone;
	}

	public Double getInvoiceAmount() {
		return invoiceAmount;
	}

	public void setInvoiceAmount(Double invoiceAmount) {
		this.invoiceAmount = invoiceAmount;
	}

	public String getTicketUser() {
		return ticketUser;
	}

	public void setTicketUser(String ticketUser) {
		this.ticketUser = ticketUser;
	}

	public String getTicketPhone() {
		return ticketPhone;
	}

	public void setTicketPhone(String ticketPhone) {
		this.ticketPhone = ticketPhone;
	}

	public Integer getSendWay() {
		return sendWay;
	}

	public void setSendWay(Integer sendWay) {
		this.sendWay = sendWay;
	}

	public SaleBarginManage getBarginManage() {
		return barginManage;
	}

	public void setBarginManage(SaleBarginManage barginManage) {
		this.barginManage = barginManage;
	}

	public Integer getBarginManageId() {
		return barginManageId;
	}

	public void setBarginManageId(Integer barginManageId) {
		this.barginManageId = barginManageId;
	}

	public Integer getIsNewProject() {
		return isNewProject;
	}

	public void setIsNewProject(Integer isNewProject) {
		this.isNewProject = isNewProject;
	}

	public SaleProjectManage getSaleProjectManage() {
		return saleProjectManage;
	}

	public void setSaleProjectManage(SaleProjectManage saleProjectManage) {
		this.saleProjectManage = saleProjectManage;
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

	public List<FinInvoiceProjectMembers> getFinInvoiceProjectMembersList() {
		return finInvoiceProjectMembersList;
	}

	public void setFinInvoiceProjectMembersList(List<FinInvoiceProjectMembers> finInvoiceProjectMembersList) {
		this.finInvoiceProjectMembersList = finInvoiceProjectMembersList;
	}

	public Integer getApplyUserId() {
		return applyUserId;
	}

	public void setApplyUserId(Integer applyUserId) {
		this.applyUserId = applyUserId;
	}

	public SysUser getApplyUser() {
		return applyUser;
	}

	public void setApplyUser(SysUser applyUser) {
		this.applyUser = applyUser;
	}

	public Integer getApplyUnit() {
		return applyUnit;
	}

	public void setApplyUnit(Integer applyUnit) {
		this.applyUnit = applyUnit;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getProcessInstanceId() {
		return processInstanceId;
	}

	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}

	public FinRevenueRecognition getFinRevenueRecognition() {
		return finRevenueRecognition;
	}

	public void setFinRevenueRecognition(FinRevenueRecognition finRevenueRecognition) {
		this.finRevenueRecognition = finRevenueRecognition;
	}

	public String getApplyUserName() {
		return applyUserName;
	}

	public void setApplyUserName(String applyUserName) {
		this.applyUserName = applyUserName;
	}

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public Date getFinInvoicedDate() {
		return finInvoicedDate;
	}

	public void setFinInvoicedDate(Date finInvoicedDate) {
		this.finInvoicedDate = finInvoicedDate;
	}

	public Double getInvoiceAmountTo() {
		return invoiceAmountTo;
	}

	public void setInvoiceAmountTo(Double invoiceAmountTo) {
		this.invoiceAmountTo = invoiceAmountTo;
	}

}