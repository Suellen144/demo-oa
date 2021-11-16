package com.reyzar.oa.domain;

import java.lang.String;
import java.util.Date;
import java.util.List;
import java.lang.Integer;

@SuppressWarnings("serial")
public class SysDept extends BaseEntity {

	private Integer id; // 主键
	private Integer parentId; // 父部门主键
	private String nodeLinks; // 根据节点链接可以遍历从树根到当前节点
	private String name; // 部门名称
	private String code; // 部门代码
	private Integer userId; // 部门经理
	private Integer assistantId; // 部门副经理
	private Integer level; // 级别 1：公司 2：部门 3：小组
	private String alias; // 别名
	private Integer sort; //排序序号
	private String originName; // 原部门名，此属性不保存到数据库，只用于前端
	
	private List<SysDept> children;
	
	private SysUser principal;
	private SysUser assistant;
	
	private Integer generateKpi;
	
	private List<SysRole> childrenPosition;
	private Integer isAccording;//是否显示在机构设置中
	private Integer index;//序列

	private String deptPerson; //部门负责人
	private String deptPhone; //部门负责人电话
	private String deptAddress; //部门地址
	private Date createDate; //部门成立日期
	private Date deptRevokeDate; //部门撤销日期
	
	private Responsibility responsibility;//部门or 岗位 职责

	private String isCompany;

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	
	public Integer getParentId() {
		return this.parentId;
	}

	public String getNodeLinks() {
		return nodeLinks;
	}

	public void setNodeLinks(String nodeLinks) {
		this.nodeLinks = nodeLinks;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
	public String getCode() {
		return this.code;
	}
	
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	
	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public String getAlias() {
		return alias;
	}

	public void setAlias(String alias) {
		this.alias = alias;
	}

	public List<SysDept> getChildren() {
		return children;
	}

	public void setChildren(List<SysDept> children) {
		this.children = children;
	}

	public SysUser getPrincipal() {
		return principal;
	}

	public void setPrincipal(SysUser principal) {
		this.principal = principal;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public Integer getAssistantId() {
		return assistantId;
	}

	public void setAssistantId(Integer assistantId) {
		this.assistantId = assistantId;
	}

	public SysUser getAssistant() {
		return assistant;
	}

	public void setAssistant(SysUser assistant) {
		this.assistant = assistant;
	}

	public String getOriginName() {
		return originName;
	}

	public void setOriginName(String originName) {
		this.originName = originName;
	}

	public Integer getGenerateKpi() {
		return generateKpi;
	}

	public void setGenerateKpi(Integer generateKpi) {
		this.generateKpi = generateKpi;
	}

	public List<SysRole> getChildrenPosition() {
		return childrenPosition;
	}

	public void setChildrenPosition(List<SysRole> childrenPosition) {
		this.childrenPosition = childrenPosition;
	}

	public Integer getIsAccording() {
		return isAccording;
	}

	public void setIsAccording(Integer isAccording) {
		this.isAccording = isAccording;
	}

	public Integer getIndex() {
		return index;
	}

	public void setIndex(Integer index) {
		this.index = index;
	}

	public String getDeptPerson() {
		return deptPerson;
	}

	public void setDeptPerson(String deptPerson) {
		this.deptPerson = deptPerson;
	}

	public String getDeptPhone() {
		return deptPhone;
	}

	public void setDeptPhone(String deptPhone) {
		this.deptPhone = deptPhone;
	}

	public String getDeptAddress() {
		return deptAddress;
	}

	public void setDeptAddress(String deptAddress) {
		this.deptAddress = deptAddress;
	}

	@Override
	public Date getCreateDate() {
		return createDate;
	}

	@Override
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public Date getDeptRevokeDate() {
		return deptRevokeDate;
	}

	public void setDeptRevokeDate(Date deptRevokeDate) {
		this.deptRevokeDate = deptRevokeDate;
	}

	public Responsibility getResponsibility() {
		return responsibility;
	}

	public void setResponsibility(Responsibility responsibility) {
		this.responsibility = responsibility;
	}

	public String getIsCompany() {
		return isCompany;
	}

	public void setIsCompany(String isCompany) {
		this.isCompany = isCompany;
	}
}