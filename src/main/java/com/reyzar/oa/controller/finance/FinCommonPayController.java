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
import com.reyzar.oa.domain.FinCommonPay;
import com.reyzar.oa.service.finance.IFinCommonPayService;


@Controller
@RequestMapping("/manage/finance/commonPay")
public class FinCommonPayController extends BaseController {
	
	private final Logger logger = Logger.getLogger(FinCommonPayController.class);

	@Autowired
	private IFinCommonPayService commonPayService; 
	
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/finance/commonPay/list";
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinCommonPay> page = commonPayService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id , Model model) {
		if (id != null ) {
			FinCommonPay commonPay = commonPayService.findById(id);
			model.addAttribute("commonPay", commonPay);
		}
		return "manage/finance/commonPay/addOrEdit";
	}
	
	
	@RequestMapping(value="/saveInfo", method=RequestMethod.POST)
	@ResponseBody
	public String saveInfo(@RequestBody JSONObject json) {
		CrudResultDTO result = commonPayService.saveInfo(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
			logger.info(getUser().getName()+"删除了常规付款ID为"+id+"的附件");
			return commonPayService.deleteAttach(path, id);
	}

	@RequestMapping("/delete")
	@ResponseBody
	public CrudResultDTO deleteById(Integer id){
		return commonPayService.deleteById(id);
	}
}
