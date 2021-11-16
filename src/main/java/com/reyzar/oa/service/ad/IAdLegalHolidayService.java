package com.reyzar.oa.service.ad;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdLegalHoliday;
import com.reyzar.oa.domain.SysUser;

public interface IAdLegalHolidayService {

	public Page<AdLegalHoliday> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize);
	
	public CrudResultDTO save(JSONObject json, SysUser user);
	
	public AdLegalHoliday findById(Integer id);
	
	public CrudResultDTO delete(Integer id);
	
	public CrudResultDTO update(JSONObject json);
}
