package com.reyzar.oa.service.finance;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.FinCommonReceived;

public interface IFinCommonReceivedService {

	FinCommonReceived findById(Integer id);

	CrudResultDTO saveInfo(JSONObject json);

	CrudResultDTO deleteAttach(String path, Integer id);

	Page<FinCommonReceived> findByPage(Map<String, Object> paramsMap, Integer valueOf, Integer valueOf2);

	CrudResultDTO deleteById(Integer id);
	
}