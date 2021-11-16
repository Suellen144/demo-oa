package com.reyzar.oa.service.finance;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.FinCommonPay;

public interface IFinCommonPayService {

	FinCommonPay findById(Integer id);

	CrudResultDTO saveInfo(JSONObject json);

	Page<FinCommonPay> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);

	CrudResultDTO deleteAttach(String path, Integer id);

	CrudResultDTO deleteById(Integer id);

}