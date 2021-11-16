package com.reyzar.oa.service.finance;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 财务统计 付款
 */
public interface IFinStatisticsPayService {

    public CrudResultDTO searchByStatistics(JSONObject json);

    public Map<String,Object> payCount(StatisticsFromPageDTO statisticsFromPageDTO);

    public Map<String,Object> remiburseAndTravelCount(StatisticsFromPageDTO statisticsFromPageDTO);

    public Map<String,Object> commonPayCount(StatisticsFromPageDTO statisticsFromPageDTO);

    public CrudResultDTO singleDetail(StatisticsFromPageDTO statisticsFromPageDTO);

    public void exportExcel(ServletOutputStream outputStream, Map<String, Object> paramMap);

	public void exportDetails(HttpServletRequest request, HttpServletResponse response, Map<String, String> param);
	
	public void exportExcelOne(ServletOutputStream outputStream, Map<String, Object> paramMap);
}
