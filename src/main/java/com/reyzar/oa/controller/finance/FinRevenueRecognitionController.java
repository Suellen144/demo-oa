package com.reyzar.oa.controller.finance;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.controller.sale.SaleBarginManageController;
import com.reyzar.oa.domain.FinRevenueRecognition;
import com.reyzar.oa.service.finance.IFinRevenueRecognitionService;

@Controller
@RequestMapping(value="/manage/finance/revenueRecognition")
public class FinRevenueRecognitionController extends BaseController{
private final Logger logger = Logger.getLogger(SaleBarginManageController.class);
	
	@Autowired
	private IFinRevenueRecognitionService iFinRevenueRecognitionService; 
	
//	@RequestMapping("/toList")
//	public String toList() {
//		return "manage/sale/barginManage/list";
//	}
	
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinRevenueRecognition> page = iFinRevenueRecognitionService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}

}
