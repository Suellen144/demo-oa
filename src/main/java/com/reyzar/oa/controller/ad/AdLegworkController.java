package com.reyzar.oa.controller.ad;

import java.util.Map;

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
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdLegwork;
import com.reyzar.oa.service.ad.IAdLegworkService;

@Controller
@RequestMapping(value="/manage/ad/legwork")
public class AdLegworkController extends BaseController{
	
	@Autowired
	private IAdLegworkService legworkService;
	
	@RequestMapping(value="/toList")
	public String toList(Model model) {
		model.addAttribute("userId", UserUtils.getCurrUser().getId());
		return "manage/ad/chkatt/legwork/list";
	}
	
	@RequestMapping("/getLegworkList")
	@ResponseBody
	public String getLegworkList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<AdLegwork> page = legworkService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()),
				getUser());
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}

	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id){
		return "manage/ad/chkatt/legwork/add";
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		return JSON.toJSONString(legworkService.save(json, getUser()));
	}
	
	
	@RequestMapping(value="/viewList")
	@ResponseBody
	public String viewList(String categorize) {
		return JSON.toJSONString(legworkService.findByCategorize(categorize));
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(String categorize) {
		return JSON.toJSONString(legworkService.deleteBycategorize(categorize));
	}
	
}
