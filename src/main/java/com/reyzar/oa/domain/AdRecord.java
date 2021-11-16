package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
* @Description: 个人档案
* @author zhouShaoFeng
* @date 2016年7月5日 上午9:43:41 
*
 */
public class AdRecord extends BaseEntity{

	private static final long serialVersionUID = 1L;
	
	private Integer id;//id
	private String name;//姓名
	private Integer userId; //用户主键ID
	private Integer deptId;
	private String sex;//性别: 女,男
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date birthday;//生日
	private String education;//文化程度
	private String major;//专业
	private String majorName;//专业技术职称
	private String politicsStatus;//政治面貌
	private String maritalStatus;//婚姻状态
	private String nation;//民族
	private Integer height;//身高
	private Integer weight;//体重
	private String phone;//电话
	private String emergencyPerson;//紧急联络人
	private String emergencyRelation;//紧急联络人关系
	private String emergencyPhone;//紧急联络人电话
	private String idcard;//身份证
	private String idcardAddress;//身份证地址
	private String qq;//QQ
	private String specialty;//特长技能
	private String householdAddress;//户口所在地
	private String email;//邮箱
	private String householdState;//户口性质
	private String home;//现住址
	private String postcode;//邮编
	private String photo; //档案照片
	private String dept; // 所属部门
	private String deptName; // 部门名，不做表字段映射，只是保存数据
	private String salary; //正式薪酬
	private Double probationsalary; //试用薪酬
	private String position;//职位
	private Integer entrystatus; //入职状态
	private String score;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date entryTime;//入职时间
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date leaveTime;//离职时间
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date becomeDate;//转正时间
	private Integer beforeWarnDay;//转正提前提醒天数
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date workBeginDate;//合同开始时间
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date workEndDate;//合同结束时间
	private String unlimited;//1：合同结束时间无固定 
	private String school;//毕业院校
	private String isencryption;//加密状态
	private Integer number;//员工编号
	private String bankCard;//银行卡号
	private String bank;//开户银行
	private String company;//所属公司
	private String projectTeam;//项目组
	
	private List<AdArbeitsvertrag> arbeitsvertrags;//劳动签约记录
	private List<AdCertificate> certificates;//证书|荣誉
	private List<AdEducation> educations;//教育背景
	private List<AdJobRecord> jobRecords;//以往工作记录
	private List<AdPostAppointment> postAppointments;//岗位任免记录
	private List<AdPayAdjustment> payAdjustments; //薪酬调整记录
	private SysUser sysUser;
	
	public String getPhoto() {
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}
	public Date getLeaveTime() {
		return leaveTime;
	}
	public void setLeaveTime(Date leaveTime) {
		this.leaveTime = leaveTime;
	}
	
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
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public Date getBirthday() {
		return birthday;
	}
	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}
	public String getEducation() {
		return education;
	}
	public void setEducation(String education) {
		this.education = education;
	}
	public String getMajor() {
		return major;
	}
	public void setMajor(String major) {
		this.major = major;
	}
	public String getMajorName() {
		return majorName;
	}
	public void setMajorName(String majorName) {
		this.majorName = majorName;
	}
	public String getPoliticsStatus() {
		return politicsStatus;
	}
	public void setPoliticsStatus(String politicsStatus) {
		this.politicsStatus = politicsStatus;
	}
	public String getMaritalStatus() {
		return maritalStatus;
	}
	public void setMaritalStatus(String maritalStatus) {
		this.maritalStatus = maritalStatus;
	}
	public String getNation() {
		return nation;
	}
	public void setNation(String nation) {
		this.nation = nation;
	}
	public Integer getHeight() {
		return height;
	}
	public void setHeight(Integer height) {
		this.height = height;
	}
	public Integer getWeight() {
		return weight;
	}
	public void setWeight(Integer weight) {
		this.weight = weight;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmergencyPerson() {
		return emergencyPerson;
	}
	public void setEmergencyPerson(String emergencyPerson) {
		this.emergencyPerson = emergencyPerson;
	}
	public String getEmergencyRelation() {
		return emergencyRelation;
	}
	public void setEmergencyRelation(String emergencyRelation) {
		this.emergencyRelation = emergencyRelation;
	}
	public String getEmergencyPhone() {
		return emergencyPhone;
	}
	public void setEmergencyPhone(String emergencyPhone) {
		this.emergencyPhone = emergencyPhone;
	}
	public String getIdcard() {
		return idcard;
	}
	public void setIdcard(String idcard) {
		this.idcard = idcard;
	}
	public String getIdcardAddress() {
		return idcardAddress;
	}
	public void setIdcardAddress(String idcardAddress) {
		this.idcardAddress = idcardAddress;
	}
	public String getQq() {
		return qq;
	}
	public void setQq(String qq) {
		this.qq = qq;
	}
	public String getSpecialty() {
		return specialty;
	}
	public void setSpecialty(String specialty) {
		this.specialty = specialty;
	}
	public String getHouseholdAddress() {
		return householdAddress;
	}
	public void setHouseholdAddress(String householdAddress) {
		this.householdAddress = householdAddress;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getHouseholdState() {
		return householdState;
	}
	public void setHouseholdState(String householdState) {
		this.householdState = householdState;
	}
	public String getHome() {
		return home;
	}
	public void setHome(String home) {
		this.home = home;
	}
	public String getPostcode() {
		return postcode;
	}
	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}
	public String getDept() {
		return dept;
	}
	public void setDept(String dept) {
		this.dept = dept;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public Date getEntryTime() {
		return entryTime;
	}
	public void setEntryTime(Date entryTime) {
		this.entryTime = entryTime;
	}
	public Date getBecomeDate() {
		return becomeDate;
	}
	public void setBecomeDate(Date becomeDate) {
		this.becomeDate = becomeDate;
	}
	public Integer getBeforeWarnDay() {
		return beforeWarnDay;
	}
	public void setBeforeWarnDay(Integer beforeWarnDay) {
		this.beforeWarnDay = beforeWarnDay;
	}
	public Date getWorkBeginDate() {
		return workBeginDate;
	}
	public void setWorkBeginDate(Date workBeginDate) {
		this.workBeginDate = workBeginDate;
	}
	public Date getWorkEndDate() {
		return workEndDate;
	}
	public void setWorkEndDate(Date workEndDate) {
		this.workEndDate = workEndDate;
	}
	
	public String getUnlimited() {
		return unlimited;
	}
	public void setUnlimited(String unlimited) {
		this.unlimited = unlimited;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getSchool() {
		return school;
	}
	public void setSchool(String school) {
		this.school = school;
	}
	public String getSalary() {
		return salary;
	}
	public void setSalary(String salary) {
		this.salary = salary;
	}
	public Double getProbationsalary() {
		return probationsalary;
	}
	public void setProbationsalary(Double probationsalary) {
		this.probationsalary = probationsalary;
	}
	public Integer getEntrystatus() {
		return entrystatus;
	}
	public void setEntrystatus(Integer entrystatus) {
		this.entrystatus = entrystatus;
	}
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String getIsencryption() {
		return isencryption;
	}
	public void setIsencryption(String isencryption) {
		this.isencryption = isencryption;
	}
	public String getScore() {
		return score;
	}
	public void setScore(String score) {
		this.score = score;
	}

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}
	
	
	public Integer getNumber() {
		return number;
	}
	public void setNumber(Integer number) {
		this.number = number;
	}
	public String getBankCard() {
		return bankCard;
	}
	public void setBankCard(String bankCard) {
		this.bankCard = bankCard;
	}
	public String getBank() {
		return bank;
	}
	public void setBank(String bank) {
		this.bank = bank;
	}
	public List<AdArbeitsvertrag> getArbeitsvertrags() {
		return arbeitsvertrags;
	}
	public void setArbeitsvertrags(List<AdArbeitsvertrag> arbeitsvertrags) {
		this.arbeitsvertrags = arbeitsvertrags;
	}
	public List<AdCertificate> getCertificates() {
		return certificates;
	}
	public void setCertificates(List<AdCertificate> certificates) {
		this.certificates = certificates;
	}
	public List<AdEducation> getEducations() {
		return educations;
	}
	public void setEducations(List<AdEducation> educations) {
		this.educations = educations;
	}
	public List<AdJobRecord> getJobRecords() {
		return jobRecords;
	}
	public void setJobRecords(List<AdJobRecord> jobRecords) {
		this.jobRecords = jobRecords;
	}
	public List<AdPostAppointment> getPostAppointments() {
		return postAppointments;
	}
	public void setPostAppointments(List<AdPostAppointment> postAppointments) {
		this.postAppointments = postAppointments;
	}
	public List<AdPayAdjustment> getPayAdjustments() {
		return payAdjustments;
	}
	public void setPayAdjustments(List<AdPayAdjustment> payAdjustments) {
		this.payAdjustments = payAdjustments;
	}
	public String getCompany() {
		return company;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public String getProjectTeam() {
		return projectTeam;
	}
	public void setProjectTeam(String projectTeam) {
		this.projectTeam = projectTeam;
	}
	public SysUser getSysUser() {
		return sysUser;
	}
	public void setSysUser(SysUser sysUser) {
		this.sysUser = sysUser;
	}
	
}
