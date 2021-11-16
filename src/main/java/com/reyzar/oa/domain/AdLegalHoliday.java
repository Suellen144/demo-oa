package com.reyzar.oa.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class AdLegalHoliday extends BaseEntity{

	private Integer id;
	private String name;
	private String dateBelongs;//假期所属月份
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date startDate;//开始时间
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date endDate;//结束日期
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date legal;//开始时间
	private Integer numberDays;//放假天数
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date beforeLeave;//假前加班
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date afterLeave;//假后加班
	private String fitPeople;//适用人群
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getDateBelongs() {
		return dateBelongs;
	}
	public void setDateBelongs(String dateBelongs) {
		this.dateBelongs = dateBelongs;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Integer getNumberDays() {
		return numberDays;
	}
	public void setNumberDays(Integer numberDays) {
		this.numberDays = numberDays;
	}
	public Date getBeforeLeave() {
		return beforeLeave;
	}
	public void setBeforeLeave(Date beforeLeave) {
		this.beforeLeave = beforeLeave;
	}
	public Date getAfterLeave() {
		return afterLeave;
	}
	public void setAfterLeave(Date afterLeave) {
		this.afterLeave = afterLeave;
	}
	public String getFitPeople() {
		return fitPeople;
	}
	public void setFitPeople(String fitPeople) {
		this.fitPeople = fitPeople;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getLegal() {
		return legal;
	}
	public void setLegal(Date legal) {
		this.legal = legal;
	}
	

}
