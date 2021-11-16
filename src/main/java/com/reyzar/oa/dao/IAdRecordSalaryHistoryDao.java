package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.AdRecordSalaryHistory;


@MyBatisDao
public interface IAdRecordSalaryHistoryDao {
	
	public List<AdRecordSalaryHistory> findAll();
	
	public AdRecordSalaryHistory findById(Integer id);

	public AdRecordSalaryHistory findByOne(Integer userId);
	
	public void save(AdRecordSalaryHistory adRecordSalaryHistory);
	
	public void update(AdRecordSalaryHistory adRecordSalaryHistory);
	
	public void deleteById(Integer id);

	public List<AdRecordSalaryHistory> findByUserId(Integer userId);

	public void deleteByIds(List<Integer> ids);

	public AdRecordSalaryHistory findNewSalary(Integer userId);

	public Page<AdRecordSalaryHistory> findByPage(Map<String, Object> params);
	
	
	public void batchUpdate(@Param(value="recordSalaryHistories") List<AdRecordSalaryHistory> recordSalaryHistories);
}