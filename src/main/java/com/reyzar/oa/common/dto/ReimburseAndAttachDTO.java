package com.reyzar.oa.common.dto;

import com.reyzar.oa.domain.FinReimburseAttach;

public class ReimburseAndAttachDTO extends FinReimburseAttach {

    private Integer userId;    //用户ID
    private String userName;   //用户姓名
    private String deptName;    //部门名称
    private Integer deptId;    //部门ID

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
}
