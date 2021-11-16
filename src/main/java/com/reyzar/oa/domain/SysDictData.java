package com.reyzar.oa.domain; 

/**
 * 
 * @Description: 系统字典数据
 * @author Lairongfa
 * @date 2016年10月20日 上午10:51:52 
 *
 */
public class SysDictData {
	private Integer id;  //主键ID
	private Integer typeid;
	private String name;  //字典数据名称
	private String value; //字典数据值
	private String remark; //备注
	private String sort;  //排序字段
	private String isdeleted;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getTypeid() {
		return typeid;
	}
	public void setTypeid(Integer typeid) {
		this.typeid = typeid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getIsdeleted() {
		return isdeleted;
	}
	public void setIsdeleted(String isdeleted) {
		this.isdeleted = isdeleted;
	}
 }
 