package com.reyzar.oa.service.sale;


import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleProjectManageHistory;

public interface ISaleProjectManageHistoryService {
	
	public SaleProjectManageHistory findById(Integer id);
	
	public List<SaleProjectManageHistory> findByProjectId(Integer id);
	
	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO submit(JSONObject json);
	
	CrudResultDTO setStatusNew(Integer id, String status);
	
	CrudResultDTO sendMail(Integer id,String comment);
}