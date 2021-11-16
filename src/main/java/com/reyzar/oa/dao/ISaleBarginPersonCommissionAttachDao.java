package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.SaleBarginPersonCommissionAttach;


@MyBatisDao
public interface ISaleBarginPersonCommissionAttachDao {
	
	public List<SaleBarginPersonCommissionAttach> findAll();
	
	public SaleBarginPersonCommissionAttach findById(Integer id);

	public List<SaleBarginPersonCommissionAttach> findByCommissionId(Integer id);

	public void save(SaleBarginPersonCommissionAttach saleBarginPersonCommissionAttach);
	
	public void saveList(List<SaleBarginPersonCommissionAttach> saleBarginPersonCommissionAttachList);

	public void update(SaleBarginPersonCommissionAttach saleBarginPersonCommissionAttach);

	public void updateList(List<SaleBarginPersonCommissionAttach> saleBarginPersonCommissionAttachList);
	
	public void deleteById(Integer id);
}