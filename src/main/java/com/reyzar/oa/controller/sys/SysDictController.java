package com.reyzar.oa.controller.sys;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.domain.SysDictType;
import com.reyzar.oa.service.sys.ISysDictDataService;
import com.reyzar.oa.service.sys.ISysDictTypeService;

@Controller
@RequestMapping("/manage/sys/dict")
public class SysDictController extends BaseController {
	
	
	@Autowired
	private ISysDictTypeService typeService;
	
	@Autowired
	private ISysDictDataService dataService;
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/sys/dict/list";
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAdd(@RequestParam Integer id, Model model){
		SysDictData dictData= new SysDictData();
		if (id != null) {
			dictData = dataService.findById(id);
		}
		model.addAttribute("dictData",dictData);
		return "manage/sys/dict/addOrEdit";
	}
	
	@RequestMapping("/getTypeWithDataList")
	@ResponseBody
	public String getTypeWithDataList(HttpServletRequest request) {
		return JSON.toJSONString(typeService.getTypeList(request.getContextPath()));
	} 
	
	@RequestMapping("/getDataList")
	@ResponseBody
	public String getDataList(@RequestBody Map<String, Object> requestMap)
	{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<SysDictData> page = dataService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()),  
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/getData")
	@ResponseBody
	public String getData(Integer id)
	{
		return JSON.toJSONString(dataService.findById(id));
		
	}
	
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(SysDictType dictType) {
		CrudResultDTO result = typeService.save(dictType);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/savedata")
	@ResponseBody
	public String savedata(SysDictData dictData) {
		CrudResultDTO result = dataService.save(dictData);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(SysDictData dictData) {
		CrudResultDTO result = dataService.update(dictData);
		return JSON.toJSONString(result);
	}
	
	
	@RequestMapping("/delete")
	public void delete(@RequestParam Integer id, HttpServletResponse response) {
		CrudResultDTO result = typeService.deleteById(id);
		renderJSONString(response, result);
	}
	
	
	@RequestMapping("/deletedata")
	@ResponseBody
	public String deletedata(@RequestParam Integer id, HttpServletResponse response){
		CrudResultDTO result = dataService.updatebyId(id);
		return JSON.toJSONString(result);
		
	}
}