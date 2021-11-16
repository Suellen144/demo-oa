package com.reyzar.oa.controller.finance;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.common.util.WebUtil;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.service.finance.IFinStatisticsBarginService;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping(value = "/manage/finance/statisticsBargin")
public class FinStatisticsBarginController extends BaseController {
    @Autowired
    IFinStatisticsBarginService iFinStatisticsBarginService;

    @RequestMapping(value="/toList")
    public String toList(Model model){
        return "manage/finance/statisticsBargin/list";
    }

    @RequestMapping(value = "/searchByStatistics")
    @ResponseBody
    public String searchByStatistics(@RequestBody JSONObject json, Model model){
        return JSON.toJSONString(iFinStatisticsBarginService.searchByStatistics(json));
    }
    
    
    @RequestMapping(value="/toOtherList")
    public String toOtherList(Model model){
        return "manage/finance/statiscsOther/list";
    }
    
    
    @RequestMapping(value = "/searchOtherByStatistics")
    @ResponseBody
    public String searchOtherByStatistics(@RequestBody JSONObject json, Model model){
        return JSON.toJSONString(iFinStatisticsBarginService.searchOtherByStatistics(json));
    }
    
    @RequestMapping(value = "/searchOtherByProjectId")
    @ResponseBody
    public String searchOtherByProjectId(@RequestBody JSONObject json){
        return JSON.toJSONString(iFinStatisticsBarginService.searchOtherByProjectId(json));
    }
    
    @RequestMapping(value = "/searchInfoByProjectId")
    @ResponseBody
    public String searchInfoByProjectId(StatisticsFromPageDTO statisticsFromPageDTO){
        return JSON.toJSONString(iFinStatisticsBarginService.searchInfoByProjectId(statisticsFromPageDTO));
    }
    
    @RequestMapping("/exportDetails")
    @ResponseBody
    public void exportDetails(HttpServletResponse response, HttpServletRequest request){
        @SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
        iFinStatisticsBarginService.exportDetails(request, response, param);
    }
    
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
        Map<String,Object> paramMap=parseRequestMap(request);
        String strCompany=request.getParameter("strRayCompany");
        paramMap.put("strCompany", strCompany);
        String fileName = "合同统计.xls";
        System.out.println(paramMap);
        String agent = request.getHeader("USER-AGENT").toLowerCase();
        if (agent.contains("firefox")){
            response.setCharacterEncoding("UTF-8");
            fileName = new String(fileName.getBytes(),"ISO8859-1");
        } else {
            fileName = java.net.URLEncoder.encode(fileName,"UTF-8");
        }
        
        response.setContentType("application/vnd.ms-excel;charset=utf-8");
        response.addHeader("Content-Disposition","attachment;filenaem="+fileName);
        iFinStatisticsBarginService.exportExcel(response.getOutputStream(), paramMap);
    }
}
