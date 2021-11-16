package com.reyzar.oa.controller.sale;

import java.util.Date;
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
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SaleTicketConfirmation;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleTicketConfirmationService;

@Controller
@RequestMapping("/manage/sale/ticketConfirmation")
public class saleTicketConfirmationController extends BaseController {

	private final Logger logger = Logger.getLogger(SaleProjectManageController.class);
	
	@Autowired
	private ISaleTicketConfirmationService iSaleTicketConfirmationService;
	

	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<SaleTicketConfirmation> page = iSaleTicketConfirmationService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}

	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id,Integer barginManageId, Model model) {
		if(id != null) {
			SaleTicketConfirmation saleTicketConfirmation=iSaleTicketConfirmationService.findById(id);
			if(saleTicketConfirmation!=null) {
				model.addAttribute("saleTicketConfirmation", saleTicketConfirmation);
			}
		}
		model.addAttribute("barginManageId", barginManageId);
		SysUser user = UserUtils.getCurrUser();
		model.addAttribute("createBy", user.getAccount());
		model.addAttribute("ticketUserId", user.getId());
		model.addAttribute("createDate", new Date());
		return "manage/sale/barginManage/addOrEditProcurement";
	}
	@RequestMapping(value="/submit", method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		CrudResultDTO result = iSaleTicketConfirmationService.save(json);
		return JSON.toJSONString(result);
	}
}	
