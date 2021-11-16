package com.reyzar.oa.service.ad;

import java.io.OutputStream;
import java.util.Date;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdWorkReport;

public interface IAdWorkReportService {
	
	public Page<AdWorkReport> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public AdWorkReport findById(Integer id);

	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public CrudResultDTO checkStatus(Integer id);
	
	public CrudResultDTO delete(Integer id);
	
	public Map<String, Object> getWorkReportChartsData(Map<String, String> paramsMap);
	
	public CrudResultDTO checkNumber(Integer id, Integer userId, Integer month, Integer number, String workDate);
	
	public void exportExcel(OutputStream out, Map<String, Object> paramMap);
}