package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdPosition;

public interface IAdPositionService {
	
	public List<AdPosition> findAll();
	
	public Page<AdPosition> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public AdPosition findById(Integer id);
	
	public AdPosition findByCode(String code);
	
	public CrudResultDTO save(AdPosition position);
	
	public CrudResultDTO delete(Integer id);
	
	public List<AdPosition> findByDeptId(Integer DeptId);
	
	public List<AdPosition> findPositionOfManagerByDeptIdAndLevel(Integer deptId, Integer level);

	public void update(AdPosition position);

}