package com.reyzar.oa.common.dict.entity;

import java.util.List;

/** 
* @ClassName: DictType 
* @Description: 字典类型
* @author Lin 
* @date 2016年11月1日 下午3:34:30 
*  
*/
public class DictType {

	private Integer id; // 主键ID
	private Integer parentId; // 父ID
	private String key; // key，即是表字段的name
	private Integer value; // value，即是id
	private String remark; // 备注
	
	private List<DictData> dictDataList;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public Integer getValue() {
		return value;
	}
	public void setValue(Integer value) {
		this.value = value;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public List<DictData> getDictDataList() {
		return dictDataList;
	}
	public void setDictDataList(List<DictData> dictDataList) {
		this.dictDataList = dictDataList;
	}
	
}
