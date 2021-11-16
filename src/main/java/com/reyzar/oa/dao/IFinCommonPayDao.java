package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.FinCommonPay;


@MyBatisDao
public interface IFinCommonPayDao {
	
	public List<FinCommonPay> findAll();
	
	public FinCommonPay findById(Integer id);
	
	public void save(FinCommonPay finCommonPay);
	
	public void update(FinCommonPay finCommonPay);
	
	public void deleteById(Integer id);

	public Page<FinCommonPay> findByPage(Map<String, Object> params);
}