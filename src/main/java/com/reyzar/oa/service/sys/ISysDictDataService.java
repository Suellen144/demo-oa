package com.reyzar.oa.service.sys;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.domain.SysDictType;

public interface ISysDictDataService {
	
	public List<SysDictData> findAll();
	
	public Page<SysDictData> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public SysDictData findById(Integer id);
	
	public SysDictData findByTypeId(Integer TypeId);
	
	public CrudResultDTO save(SysDictData dictData);
	
	public CrudResultDTO update(SysDictData dictData);
	
	public CrudResultDTO updatebyId(Integer id);
	//根据ID删除字典数据
	public boolean deleteById(Integer id);
	//根据类型ID删除字典数据
	public boolean deleteByTypeId(Integer typeid);


}