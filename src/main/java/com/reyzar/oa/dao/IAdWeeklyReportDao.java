package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdWeeklyReport;

@MyBatisDao
public interface IAdWeeklyReportDao {

	public Page<AdWeeklyReport> findByPage(Map<String, Object> params);
	
	public void insertAll(@Param(value="weeklyReportList") List<AdWeeklyReport> weeklyReportList);
	
	public void modifyStatusByCategorize(@Param(value="categorize") String categorize, 
			@Param(value="status") String status);
	
	public List<AdWeeklyReport> findByCategorize(String categorize);
}