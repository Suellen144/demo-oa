package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdLeave;
import com.reyzar.oa.domain.AdLegwork;
import com.reyzar.oa.domain.SysUser;

public interface IAdLegworkService {

	public Page<AdLegwork> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize,SysUser user);

	public CrudResultDTO save(JSONObject json, SysUser user);
	
	public CrudResultDTO deleteBycategorize(String categorize);
	
	public AdLegwork findById(Integer id);
	
	public List<AdLegwork>  findByCategorize(String categorize);
	


}
