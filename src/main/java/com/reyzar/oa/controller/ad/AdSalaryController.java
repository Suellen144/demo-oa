package com.reyzar.oa.controller.ad;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.reyzar.oa.domain.AdRecordSalaryHistory;
import com.reyzar.oa.service.ad.IAdRecordSalaryHistoryService;
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
import com.google.common.collect.Lists;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.WebUtil;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.AdSalary;
import com.reyzar.oa.domain.AdSalaryAttach;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.ad.IAdSalaryService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/manage/ad/salary")
public class AdSalaryController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdSalaryController.class);
	
	@Autowired
	private IAdSalaryService salaryService;
	@Autowired
	private IAdRecordService recordService;
	@Autowired
	private IAdRecordSalaryHistoryService salaryHistoryService;
	
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/ad/salary/list";
	}
	
	//获取通用报销List
	@RequestMapping("/getList")
	@ResponseBody
		public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
			Map<String, Object> paramsMap = parsePageMap(requestMap);
			
			Page<AdSalary> page = salaryService.findByPage(paramsMap, 
						Integer.valueOf(paramsMap.get("pageNum").toString()),
					Integer.valueOf(paramsMap.get("pageSize").toString()));
			
			Map<String, Object> jsonMap = buildTableData(paramsMap, page);
			return JSONObject.toJSONString(jsonMap);
		}
	
	@RequestMapping("/workingStateselectVal")
	@ResponseBody
	public List<AdRecord> workingStateselectVal(HttpServletRequest request, HttpServletResponse response, Model model) {
		List<AdRecord> recordList=salaryService.workingStateselectVal();
		return recordList;
	}
	
	@RequestMapping("/toAdd")
	public String toAdd(HttpServletRequest request,Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		
//		List<Integer> deptIdList = Lists.newArrayList();
//		deptIdList.add(2);
//		deptIdList.add(10);
//		deptIdList.add(3);
//		deptIdList.add(6);
//		deptIdList.add(5);
//		deptIdList.add(4);
//		deptIdList.add(20);
//		List<AdRecord> userList = recordService.findByDeptIds(deptIdList);
		
		param.put("entry_status", param.get("selectVal"));
		List<AdRecord> userList = recordService.findByDeptIds2(param);
		List<AdSalaryAttach> salaryAttachList = Lists.newArrayList();
		for (AdRecord adRecord : userList) {
			AdSalaryAttach attach = new AdSalaryAttach();
			AdRecordSalaryHistory salary = salaryHistoryService.findOne(adRecord.getUserId());
			attach.setSalary(salary);
			attach.setRecord(adRecord);
			salaryAttachList.add(attach);
		}
		model.addAttribute("salaryList", salaryAttachList);
		return "manage/ad/salary/add";
	}
	
	@RequestMapping("/toAdd2")
	public String toAdd2(Model model) {
		return "manage/ad/salary/add";
	}
	
	@RequestMapping("/initAddPageData")
	@ResponseBody
	public List<AdSalaryAttach> initAddPageData(HttpServletRequest request) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		param.put("entry_status", param.get("selectVal"));
		List<AdRecord> userList = recordService.findByDeptIds2(param);
		List<AdSalaryAttach> salaryAttachList = Lists.newArrayList();
		for (AdRecord adRecord : userList) {
			AdSalaryAttach attach = new AdSalaryAttach();
			AdRecordSalaryHistory salary = salaryHistoryService.findOne(adRecord.getUserId());
			attach.setSalary(salary);
			attach.setRecord(adRecord);
			salaryAttachList.add(attach);
		}
		return salaryAttachList;
	}

	@RequestMapping(value="/save", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json){
		return JSON.toJSONString(salaryService.save(json));
	}
	
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@RequestBody JSONObject json){
		return JSON.toJSONString(salaryService.update(json));
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return salaryService.setStatus(id, status);
	}
	
	/**
	* @Title: lock
	* @Description: 加密数据
	* @param json
	* @return CrudResultDTO
	 */
	@RequestMapping(value="/lock", method=RequestMethod.POST)
	@ResponseBody
	public CrudResultDTO lock(@RequestBody JSONObject json) {
		return salaryService.lock(json);
	}

	@RequestMapping("/exportExcel")
	@ResponseBody
	public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
		Map<String,Object> paramMap=parseRequestMap(request);
		String fileName = "调薪计划表格.xls";
		String agent = request.getHeader("USER-AGENT").toLowerCase();
		if (agent.contains("firefox")){
			response.setCharacterEncoding("UTF-8");
			fileName = new String(fileName.getBytes(),"ISO8859-1");
		} else {
			fileName = java.net.URLEncoder.encode(fileName,"UTF-8");
		}
		response.setContentType("application/vnd.ms-excel;charset=utf-8");
		response.addHeader("Content-Disposition","attachment;filenaem="+fileName);
		salaryService.exportExcel(response.getOutputStream(), paramMap);
	}
}