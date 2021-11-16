package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdLeave;

public interface IAdLeaveService {
	
	public Page<AdLeave> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public AdLeave findById(Integer id);
	
	public CrudResultDTO save(AdLeave leave);
	
	public CrudResultDTO update(AdLeave leave);
	
	public CrudResultDTO setStatus(Integer id, String status);
	
	public CrudResultDTO setBackLeave(Integer id);
	
	public List<Map<String, Object>> getLeaveDays(Map<String, Object> paramsMap);
	
	public List<Map<String, Object>> getNameList(Map<String, Object> paramsMap);

	public void sendMail(AdLeave leave);
	
	public CrudResultDTO checkDate(String startTime,String endTime);
	
	public List<AdLeave> findByUserId(Integer id);
}