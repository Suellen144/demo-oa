package com.reyzar.oa.controller.ad;

import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdLegalHoliday;
import com.reyzar.oa.domain.AdLegwork;
import com.reyzar.oa.service.ad.IAdLegalHolidayService;



@Controller
@RequestMapping("/manage/ad/legalHoliday")
public class AdLegalHolidayController  extends BaseController{
	
	@Autowired
	IAdLegalHolidayService legalHolidayService;

	@RequestMapping(value="/toList")
	public String toList(Model model) {
		return "manage/ad/chkatt/legalholiday/list";
	}
	
	
	@RequestMapping(value="/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<AdLegalHoliday> page = legalHolidayService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}
	
	@RequestMapping(value="/toAdd")
	public String toAdd(Model model) {
		return "manage/ad/chkatt/legalholiday/add";
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		return JSON.toJSONString(legalHolidayService.save(json, getUser()));
	}
	
	@RequestMapping(value="/view")
	@ResponseBody
	public String view(Integer id) {
		return JSON.toJSONString(legalHolidayService.findById(id));
	}
	
	@RequestMapping(value="/delete")
	@ResponseBody
	public String delete(@Param(value="id") Integer id) {
		return JSON.toJSONString(legalHolidayService.delete(id));
	}
	
	@RequestMapping(value="/toAddOrEdit")
	public String toAddOrEdit(Model model,Integer id){
		AdLegalHoliday legalHoliday=legalHolidayService.findById(id);
		model.addAttribute("legalHoliday", legalHoliday);
		return "manage/ad/chkatt/legalholiday/edit";
	}
	
	@RequestMapping(value="/update")
	@ResponseBody
	public String update(@RequestBody JSONObject json) {
		return JSON.toJSONString(legalHolidayService.update(json));
	}
	
}
