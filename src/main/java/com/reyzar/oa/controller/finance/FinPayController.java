package com.reyzar.oa.controller.finance;

import java.util.Map;

import com.reyzar.oa.common.util.UserUtils;
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
import com.reyzar.oa.domain.FinPay;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.service.finance.FinPayService;
import com.reyzar.oa.service.sale.ISaleBarginManageService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.Null;


@Controller
@RequestMapping("/manage/finance/pay")
public class FinPayController extends BaseController {
	
	private final Logger logger = Logger.getLogger(FinPayController.class);

	@Autowired
	private FinPayService finPayService;
	
	@Autowired
	private ISaleBarginManageService saleBarginManageService;
	
	@Autowired
	private ISaleProjectManageService saleProjectManageService;
	
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/finance/pay/list";
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinPay> page = finPayService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	/**
	    *  新项目模块
	 * @param requestMap
	 * @return
	 * @throws JsonProcessingException
	 */
	@RequestMapping("/getListNew")
	@ResponseBody
	public String getListNew(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinPay> page = finPayService.findByPageNew(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer barginManageId ,Integer id , Model model, HttpServletRequest request,Integer projectId) {
		FinPay finPay = new FinPay();
		if(id!=null) {
			finPay = finPayService.findById(id);	
			if(finPay!=null && finPay.getBarginManageId()!=null && barginManageId==null) {
				barginManageId=finPay.getBarginManageId();
			}
		}
		if(barginManageId!=null) {
			SaleBarginManage barginManage = saleBarginManageService.findById(barginManageId);
			finPay.setBarginManage(barginManage);
			if(barginManage!=null && barginManage.getProjectManageId()!=null) {
				finPay.setBarginManageId(barginManage.getId());
				finPay.setTotalMoney(barginManage.getTotalMoney());
				SaleProjectManage project = saleProjectManageService.findById(barginManage.getProjectManageId());
				if(project!=null) {
					finPay.setProjectManage(project);
					finPay.setProjectManageId(project.getId());
				}
			}
		}
		if(projectId != null) {
			SaleProjectManage project = saleProjectManageService.findById(projectId);
			if(project!=null) {
				finPay.setProjectManage(project);
				finPay.setProjectManageId(project.getId());
			}
		}
		model.addAttribute("finPay", finPay);
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		if (ismobile) {
			return "manage/finance/pay/mobileaddoredit";
		}else{
			return "manage/finance/pay/addOrEdit";
		}
	}
	@RequestMapping(value="/saveInfo", method=RequestMethod.POST)
	@ResponseBody
	public String saveInfo(@RequestBody JSONObject json) {
		CrudResultDTO result = finPayService.saveInfo(json);
		
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/submit", method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		
		CrudResultDTO result = finPayService.submit(json);
		return JSON.toJSONString(result);
	}
		
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(@RequestBody JSONObject json) {
		CrudResultDTO result = finPayService.delete(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return finPayService.setStatus(id, status);
	}
	
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
			logger.info(getUser().getName()+"删除了付款ID为"+id+"的附件");
			return finPayService.deleteAttach(path, id);
	}
	
	//查找与合同关联的已审批完成的付款流程在合同详情页面展示
	@RequestMapping("/findPayInfo")
	@ResponseBody
	public CrudResultDTO findPayInfo(Integer barginManageId , String  status ) {
		return finPayService.findPayInfo(barginManageId ,status);
	}
	
	@RequestMapping(value="/sendMail",method=RequestMethod.POST)
	public void sendMail(Integer id, String contents) {
		finPayService.sendMailToApple(id, contents);
	}
	
	@RequestMapping("/getTaskNext")
	@ResponseBody
	public CrudResultDTO getTaskNext(String taskId) {
		return finPayService.getTaskNext(taskId);
	}
}
