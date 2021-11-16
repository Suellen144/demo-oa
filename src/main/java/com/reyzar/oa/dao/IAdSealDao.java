package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdSeal;


@MyBatisDao
public interface IAdSealDao {
	
	public Page<AdSeal> findByPage(Map<String, Object> params);
	
	public List<AdSeal> findAll();
	
	public AdSeal findById(Integer id);
	
	public void save(AdSeal adSeal);
	
	public void update(AdSeal adSeal);
	
	public void deleteById(Integer id);
}