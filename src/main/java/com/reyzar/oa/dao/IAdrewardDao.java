package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.Adreward;


@MyBatisDao
public interface IAdrewardDao {

	public Page<Adreward> findByPage(Map<String, Object> params);
	
	public List<Adreward> findAll();

	public List<Adreward> findByEncrypted(String encrypted);
	
	public Adreward findById(Integer id);
	
	public void save(Adreward adreward);
	
	public void update(Adreward adreward);
	
	public void deleteById(Integer id);
}