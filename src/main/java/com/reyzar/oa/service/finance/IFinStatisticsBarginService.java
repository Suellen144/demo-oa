package com.reyzar.oa.service.finance;

import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestBody;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;

public interface IFinStatisticsBarginService {
	
    public CrudResultDTO searchByStatistics(JSONObject json);
    
    public CrudResultDTO searchOtherByStatistics(JSONObject json);
    
    public CrudResultDTO searchOtherByProjectId(@RequestBody JSONObject json);
    
    public CrudResultDTO searchInfoByProjectId(StatisticsFromPageDTO statisticsFromPageDTO);
    
    public void exportExcel(ServletOutputStream outputStream, Map<String, Object> paramMap);
    
    public void exportDetails(HttpServletRequest request, HttpServletResponse response, Map<String, String> param);

}
