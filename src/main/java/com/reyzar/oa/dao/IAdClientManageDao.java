package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdClientManage;
import com.reyzar.oa.domain.SaleBarginManage;


@MyBatisDao
public interface IAdClientManageDao {
	public Page<AdClientManage> findByPage(Map<String, Object> params);
	
	public List<AdClientManage> findAll();
	
	public AdClientManage findById(Integer id);
	 
	public List<SaleBarginManage> findByProjectManageId(Integer projectManageId);
	
	public void save(AdClientManage adClientManage);
	
	public void insertAll(List<AdClientManage> adClientManageList);
	
	public void update(AdClientManage adClientManage);
	
	public void deleteById(Integer id);
}