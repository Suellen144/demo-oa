package com.reyzar.oa.controller.finance;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinInvoiced;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.service.finance.IFinCollectionService;
import com.reyzar.oa.service.finance.IFinInvoicedService;
import com.reyzar.oa.service.sale.ISaleBarginManageService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;

@Controller
@RequestMapping(value="/manage/sale/finInvoiced")
public class FinInvoicedController extends BaseController {

	private final Logger logger = Logger.getLogger(FinInvoicedController.class);
	@Autowired
	private IFinInvoicedService iFinInvoicedService; 
	@Autowired
	private ISaleProjectManageService iSaleProjectManageService; 
	@Autowired
	private ISaleBarginManageService iSaleBarginManageService; 
	@Autowired
	private IFinCollectionService iFinCollectionService; 
	
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/finance/collection/listInvoice";
	}
	
	@RequestMapping("/getInvoiceList")
	@ResponseBody
	public String getInvoiceList(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinInvoiced> page = iFinInvoicedService.findByPageList(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinInvoiced> page = iFinInvoicedService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id ,Model model,HttpServletRequest request,Integer barginManageId) {
		FinInvoiced finInvoiced=new FinInvoiced();
		if(id != null) {
			finInvoiced=iFinInvoicedService.findById(id);
		}
		if(barginManageId != null){
			List<SaleProjectManage> saleProjectManage=iSaleProjectManageService.findProjectManageByBarginId(barginManageId);
			if(saleProjectManage!=null && saleProjectManage.size()>0) {
				finInvoiced.setSaleProjectManage(saleProjectManage.get(0));
			}
			SaleBarginManage saleBarginManage=iSaleBarginManageService.findById(barginManageId);
			finInvoiced.setBarginManageId(barginManageId);
			finInvoiced.setBarginManage(saleBarginManage);
			double invoiceAmount=0.0;
			//获取 已开票金额
			List<FinCollection> finCollections=iFinCollectionService.findByBarginIdAndCreateDate(barginManageId,finInvoiced.getCreateDate()==null?new Date():finInvoiced.getCreateDate());
			for (int i = 0; i < finCollections.size(); i++) {
				if(finCollections.get(i).getBill()!=null) {
					invoiceAmount+=finCollections.get(i).getBill();
				}
			}
			List<FinInvoiced> finInvoiceds=iFinInvoicedService.findByBarginIdAndCreateDate(barginManageId,finInvoiced.getCreateDate()==null?new Date():finInvoiced.getCreateDate());
			for (int j = 0; j < finInvoiceds.size(); j++) {
				if(finInvoiceds.get(j).getInvoiceAmount()!=null) {
				invoiceAmount+=finInvoiceds.get(j).getInvoiceAmount();
				}
			}
			finInvoiced.setInvoiceAmountTo(invoiceAmount);
		}
		model.addAttribute("finInvoiced", finInvoiced);
		
			return "manage/finance/collection/addInvoice";

	}
	
	@RequestMapping(value="/saveInfo", method=RequestMethod.POST)
	@ResponseBody
	public String saveInfo(@RequestBody JSONObject json) {
		CrudResultDTO result = new CrudResultDTO();
		result=	iFinInvoicedService.saveInfo(json);
		
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/submitinfo", method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		CrudResultDTO result = new CrudResultDTO();
		 result = iFinInvoicedService.submitinfo(json);
		
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@RequestBody JSONObject json) {
		return JSON.toJSONString(iFinInvoicedService.saveOrUpdate(json));
	}
	
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
		logger.info(getUser().getName()+"删除了发票ID为"+id+"的附件");
		return iFinInvoicedService.deleteAttach(path, id);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return iFinInvoicedService.setStatus(id, status);
	}
	
	@RequestMapping(value="/sendMail",method=RequestMethod.POST)
	public void sendMail(Integer id, String contents) {
		iFinInvoicedService.sendMailToApple(id, contents);
	}
}