package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.AdUserCar;


@MyBatisDao
public interface IAdUserCarDao {
	public Page<AdUserCar> findByPage(Map<String, Object> params);
	
	public List<AdUserCar> findAll();
	
	public AdUserCar findById(Integer id);
	
	public void save(AdUserCar adUserCar);
	
	public void update(AdUserCar adUserCar);
	
	public void deleteById(Integer id);
}