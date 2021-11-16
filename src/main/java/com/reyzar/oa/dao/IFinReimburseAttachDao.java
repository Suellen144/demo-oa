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


@MyBatisDao
public interface IFinReimburseAttachDao {
	
	public List<FinReimburseAttach> findAll();
	
	public List<FinReimburseAttach> findByReimburseId(Integer reimburseId);
	
	public FinReimburseAttach findById(Integer id);
	
	public List<FinReimburseAttach> findByIds(@Param("ids") Collection<Integer> ids);
	
	public void save(FinReimburseAttach finReimburseAttach);
	
	public void insertAll(List<FinReimburseAttach> reimburseAttachList);
	
	public void update(FinReimburseAttach finReimburseAttach);
	
	public void batchUpdate(@Param(value="reimburseAttachList") List<FinReimburseAttach> reimburseAttachList);
	
	public void deleteById(Integer id);
	
	public void deleteByreimburseId(Integer reimburseId);
	
	public void deleteByIdList(List<Integer> idList);

	public List<FinReimburseAttach> findByProjectId(Integer id);

	public Page<FinReimburseAttach> findPageByProjectId(Map<String, Object> params);

	public void unbound(List<FinReimburseAttach> attach);

	public List<FinReimburseAttach> findReimburseByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<FinReimburseAttach> findReimburseByStatisticsAndTitle(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<SingleDetail> findReimburseByIdList(List<String> reimburseMainId);
	
	public List<SingleDetail> findReimburseByProjectId(int projectId);
}