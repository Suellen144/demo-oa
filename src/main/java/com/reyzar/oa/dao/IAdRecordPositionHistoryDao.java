package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.AdRecordPositionHistory;


@MyBatisDao
public interface IAdRecordPositionHistoryDao {
	
	public List<AdRecordPositionHistory> findAll();
	
	public AdRecordPositionHistory findById(Integer id);
	
	public void save(AdRecordPositionHistory adRecordPositionHistory);
	
	public void update(AdRecordPositionHistory adRecordPositionHistory);
	
	public void deleteById(Integer id);

	public List<AdRecordPositionHistory> findByUserId(Integer userId);

	public void deleteByIds(List<Integer> ids);

	public List<AdRecordPositionHistory> findActivePosition(Integer userId);
}