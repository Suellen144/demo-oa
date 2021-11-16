package com.reyzar.oa.common.dto;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;
/**
 * 用来接收  财务统计  的搜索条件
 */
public class StatisticsFromPageDTO {
	
    /**存放收款表的Id*/
    private String collectionMainId;
    /**存放常规收款的Id*/
    private String commonReceivedMainId;
    /**付款表中涉及的ID*/
    private String finPayMainId;
    /**通用报销表中涉及的ID*/
    private String reimburseMainId;
    /**通用报销表中涉及的ID (用于储存差旅报销中攻关费和业务费数据)*/
    private String reimburseOrTravelMainId;
    /**差旅报销表中涉及的ID*/
    private String travelMainId;
    /**常规付款表中涉及的ID*/
    private String commonPayMainId;
    /**是否需要按照项目遍历*/
    private String whetherSelectProject;
    /** 费用归属的ID*/
    private String investId;
    /** 费用归属名称*/
    private String investValue;
    //开始时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date beginDate;
    //结束时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date endDate;
    /**项目ID*/
    private Integer projectId;
    /**项目名称*/
    private String projectName;
    /**公司value*/
    private String payCompany;
    /**公司名称*/
    private String companyName;
    /**部门名称*/
    private String deptName;
    /**部门ID*/
    private Integer deptId;
    /**收入性质*/
    private String costProperty;
    /**收入名称*/
    private String costPropertyName;
    /**付款费用性质*/
    private String payType;
    /**用户ID*/
    private Integer userId;
    /**用户姓名*/
    private String userName;
    /**通用报销类别*/
    private String generalReimbursType;
    /** 合同*/
    private Integer barginId;
    /** 合同名称 */
    private String barginName;
    /**金额*/

    private Double money;
    /**输出类型判断
     *  1:通用报销（包含了差旅报销）
     *  2：付款
     *  3：常规付款
     *  4：常规收入
     *  */
    private String type;
    private String typeName;
    /**审批状态*/
    private String status;
    
    /** 审批环节 */
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

	public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
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

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public Integer getDeptId() {
        return deptId;
    }

    public void setDeptId(Integer deptId) {
        this.deptId = deptId;
    }

    public String getCostProperty() {
        return costProperty;
    }

    public void setCostProperty(String costProperty) {
        this.costProperty = costProperty;
    }

    public String getPayType() {
        return payType;
    }

    public void setPayType(String payType) {
        this.payType = payType;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getGeneralReimbursType() {
        return generalReimbursType;
    }

    public void setGeneralReimbursType(String generalReimbursType) {
        this.generalReimbursType = generalReimbursType;
    }

    public Integer getBarginId() {
        return barginId;
    }

    public void setBarginId(Integer barginId) {
        this.barginId = barginId;
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
    public String getBarginName() {
        return barginName;
    }

    public void setBarginName(String barginName) {
        this.barginName = barginName;
    }

    public String getCostPropertyName() {
        return costPropertyName;
    }

    public void setCostPropertyName(String costPropertyName) {
        this.costPropertyName = costPropertyName;
    }

    public String getPayCompany() {
        return payCompany;
    }

    public void setPayCompany(String payCompany) {
        this.payCompany = payCompany;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getFinPayMainId() {
        return finPayMainId;
    }

    public void setFinPayMainId(String finPayMainId) {
        this.finPayMainId = finPayMainId;
    }

    public String getReimburseMainId() {
        return reimburseMainId;
    }

    public void setReimburseMainId(String reimburseMainId) {
        this.reimburseMainId = reimburseMainId;
    }

    public String getTravelMainId() {
        return travelMainId;
    }

    public void setTravelMainId(String travelMainId) {
        this.travelMainId = travelMainId;
    }

    public String getCommonPayMainId() {
        return commonPayMainId;
    }

    public void setCommonPayMainId(String commonPayMainId) {
        this.commonPayMainId = commonPayMainId;
    }

    public String getCommonReceivedMainId() {
        return commonReceivedMainId;
    }

    public void setCommonReceivedMainId(String commonReceivedMainId) {
        this.commonReceivedMainId = commonReceivedMainId;
    }

    public String getWhetherSelectProject() {
        return whetherSelectProject;
    }

    public void setWhetherSelectProject(String whetherSelectProject) {
        this.whetherSelectProject = whetherSelectProject;
    }

    public String getInvestId() {
        return investId;
    }

    public void setInvestId(String investId) {
        this.investId = investId;
    }

    public String getInvestValue() {
        return investValue;
    }

    public void setInvestValue(String investValue) {
        this.investValue = investValue;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getCollectionMainId() {
        return collectionMainId;
    }

    public void setCollectionMainId(String collectionMainId) {
        this.collectionMainId = collectionMainId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

	public String getActName() {
		return actName;
	}

	public void setActName(String actName) {
		this.actName = actName;
	}

	public String getReimburseOrTravelMainId() {
		return reimburseOrTravelMainId;
	}

	public void setReimburseOrTravelMainId(String reimburseOrTravelMainId) {
		this.reimburseOrTravelMainId = reimburseOrTravelMainId;
	}
	
}
