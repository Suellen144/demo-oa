package com.reyzar.oa.service.office;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.OffPost;
import com.reyzar.oa.domain.OffReply;

public interface IOffPostService {
	public Page<OffPost> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public List<OffPost> findAll(Map<String, Object> map);
	
	public OffPost findById(Integer id);
	
	public CrudResultDTO save(OffPost offPost);
	
	public CrudResultDTO update(OffPost offPost);
	
	public CrudResultDTO deleteById(Integer id);
	
	public List<OffReply> findReplyById(Integer id);
	
	public CrudResultDTO addReply(JSONObject json);
	
	public CrudResultDTO addInReply(JSONObject json);
	
	public CrudResultDTO updateAudit(Integer id,Integer audit);
	
	public CrudResultDTO updateStatus(Integer id,Integer status);
	
}
