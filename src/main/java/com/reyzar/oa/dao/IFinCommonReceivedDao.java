package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.FinCommonReceived;


@MyBatisDao
public interface IFinCommonReceivedDao {
	
	public List<FinCommonReceived> findAll();
	
	public FinCommonReceived findById(Integer id);
	
	public void save(FinCommonReceived finCommonReceived);
	
	public void update(FinCommonReceived finCommonReceived);
	
	public void deleteById(Integer id);

	public Page<FinCommonReceived> findByPage(Map<String, Object> params);
}