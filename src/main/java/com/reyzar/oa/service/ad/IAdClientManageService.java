package com.reyzar.oa.service.ad;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdClientManage;

public interface IAdClientManageService {
	public Page<AdClientManage> findByPage(Map<String, Object> params, int pageNum,int pageSize);
	
	public AdClientManage findById(Integer id);
	
	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public CrudResultDTO delete(Integer id);

	public CrudResultDTO findByProjectId(Integer projectId);
	
}