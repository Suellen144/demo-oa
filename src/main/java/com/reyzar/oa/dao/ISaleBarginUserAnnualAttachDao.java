package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.SaleBarginUserAnnualAttach;


@MyBatisDao
public interface ISaleBarginUserAnnualAttachDao {
	
	public List<SaleBarginUserAnnualAttach> findAll();
	
	public SaleBarginUserAnnualAttach findById(Integer id);
	
	public void save(SaleBarginUserAnnualAttach saleBarginUserAnnualAttach);

	public void saveList(List<SaleBarginUserAnnualAttach> SaleBarginUserAnnualAttachList);

	public void update(SaleBarginUserAnnualAttach saleBarginUserAnnualAttach);

	public void updateList(List<SaleBarginUserAnnualAttach> SaleBarginUserAnnualAttachList);

	public void deleteById(Integer id);

	public List<SaleBarginUserAnnualAttach> findAllBySale();

	public List<SaleBarginUserAnnualAttach> findByAnnualId(Integer id);


}