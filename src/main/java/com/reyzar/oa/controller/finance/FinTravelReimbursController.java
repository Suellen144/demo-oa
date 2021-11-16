package com.reyzar.oa.controller.finance;

import java.text.ParseException;
import java.util.List;
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
import com.google.common.collect.Lists;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdTravel;
import com.reyzar.oa.domain.FinInvest;
import com.reyzar.oa.domain.FinTravelReimbursHistory;
import com.reyzar.oa.domain.FinTravelreimburse;
import com.reyzar.oa.domain.FinTravelreimburseAttach;
import com.reyzar.oa.service.ad.IAdTravelService;
import com.reyzar.oa.service.finance.IFinInvestService;
import com.reyzar.oa.service.finance.IFinTravelReimbursService;

/**
 * 
* @Description: 出差报销
*
 */
@Controller
@RequestMapping("/manage/finance/travelReimburs")
public class FinTravelReimbursController extends BaseController {
	
	private final Logger logger = Logger.getLogger(FinTravelReimbursController.class);
	
	@Autowired
	private IFinTravelReimbursService travelReimbursService;
	@Autowired
	private IFinInvestService investService;
	@Autowired
	private IAdTravelService travelService;
	
	//获取出差报销页面
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/finance/travelReimburs/list";
	}
	
	@RequestMapping("/toAdd")
	public String toAdd(Model model) {
		
		List<FinTravelReimbursHistory> travelReimbursHistoryList = travelReimbursService.getBankInfoByUserId(getUser().getId());
		List<FinTravelReimbursHistory> banknumber = travelReimbursService.getMainBankInfo(getUser().getId(), 2);
		List<FinTravelReimbursHistory> bankaddress = travelReimbursService.getMainBankInfo(getUser().getId(), 1);
		List<FinTravelReimbursHistory> payees = travelReimbursService.getMainBankInfo(getUser().getId(), 0);
		String number="",address="",payee="";
		if (banknumber.size() != 0) {
				number = banknumber.get(0).getValue();
		}
		if (bankaddress.size() != 0) {
			address = bankaddress.get(0).getValue();
		} 
		if (payees.size() != 0) {
			payee = payees.get(0).getValue();
		} 
		List<FinInvest> investList = investService.findAll();
		model.addAttribute("travelReimbursHistoryList", travelReimbursHistoryList);
		model.addAttribute("number", number);
		model.addAttribute("address", address);
		model.addAttribute("payee", payee);
		model.addAttribute("investList", investList);
		model.addAttribute("investListForJson", JSON.toJSONString(investList));
		return "manage/finance/travelReimburs/add";
	}
	
	
	@RequestMapping("/toEdit")
	public String toEdit(Integer id, String unbound,Model model) {
		FinTravelreimburse travelreimburse = travelReimbursService.findById(id);
		List<FinTravelreimburseAttach> travelreimburseAttachs = travelReimbursService.findById(id).getTravelreimburseAttachList();
		List<FinTravelReimbursHistory> travelReimbursHistoryList = travelReimbursService.getBankInfoByUserId(getUser().getId());
		List<FinInvest> investList = investService.findAll();
//		FinInvest invest = investService.findById(travelReimbursService.findById(id).getInvestId());
		String travelIds = travelReimbursService.findById(id).getTravelId();
		if (travelIds != null && !travelIds.equals("")) {
			List<AdTravel>  travels  = travelService.findByIds(travelIds);
			List<String> travelProcessInstanceIds = Lists.newArrayList();
			for (AdTravel travel : travels) {
				travelProcessInstanceIds.add(travel.getProcessInstanceId());
			}
			model.addAttribute("travels", travels);
			model.addAttribute("travelProcessInstanceIds", travelProcessInstanceIds);
		}
		
		model.addAttribute("travelreimburse", travelreimburse);
		model.addAttribute("travelReimbursHistoryList", travelReimbursHistoryList);
//		model.addAttribute("invest", invest);
		model.addAttribute("investList", investList);
		model.addAttribute("travelreimburseAttachs", travelreimburseAttachs);
		model.addAttribute("investListForJson", JSON.toJSONString(investList));
		model.addAttribute("unbound", unbound);
		
		if(unbound != null && unbound != ""){
			
			return "manage/finance/travelReimburs/projectUnboundReimburs";
			
		}else{
			return "manage/finance/travelReimburs/edit";
		}
	}
	
	//获取报销List
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<FinTravelreimburse> page = travelReimbursService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	// 获取银行历史数据
	@RequestMapping("/getBankInfo")
	@ResponseBody
	public String getBankInfo(Integer userId) {
		List<FinTravelReimbursHistory> travelReimbursHistoryList = travelReimbursService.getBankInfoByUserId(userId);
		return JSONObject.toJSONString(travelReimbursHistoryList);
	}
	
	@RequestMapping(value="/unbound",method=RequestMethod.POST)
	@ResponseBody
	public String unbound(@RequestBody JSONObject json) {
		return JSON.toJSONString(travelReimbursService.unbound(json));
	}
	
	@RequestMapping(value="/save",method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		return JSON.toJSONString(travelReimbursService.save(json));
	}
	
	@RequestMapping(value="/remove",method=RequestMethod.POST)
	@ResponseBody
	public String remove(Integer id) {
		return JSON.toJSONString(travelReimbursService.remove(id));
	}
	
	@RequestMapping(value="/submitinfo",method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		return JSON.toJSONString(travelReimbursService.submitinfo(json));
	}
	
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@RequestBody JSONObject json) throws ParseException {
		return JSON.toJSONString(travelReimbursService.saveOrUpdate(json));
	}
	
	@RequestMapping("/setAssistantAffirm")
	@ResponseBody
	public CrudResultDTO setAssistantAffirm(Integer id, String assistantStatus) {
		return travelReimbursService.setAssistantAffirm(id, assistantStatus);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return travelReimbursService.setStatus(id, status);
	}
	
	@RequestMapping(value="/saveBankInfo",method=RequestMethod.POST)
	public void saveBankInfo(FinTravelreimburse travelReimburse) {
		travelReimbursService.saveBankInfo(travelReimburse.getUserId(), travelReimburse.getPayee(), 
				travelReimburse.getBankAccount(), travelReimburse.getBankAddress());
	}
	
	@RequestMapping(value="/sendMail",method=RequestMethod.POST)
	public void sendMail(Integer id, String contents) {
		travelReimbursService.sendMailToApple(id, contents);
	}
	
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
			logger.info(getUser().getName()+"删除了差旅报销ID为"+id+"的附件");
			return travelReimbursService.deleteAttach(path, id);
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
		return travelReimbursService.lock(json);
	}
	
	
	@RequestMapping(value="/getTravelProcessInstanceIds")
	@ResponseBody
	public CrudResultDTO getTravelProcessInstanceIds( String ids) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功");
		List<AdTravel> adTravels = travelService.findByIds(ids);
		List<String> travelProcessInstanceIds = Lists.newArrayList();
		for (AdTravel travel : adTravels) {
			travelProcessInstanceIds.add(travel.getProcessInstanceId());
		}
		result.setResult(travelProcessInstanceIds);
		return result;
	}
	
	@RequestMapping("/getStatusById")
	@ResponseBody
	public String setStatus(Integer id) {
		return JSON.toJSONString(travelReimbursService.findById(id));
	}
}
