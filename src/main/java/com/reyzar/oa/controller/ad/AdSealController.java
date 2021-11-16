package com.reyzar.oa.controller.ad;

import java.util.Map;

import com.reyzar.oa.common.util.UserUtils;
import org.apache.ibatis.annotations.Param;
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
import com.reyzar.oa.domain.AdSeal;
import com.reyzar.oa.service.ad.IAdSealService;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/manage/ad/seal")
public class AdSealController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdSealController.class);
	
	@Autowired
	private IAdSealService sealService;
	
	@RequestMapping(value="/toList")
	public String toList(Model model) {
		return "manage/ad/seal/list";
	}
	
	
	@RequestMapping("/getSealList")
	@ResponseBody
	public String getSealList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<AdSeal> page = sealService.findByPage(paramsMap, 
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
			return "manage/ad/seal/mobileadd";
		}else{
			return "manage/ad/seal/add";
		}

	}

	@RequestMapping("/sendMail")
	@ResponseBody
	public CrudResultDTO sendMail(@Param("id")Integer id,
								  @Param("comment")String comment){
		CrudResultDTO result = sealService.sendMail(id,comment);
		return result;
	}

	@RequestMapping("/save")
	@ResponseBody
	public String save(AdSeal seal) {
		CrudResultDTO result = sealService.save(seal);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(AdSeal seal) {
		CrudResultDTO result = sealService.update(seal);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return sealService.setStatus(id, status);
	}
	
	
}