package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.domain.FinCommonPayAttach;
import com.reyzar.oa.domain.SingleDetail;


@MyBatisDao
public interface IFinCommonPayAttachDao {
	
	public List<FinCommonPayAttach> findAll();
	
	public FinCommonPayAttach findById(Integer id);
	
	public void save(FinCommonPayAttach finCommonPayAttach);
	
	public void update(FinCommonPayAttach finCommonPayAttach);
	
	public void deleteById(Integer id);

	public void deleteByCommonPayId(Integer id);

	public List<FinCommonPayAttach> findByCommonId(Integer id);

	public void insertAll(List<FinCommonPayAttach> commonPayAttachs);

	public void batchUpdate(List<FinCommonPayAttach> updateList);

	public void deleteByIdList(List<Integer> delList);

	public List<FinCommonPayAttach> findByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<SingleDetail> findCommonPayByIdList(List<String> commonMainId);
	
	public List<SingleDetail> findCommonPayByProjectId(int projectId);
	
	public List<FinCommonPayAttach> findFinCommonPayAttach(StatisticsFromPageDTO statisticsFromPageDTO);
	
}