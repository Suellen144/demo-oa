package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdLeave;
import com.reyzar.oa.domain.AdLegwork;

@MyBatisDao
public interface IAdLeaveDao {
	
	public Page<AdLeave> findByPage(Map<String, Object> params);
	
	public AdLeave findById(Integer id);
	
	public List<AdLeave> findByEndTimeAndStatus(@Param("endTime") String endTime, @Param("status") String status);
	
	public void save(AdLeave leave);
	
	public int update(AdLeave leave);
	
	public List<Map<String, Object>> getLeaveDays(Map<String, Object> paramsMap);
	
	public List<Map<String, Object>> getNameList(Map<String, Object> paramsMap);
	
	public List<AdLeave> findByParam(Map<String, Object> params);
	
	public List<AdLeave> findRestByParam(Map<String, Object> params);
	
	public List<AdLeave> findLeaveByParam(Map<String, Object> params);

	public List<AdLeave> findYearLeave(Map<String, Object> params);
	
	public List<AdLeave> findByUserId(Integer id);
}