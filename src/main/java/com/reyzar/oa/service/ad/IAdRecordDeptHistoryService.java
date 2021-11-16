package com.reyzar.oa.service.ad;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.domain.AdRecordDeptHistory;

public interface IAdRecordDeptHistoryService {

	List<AdRecordDeptHistory> findByUserId(Integer userId);

	Object saveBatchDeptHistory(JSONObject jsonObject);
	
}