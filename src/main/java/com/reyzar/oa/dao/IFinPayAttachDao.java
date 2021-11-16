package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.domain.SingleDetail;
import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinPayAttach;


@MyBatisDao
public interface IFinPayAttachDao {
	
	public List<FinPayAttach> findAll();
	
	public List<FinPayAttach> findByPayId(Integer payId);
	
	public FinPayAttach findById(Integer id);
	
	public void save(FinPayAttach finPayAttach);
	
	public void insertAll(List<FinPayAttach> payAttachList);
	
	public void update(FinPayAttach finCollectionAttach);
	
	public void batchUpdate(@Param(value="payAttachList") List<FinPayAttach> payAttachList);
	
	public void deleteById(Integer id);
	
	public void deleteByPayId(Integer payId);
	
	public void deleteByIdList(List<Integer> idList);

	public List<FinPayAttach> findByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<SingleDetail> findCollectionByIdList(List<String> collectionMainId);
	
	public List<SingleDetail> findPayByProjectId(int projectId);
}