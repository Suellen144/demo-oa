package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

public class FinPay extends BaseEntity{

	private static final long serialVersionUID = 1L;
	private Integer id;
	private String processInstanceId;
	private Integer barginManageId;
	private Integer projectManageId;
	private String title;
	private Integer deptId;
	private Integer userId;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime;
	private String collectCompany;
	private String bankAccount;
	private String bankAddress;
	private String payType;
	private String reimburseType;//通用类型
	private String invoiceCollect;
	private Double invoiceMoney;//发票金额
	private Double totalMoney; // 合同总金额
	private Double applyMoney; // 申请金额
	private String applyProportion;//本次申请比例
	private String purpose;	
	private String actualInvoiceStatus; // 发票实际收取情况
	private Double actualPayMoney; // 实际付款金额
	private Double payBill; // 实际已付款金额
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date actualPayDate;//实际付款日期	
	private String attachName;
	private String attachments;
	private String status;
	private SaleBarginManage barginManage;
	private SaleProjectManage projectManage;
	private SysUser sysUser;
	private SysDept dept;
	private List<FinPayAttach> payAttachList;
	private String cause;
	
	public Double getPayBill() {
		return payBill;
	}
	public void setPayBill(Double payBill) {
		this.payBill = payBill;
	}

	public void setId(Integer id){
		this.id = id;
	}
	public Integer getId(){
		return this.id;
	}
	public void setProcessInstanceId(String processInstanceId){
		this.processInstanceId = processInstanceId;
	}
	public String getProcessInstanceId(){
		return this.processInstanceId;
	}
	public void setBarginManageId(Integer barginManageId){
		this.barginManageId = barginManageId;
	}
	public Integer getBarginManageId(){
		return this.barginManageId;
	}
	public void setProjectManageId(Integer projectManageId){
		this.projectManageId = projectManageId;
	}
	public Integer getProjectManageId(){
		return this.projectManageId;
	}
	public void setTitle(String title){
		this.title = title;
	}
	public String getTitle(){
		return this.title;
	}
	public void setDeptId(Integer deptId){
		this.deptId = deptId;
	}
	public Integer getDeptId(){
		return this.deptId;
	}
	public void setUserId(Integer userId){
		this.userId = userId;
	}
	public Integer getUserId(){
		return this.userId;
	}
	public void setApplyTime(Date applyTime){
		this.applyTime = applyTime;
	}
	public Date getApplyTime(){
		return this.applyTime;
	}
	public void setCollectCompany(String collectCompany){
		this.collectCompany = collectCompany;
	}
	public String getCollectCompany(){
		return this.collectCompany;
	}
	public void setBankAccount(String bankAccount){
		this.bankAccount = bankAccount;
	}
	public String getBankAccount(){
		return this.bankAccount;
	}
	public void setBankAddress(String bankAddress){
		this.bankAddress = bankAddress;
	}
	public String getBankAddress(){
		return this.bankAddress;
	}
	public void setPayType(String payType){
		this.payType = payType;
	}
	public String getPayType(){
		return this.payType;
	}
	
	
	public String getInvoiceCollect() {
		return invoiceCollect;
	}
	public void setInvoiceCollect(String invoiceCollect) {
		this.invoiceCollect = invoiceCollect;
	}
	public Double getInvoiceMoney() {
		return invoiceMoney;
	}
	public void setInvoiceMoney(Double invoiceMoney) {
		this.invoiceMoney = invoiceMoney;
	}
	public Double getTotalMoney() {
		return totalMoney;
	}
	public void setTotalMoney(Double totalMoney) {
		this.totalMoney = totalMoney;
	}
	public Double getApplyMoney() {
		return applyMoney;
	}
	public void setApplyMoney(Double applyMoney) {
		this.applyMoney = applyMoney;
	}
	public String getApplyProportion() {
		return applyProportion;
	}
	public void setApplyProportion(String applyProportion) {
		this.applyProportion = applyProportion;
	}
	public void setPurpose(String purpose){
		this.purpose = purpose;
	}
	public String getPurpose(){
		return this.purpose;
	}
	
	
	public String getActualInvoiceStatus() {
		return actualInvoiceStatus;
	}
	public void setActualInvoiceStatus(String actualInvoiceStatus) {
		this.actualInvoiceStatus = actualInvoiceStatus;
	}
	public Double getActualPayMoney() {
		return actualPayMoney;
	}
	public void setActualPayMoney(Double actualPayMoney) {
		this.actualPayMoney = actualPayMoney;
	}
	
	public Date getActualPayDate() {
		return actualPayDate;
	}
	public void setActualPayDate(Date actualPayDate) {
		this.actualPayDate = actualPayDate;
	}
	public void setAttachName(String attachName){
		this.attachName = attachName;
	}
	public String getAttachName(){
		return this.attachName;
	}
	public void setAttachments(String attachments){
		this.attachments = attachments;
	}
	public String getAttachments(){
		return this.attachments;
	}
	public void setStatus(String status){
		this.status = status;
	}
	public String getStatus(){
		return this.status;
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
	public SysUser getSysUser() {
		return sysUser;
	}
	public void setSysUser(SysUser sysUser) {
		this.sysUser = sysUser;
	}
	public SysDept getDept() {
		return dept;
	}
	public void setDept(SysDept dept) {
		this.dept = dept;
	}
	public String getReimburseType() {
		return reimburseType;
	}
	public void setReimburseType(String reimburseType) {
		this.reimburseType = reimburseType;
	}
	
	public List<FinPayAttach> getPayAttachList() {
		return payAttachList;
	}

	public void setPayAttachList(List<FinPayAttach> payAttachList) {
		this.payAttachList = payAttachList;
	}

	public String getCause() {
		return cause;
	}

	public void setCause(String cause) {
		this.cause = cause;
	}
}