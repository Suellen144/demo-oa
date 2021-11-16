package com.reyzar.oa.common.dto;

/** 
* @ClassName: CrudresultDTO 
* @Description: 对DB操作返回状态的结构
* @author Lin 
* @date 2016年6月4日 上午11:52:00 
*  
*/
public class CrudResultDTO {
	
	public static int SUCCESS = 1;
	public static int FAILED = 0;
	public static int EXCEPTION = -1;
	
	private int code;
	private Object result;
	
	public CrudResultDTO() {}
	
	public CrudResultDTO(int code, Object result) {
		super();
		this.code = code;
		this.result = result;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public Object getResult() {
		return result;
	}

	public void setResult(Object result) {
		this.result = result;
	}

	@Override
	public String toString() {
		return "CrudResultDTO [code=" + code + ", result=" + result + "]";
	}
	
}
