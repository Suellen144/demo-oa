package com.reyzar.oa.domain; 

import java.util.List;

/**
 * 
 * @Description: 系统字典类型
 * @author Lairongfa
 * @date 2016年10月20日 上午10:45:18 
 *
 */
public class SysDictType {
	private Integer id;   //字典ID
	private String name;  //字典名称
	private String remark ; //字典备注
	private Integer parentId; //字典类型父ID
	
	public Integer getId() {
		return id;
	}
	
	public Integer getParentId() {
		return parentId;
	}

	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}


	

}
 