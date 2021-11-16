package com.reyzar.oa.common.util;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;
/**
 * 
 * @author LWY
 *
 */
@SuppressWarnings("rawtypes")
public class JsonResult implements Serializable{
	//TODO 泛型修改,json优化
	private static final long serialVersionUID = 5239476777142110705L;
	private int total = 0 ;
	@JsonManagedReference
	private List rows = new ArrayList();
	@JsonManagedReference
	private List ex_rows = new ArrayList();
	private String msg;
	private String msg2;
	private String error = "0";
	
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public List getRows() {
		return rows;
	}
	public void setRows(List rows) {
		this.rows = rows;
	}
	public List getEx_rows() {
		return ex_rows;
	}
	public void setEx_rows(List ex_rows) {
		this.ex_rows = ex_rows;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getMsg2() {
		return msg2;
	}
	public void setMsg2(String msg2) {
		this.msg2 = msg2;
	}
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
	
	
}
