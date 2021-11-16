package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdTravel;

public interface IAdTravelService {

	public CrudResultDTO updateTravelResult(Integer id ,String travelResult);
	
	public Page<AdTravel> findByPage(Map<String, Object> params, int pageNum, int pageSize);

	public AdTravel findById(Integer id);
	
	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public CrudResultDTO setStatus(Integer id, String status);
	
	public List<Map<String, Object>> getTraveData(Map<String, Object> paramsMap);

	public List<AdTravel> findByIds(String travelId);

}
