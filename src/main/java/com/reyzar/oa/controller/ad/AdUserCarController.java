package com.reyzar.oa.controller.ad;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdUserCar;
import com.reyzar.oa.service.ad.IAdUserCarService;

@Controller
@RequestMapping(value="/manage/ad/car")
public class AdUserCarController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdUserCarController.class);
	
	@Autowired
	private IAdUserCarService userCarService;
	
	@RequestMapping(value="/toList")
	public String toList(Model model) {
		return "manage/ad/car/list";
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getSealList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<AdUserCar> page = userCarService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAdd")
	public String toAdd() {
		return "manage/ad/car/add";
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(AdUserCar userCar) {
		CrudResultDTO result = userCarService.save(userCar);
		return JSON.toJSONString(result);
	}
	
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(AdUserCar userCar) {
		CrudResultDTO result = userCarService.update(userCar);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return userCarService.setStatus(id, status);
	}
	
	
	
	
}