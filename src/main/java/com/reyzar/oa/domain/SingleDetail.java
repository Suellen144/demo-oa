package com.reyzar.oa.domain;

import org.springframework.format.annotation.DateTimeFormat;


import java.util.Date;

public class SingleDetail {
    private Integer id;
    
    private Integer commonPayId;
    
    private Integer commonCollectionId;

	//姓名
    private String userName;
    //流程ID
    private String processInstanceId;
    //单号
    private String orderNo;
    //时间
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date date;
    //原因
    private String reason;
    
    //项目名称
    private String projectName;
    
    //金钱
    private Double money;
    
    //付款金额
    private Double payMoney;
    
    //付款时间
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date payDate;

    //费用类型
    private String type;
    
    private Integer typeOne;
    
    //部门名称
    private String deptName;
    
    //公司类型
    private String title;
    
    //审批环节
    private String statusName;
    
    //审批环节 1
    private String statusName1;
    
    //费用归属
    private String valueName;

    //开始时间
    private Date beginDate;
    
    //结束时间
    private Date endDate;
    
    //时间 字符串
    private String dateOne;
    
    //工作流名称
    private String actName;
    
    //总经理审批开始时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date zBeginDate;
    //总经理审批结束时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date zEndDate;
    
    //出纳审批开始时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date cBeginDate;
    //出纳审批结束时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date cEndDate;
    
    //常规收付款 的时间搜索 -- 开始时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date gBeginDate;
    //常规收付款 的时间搜索 -- 结束时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date gEndDate;
    
    //总经理审批时间 
    private String zjlEndTime;
    
    //出纳审批时间 
    private String chunaTime;
    
    //导出模块名称
    private String modular;
    
    //核算月份
    private String accountingYear;
    
    //付款月份
    private String paymentYear;
    
    //现金项目
    private String cashProject;
    
    //组别
    private String groups;
    
    //费用大类
    private String costType;
    
    //业务/付款发生时间
    private String dateTo;

    //费用归属
	private String investName;

    public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}

	public Double getPayMoney() {
		return payMoney;
	}

	public void setPayMoney(Double payMoney) {
		this.payMoney = payMoney;
	}

	public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getProcessInstanceId() {
        return processInstanceId;
    }

    public void setProcessInstanceId(String processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getCommonPayId() {
		return commonPayId;
	}

	public void setCommonPayId(Integer commonPayId) {
		this.commonPayId = commonPayId;
	}

	public Integer getCommonCollectionId() {
		return commonCollectionId;
	}

	public void setCommonCollectionId(Integer commonCollectionId) {
		this.commonCollectionId = commonCollectionId;
	}

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getStatusName() {
		return statusName;
	}

	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}

	public String getValueName() {
		return valueName;
	}

	public void setValueName(String valueName) {
		this.valueName = valueName;
	}

	public Integer getTypeOne() {
		return typeOne;
	}

	public void setTypeOne(Integer typeOne) {
		this.typeOne = typeOne;
	}

	public Date getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getDateOne() {
		return dateOne;
	}

	public void setDateOne(String dateOne) {
		this.dateOne = dateOne;
	}

	public String getActName() {
		return actName;
	}

	public void setActName(String actName) {
		this.actName = actName;
	}

	public Date getzBeginDate() {
		return zBeginDate;
	}

	public void setzBeginDate(Date zBeginDate) {
		this.zBeginDate = zBeginDate;
	}

	public Date getzEndDate() {
		return zEndDate;
	}

	public void setzEndDate(Date zEndDate) {
		this.zEndDate = zEndDate;
	}

	public Date getcBeginDate() {
		return cBeginDate;
	}

	public void setcBeginDate(Date cBeginDate) {
		this.cBeginDate = cBeginDate;
	}

	public Date getcEndDate() {
		return cEndDate;
	}

	public void setcEndDate(Date cEndDate) {
		this.cEndDate = cEndDate;
	}

	public String getZjlEndTime() {
		return zjlEndTime;
	}

	public void setZjlEndTime(String zjlEndTime) {
		this.zjlEndTime = zjlEndTime;
	}

	public String getModular() {
		return modular;
	}

	public void setModular(String modular) {
		this.modular = modular;
	}

	public String getStatusName1() {
		return statusName1;
	}

	public void setStatusName1(String statusName1) {
		this.statusName1 = statusName1;
	}

	public String getAccountingYear() {
		return accountingYear;
	}

	public void setAccountingYear(String accountingYear) {
		this.accountingYear = accountingYear;
	}

	public String getPaymentYear() {
		return paymentYear;
	}

	public void setPaymentYear(String paymentYear) {
		this.paymentYear = paymentYear;
	}

	public String getCashProject() {
		return cashProject;
	}

	public void setCashProject(String cashProject) {
		this.cashProject = cashProject;
	}

	public String getGroups() {
		return groups;
	}

	public void setGroups(String groups) {
		this.groups = groups;
	}

	public String getCostType() {
		return costType;
	}

	public void setCostType(String costType) {
		this.costType = costType;
	}

	public String getDateTo() {
		return dateTo;
	}

	public void setDateTo(String dateTo) {
		this.dateTo = dateTo;
	}

	public String getInvestName() {
		return investName;
	}

	public void setInvestName(String investName) {
		this.investName = investName;
	}

	public Date getgBeginDate() {
		return gBeginDate;
	}

	public void setgBeginDate(Date gBeginDate) {
		this.gBeginDate = gBeginDate;
	}

	public Date getgEndDate() {
		return gEndDate;
	}

	public void setgEndDate(Date gEndDate) {
		this.gEndDate = gEndDate;
	}

	public String getChunaTime() {
		return chunaTime;
	}

	public void setChunaTime(String chunaTime) {
		this.chunaTime = chunaTime;
	}
	
}
