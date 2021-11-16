package com.reyzar.oa.common.dict.entity;

/** 
* @ClassName: DictData 
* @Description: 字典数据
* @author Lin 
* @date 2016年11月1日 下午3:37:55 
*  
*/
public class DictData {

	private Integer id; // 主键ID
	private Integer typeValue; // 类型ID，表字段type_id
	private String key; // key，即是表字段的name
	private String value; // 字段数据值
	private String remark; // 备注
	private String isdeleted;
	
	private DictType dictType;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getTypeValue() {
		return typeValue;
	}

	public void setTypeValue(Integer typeValue) {
		this.typeValue = typeValue;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
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

	public DictType getDictType() {
		return dictType;
	}

	public void setDictType(DictType dictType) {
		this.dictType = dictType;
	}

	public String getIsdeleted() {
		return isdeleted;
	}

	public void setIsdeleted(String isdeleted) {
		this.isdeleted = isdeleted;
	}
	
}
