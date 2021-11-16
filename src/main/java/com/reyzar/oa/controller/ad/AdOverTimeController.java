package com.reyzar.oa.controller.ad;

import java.util.Map;

import com.reyzar.oa.common.util.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdOverTime;
import com.reyzar.oa.service.ad.IAdOverTimeService;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/manage/ad/overtime")
public class AdOverTimeController extends BaseController {
	@Autowired
	private IAdOverTimeService overTimeService;
	
	@RequestMapping(value="/toList")
	public String toList(Model model) {
		return "manage/ad/chkatt/overtime/list";
	}
	
	@RequestMapping("/checkDate")
	@ResponseBody
	public CrudResultDTO checkDate(String startTime,String endTime){
		return overTimeService.checkDate(startTime,endTime);
	}
	
	@RequestMapping("/getOvertimeList")
	@ResponseBody
	public String getOvertimeList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<AdOverTime> page = overTimeService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAdd")
	public String toAdd(HttpServletRequest request) {
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		if (ismobile){
			return "manage/ad/chkatt/overtime/mobileadd";
		}else{
			return "manage/ad/chkatt/overtime/add";
		}
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	@ResponseBody
	public String save(AdOverTime overTime) {
		CrudResultDTO result = overTimeService.save(overTime);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(AdOverTime overTime) {
		CrudResultDTO result = overTimeService.update(overTime);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return overTimeService.setStatus(id, status);
	}

	
}