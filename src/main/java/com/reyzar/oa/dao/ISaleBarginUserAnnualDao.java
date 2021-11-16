package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.SaleBarginUserAnnual;


@MyBatisDao
public interface ISaleBarginUserAnnualDao {
	
	public List<SaleBarginUserAnnual> findAll();
	
	public SaleBarginUserAnnual findById(Integer id);
	
	public void save(SaleBarginUserAnnual saleBarginUserAnnual);
	
	public void update(SaleBarginUserAnnual saleBarginUserAnnual);
	
	public void deleteById(Integer id);

	public Page<SaleBarginUserAnnual> findByPage(Map<String, Object> params);
}