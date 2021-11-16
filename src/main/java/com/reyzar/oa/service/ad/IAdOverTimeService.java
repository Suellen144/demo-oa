package com.reyzar.oa.service.ad;

import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdOverTime;
import com.reyzar.oa.domain.SysUser;

public interface IAdOverTimeService {
	public Page<AdOverTime> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	public AdOverTime findById(Integer id);
	
	public CrudResultDTO save(AdOverTime overTime);
	
	public CrudResultDTO update(AdOverTime overTime);
	
	public CrudResultDTO setStatus(Integer id, String status);
	
	public CrudResultDTO checkDate(String startTime,String endTime);
}