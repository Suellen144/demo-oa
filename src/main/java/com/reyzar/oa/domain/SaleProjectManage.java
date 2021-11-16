package com.reyzar.oa.domain;

import java.lang.String;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import java.lang.Integer;

@SuppressWarnings("serial")
public class SaleProjectManage extends BaseEntity {

	private Integer id; // 主键
	private String name; // 项目名称
	private String type; // 项目类型
	private String location; // 开发地点
	private String describe;
	private Integer userId; // 项目负责人
	private String deptIds; // 项目所属部门集合，在部门集合内的员工才可以看到该项目
	private String status;
	private SysUser principal; // 项目负责人
	private List<SysDept> deptList;
	private SysDept deptA; //申请人关联部门
	private SysDept deptD; //负责人关联部门
	private String title;

	private List<SaleBarginManage> saleBarginManageList;
	
	//项目管理模块新增字段 20190409
	private Integer applyDeptId; //申请人所属部门
	private Integer dutyDeptId; //负责人所属部门
	private Integer applicant;//申请人
	private Date submitDate;//提交时间
	private Double size ;//规模
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date projectDate ;//立项时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date projectEndDate ;//结束时间
	private Double researchCostLines ;//攻关费用额度
	private Integer applicationType ;//申请类型（1:新增申请;2:变更申请）
	private String processInstanceId ;//流程实例id
	private Integer statusNew;//当前审批环节
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date startTime; // 起始时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endTime; // 结束时间
	
	private String principalName;//导出的项目负责人名称
	private String applicantName;//导出的申请人名称
	private String applicationTypes;//导出的申请类型名称
	private String statusNews;//导出的审批环节名称
	private String submitDates;//导出的提交时间
	
	private SysUser applicantP;//申请人
	private List<SaleProjectMember> projectMemberList;
	
	private Integer isNewProject;//是否新项目管理模块创建
	private String attachName;//文件名称
	private String attachments;//附件


	private Double totalMoney;//合同金额
	private Double confirmAmount;//收入
	private Double actReimburse2;//支出
	private Double actReimburse;//攻关费用
	private String reason; //立项原因

	private Double researchCostLinesBalance; //攻关费用余额，用于 报销管理计算
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
	
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getType() {
		return this.type;
	}
	
	public void setLocation(String location) {
		this.location = location;
	}
	
	public String getLocation() {
		return this.location;
	}
	
	public String getDescribe() {
		return describe;
	}

	public void setDescribe(String describe) {
		this.describe = describe;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}

	public SysUser getPrincipal() {
		return principal;
	}

	public void setPrincipal(SysUser principal) {
		this.principal = principal;
	}

	public String getDeptIds() {
		return deptIds;
	}

	public void setDeptIds(String deptIds) {
		this.deptIds = deptIds;
	}

	public List<SysDept> getDeptList() {
		return deptList;
	}

	public void setDeptList(List<SysDept> deptList) {
		this.deptList = deptList;
	}
	
	

	public List<SaleBarginManage> getSaleBarginManageList() {
		return saleBarginManageList;
	}

	public void setSaleBarginManageList(List<SaleBarginManage> saleBarginManageList) {
		this.saleBarginManageList = saleBarginManageList;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
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

	public String getPrincipalName() {
		return principalName;
	}

	public void setPrincipalName(String principalName) {
		this.principalName = principalName;
	}

	public String getApplicantName() {
		return applicantName;
	}

	public void setApplicantName(String applicantName) {
		this.applicantName = applicantName;
	}

	public String getApplicationTypes() {
		return applicationTypes;
	}

	public void setApplicationTypes(String applicationTypes) {
		this.applicationTypes = applicationTypes;
	}

	public String getStatusNews() {
		return statusNews;
	}

	public void setStatusNews(String statusNews) {
		this.statusNews = statusNews;
	}

	public String getSubmitDates() {
		return submitDates;
	}

	public void setSubmitDates(String submitDates) {
		this.submitDates = submitDates;
	}

	public List<SaleProjectMember> getProjectMemberList() {
		return projectMemberList;
	}

	public void setProjectMemberList(List<SaleProjectMember> projectMemberList) {
		this.projectMemberList = projectMemberList;
	}

	public Integer getApplicant() {
		return applicant;
	}

	public void setApplicant(Integer applicant) {
		this.applicant = applicant;
	}

	public SysUser getApplicantP() {
		return applicantP;
	}

	public void setApplicantP(SysUser applicantP) {
		this.applicantP = applicantP;
	}

	public Integer getIsNewProject() {
		return isNewProject;
	}

	public void setIsNewProject(Integer isNewProject) {
		this.isNewProject = isNewProject;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
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

	public Double getTotalMoney() {
		return totalMoney;
	}

	public void setTotalMoney(Double totalMoney) {
		this.totalMoney = totalMoney;
	}

	public Double getConfirmAmount() {
		return confirmAmount;
	}

	public void setConfirmAmount(Double confirmAmount) {
		this.confirmAmount = confirmAmount;
	}

	public Double getActReimburse() {
		return actReimburse;
	}

	public void setActReimburse(Double actReimburse) {
		this.actReimburse = actReimburse;
	}

	public Double getActReimburse2() {
		return actReimburse2;
	}

	public void setActReimburse2(Double actReimburse2) {
		this.actReimburse2 = actReimburse2;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public Double getResearchCostLinesBalance() {
		return researchCostLinesBalance;
	}

	public void setResearchCostLinesBalance(Double researchCostLinesBalance) {
		this.researchCostLinesBalance = researchCostLinesBalance;
	}
	
}