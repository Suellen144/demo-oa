package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

public class SysUser extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public int getMissStart() {
		return missStart;
	}

	public void setMissStart(int missStart) {
		this.missStart = missStart;
	}

	public Date getMissTime() {
		return missTime;
	}

	public void setMissTime(Date missTime) {
		this.missTime = missTime;
	}

	private Integer id; // 主键ID
	private String name; // 用户姓名
	private String nickname; // 用户昵称
	private String account; // 登录帐号
	private Integer deptId; // 部门主键
	private String password; // 登录密码
	private String telphone; // 联系号码
	private String mobilephone; // 手机号码
	private String email; // 邮箱
	private String qq; // QQ号码
	private String photo; // 照片
	private String inJob; // 是否在职 0：离职 1：在职
	private Date readNoticeDate;//查看公告的时间
	private String isSkip;
	private String principalName;//负责人名称
	private Integer principalId;//负责人ID
	private SysDept dept; // 所属部门
	private List<SysRole> roleList;
	private List<AdPosition> positionList;
	private List<Integer> roleidList;
	private String positionId;
	private int missStart;
	private Date missTime;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getTelphone() {
		return telphone;
	}

	public void setTelphone(String telphone) {
		this.telphone = telphone;
	}

	public String getMobilephone() {
		return mobilephone;
	}

	public void setMobilephone(String mobilephone) {
		this.mobilephone = mobilephone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getQq() {
		return qq;
	}

	public void setQq(String qq) {
		this.qq = qq;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public String getInJob() {
		return inJob;
	}

	public void setInJob(String inJob) {
		this.inJob = inJob;
	}

	public List<SysRole> getRoleList() {
		return roleList;
	}

	public void setRoleList(List<SysRole> roleList) {
		this.roleList = roleList;
	}

	public List<AdPosition> getPositionList() {
		return positionList;
	}

	public void setPositionList(List<AdPosition> positionList) {
		this.positionList = positionList;
	}

	public SysDept getDept() {
		return dept;
	}

	public void setDept(SysDept dept) {
		this.dept = dept;
	}

	public Date getReadNoticeDate() {
		return readNoticeDate;
	}

	public void setReadNoticeDate(Date readNoticeDate) {
		this.readNoticeDate = readNoticeDate;
	}

	public String getIsSkip() {
		return isSkip;
	}

	public void setIsSkip(String isSkip) {
		this.isSkip = isSkip;
	}

	public Integer getPrincipalId() {
		return principalId;
	}

	public void setPrincipalId(Integer principalId) {
		this.principalId = principalId;
	}

	public String getPrincipalName() {
		return principalName;
	}

	public void setPrincipalName(String principalName) {
		this.principalName = principalName;
	}

	public List<Integer> getRoleidList() {
		return roleidList;
	}

	public void setRoleidList(List<Integer> roleidList) {
		this.roleidList = roleidList;
	}

	public String getPositionId() {
		return positionId;
	}

	public void setPositionId(String positionId) {
		this.positionId = positionId;
	}


}