package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdCertificate  extends BaseEntity{

	private Integer id;
	private Integer recordId;
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date date;			//日期
	private String issuingUnit; //颁发单位
	private String honor;		//证书/荣誉名称
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date validity; 		//有效期
	private String isValidity; 		//是否有效期
	private String scannings;   //证书扫描件上传
	private String scanningName;//文件名
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getRecordId() {
		return recordId;
	}
	public void setRecordId(Integer recordId) {
		this.recordId = recordId;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public String getIssuingUnit() {
		return issuingUnit;
	}
	public void setIssuingUnit(String issuingUnit) {
		this.issuingUnit = issuingUnit;
	}
	public String getHonor() {
		return honor;
	}
	public void setHonor(String honor) {
		this.honor = honor;
	}
	public Date getValidity() {
		return validity;
	}
	public void setValidity(Date validity) {
		this.validity = validity;
	}
	
	public String getScannings() {
		return scannings;
	}
	public void setScannings(String scannings) {
		this.scannings = scannings;
	}
	public String getScanningName() {
		return scanningName;
	}
	public void setScanningName(String scanningName) {
		this.scanningName = scanningName;
	}
	public String getIsValidity() {
		return isValidity;
	}
	public void setIsValidity(String isValidity) {
		this.isValidity = isValidity;
	}
	
}
