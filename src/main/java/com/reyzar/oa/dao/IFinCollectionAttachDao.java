package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.SingleDetail;
import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinCollectionAttach;
import com.reyzar.oa.domain.FinTravelreimburseAttach;


@MyBatisDao
public interface IFinCollectionAttachDao {
	
	public List<FinCollectionAttach> findAll();
	
	public List<FinCollectionAttach> findByCollectionId(Integer collectionId);
	
	public FinCollectionAttach findById(Integer id);
	
	public void save(FinCollectionAttach finCollectionAttach);
	
	public void insertAll(List<FinCollectionAttach> collectionAttachList);
	
	public void update(FinCollectionAttach finCollectionAttach);
	
	public void batchUpdate(@Param(value="collectionAttachList") List<FinCollectionAttach> collectionAttachList);
	
	public void deleteById(Integer id);
	
	public void deleteByCollectionId(Integer collectionId);
	
	public void deleteByIdList(List<Integer> idList);

	public List<FinCollectionAttach> findByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<SingleDetail> findCollectionByIdList(List<String> collectionMainId);
}