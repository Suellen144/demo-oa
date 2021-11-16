package com.reyzar.oa.service.ad;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdWorkMarket;

public interface IAdWorkMarketService {
	public AdWorkMarket findById(Integer id);
	
	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public CrudResultDTO delete(Integer id);

	public CrudResultDTO rejectProcess(Integer id);
	
	public CrudResultDTO rejectProcess(Integer id,String contents);
	
}