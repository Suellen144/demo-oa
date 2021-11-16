package com.reyzar.oa.service.finance;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 财务统计 收款
 */
public interface IFinStatisticsReceivedService {
    public CrudResultDTO searchByStatistics(JSONObject json);

    public Map<String,Object> commonReceivedCount(StatisticsFromPageDTO statisticsFromPageDTO);

    public Map<String,Object> sumByType(StatisticsFromPageDTO statisticsFromPageDTO);

    public Map<String,Object> sumByProject(StatisticsFromPageDTO statisticsFromPageDTO);

    public CrudResultDTO singleDetail(StatisticsFromPageDTO statisticsFromPageDTO);

    public void exportExcel(ServletOutputStream outputStream, Map<String, Object> paramMap);

	public void exportDetails(HttpServletRequest request, HttpServletResponse response, Map<String, String> param);
}
