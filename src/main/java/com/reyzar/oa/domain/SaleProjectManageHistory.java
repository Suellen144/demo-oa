package com.reyzar.oa.domain;

import java.lang.String;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.Integer;

@SuppressWarnings("serial")
public class SaleProjectManageHistory extends BaseEntity {

	private Integer id; // 主键
	private Integer projectId; // 项目Id
	private String name; // 项目名称
	private String describe; // 项目说明
	private Integer applicant; // 项目申请人Id
	private Integer userId; // 项目负责人Id	
	private Integer applyDeptId; // 申请人所属部门Id
	private Integer dutyDeptId; // 负责人所属部门Id	
	private String status; // 项目状态
	private Date submitDate; // 提交时间
	private Double size ; // 规模
	private Double barginMoney; // 合同金额
	private Double income; //收入
	private Double pay; // 支出
	private Double ggMoney; // 攻关费用（已用）
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date projectDate ; // 立项时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date projectEndDate ; // 结束时间
	private Double researchCostLines; // 攻关费用额度
	private Double qdMoney; // 渠道费用额度
	private Double qdMoneyUsed; // 渠道费用（已用）
	private Double qdMoneyResidue; // 渠道费用（剩余）
	private Double performanceContribution; // 业绩贡献
	private Double royaltyQuota; // 提成额度
	private Integer applicationType ;//申请类型（1:新增申请;2:变更申请）
	private String processInstanceId; // 流程实例Id
	private Integer statusNew; // 当前审批环节
	private String title;
	private Integer createUserId;  //  项目变更申请人Id
	
	private SysUser alteredPerson; // 项目变更申请人
	private SysUser applicantP; // 项目立项申请人
	private SysUser principal; // 项目负责人
	private SysDept deptA; // 申请人关联部门
	private SysDept deptD; // 负责人关联部门
	private List<SaleProjectMemberHistory> projectMemberHistoryList;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getProjectId() {
		return projectId;
	}
	public void setProjectId(Integer projectId) {
		this.projectId = projectId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescribe() {
		return describe;
	}
	public void setDescribe(String describe) {
		this.describe = describe;
	}
	public Integer getApplicant() {
		return applicant;
	}
	public void setApplicant(Integer applicant) {
		this.applicant = applicant;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public Integer getApplyDeptId() {
		return applyDeptId;
	}
	public void setApplyDeptId(Integer applyDeptId) {
		this.applyDeptId = applyDeptId;
	}
	public Integer getDutyDeptId() {
		return dutyDeptId;
	}
	public void setDutyDeptId(Integer dutyDeptId) {
		this.dutyDeptId = dutyDeptId;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getSubmitDate() {
		return submitDate;
	}
	public void setSubmitDate(Date submitDate) {
		this.submitDate = submitDate;
	}
	public Double getSize() {
		return size;
	}
	public void setSize(Double size) {
		this.size = size;
	}
	public Double getBarginMoney() {
		return barginMoney;
	}
	public void setBarginMoney(Double barginMoney) {
		this.barginMoney = barginMoney;
	}
	public Double getIncome() {
		return income;
	}
	public void setIncome(Double income) {
		this.income = income;
	}
	public Double getPay() {
		return pay;
	}
	public void setPay(Double pay) {
		this.pay = pay;
	}
	public Double getGgMoney() {
		return ggMoney;
	}
	public void setGgMoney(Double ggMoney) {
		this.ggMoney = ggMoney;
	}
	public Date getProjectDate() {
		return projectDate;
	}
	public void setProjectDate(Date projectDate) {
		this.projectDate = projectDate;
	}
	public Date getProjectEndDate() {
		return projectEndDate;
	}
	public void setProjectEndDate(Date projectEndDate) {
		this.projectEndDate = projectEndDate;
	}
	public Double getResearchCostLines() {
		return researchCostLines;
	}
	public void setResearchCostLines(Double researchCostLines) {
		this.researchCostLines = researchCostLines;
	}
	public Double getQdMoney() {
		return qdMoney;
	}
	public void setQdMoney(Double qdMoney) {
		this.qdMoney = qdMoney;
	}
	public Double getQdMoneyUsed() {
		return qdMoneyUsed;
	}
	public void setQdMoneyUsed(Double qdMoneyUsed) {
		this.qdMoneyUsed = qdMoneyUsed;
	}
	public Double getQdMoneyResidue() {
		return qdMoneyResidue;
	}
	public void setQdMoneyResidue(Double qdMoneyResidue) {
		this.qdMoneyResidue = qdMoneyResidue;
	}
	public Double getPerformanceContribution() {
		return performanceContribution;
	}
	public void setPerformanceContribution(Double performanceContribution) {
		this.performanceContribution = performanceContribution;
	}
	public Double getRoyaltyQuota() {
		return royaltyQuota;
	}
	public void setRoyaltyQuota(Double royaltyQuota) {
		this.royaltyQuota = royaltyQuota;
	}
	public Integer getApplicationType() {
		return applicationType;
	}
	public void setApplicationType(Integer applicationType) {
		this.applicationType = applicationType;
	}
	public String getProcessInstanceId() {
		return processInstanceId;
	}
	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}
	public Integer getStatusNew() {
		return statusNew;
	}
	public void setStatusNew(Integer statusNew) {
		this.statusNew = statusNew;
	}
	public SysUser getApplicantP() {
		return applicantP;
	}
	public void setApplicantP(SysUser applicantP) {
		this.applicantP = applicantP;
	}
	public SysUser getPrincipal() {
		return principal;
	}
	public void setPrincipal(SysUser principal) {
		this.principal = principal;
	}
	public SysDept getDeptA() {
		return deptA;
	}
	public void setDeptA(SysDept deptA) {
		this.deptA = deptA;
	}
	public SysDept getDeptD() {
		return deptD;
	}
	public void setDeptD(SysDept deptD) {
		this.deptD = deptD;
	}
	public List<SaleProjectMemberHistory> getProjectMemberHistoryList() {
		return projectMemberHistoryList;
	}
	public void setProjectMemberHistoryList(List<SaleProjectMemberHistory> projectMemberHistoryList) {
		this.projectMemberHistoryList = projectMemberHistoryList;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Integer getCreateUserId() {
		return createUserId;
	}
	public void setCreateUserId(Integer createUserId) {
		this.createUserId = createUserId;
	}
	public SysUser getAlteredPerson() {
		return alteredPerson;
	}
	public void setAlteredPerson(SysUser alteredPerson) {
		this.alteredPerson = alteredPerson;
	}
		
}