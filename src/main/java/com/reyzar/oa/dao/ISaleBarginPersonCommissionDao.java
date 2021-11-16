package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.SaleBarginPersonCommission;


@MyBatisDao
public interface ISaleBarginPersonCommissionDao {
	
	public List<SaleBarginPersonCommission> findAll();
	
	public SaleBarginPersonCommission findById(Integer id);
	
	public void save(SaleBarginPersonCommission saleBarginPersonCommission);
	
	public void update(SaleBarginPersonCommission saleBarginPersonCommission);
	
	public void deleteById(Integer id);
}