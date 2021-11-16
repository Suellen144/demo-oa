package com.reyzar.oa.domain;

import java.lang.Integer;

@SuppressWarnings("serial")
public class SysUserPosition extends BaseEntity {

	private Integer userId; // 用户ID
	private Integer positionId; // 职位ID
	
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public Integer getPositionId() {
		return positionId;
	}
	public void setPositionId(Integer positionId) {
		this.positionId = positionId;
	}

}