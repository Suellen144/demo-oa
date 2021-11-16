package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class FinTravelreimburse extends BaseEntity {

	private Integer id; // 主键ID
	private String processInstanceId; // 流程实例ID
	private Integer userId; // 流程发起人用户主键
	private String orderNo; // 单号
	private String title; // 公司标头
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date applyTime; // 填报日期
	private Integer deptId; // 部门主键
	private String name; // 出差人员
	private String payee; // 收款人
	private String bankAccount; // 收款银行卡号
	private String bankAddress; // 收款银行开户地址
	private Double total; // 合计
//	private Integer investId; // 费用归属主键
	private String travelId; // 出差管理主键
	private String attachName; // 附件原文件名
	private String attachments; // 附件
	private String status; // 审批状态 
	private String encrypted; // 标记是否被加密过 y:是 n:否
	private String assistantStatus;//市场助理确认 1：是 0：否
	
	private SysUser applicant; // 流程发起人
	private SysDept dept; // 关联部门
	private FinInvest invest;
	
	private Integer kind;//报销类别，1为差旅，2为通用
	
	private Integer isSend;//是否发送邮件   1已发送   0未发送
	private Double initMoney;//初始金额（申请金额）
	
	private Double actReimburse;//页面展示使用 开支金额
	
	private String createDateStr; //创建时间String
	
	private String isOk; //是否市场部
	
	public Integer getIsSend() {
		return isSend;
	}

	public void setIsSend(Integer isSend) {
		this.isSend = isSend;
	}

	public Double getInitMoney() {
		return initMoney;
	}

	public void setInitMoney(Double initMoney) {
		this.initMoney = initMoney;
	}

	private List<FinTravelreimburseAttach> travelreimburseAttachList;

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
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTitle() {
		return this.title;
	}
	
	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}
	
	public Date getApplyTime() {
		return this.applyTime;
	}
	
	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	public Integer getDeptId() {
		return this.deptId;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setPayee(String payee) {
		this.payee = payee;
	}
	
	public String getPayee() {
		return this.payee;
	}
	
	public void setBankAccount(String bankAccount) {
		this.bankAccount = bankAccount;
	}
	
	public String getBankAccount() {
		return this.bankAccount;
	}
	
	public void setBankAddress(String bankAddress) {
		this.bankAddress = bankAddress;
	}
	
	public String getBankAddress() {
		return this.bankAddress;
	}
	
	public void setTotal(Double total) {
		this.total = total;
	}
	
	public Double getTotal() {
		return this.total;
	}
	
//	public void setInvestId(Integer investId) {
//		this.investId = investId;
//	}
	
//	public Integer getInvestId() {
//		return this.investId;
//	}
	
	
	
	public String getTravelId() {
		return travelId;
	}

	public void setTravelId(String travelId) {
		this.travelId = travelId;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public FinInvest getInvest() {
		return invest;
	}

	public void setInvest(FinInvest invest) {
		this.invest = invest;
	}

	public List<FinTravelreimburseAttach> getTravelreimburseAttachList() {
		return travelreimburseAttachList;
	}

	public void setTravelreimburseAttachList(List<FinTravelreimburseAttach> travelreimburseAttachList) {
		this.travelreimburseAttachList = travelreimburseAttachList;
	}

	public Integer getKind() {
		return kind;
	}

	public void setKind(Integer kind) {
		this.kind = kind;
	}

	public String getEncrypted() {
		return encrypted;
	}

	public void setEncrypted(String encrypted) {
		this.encrypted = encrypted;
	}

	public String getAssistantStatus() {
		return assistantStatus;
	}

	public void setAssistantStatus(String assistantStatus) {
		this.assistantStatus = assistantStatus;
	}

	public Double getActReimburse() {
		return actReimburse;
	}

	public void setActReimburse(Double actReimburse) {
		this.actReimburse = actReimburse;
	}

	public String getCreateDateStr() {
		return createDateStr;
	}

	public void setCreateDateStr(String createDateStr) {
		this.createDateStr = createDateStr;
	}

	public String getIsOk() {
		return isOk;
	}

	public void setIsOk(String isOk) {
		this.isOk = isOk;
	}
}