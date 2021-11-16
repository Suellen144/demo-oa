package com.reyzar.oa.controller.finance;

import java.util.Map;
import javax.servlet.http.HttpServletResponse;

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
import com.reyzar.oa.common.dto.ReimburseDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.service.finance.IFinReimbursService;

/**
 * 
* @Description: 报销管理
*
 */
@Controller
@RequestMapping("/manage/finance/management")
public class FinReimbursManagementController extends BaseController {
	
	@SuppressWarnings("unused")
	private final Logger logger = Logger.getLogger(FinReimbursManagementController.class);
	
	@Autowired
	private IFinReimbursService reimbursService;
	
	//获取报销管理页面
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/finance/management/list";
	}
	
	
	//获取个人报销申请页面
	@RequestMapping("/toShow")
	public String toMe(Model model){
		return "manage/finance/management/show";
	}
	
	//获取报销List
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<ReimburseDTO> page = reimbursService.findAllByPage(paramsMap,Integer.valueOf(paramsMap.get("pageNum").toString()), Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	//获取与项目关联的报销List  
	@RequestMapping("/initTable")
	@ResponseBody
	public String initTable(Integer id ) throws JsonProcessingException{
		
		CrudResultDTO dto = reimbursService.initFindAllByProjectId(id);
		
		
		return JSON.toJSONString(dto);
	}
	
	//查询是否有与项目关联的报销单
	@RequestMapping("/findAllByProjectId")
	@ResponseBody
	public String findAllByProjectId(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<ReimburseDTO> page = reimbursService.findAllByProjectId(paramsMap,Integer.valueOf(paramsMap.get("pageNum").toString()), Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	
	//获取报销List
	@RequestMapping("/showList")
	@ResponseBody
	public String showList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<ReimburseDTO> page = reimbursService.findMeByPage(paramsMap,Integer.valueOf(paramsMap.get("pageNum").toString()), Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	
	//获取报销List
	@RequestMapping("/showSize")
	@ResponseBody
	public void showSize(HttpServletResponse response){
		 renderJSONString(response, reimbursService.showSize());
	}
	
	@RequestMapping("/toAdd")
	public String toAdd(Model model) {
		return "manage/finance/management/add";
	}
	
}
