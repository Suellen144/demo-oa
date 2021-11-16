package com.reyzar.oa.service.sale;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleTicketConfirmation;

public interface ISaleTicketConfirmationService {

	public SaleTicketConfirmation findById(Integer id);
	
	public CrudResultDTO save(JSONObject json);
	
	Page<SaleTicketConfirmation> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
}
