package com.reyzar.oa.common.dto;

import java.util.Date;

/** 
* @ClassName: FileUploadDTO 
* @Description: 上传文件后的结果对象，封装一些文件数据给客户端
* @author Lin 
* @date 2016年8月26日 上午11:42:50 
*  
*/
public class FileUploadDTO {

	private CrudResultDTO execResult; // 执行结果标志对象。如果是成功的，以下其他属性才有效
	private String originName; // 原始的文件名
	private String name; // 上传后的文件名 
	private Long size; // 文件大小，以 byte 为单位
	private String path; // 上传后的路径
	private String suffix; // 文件后缀（文件类型）
	private Date uploadDate; // 上传时间
	
	public CrudResultDTO getExecResult() {
		return execResult;
	}
	public void setExecResult(CrudResultDTO execResult) {
		this.execResult = execResult;
	}
	public String getOriginName() {
		return originName;
	}
	public void setOriginName(String originName) {
		this.originName = originName;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Long getSize() {
		return size;
	}
	public void setSize(Long size) {
		this.size = size;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getSuffix() {
		return suffix;
	}
	public void setSuffix(String suffix) {
		this.suffix = suffix;
	}
	public Date getUploadDate() {
		return uploadDate;
	}
	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
	}
	
}
