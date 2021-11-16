package com.reyzar.oa.service.office;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.reyzar.oa.common.dto.CrudResultDTO;

public interface IOffPendflowService {

	public List<Map<String, Object>> findTaskByAssignee(String assignee);
	
	public CrudResultDTO getOrderNo(JSONArray jsonArray);

	public CrudResultDTO completeTask(String processId);
}
