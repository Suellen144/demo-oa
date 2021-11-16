package com.reyzar.oa.common.dto;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 用来接收财务统计 合同统计的 搜索条件
 */
public class StatisticsBarginDTO {
    //开始时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date beginDate;
    //结束时间
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date endDate;
//    /**是否需要按照项目遍历*/
//    private String whetherSelectProject;
    /**项目ID*/
    private Integer projectId;
    /**合同ID*/
    private String barginId;
    /**所属公司*/
    private String[] payCompany;
    /**合同类型*/
    private String[] barginType;


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

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getBarginId() {
        return barginId;
    }

    public void setBarginId(String barginId) {
        this.barginId = barginId;
    }

//    public String getWhetherSelectProject() {
//        return whetherSelectProject;
//    }
//
//    public void setWhetherSelectProject(String whetherSelectProject) {
//        this.whetherSelectProject = whetherSelectProject;
//    }

    public String[] getPayCompany() {
        return payCompany;
    }

    public void setPayCompany(String[] payCompany) {
        this.payCompany = payCompany;
    }

    public String[] getBarginType() {
        return barginType;
    }

    public void setBarginType(String[] barginType) {
        this.barginType = barginType;
    }
}
