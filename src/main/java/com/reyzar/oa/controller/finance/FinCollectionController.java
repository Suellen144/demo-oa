package com.reyzar.oa.controller.finance;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinPay;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.service.finance.FinPayService;
import com.reyzar.oa.service.finance.IFinInvoicedService;
import com.reyzar.oa.service.sale.ISaleBarginManageService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;
import org.apache.commons.collections.MapUtils;
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
import com.reyzar.oa.service.finance.IFinCollectionService;

@Controller
@RequestMapping(value="/manage/finance/collection")
public class FinCollectionController extends BaseController {
	
	private final Logger logger = Logger.getLogger(FinCollectionController.class);
	@Autowired
	private IFinCollectionService collectionService;
    @Autowired
    private FinPayService finPayService;
	@Autowired
	private ISaleProjectManageService iSaleProjectManageService;
	@Autowired
	private ISaleBarginManageService iSaleBarginManageService;
	@Autowired
	private IFinInvoicedService finInvoicedService;

	@RequestMapping(value="/findTaxesAndRelationshipByProjectId",method=RequestMethod.POST)
	@ResponseBody
	public String findTaxesAndRelationshipByProjectId(Integer projectId,Integer barginId,Integer id) {
		return JSON.toJSONString(collectionService.findTaxesAndRelationshipByProjectId(projectId,barginId,id));
	}

	@RequestMapping(value="/changeData",method=RequestMethod.POST)
	@ResponseBody
	public String changeData(String id ,double purchase,double taxes,double relationship,double other,double commissionBase) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功");
		int count = collectionService.changeData(Integer.valueOf(id),purchase,taxes,relationship,other,commissionBase);
		if(count <1) {
            result = new CrudResultDTO(CrudResultDTO.FAILED,"");
        }
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/findUser",method=RequestMethod.POST)
	@ResponseBody
	public String findUser() {
		return JSON.toJSONString(collectionService.findUser());
	}
		
	@RequestMapping(value="/toList")
	public String toList(Model model) {
		return "manage/finance/collection/list";
	}
	
	@RequestMapping(value="/toListNew")
	public String toListNew(Model model) {
		return "manage/finance/collection/listNew";
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getOvertimeList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinCollection> page = collectionService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	/**
	 * 新项目管理模块 -销售合同详情 的收款列表
	 * @param requestMap
	 * @return
	 * @throws JsonProcessingException
	 */
	@RequestMapping("/getListNew")
	@ResponseBody
	public String getListNew(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<FinCollection> page = collectionService.findByPageNew(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	/**
	 * 项目管理模块-收款申请管理列表
	 * @return
	 */
	@RequestMapping("/getCollectionListNew")
	@ResponseBody
	public String getCollectionListNew(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
        Map<String, Object> jsonMap = null;
		if(MapUtils.getString(paramsMap,"status").equals("1")) {
            Page<FinCollection> page = collectionService.findListByPage(paramsMap,
                Integer.valueOf(paramsMap.get("pageNum").toString()),
                Integer.valueOf(paramsMap.get("pageSize").toString()));
            jsonMap = buildTableData(paramsMap, page);
        }else {
            Page<FinPay> page = finPayService.findByPage2(paramsMap,
                    Integer.valueOf(paramsMap.get("pageNum").toString()),
                    Integer.valueOf(paramsMap.get("pageSize").toString()));
             jsonMap = buildTableData(paramsMap, page);
        }

		return JSONObject.toJSONString(jsonMap);
	}

	/**
	 * 项目管理模块-新增收款跳转
	 * @return
	 */
	@RequestMapping("/toAddNew")
	public String toAddNew(Integer barginManageId ,Integer id, Model model,Integer projectId) {
		FinCollection finCollection=new FinCollection();
		if(id!=null){
			finCollection=collectionService.findById(id);
		}else {
			finCollection.setApplyTime(new Date());
		}
		if(barginManageId != null){
			List<SaleProjectManage> saleProjectManage=iSaleProjectManageService.findProjectManageByBarginId(barginManageId);
			if(saleProjectManage!=null && saleProjectManage.size()>0) {
				finCollection.setProjectManage(saleProjectManage.get(0));
			}
			SaleBarginManage saleBarginManage=iSaleBarginManageService.findById(barginManageId);
			finCollection.setBarginId(barginManageId);
			finCollection.setBarginManage(saleBarginManage);
		}
		if(projectId != null) {
			SaleProjectManage project = iSaleProjectManageService.findById(projectId);
			if(project!=null) {
				finCollection.setProjectManage(project);
				finCollection.setProjectId(project.getId());
			}
		}
		model.addAttribute("finCollection", finCollection);
		return "manage/finance/collection/addNew";
	}
	
	
	@RequestMapping("/toAdd")
	public String toAdd() {
		return "manage/finance/collection/add";
	}
	
	
	@RequestMapping(value="/submitinfo",method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		return JSON.toJSONString(collectionService.submitinfo(json));
	}
	
	@RequestMapping(value="/save",method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		return JSON.toJSONString(collectionService.save(json));
	}
	
	
	@RequestMapping(value="/edit",method=RequestMethod.GET)
	public String toEdit(Integer id , Model model){
			if(id!=null){
				FinCollection finCollection=collectionService.findById(id);
				model.addAttribute("finCollection", finCollection);
			}
		return "manage/finance/collection/edit";
	}
	
	
	@RequestMapping(value="/findById",method=RequestMethod.POST)
	@ResponseBody
	public String findById(Integer id) {
		FinCollection finCollection=collectionService.findById(id);
		return JSON.toJSONString(finCollection);
	}
	
	
	
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@RequestBody JSONObject json) {
		return JSON.toJSONString(collectionService.saveOrUpdate(json));
	}
	
	//更改收款表中的收款总额
	@RequestMapping(value="/updateCoollection",method=RequestMethod.POST)
	@ResponseBody
	public String updateCoollection(@RequestBody JSONObject json) {
		return JSON.toJSONString(collectionService.saveOrUpdate(json));
	}
	
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return collectionService.setStatus(id, status);
	}


	@RequestMapping(value = "/findCollectionInfo",method = RequestMethod.POST)
	@ResponseBody
	public CrudResultDTO findCollectionInfo(Integer barginId,String status){
		return collectionService.findCollectionInfo(barginId,status);
	}

	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
		logger.info(getUser().getName()+"删除了付款ID为"+id+"的附件");
		return collectionService.deleteAttach(path, id);
	}
	
	@RequestMapping(value="/sendMail",method=RequestMethod.POST)
	public void sendMail(Integer id, String contents) {
		collectionService.sendMailToApple(id, contents);
	}
}