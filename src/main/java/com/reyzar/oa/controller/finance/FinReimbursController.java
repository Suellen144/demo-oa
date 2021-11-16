package com.reyzar.oa.controller.finance;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
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
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.FinInvest;
import com.reyzar.oa.domain.FinReimburse;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelReimbursHistory;
import com.reyzar.oa.domain.FinTravelreimburse;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.finance.IFinInvestService;
import com.reyzar.oa.service.finance.IFinReimbursService;
import com.reyzar.oa.service.finance.IFinTravelReimbursService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;
import com.reyzar.oa.service.sys.ISysUserService;

/**
 * 
* @Description: 通用报销
*
 */
@Controller
@RequestMapping("/manage/finance/reimburs")
public class FinReimbursController extends BaseController {
	
	private final Logger logger = Logger.getLogger(FinReimbursController.class);
	
	@Autowired
	private IFinReimbursService reimbursService;
	@Autowired
	private IFinTravelReimbursService travelReimbursService;
	@Autowired
	private IFinInvestService investService;
	@Autowired
	private ISysUserService iSysUserService;
	@Autowired
	private ISaleProjectManageService iSaleProjectManageService;
	
	//获取通用报销页面
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/finance/reimburs/list";
	}
	
	@RequestMapping("/toAdd")
	public String toAdd(Model model) {
		List<FinTravelReimbursHistory> travelReimbursHistoryList = travelReimbursService.getBankInfoByUserId(getUser().getId());
		List<FinTravelReimbursHistory>  banknumber = travelReimbursService.getMainBankInfo(getUser().getId(), 2);//查找用户最近的数据
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
		model.addAttribute("number", number);
		model.addAttribute("address", address);
		model.addAttribute("payee", payee);
		model.addAttribute("travelReimbursHistoryList", travelReimbursHistoryList);
		model.addAttribute("investList", investList);
		model.addAttribute("investListForJson", JSON.toJSONString(investList));
		
		return "manage/finance/reimburs/add";
	}
	
	
	@RequestMapping("/toEdit")
	public String toEdit(Integer id,String unbound  ,Model model) {
		FinReimburse reimburse = reimbursService.findById(id);
		List<FinReimburseAttach> reimburseAttachs = reimbursService.findById(id).getReimburseAttachList();
		List<FinTravelReimbursHistory> travelReimbursHistoryList = travelReimbursService.getBankInfoByUserId(getUser().getId());
		List<FinInvest> investList = investService.findAll();
		model.addAttribute("reimburse", reimburse);
		model.addAttribute("reimburseAttachs", reimburseAttachs);
		model.addAttribute("travelReimbursHistoryList", travelReimbursHistoryList);
		model.addAttribute("investList", investList);
		model.addAttribute("unbound", unbound);
		
		if(unbound != null && unbound != ""){
			
			return "manage/finance/reimburs/projectUnboundReimburs";
			
		}else{
			return "manage/finance/reimburs/edit";
		}
		
		
	}
	
	@RequestMapping(value="/unbound",method=RequestMethod.POST)
	@ResponseBody
	public String unbound(@RequestBody JSONObject json) throws ParseException {
		return JSON.toJSONString(reimbursService.unbound(json));
	}
	
	//获取通用报销List
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinReimburse> page = reimbursService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/getReimburse")
	@ResponseBody
	public String getReimburse(Integer id) {
		FinReimburse reimburse = new FinReimburse();
		if(id != null) {
			reimburse = reimbursService.findById(id);
		}
		return JSONObject.toJSONString(reimburse);
	}
	
	@RequestMapping("/validationByName")
	@ResponseBody
	public String validationByName(String name) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "");
		if(name != null) {
			List<SysUser> sysUsers= iSysUserService.findByName(name);
			if(sysUsers!=null && sysUsers.size()>0) {
				result.setCode(CrudResultDTO.SUCCESS);
			}else {
				result.setCode(CrudResultDTO.EXCEPTION);
			}
		}
		return JSONObject.toJSONString(result);
	}
	
	@RequestMapping("/getProjectById")
	@ResponseBody
	public String getProjectById(Integer id,Integer reimbursid,Integer travelreimburseid) {
		SaleProjectManage saleProjectManage=new SaleProjectManage();
		if(id != null) {
			saleProjectManage= iSaleProjectManageService.findByIdByCreateDate(id);
			//根据项目获取 该项目攻关费用余额
			FinTravelreimburse	finTravelreimburse = reimbursService.findByClearanceBeenTo(id,reimbursid,travelreimburseid);
			if(finTravelreimburse!=null && finTravelreimburse.getActReimburse() == null ) {
				finTravelreimburse.setActReimburse(0.0);
			}
			if(finTravelreimburse == null ) {
				finTravelreimburse=new FinTravelreimburse();
				finTravelreimburse.setActReimburse(0.0);
			}	
			if(saleProjectManage==null) {
				saleProjectManage=new SaleProjectManage();
				saleProjectManage.setResearchCostLinesBalance(100000000.0);
			}else {
				if(saleProjectManage.getResearchCostLines()!=null && saleProjectManage.getResearchCostLines()>=finTravelreimburse.getActReimburse()) {
					saleProjectManage.setResearchCostLinesBalance(saleProjectManage.getResearchCostLines()-finTravelreimburse.getActReimburse());
				}else {
					saleProjectManage.setResearchCostLinesBalance(0.0);
				}
			}
		}
		return JSONObject.toJSONString(saleProjectManage);
	}
	
	@RequestMapping("/getGroupBusinessSum")
	@ResponseBody
	public String getGroupBusinessSum(Integer id,Integer state) {
		List<Double> doubles=new ArrayList<Double>();
		Double business=0.0;
		SysUser user = UserUtils.getCurrUser();
		Calendar cale = Calendar.getInstance(); 
		int year = cale.get(Calendar.YEAR);
		String startDate=year+"-01-01 00:00:00";
		String endDate=year+1+"-01-01 00:00:00";
			//等于1则是通用报销，id则是通用报销的id
			if(state == 1) {
				Double actReimburse=reimbursService.findByIdAndUser(id, user.getId(),startDate,endDate);
				if(actReimburse!=null) {
					business=actReimburse;
				}
				
			}else if(state == 2) {
				Double actReimburse=travelReimbursService.findByIdAndUser(id, user.getId(),startDate,endDate);
				if(actReimburse!=null) {
					business=business+actReimburse;
				}
			}
			doubles.add(business);
			doubles.add(30000.0);
		return JSONObject.toJSONString(doubles);
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json){
		return JSON.toJSONString(reimbursService.save(json));
	}
	
	@RequestMapping(value="/submitinfo",method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		return JSON.toJSONString(reimbursService.submitinfo(json));
	}
	
	
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@RequestBody JSONObject json) throws ParseException {
		return JSON.toJSONString(reimbursService.saveOrUpdate(json));
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return reimbursService.setStatus(id, status);
	}
	
	@RequestMapping(value="/sendMail",method=RequestMethod.POST)
	public void sendMail(Integer id, String contents) {
		reimbursService.sendMailToApple(id, contents);
	}
	
	@RequestMapping("/setAssistantAffirm")
	@ResponseBody
	public CrudResultDTO setAssistantAffirm(Integer id, String assistantStatus) {
		return reimbursService.setAssistantAffirm(id, assistantStatus);
	}
	
	@RequestMapping("/getInvestList")
	@ResponseBody
	public List<FinInvest> getInvestList() {
		return investService.findAll();
	}
	
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
			logger.info(getUser().getName()+"删除了通用报销ID为"+id+"的附件");
			return reimbursService.deleteAttach(path, id);
	}
	
	@RequestMapping("/remove")
	@ResponseBody
	public CrudResultDTO remove(Integer id){
			return reimbursService.remove(id);
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
		return reimbursService.lock(json);
	}
	
	@RequestMapping("/getStatusById")
	@ResponseBody
	public String setStatus(Integer id) {
		return JSON.toJSONString(reimbursService.findById(id));
	}
}
