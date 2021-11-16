package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.AdAtravelDto;
import com.reyzar.oa.domain.AdTravel;

@MyBatisDao
public interface IAdTravelDao {
	public void updateTravelResult(@Param("id")Integer id ,@Param("travelResult")String travelResult);
	
	public Page<AdTravel> findByPage(Map<String, Object> params);
	
	public void save(AdTravel travel);
	
	public void update(AdTravel travel);

	public AdTravel findById(Integer travelId);
	
	public List<Map<String, Object>> getTraveData(Map<String, Object> paramsMap);

	public List<AdTravel> findByIds(@Param("ids")List<Integer> ids);
	
	public List<AdAtravelDto> findByParam(Map<String, Object> params);

	public List<AdAtravelDto> findByAdAttendance(Map<String, Object> params);
	
	public List<AdAtravelDto> findByAdAttendanceName(Map<String, Object> params);
}
