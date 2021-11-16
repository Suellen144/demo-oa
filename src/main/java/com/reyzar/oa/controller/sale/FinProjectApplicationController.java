package com.reyzar.oa.controller.sale;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.reyzar.oa.domain.SaleProjectAchievement;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.service.sale.ISaleProjectManageService;

@Controller
@RequestMapping(value = "/manage/finance/projectApplication")
public class FinProjectApplicationController extends BaseController{
	
	@Autowired
	ISaleProjectManageService iSaleProjectManageService;
	@Autowired
	private ISaleProjectManageService projectManageService;

	@RequestMapping(value="/toAchievementList")
	public String toAchievementList(Model model) {
		return "manage/finance/projectApplication/achievementList";
	}

	@RequestMapping(value = "/toRoyaltyNew")
	public String toRoyaltyNew(Integer id , Model model) {
		SaleProjectManage saleProjectManage= new SaleProjectManage();
		if(id!=null) {
			saleProjectManage = projectManageService.findById(id);
		}else {
			SysUser user = getUser();
			saleProjectManage.setApplicantP(getUser());
			saleProjectManage.setDeptA(getUser().getDept());
		}
		model.addAttribute("saleProjectManage", saleProjectManage);
		return "manage/finance/projectApplication/royaltyNew";
	}
	 
	@RequestMapping(value="/toList")
    public String toList(Map<String,Object> map){
         return "manage/finance/projectApplication/list";
    }
	 
	@RequestMapping("/getProjectList")
	@ResponseBody
	public String getProjectList(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<SaleProjectManage> page = iSaleProjectManageService.findByPage3(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
		Map<String, Object> paramMap = parseRequestMap(request);
		String fileName = "项目申请列表.xls";
		String agent = request.getHeader("USER-AGENT").toLowerCase();
		if (agent.contains("firefox")) {
			response.setCharacterEncoding("UTF-8");
			fileName = new String(fileName.getBytes(), "ISO8859-1");
		} else {
			fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
		}
		
		response.setContentType("application/vnd.ms-excel; charset=utf-8");  
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
        
        iSaleProjectManageService.exportExcelList(response.getOutputStream(), paramMap);
	}

	/**
	 * 项目管理模块-项目业绩列表
	 * @return
	 */
	@RequestMapping("/getAchievementListNew")
	@ResponseBody
	public String getAchievementListNew(@RequestBody Map<String, Object> requestMap)
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		List<SaleProjectAchievement>  SaleProjectAchievementLists = iSaleProjectManageService.findPerformanceContributionList(paramsMap);
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("aaData",SaleProjectAchievementLists);
		return JSONObject.toJSONString(dataMap);
	}

	/**
	 * 项目管理模块-项目提成列表
	 * @return
	 */
	@RequestMapping("/getRoyalyListNew")
	@ResponseBody
	public String getRoyalyListNew(@RequestBody Map<String, Object> requestMap)
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		List<SaleProjectAchievement>  ProjectAchievementList = iSaleProjectManageService.findProjectAchievementList(paramsMap);
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("aaData",ProjectAchievementList);
		return JSONObject.toJSONString(dataMap);
	}
}
