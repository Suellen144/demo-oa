package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.domain.SysDictType;

@MyBatisDao
public interface ISysDictTypeDao {
	
	public List<SysDictType> findAll();
	 
	public Page<SysDictType> findByPage(Map<String, Object> params);
	
	public SysDictType findById(Integer id);
	
	public void save(SysDictType dictType);
	
	public void update(SysDictType dictType);
	
	public void delete(Integer id);
	

}