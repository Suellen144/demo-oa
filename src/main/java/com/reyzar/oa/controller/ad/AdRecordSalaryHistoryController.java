package com.reyzar.oa.controller.ad;

import java.util.List;
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
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.fasterxml.jackson.core.JsonParseException;
import com.github.pagehelper.Page;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.AdRecordSalaryHistory;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdRecordSalaryHistoryService;
import com.reyzar.oa.service.sys.ISysUserService;

@Controller
@RequestMapping("/manage/ad/salaryHistory")
public class AdRecordSalaryHistoryController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdRecordSalaryHistoryController.class);
	
	@Autowired
	private IAdRecordSalaryHistoryService salaryHistoryService; 
	
	@Autowired
	private ISysUserService userService;
	
	@RequestMapping("/getSalaryHistory")
	@ResponseBody
	public String getSalaryHistory(@RequestBody Map<String, Object> requestMap) throws JsonParseException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		paramsMap.put("userId", getUser().getId());
		Page<AdRecordSalaryHistory> page = salaryHistoryService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()),  
				Integer.valueOf(paramsMap.get("pageSize").toString()),getUser());
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}
	
	@RequestMapping("/addOrEditSalaryHistory")
	public String addOrEditSalaryHistory(Integer userId,Model model){
		List<AdRecordSalaryHistory> salaryHistories = salaryHistoryService.findByUserId(userId);
		if (salaryHistories != null && salaryHistories.size() >0) {
			model.addAttribute("isEdit", true);
			model.addAttribute("salaryHistories", salaryHistories);
		}else {
			model.addAttribute("isEdit", false);
		}
		SysUser user = userService.findById(userId);
		model.addAttribute("user", user);
		model.addAttribute("userId", userId);
		return "manage/ad/salaryManage/addOrEditSalaryHistory";
	}
	
	@RequestMapping("/saveBatchSalaryHistory")
	@ResponseBody
	public String saveBatchSalaryHistory(@RequestBody JSONObject jsonObject,Integer userId){
		return JSON.toJSONString(salaryHistoryService.saveBatchSalaryHistory(jsonObject,userId));
	}
}