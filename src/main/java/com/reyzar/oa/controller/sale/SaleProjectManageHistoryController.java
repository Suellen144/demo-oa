package com.reyzar.oa.controller.sale;

import java.util.List;

import org.apache.ibatis.annotations.Param;
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
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SaleProjectManageHistory;
import com.reyzar.oa.service.sale.ISaleProjectManageHistoryService;

@Controller
@RequestMapping("/manage/sale/projectManageHistory")
public class SaleProjectManageHistoryController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SaleProjectManageHistoryController.class);
	
	@Autowired
	private ISaleProjectManageHistoryService projectManageHistoryService;
	
	@RequestMapping("/setStatusNew")
	@ResponseBody
	public CrudResultDTO setStatusNew(Integer id, String status) {
		return projectManageHistoryService.setStatusNew(id, status);
	}
	
	@RequestMapping(value="/saveInfo", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		CrudResultDTO result = projectManageHistoryService.save(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/submit", method=RequestMethod.POST)
	@ResponseBody
	public String modify(@RequestBody JSONObject json) {
		
		CrudResultDTO result = projectManageHistoryService.submit(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/getHistory")
	public String getHistory(Integer id,Model model) {
		
		List<SaleProjectManageHistory> projectHistoryList = projectManageHistoryService.findByProjectId(id);
		model.addAttribute("projectHistoryList", projectHistoryList);
		
		return "manage/sale/projectManageNew/changeHistory";
	}	
	@RequestMapping("/getHistoryValidation")
	@ResponseBody
	public String getHistoryValidation(Integer id)throws JsonProcessingException {
		boolean isok=false;
		if(id!=null) {
			List<SaleProjectManageHistory> projectHistoryList = projectManageHistoryService.findByProjectId(id);
			if(projectHistoryList!=null && projectHistoryList.size()>0) {
				isok=true;
			}
		}
		return JSONObject.toJSONString(isok);
	}
	@RequestMapping("/getHistoryValidationIsApply")
	@ResponseBody
	public String getHistoryValidationIsApply(Integer id)throws JsonProcessingException {
		boolean isok=false;
		if(id!=null) {
			List<SaleProjectManageHistory> projectHistoryList = projectManageHistoryService.findByProjectId(id);
			if(projectHistoryList!=null && projectHistoryList.size()>0) {
				for (int i = 0; i < projectHistoryList.size(); i++) {
					if(projectHistoryList.get(i).getStatusNew() ==5 || projectHistoryList.get(i).getStatusNew() == 6) {
						isok=true;
					}
				}
			}else {
				isok=true;
			}
		}
		return JSONObject.toJSONString(isok);
	}
	@RequestMapping("/sendMail")
	@ResponseBody
	public CrudResultDTO sendMailModify(@Param("id")Integer id,
								  @Param("comment")String comment){
		CrudResultDTO result = projectManageHistoryService.sendMail(id,comment);
		return result;
	}
}