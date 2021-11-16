package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdLeave;
import com.reyzar.oa.domain.AdOverTime;


@MyBatisDao
public interface IAdOverTimeDao {
	
	public Page<AdOverTime> findByPage(Map<String, Object> params);
	
	public List<AdOverTime> findAll();
	
	public AdOverTime findById(Integer id);
	
	public void save(AdOverTime adOverTime);
	
	public void update(AdOverTime adOverTime);
	
	public void deleteById(Integer id);
	
	public List<AdOverTime> findByParam(Map<String, Object> params);
	
	public List<AdOverTime> findAllByParam(Map<String, Object> params);
}