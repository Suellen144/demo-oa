package com.reyzar.oa.controller.sale;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.reyzar.oa.domain.SysUser;
import org.apache.ibatis.annotations.Param;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
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
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinPay;
import com.reyzar.oa.domain.FinReimburse;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelreimburse;
import com.reyzar.oa.domain.FinTravelreimburseAttach;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SaleProjectManageHistory;
import com.reyzar.oa.domain.SaleProjectMember;
import com.reyzar.oa.domain.SaleProjectMemberHistory;
import com.reyzar.oa.domain.SaleResearchRecord;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.service.finance.IFinReimbursService;
import com.reyzar.oa.service.finance.IFinTravelReimbursService;
import com.reyzar.oa.service.sale.ISaleBarginManageService;
import com.reyzar.oa.service.sale.ISaleProjectManageHistoryService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;
import com.reyzar.oa.service.sale.ISaleProjectMemberHistoryService;
import com.reyzar.oa.service.sale.ISaleProjectMemberService;
import com.reyzar.oa.service.sale.ISaleResearchRecordService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Controller
@RequestMapping("/manage/sale/projectManage")
public class SaleProjectManageController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SaleProjectManageController.class);
	
	@Autowired
	private ISaleProjectManageService projectManageService;
	
	@Autowired
	private ISaleBarginManageService saleBarginManageService;
	
	@Autowired
	private ISysDeptService deptService;
	
	@Autowired
	private IFinReimbursService finReimbursService;
	
	@Autowired
	private IFinTravelReimbursService finTravelReimbursService;
	
	@Autowired
	private ISaleResearchRecordService saleResearchRecordService;
	
	@Autowired
	private  ISaleProjectMemberService saleProjectMemberService;
	
	@Autowired
	private  ISaleProjectMemberHistoryService iSaleProjectMemberHistoryService;
	
	@Autowired
	private  IFinReimbursService iFinReimbursService;
	
	@Autowired
	private ISaleProjectManageHistoryService iSaleProjectManageHistoryService;
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/sale/projectManage/list";
	}
	
	@RequestMapping("/toListNew")
	public String toListNew() {
		return "manage/sale/projectManageNew/list";
	}

	@RequestMapping("/getParentDeptName")
	@ResponseBody
	public String getParentDeptName(Integer principalDeptId)throws JsonProcessingException {
		SysDept sysDept = new SysDept();
		if(principalDeptId != null) {
			sysDept = projectManageService.findDeptByDeptId(principalDeptId);
			if(sysDept != null && sysDept.getParentId() == 3) {
				sysDept = projectManageService.findDeptByDeptId(sysDept.getParentId());
				return JSONObject.toJSONString(sysDept);
			}
		}
		return null;
	}
	
	@RequestMapping("/getListHistory")
	@ResponseBody
	public String getListHistory(Integer projectIdHistory)throws JsonProcessingException {
		List<SaleProjectMemberHistory> saleProjectMemberHistory=new ArrayList<SaleProjectMemberHistory>();
		if(projectIdHistory!=null) {
		SaleProjectManageHistory saleProjectManageHistory=iSaleProjectManageHistoryService.findById(projectIdHistory);
			//根据 项目id获取项目成员信息，并渲染
			if(saleProjectManageHistory!=null ) {
				//根据项目id获取项目成员集合
				saleProjectMemberHistory=iSaleProjectMemberHistoryService.findByProjectId(saleProjectManageHistory.getId());
			}
		}	
		return JSONObject.toJSONString(saleProjectMemberHistory);
	}
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(Integer projectId)throws JsonProcessingException {
		List<SaleProjectMember> saleProjectMembers=new ArrayList<SaleProjectMember>();
		if(projectId!=null) {
		SaleProjectManage saleProjectManage=projectManageService.findById(projectId);
			//根据 项目id获取项目成员信息，并渲染
			if(saleProjectManage!=null ) {
				//根据项目id获取项目成员集合
				saleProjectMembers=saleProjectMemberService.findByProjectId(saleProjectManage.getId());
			}
		}	
		return JSONObject.toJSONString(saleProjectMembers);
	}
	@RequestMapping("/getContractAmount")
	@ResponseBody
	public String getContractAmount(Integer projectId)throws JsonProcessingException {
		SaleBarginManage saleBarginManage=new SaleBarginManage();
		if(projectId!=null) {
			 saleBarginManage=saleBarginManageService.findByContractAmount(projectId);
			 if(saleBarginManage!=null && saleBarginManage.getTotalMoney() == null) {
				 saleBarginManage.setTotalMoney(0.0);
				 saleBarginManage.setChannelExpense(0.0);
			 }
		}else {
			saleBarginManage.setTotalMoney(0.0);
			saleBarginManage.setChannelExpense(0.0);
		}
		return JSONObject.toJSONString(saleBarginManage);
	}
	@RequestMapping("/getIncome")
	@ResponseBody
	public String getIncome(Integer projectId)throws JsonProcessingException {
		SaleBarginManage saleBarginManage=new SaleBarginManage();
		if(projectId!=null) {
			 saleBarginManage=saleBarginManageService.findByIncome(projectId);
			 if(saleBarginManage!=null && saleBarginManage.getConfirmAmount() == null) {
				 saleBarginManage.setConfirmAmount(0.0);
				 saleBarginManage.setResultsAmount(0.0);
			 }
		}else {
			saleBarginManage.setConfirmAmount(0.0);
			saleBarginManage.setResultsAmount(0.0);
		}
		return JSONObject.toJSONString(saleBarginManage);
	}
	@RequestMapping("/getExpenditure")
	@ResponseBody
	public String getExpenditure(Integer projectId)throws JsonProcessingException {
		FinTravelreimburse finTravelreimburse=new FinTravelreimburse();
		if(projectId!=null) {
			finTravelreimburse = iFinReimbursService.findByExpenditure(projectId);
			if(finTravelreimburse!=null && finTravelreimburse.getActReimburse() == null ) {
				finTravelreimburse.setActReimburse(0.0);
			}
		}else {
			finTravelreimburse.setActReimburse(0.0);
		}
		return JSONObject.toJSONString(finTravelreimburse);
	}
	@RequestMapping("/getClearanceBeen")
	@ResponseBody
	public String getClearanceBeen(Integer projectId) throws JsonProcessingException {
		FinTravelreimburse finTravelreimburse=new FinTravelreimburse();
		if(projectId!=null) {
			finTravelreimburse = iFinReimbursService.findByClearanceBeen(projectId);
			if(finTravelreimburse!=null && finTravelreimburse.getActReimburse() == null ) {
				finTravelreimburse.setActReimburse(0.0);
			}
		}else {
			finTravelreimburse.setActReimburse(0.0);
		}
		return JSONObject.toJSONString(finTravelreimburse);
	}
	@RequestMapping("/getChannelHave")
	@ResponseBody
	public String getChannelHave(Integer projectId)throws JsonProcessingException {
		SaleBarginManage saleBarginManage=new SaleBarginManage();
		if(projectId!=null) {
			 saleBarginManage=saleBarginManageService.findByChannelHave(projectId);
			 if(saleBarginManage!=null && saleBarginManage.getChannelCost() == null) {
				 saleBarginManage.setChannelCost(0.0);
			 }
		}else {
			saleBarginManage.setChannelCost(0.0);
		}
		return JSONObject.toJSONString(saleBarginManage);
	}
	@RequestMapping("/getProjectList")
	@ResponseBody
	public String getProjectList(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("sale:projectmanage:seeall")) {
			paramsMap.put("seeall", true);
		} else {
			paramsMap.put("seeall", false);
			List<SysDept> deptList = deptService.getDeptLink(getUser().getDeptId());
			List<Integer> idList = Lists.newArrayList();
			for(SysDept dept : deptList) {
				idList.add(dept.getId());
			}
			
			StringBuffer sb = new StringBuffer();
			if(idList.size() > 1) {
				for(Integer id : idList) {
					sb.append(id).append(",");
				}
				sb.delete(sb.length()-1, sb.length());
			} else if(idList.size() == 1) {
				sb.append(idList.get(0));
			}
			
			paramsMap.put("deptIdList", sb.toString());
		}
		paramsMap.put("statusNew", 5);
		
		Page<SaleProjectManage> page = projectManageService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/getProjectList2")
	@ResponseBody
	public String getProjectList2(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("sale:projectmanage:seeall")) {
			paramsMap.put("seeall", true);
		} else {
			paramsMap.put("seeall", false);
			List<SysDept> deptList = deptService.getDeptLink(getUser().getDeptId());
			List<Integer> idList = Lists.newArrayList();
			for(SysDept dept : deptList) {
				idList.add(dept.getId());
			}
			
			StringBuffer sb = new StringBuffer();
			if(idList.size() > 1) {
				for(Integer id : idList) {
					sb.append(id).append(",");
				}
				sb.delete(sb.length()-1, sb.length());
			} else if(idList.size() == 1) {
				sb.append(idList.get(0));
			}
			
			paramsMap.put("deptIdList", sb.toString());
		}
		
		
		Page<SaleProjectManage> page = projectManageService.findByPage2(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/getAllProject")
	@ResponseBody
	public String getAllProject(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("sale:projectmanage:seeall")) {
			paramsMap.put("seeall", true);
		} else {
			paramsMap.put("seeall", false);
			List<SysDept> deptList = deptService.getDeptLink(getUser().getDeptId());
			List<Integer> idList = Lists.newArrayList();
			for(SysDept dept : deptList) {
				idList.add(dept.getId());
			}
			
			StringBuffer sb = new StringBuffer();
			if(idList.size() > 1) {
				for(Integer id : idList) {
					sb.append(id).append(",");
				}
				sb.delete(sb.length()-1, sb.length());
			} else if(idList.size() == 1) {
				sb.append(idList.get(0));
			}
			
			paramsMap.put("deptIdList", sb.toString());
		}		
		
		Page<SaleProjectManage> page = projectManageService.findAll(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(@RequestParam Integer id, Model model) {
		if(id != null) {
			SaleProjectManage project = projectManageService.findById(id);
			List<SaleBarginManage> barginManages = saleBarginManageService.findByProjectManageId(id);
			for (SaleBarginManage saleBarginManage : barginManages) {
				double receivedMoney = 0;
				double payMoney = 0;
				if((saleBarginManage.getReceivedMoney() == null || saleBarginManage.getReceivedMoney() == 0) && saleBarginManage.getCollectionList().size() > 0) {
					for (FinCollection finCollection : saleBarginManage.getCollectionList()) {
						if(finCollection.getApplyPay()!=null&&!"".equals(finCollection.getApplyPay()))
						receivedMoney += Double.parseDouble(finCollection.getApplyPay());
						else
							receivedMoney += finCollection.getBill();
					}
					saleBarginManage.setReceivedMoney(receivedMoney);
				}
				if((saleBarginManage.getPayMoney() == null || saleBarginManage.getPayMoney() == 0) && saleBarginManage.getPayList().size() > 0) {
					for (FinPay finPay : saleBarginManage.getPayList()) {
						payMoney += finPay.getPayBill();
					}
					saleBarginManage.setPayMoney(payMoney);
				}
			}
			model.addAttribute("project", project);
			model.addAttribute("barginManages", barginManages);
		}
		return "manage/sale/projectManage/addOrEdit";
	}
	
	
	@RequestMapping(value="/saveInfo", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		CrudResultDTO result = projectManageService.save(json, getUser());
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/saveInfoOld", method=RequestMethod.POST)
	@ResponseBody
	public String saveInfoOld(@RequestBody JSONObject json) {
		CrudResultDTO result = projectManageService.saveInfoOld(json, getUser());
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/submit", method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		
		CrudResultDTO result = projectManageService.submit(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public String setStatus(Integer id,String status) {
		CrudResultDTO result = null;
		if ( status != null &&  !status.equals("") && status.equals("-1")) {
			
			//注销，开启关闭按钮处理，注销时，判断是否有关联的报销单
			List<FinReimburseAttach> reimburseAttachs = finReimbursService.findByProjectId(id);
			List<FinTravelreimburseAttach> travelreimburseAttachs = finTravelReimbursService.findByProjectId(id);
			
			int num = 0;
			
			if(reimburseAttachs  != null && !reimburseAttachs.equals("") && reimburseAttachs.size()>0){
				for (FinReimburseAttach finReimburseAttach : reimburseAttachs) {
					FinReimburse finReimburses = finReimbursService.findById(finReimburseAttach.getReimburseId());
					String status2 = finReimburses.getStatus();
					if( status2 !=null && !status2.equals("") && !status2.equals("7")){
						num = num +1;
					}
				}
			}
			
			if(travelreimburseAttachs  != null && !travelreimburseAttachs.equals("") && travelreimburseAttachs.size()>0){
				for (FinTravelreimburseAttach finTravelreimburseAttach : travelreimburseAttachs) {
					FinTravelreimburse finTravelreimburse = finTravelReimbursService.findById(finTravelreimburseAttach.getTravelreimburseId());
					String status2 = finTravelreimburse.getStatus();
					if( status2 !=null && !status2.equals("") && !status2.equals("7")){
						num = num +1;
					}
				}
			}
			
			if(num > 0){
				result = new CrudResultDTO(CrudResultDTO.SUCCESS,id); 
			}else {
				result = projectManageService.setStatus(id,status);
			}
			
		}else {
			result = projectManageService.setStatus(id,status);
			
		}
		
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/cancel")
	public String cancel(Integer id,Model model) {
		model.addAttribute("id", id);
		return "manage/sale/projectManage/cancel";
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(Integer id) {
		CrudResultDTO result = projectManageService.delete(id);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
		Map<String, Object> paramMap = parseRequestMap(request);
		String fileName = "项目详情.xls";
		String agent = request.getHeader("USER-AGENT").toLowerCase();
		if (agent.contains("firefox")) {
			response.setCharacterEncoding("UTF-8");
			fileName = new String(fileName.getBytes(), "ISO8859-1");
		} else {
			fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
		}
		
		response.setContentType("application/vnd.ms-excel; charset=utf-8");  
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
        
        projectManageService.exportExcel(response.getOutputStream(), paramMap);
	}
	
/*	@RequestMapping("/toAdd")
	public String toAdd() {
		return "manage/sale/projectManageNew/add";
	}*/
	
	@RequestMapping("/toEdit")
	public String toEdit(Integer id, Model model) {
		SaleProjectManage saleProjectManage=new SaleProjectManage();
		if(id!=null) {
			 saleProjectManage = projectManageService.findById(id);
		}else {
			saleProjectManage.setApplicantP(getUser());
			saleProjectManage.setDeptA(getUser().getDept());
		}
		model.addAttribute("saleProjectManage", saleProjectManage);
		return "manage/sale/projectManageNew/addOrEdit";
	}
	
	@RequestMapping("/toProcess")
	public String toProcess(Integer id, Model model) {
		SaleProjectManage saleProjectManage=new SaleProjectManage();
		if(id!=null) {
			 saleProjectManage = projectManageService.findById(id);
		}else {
			saleProjectManage.setApplicantP(getUser());
			saleProjectManage.setDeptA(getUser().getDept());
		}
		Map<String, Object> jsonMap = Maps.newHashMap();
		Map<String, Object> variables = Maps.newHashMap();
		jsonMap.put("business", JSON.toJSON(saleProjectManage));
		jsonMap.put("variables", variables);
		Map<String, Object> result = Maps.newHashMap();
		result.put("business", saleProjectManage);
		result.put("variables", variables);
		result.put("jsonMap", jsonMap);
		Map<String, Object> map =result;
		model.addAttribute("map", map);
		return "manage/sale/projectManageNew/process";
	}
	
	@RequestMapping("/setStatusNew")
	@ResponseBody
	public CrudResultDTO setStatusNew(Integer id, String status) {
		return projectManageService.setStatusNew(id, status);
	}
	
/*	@RequestMapping("/findInfo")
	public String findInfo(Integer id, Model model) {
		
		List<String> barginId = new ArrayList<String>();
		SaleProjectManage project = projectManageService.findById(id);
		List<SaleBarginManage> barginManages = saleBarginManageService.findByProjectManageId(id);
		List<FinReimburseAttach> finReimburseAttach = finReimbursService.findByProjectId(id);
		List<ReimburseDTO> reimburs = finReimbursService.findAllByProjectIdAndStatus(id);
		
		for (SaleBarginManage saleBarginManage : barginManages) {
			barginId.add(saleBarginManage.getId().toString());
		}
		List<FinRevenueRecognition> finRevenueRecognition = null;
		if(barginId.size() > 0) {
			finRevenueRecognition = finRevenueRecognitionService.findBybarginIds(barginId);
		}
		for (SaleBarginManage saleBarginManage : barginManages) {
			double receivedMoney = 0;
			double payMoney = 0;
			if((saleBarginManage.getReceivedMoney() == null || saleBarginManage.getReceivedMoney() == 0) && saleBarginManage.getCollectionList().size() > 0) {
				for (FinCollection finCollection : saleBarginManage.getCollectionList()) {
					if(finCollection.getApplyPay() != null && !"".equals(finCollection.getApplyPay()))
					receivedMoney += Double.parseDouble(finCollection.getApplyPay());
					else
						receivedMoney += finCollection.getBill();
				}
				saleBarginManage.setReceivedMoney(receivedMoney);
			}
			if((saleBarginManage.getPayMoney() == null || saleBarginManage.getPayMoney() == 0) && saleBarginManage.getPayList().size() > 0) {
				for (FinPay finPay : saleBarginManage.getPayList()) {
					payMoney += finPay.getPayBill();
				}
				saleBarginManage.setPayMoney(payMoney);
			}
		}
		model.addAttribute("project", project);
		model.addAttribute("barginManages", barginManages);
		model.addAttribute("finReimburseAttach", JSONArray.toJSONString(finReimburseAttach));
		model.addAttribute("finRevenueRecognition", JSONArray.toJSONString(finRevenueRecognition));
		model.addAttribute("reimburs", reimburs);
		
		return "manage/sale/projectManageNew/info";
	}*/
	
	@RequestMapping("/getBarginManageList")
	@ResponseBody
	public String getBarginManageList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<SaleBarginManage> page = saleBarginManageService.findByPage1(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/getSpendingList")
	@ResponseBody
	public String getSpendingList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinTravelreimburse> page = iFinReimbursService.findByPage1(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()),
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toModify")
	public String toModify(Integer id, Model model) {
		
		SaleProjectManage project = projectManageService.findById(id);		
		model.addAttribute("project", project);
		
		return "manage/sale/projectManageNew/modify";
	}
	
	@RequestMapping("/findCostById")
	@ResponseBody
	public List<SaleResearchRecord> findCostById(Integer id) {
		return saleResearchRecordService.findByProjectId(id);
	}
	
	@RequestMapping("/change")
	@ResponseBody
	public CrudResultDTO change(Integer id, double money) {
		return saleResearchRecordService.save(id, money);
	}
	@RequestMapping("/findByProjectManageName")
	@ResponseBody
	public String findByProjectManageName(@RequestBody JSONObject json) {
		CrudResultDTO result = projectManageService.findByProjectName(json); 
		return JSON.toJSONString(result);
	}

	@RequestMapping("/exportExcelOne")
	@ResponseBody
	public void exportExcelOne(HttpServletResponse response, HttpServletRequest request) throws IOException {
		Map<String,Object> paramMap=parseRequestMap(request);
		String fileName = "财务统计_付款_统计表.xls";
		String agent = request.getHeader("USER-AGENT").toLowerCase();
		if (agent.contains("firefox")){
			response.setCharacterEncoding("UTF-8");
			fileName = new String(fileName.getBytes(),"ISO8859-1");
		} else {
			fileName = java.net.URLEncoder.encode(fileName,"UTF-8");
		}
		response.setContentType("application/vnd.ms-excel;charset=utf-8");
		response.addHeader("Content-Disposition","attachment;filenaem="+fileName);
		projectManageService.exportExcelOne(response.getOutputStream(), paramMap);
	}

	@RequestMapping("/deleteById")
	@ResponseBody
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result = projectManageService.updateIsDeleted(id);
		return result;
	}
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
			logger.info(getUser().getName()+"删除了项目ID为"+id+"的附件");
			return projectManageService.deleteAttach(path, id);
	}
	@RequestMapping("/sendMail")
	@ResponseBody
	public CrudResultDTO sendMail(@Param("id")Integer id,
								  @Param("comment")String comment){
		CrudResultDTO result = projectManageService.sendMail(id,comment);
		return result;
	}
}