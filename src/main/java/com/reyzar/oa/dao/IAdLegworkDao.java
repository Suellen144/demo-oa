package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdLegwork;

@MyBatisDao
public interface IAdLegworkDao {

	Page<AdLegwork> findByPage(Map<String, Object> params);

	public void save(AdLegwork legwork);
	
	public void update(AdLegwork legwork);
	
	public void deleteBycategorize(String categorize);
	
	public void insertAll(@Param(value="legworksList") List<AdLegwork> legworksList);
	
	public List<AdLegwork> findByCategorize(String categorize);

	public  AdLegwork findById(Integer id);
	
	public List<AdLegwork> findByParam(Map<String, Object> params);
	
	public List<AdLegwork> findByAdAttendance(@Param(value="userId")Integer userId,@Param(value="generalMonth")String date);
}
