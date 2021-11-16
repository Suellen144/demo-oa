package com.reyzar.oa.common.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class AdAtravelDto {
		private String userName;
		@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
		private Date beginDate;
		@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
		private Date endDate;
		public String getUserName() {
			return userName;
		}
		public void setUserName(String userName) {
			this.userName = userName;
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
		
}
