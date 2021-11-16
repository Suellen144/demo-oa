package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.AdSalary;


@MyBatisDao
public interface IAdSalaryDao {
	
	public Page<AdSalary> findByPage(Map<String, Object> params);
	
	public List<AdSalary> findAll();
	
	public List<AdSalary> findByEncrypted(String encrypted);
	
	public AdSalary findById(Integer id);
	
	public void save(AdSalary adSalary);
	
	public void update(AdSalary adSalary);
	
	public void deleteById(Integer id);

	public List<AdRecord> workingStateselectVal();

}