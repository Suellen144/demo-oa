package com.reyzar.oa.domain;

/**
 * 系统通知，非持久化对象
 * @author zhoushaofeng
 *
 */
public class SysMessage extends BaseEntity {
	
	private Integer code;//编码，用于将来的业务扩展，暂定 1为消息通知
	private String title;//标题
	private String receiver;//接受者 
	private String content;//内容
	private String viewSrc;//查看详情跳转链接
	
	public Integer getCode() {
		return code;
	}
	public void setCode(Integer code) {
		this.code = code;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getReceiver() {
		return receiver;
	}
	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getViewSrc() {
		return viewSrc;
	}
	public void setViewSrc(String viewSrc) {
		this.viewSrc = viewSrc;
	}

}
