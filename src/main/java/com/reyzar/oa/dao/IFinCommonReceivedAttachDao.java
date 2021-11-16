package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.domain.FinCommonReceivedAttach;
import com.reyzar.oa.domain.SingleDetail;


@MyBatisDao
public interface IFinCommonReceivedAttachDao {
	
	public List<FinCommonReceivedAttach> findAll();
	
	public FinCommonReceivedAttach findById(Integer id);
	
	public void save(FinCommonReceivedAttach finCommonReceivedAttach);
	
	public void update(FinCommonReceivedAttach finCommonReceivedAttach);
	
	public void deleteById(Integer id);

	public void deleteByCommonReceivedId(Integer id);

	public List<FinCommonReceivedAttach> findByReceivedId(Integer id);

	public void insertAll(List<FinCommonReceivedAttach> saveList);

	public void batchUpdate(List<FinCommonReceivedAttach> updateList);

	public void deleteByIdList(List<Integer> delList);

	public List<FinCommonReceivedAttach> findByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<SingleDetail> findCommonReceivedByIdList(List<String> commonReceivedMainId);
}