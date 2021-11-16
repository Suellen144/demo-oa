package com.reyzar.oa.controller.finance;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.FinInvest;
import com.reyzar.oa.service.finance.IFinInvestService;


/** 
* @ClassName: FinInvestController 
* @Description: 费用归属
* @author Lin 
* @date 2016年10月26日 上午10:11:54 
*  
*/
@Controller
@RequestMapping("/manage/finance/invest")
public class FinInvestController extends BaseController {
	
	@SuppressWarnings("unused")
	private final Logger logger = Logger.getLogger(FinInvestController.class);
	
	@Autowired
	private IFinInvestService investService;
	
	
	//获取通用报销页面
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/finance/invest/list";
	}
	
	//获取通用报销List
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinInvest> page = investService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Model model, @RequestParam(required=false) Integer id) {
		FinInvest invest = new FinInvest();
		if(id != null) {
			invest = investService.findById(id);
		}
		model.addAttribute("invest", invest);
		return "manage/finance/invest/addOrEdit";
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	@ResponseBody
	public String save(FinInvest invest){
		return JSON.toJSONString(investService.save(invest));
	}
	
	@RequestMapping(value="/delete")
	@ResponseBody
	public String delete(Integer id){
		return JSON.toJSONString(investService.delete(id));
	}
}
