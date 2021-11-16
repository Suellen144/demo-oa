package com.reyzar.oa.service.sys;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.domain.SysDictType;

public interface ISysDictTypeService {
	
	public List<SysDictType> findAll();
	
	public SysDictType findById(Integer id);

	public CrudResultDTO deleteById(Integer id);
	
	public List<Map<String,Object>> getTypeList(String root);

	public CrudResultDTO save(SysDictType dictType);
	
}