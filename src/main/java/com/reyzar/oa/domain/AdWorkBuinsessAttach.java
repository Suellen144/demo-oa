package com.reyzar.oa.domain;

import java.lang.Double;
import java.util.Date;
import java.lang.String;
import java.lang.Integer;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdWorkBuinsessAttach extends BaseEntity {

	private Integer id; // 主键ID
	private Integer workBusinessId; // 商务工作主ID
	private Integer responsibleUserId; // 负责人用户ID
	private String responsibleUserName;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date workDate; // 工作日期
	private Double workTime; // 工时
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date payDate; // 成功交付日期
	private String content; // 工作内容
	private SysUser	principal;
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setWorkBusinessId(Integer workBusinessId) {
		this.workBusinessId = workBusinessId;
	}
	
	public Integer getWorkBusinessId() {
		return this.workBusinessId;
	}
	
	public void setResponsibleUserId(Integer responsibleUserId) {
		this.responsibleUserId = responsibleUserId;
	}
	
	public Integer getResponsibleUserId() {
		return this.responsibleUserId;
	}
	
	public void setWorkDate(Date workDate) {
		this.workDate = workDate;
	}
	
	public Date getWorkDate() {
		return this.workDate;
	}
	
	public void setWorkTime(Double workTime) {
		this.workTime = workTime;
	}
	
	public Double getWorkTime() {
		return this.workTime;
	}
	
	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	
	public Date getPayDate() {
		return this.payDate;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public String getContent() {
		return this.content;
	}

	public SysUser getPrincipal() {
		return principal;
	}

	public void setPrincipal(SysUser principal) {
		this.principal = principal;
	}

	public String getResponsibleUserName() {
		return responsibleUserName;
	}

	public void setResponsibleUserName(String responsibleUserName) {
		this.responsibleUserName = responsibleUserName;
	}
	
}