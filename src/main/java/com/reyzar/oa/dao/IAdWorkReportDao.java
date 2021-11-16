package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.WorkReportExcelDTO;
import com.reyzar.oa.domain.AdWorkReport;


@MyBatisDao
public interface IAdWorkReportDao {
	
	public List<AdWorkReport> findAll();
	
	public Page<AdWorkReport> findByPage(Map<String, Object> params);
	
	public AdWorkReport findById(Integer id);
	
	public List<AdWorkReport> findByCondition(@Param("id") Integer id, @Param("userId") Integer userId, 
											@Param("year") Integer year, @Param("month") Integer month, @Param("number") Integer number);
	
	public List<Map<String, Object>> getChartsData(Map<String, Object> paramsMap);
	
	public List<WorkReportExcelDTO> getExcelData(Map<String, Object> paramsMap);
	
	public void save(AdWorkReport adWorkReport);
	
	public void update(AdWorkReport adWorkReport);
	
	public void deleteById(Integer id);
	
}