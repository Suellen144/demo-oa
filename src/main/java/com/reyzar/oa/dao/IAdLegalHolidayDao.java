package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdLegalHoliday;
import com.reyzar.oa.domain.AdLegwork;

@MyBatisDao
public interface IAdLegalHolidayDao {
	
	public Page<AdLegalHoliday> findByPage(Map<String, Object> params);
	
	public List<AdLegalHoliday> getLegalHolidays(Map<String, Object> paramsMap);
	
	public void addBatchs(List<AdLegalHoliday> list);
	
	public void save(AdLegalHoliday adLegalHoliday);
	
	public AdLegalHoliday findById(Integer id);
	
	public void delete(Integer id);
	
	public void update(AdLegalHoliday adLegalHoliday);
	
	public List<AdLegalHoliday> getHolidays(Map<String, Object> paramsMap);
}
