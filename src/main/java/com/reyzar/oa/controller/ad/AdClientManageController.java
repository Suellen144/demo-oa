package com.reyzar.oa.controller.ad;

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
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdClientManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.service.ad.IAdClientManageService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;

@Controller
@RequestMapping("/manage/ad/clientmanage")
public class AdClientManageController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdClientManageController.class);
	@Autowired
	private IAdClientManageService clientManageService;
	
	@Autowired
	private ISaleProjectManageService projectManageService;
	
	@RequestMapping("/toList")
	public String toList(Integer id,Model model) {
		return "manage/ad/clientmanage/list";
	}
	
	@RequestMapping("/getClientsList")
	@ResponseBody
	public String getClientsList(@RequestBody Map<String, Object> requestMap)
	{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<AdClientManage> page = clientManageService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()),  
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id,Model model) {
		if (id != null){
			AdClientManage clientManage = clientManageService.findById(id);
			if(clientManage.getProjectId()!=null){
				SaleProjectManage projectManage=projectManageService.findById(clientManage.getProjectId());
				model.addAttribute("projectManage", projectManage);
			}
			model.addAttribute("clientManage", clientManage);
		}
		return "manage/ad/clientmanage/addOrEdit";
	}
	
	@RequestMapping(value="/saveOrUpdate", method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@RequestBody JSONObject json) {
		return JSON.toJSONString(clientManageService.saveOrUpdate(json));
	}
	
	@RequestMapping(value="/delete")
	@ResponseBody
	public String delete(Integer id) {
		CrudResultDTO result = clientManageService.delete(id);
		return JSON.toJSONString(result);
	}
	
	
	@RequestMapping("/findByProjectId")
	@ResponseBody
	public String findByProjectId(Integer projectId) {
		CrudResultDTO result = clientManageService.findByProjectId(projectId); 
		return JSON.toJSONString(result);
	}

}