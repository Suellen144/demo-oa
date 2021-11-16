package com.reyzar.oa.controller.finance;

import java.util.Map;

import org.apache.log4j.Logger;
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
import com.reyzar.oa.domain.FinCommonReceived;
import com.reyzar.oa.service.finance.IFinCommonReceivedService;

@Controller
@RequestMapping("/manage/finance/commonReceived")
public class FinCommonReceivedController extends BaseController {
	
	private final Logger logger = Logger.getLogger(FinCommonReceivedController.class);
	@Autowired
	private IFinCommonReceivedService  commonReceivedService;
	
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/finance/commonReceived/list";
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinCommonReceived> page = commonReceivedService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id , Model model) {
		if (id != null ) {
			FinCommonReceived commonReceived = commonReceivedService.findById(id);
			model.addAttribute("commonReceived", commonReceived);
		}
		return "manage/finance/commonReceived/addOrEdit";
	}
	
	@RequestMapping(value="/saveInfo", method=RequestMethod.POST)
	@ResponseBody
	public String saveInfo(@RequestBody JSONObject json) {
		CrudResultDTO result = commonReceivedService.saveInfo(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
			logger.info(getUser().getName()+"删除了常规收款ID为"+id+"的附件");
			return commonReceivedService.deleteAttach(path, id);
	}

	@RequestMapping("/delete")
	@ResponseBody
	public CrudResultDTO deleteById(Integer id){
		return commonReceivedService.deleteById(id);
	}
}