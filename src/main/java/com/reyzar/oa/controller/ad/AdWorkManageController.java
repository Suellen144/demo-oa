package com.reyzar.oa.controller.ad;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.WorkManageDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.service.ad.IAdWorkBuinsessService;


/**
 * 
* @Description: 工作量管理
*
 */
@Controller
@RequestMapping("/manage/ad/workmanage")
public class AdWorkManageController extends BaseController {
	@Autowired
	private IAdWorkBuinsessService businessService;
	
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/ad/workmanage/list";
	}
	
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<WorkManageDTO> page = businessService.findAllByPage(paramsMap,Integer.valueOf(paramsMap.get("pageNum").toString()), Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}

	
	@RequestMapping("/toAdd")
	public String toAdd(Model model) {
		return "manage/ad/workmanage/add";
	}
	
}
