package com.reyzar.oa.service.ad;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.WorkManageDTO;
import com.reyzar.oa.domain.AdWorkBuinsess;

public interface IAdWorkBuinsessService {
	
	public AdWorkBuinsess findById(Integer id);
	
	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public CrudResultDTO delete(Integer id);
	
	public Page<WorkManageDTO> findAllByPage(Map<String, Object> params, int pageNum,int pageSize);

	/**
	 * 驳回
	 */
	public CrudResultDTO rejectProcess(Integer id);
	
	public CrudResultDTO rejectProcess(Integer id,String contents);
}