package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.ReimburseDTO;
import com.reyzar.oa.domain.FinReimburse;


@MyBatisDao
public interface IFinReimburseDao {
	
	public Page<FinReimburse> findByPage(Map<String, Object> params);
	
	public FinReimburse findById(Integer id);
	
	public FinReimburse findByProcessId(String processId);
	
	public List<FinReimburse> findByEncrypted(String encrypted);
	
	public void save(FinReimburse reimburse);
	
	public void update(FinReimburse reimburse);
	
	public void deleteById(Integer id);
	
	public Page<ReimburseDTO> findAllByPage(Map<String, Object> params);
	
	public Page<ReimburseDTO> findMeByPage(Map<String, Object> params);

	public Page<ReimburseDTO> findAllByProjectId(Map<String, Object> paramsMap);

	public List<ReimburseDTO> findAllByProjectId(Integer id);

	public void setAssistantAffirm(@Param("id")Integer id, @Param("assistantStatus")String assistantStatus);

	public Integer showSize(Integer id);

	public List<Integer> findByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);
	
	public List<ReimburseDTO> findAllByProjectIdAndStatus(Integer id);
	
	public Double findByIdAndUser(@Param("id")Integer id,@Param("userId")Integer userId,@Param("startDate")String startDate,@Param("endDate")String endDate);
	
}