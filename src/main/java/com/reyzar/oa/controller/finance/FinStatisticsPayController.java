package com.reyzar.oa.controller.finance;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.common.util.WebUtil;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.FinInvest;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.finance.IFinInvestService;
import com.reyzar.oa.service.finance.IFinStatisticsPayService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/***
 * 财务统计
 */
@Controller
@RequestMapping(value="/manage/finance/statisticspay")
public class FinStatisticsPayController extends BaseController {
	
    /*private final Logger logger = Logger.getLogger(FinStatisticsPayController.class);*/

    @Autowired
    IFinStatisticsPayService iFinStatisticsPayService;
    @Autowired
    IFinInvestService iFinInvestService;

    @RequestMapping(value="/toList")
    public String toList(Map<String,Object> map){
        //查找费用归属
        List<FinInvest> invests = iFinInvestService.findAll();
        SysUser user = UserUtils.getCurrUser();
        map.put("invest",invests);
        map.put("user",user);
        return "manage/finance/statisticsPay/list";
    }

    @RequestMapping(value = "/searchByStatistics")
    @ResponseBody
    public String searchByStatistics(@RequestBody JSONObject json,Model model){
       return JSON.toJSONString(iFinStatisticsPayService.searchByStatistics(json));
    }

    @RequestMapping(value = "/singleDetailByStatistics")
    @ResponseBody
    public String singleDetailByStatistics(StatisticsFromPageDTO statisticsFromPageDTO){
        return JSON.toJSONString(iFinStatisticsPayService.singleDetail(statisticsFromPageDTO));
    }
    
    @RequestMapping("/exportDetails")
    @ResponseBody
    public void exportDetails(HttpServletResponse response, HttpServletRequest request){
        @SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
        iFinStatisticsPayService.exportDetails(request, response, param);
    }

    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
        Map<String,Object> paramMap=parseRequestMap(request);
        String fileName = "财务统计_付款_项目表.xls";
        String agent = request.getHeader("USER-AGENT").toLowerCase();
        if (agent.contains("firefox")){
            response.setCharacterEncoding("UTF-8");
            fileName = new String(fileName.getBytes(),"ISO8859-1");
        } else {
            fileName = java.net.URLEncoder.encode(fileName,"UTF-8");
        }
        response.setContentType("application/vnd.ms-excel;charset=utf-8");
        response.addHeader("Content-Disposition","attachment;filenaem="+fileName);
        iFinStatisticsPayService.exportExcel(response.getOutputStream(), paramMap);
    }
    @RequestMapping("/exportExcelOne")
    @ResponseBody
    public void exportExcelOne(HttpServletResponse response, HttpServletRequest request) throws IOException {
        Map<String,Object> paramMap=parseRequestMap(request);
        String fileName = "财务统计_付款_统计表.xls";
        String agent = request.getHeader("USER-AGENT").toLowerCase();
        if (agent.contains("firefox")){
            response.setCharacterEncoding("UTF-8");
            fileName = new String(fileName.getBytes(),"ISO8859-1");
        } else {
            fileName = java.net.URLEncoder.encode(fileName,"UTF-8");
        }
        response.setContentType("application/vnd.ms-excel;charset=utf-8");
        response.addHeader("Content-Disposition","attachment;filenaem="+fileName);
        iFinStatisticsPayService.exportExcelOne(response.getOutputStream(), paramMap);
    }
}
