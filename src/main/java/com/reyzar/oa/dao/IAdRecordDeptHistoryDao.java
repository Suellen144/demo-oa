package com.reyzar.oa.dao;

import java.util.List;
import java.util.Set;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.AdRecordDeptHistory;


@MyBatisDao
public interface IAdRecordDeptHistoryDao {
	
	public List<AdRecordDeptHistory> findAll();
	
	public AdRecordDeptHistory findById(Integer id);
	
	public void save(AdRecordDeptHistory adRecordDeptHistory);
	
	public void update(AdRecordDeptHistory adRecordDeptHistory);
	
	public void deleteById(Integer id);

	public void insertAll(List<AdRecordDeptHistory> adRecordDeptHistories);

	public List<AdRecordDeptHistory> findByUserId(Integer userId);

	public void deleteByIds(List<Integer> ids);

	public List<AdRecordDeptHistory> findActiveDept(Integer userId);
}