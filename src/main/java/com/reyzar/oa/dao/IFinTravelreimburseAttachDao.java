package com.reyzar.oa.dao;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.domain.SingleDetail;
import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelreimburseAttach;


@MyBatisDao
public interface IFinTravelreimburseAttachDao {
	
	public List<FinTravelreimburseAttach> findAll();
	
	public List<FinTravelreimburseAttach> findByTravelreimburseId(Integer travelreimburseId);
	
	public FinTravelreimburseAttach findById(Integer id);
	
	public List<FinTravelreimburseAttach> findByIds(@Param("ids") Collection<Integer> ids);
	
	public void save(FinTravelreimburseAttach travelreimburseAttach);
	
	public void insertAll(List<FinTravelreimburseAttach> travelreimbursAttachList);
	
	public void update(FinTravelreimburseAttach finTravelreimburseAttach);
	
	public void batchUpdate(@Param(value="travelreimburseAttachList") List<FinTravelreimburseAttach> travelreimburseAttachList);
	
	public void deleteById(Integer id);
	
	public void deleteBytravelreimburseId(Integer travelreimburseId);
	
	public void deleteByIdList(List<Integer> idList);

	public List<FinTravelreimburseAttach> findByProjectId(Integer id);

	public Page<FinReimburseAttach> findPageByProjectId(Map<String, Object> paramsMap);

	public void unbound(List<FinTravelreimburseAttach> attach);

	public List<FinTravelreimburseAttach> findByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<FinTravelreimburseAttach> findByStatisticsAndTitle(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<SingleDetail> findByTravelByIdList(List<String> travelMainId);
	
	public List<SingleDetail> findByTravelByProjectId(int projectId);
	
}