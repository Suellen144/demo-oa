package com.reyzar.oa.service.ad;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdRecordPositionHistory;

public interface IAdRecordPositionHistoryService {

	List<AdRecordPositionHistory> findByUserId(Integer userId);
	
	CrudResultDTO saveBatchPositionHistory(JSONObject jsonObject);
	
}