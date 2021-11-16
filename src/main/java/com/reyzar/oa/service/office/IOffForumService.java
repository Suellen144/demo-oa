package com.reyzar.oa.service.office;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.OffForum;

public interface IOffForumService {
	public Page<OffForum> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public List<OffForum> findAll();
	
	public OffForum findById(Integer id);
	
	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO update(JSONObject json);
	
	public CrudResultDTO deleteById(Integer id);
}
