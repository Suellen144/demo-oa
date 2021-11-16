package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.AdSalary;

import javax.servlet.ServletOutputStream;

public interface IAdSalaryService {
	
	public Page<AdSalary> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize);
	
	public AdSalary findById(Integer id);
	
	public List<AdSalary> findAll();
	
	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO update(JSONObject json);
	
	public CrudResultDTO setStatus(Integer id, String status);
	
	public CrudResultDTO lock(JSONObject json);

	public void exportExcel(ServletOutputStream out, Map<String, Object> paramMap);

	public List<AdRecord> workingStateselectVal();
}