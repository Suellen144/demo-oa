package com.reyzar.oa.common.exception;

/** 
* @ClassName: BusinessException 
* @Description: 自定义异常处理
* @author Lin 
* @date 2016年9月28日 上午9:48:54 
*  
*/
public class BusinessException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public BusinessException() {}
	
	public BusinessException(String message) {
		super(message);
	}
	
	public BusinessException(Throwable cause) {
		super(cause);
	}
	
	public BusinessException(String message, Throwable cause) {
		super(message, cause);
	}
}
