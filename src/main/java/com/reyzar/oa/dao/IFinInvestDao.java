package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinInvest;


@MyBatisDao
public interface IFinInvestDao {
	
	public List<FinInvest> findAll();
	
	public Page<FinInvest> findByPage(Map<String, Object> params);
	
	public FinInvest findById(Integer id);
	
	public void save(FinInvest finInvest);
	
	public void update(FinInvest finInvest);
	
	public void deleteById(Integer id);
}