package com.reyzar.oa.controller.sale;

import java.util.Map;

import com.reyzar.oa.domain.SysDept;
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
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.service.sale.ISaleBarginManageService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/manage/sale/barginManage")
public class SaleBarginManageController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SaleBarginManageController.class);
	
	@Autowired
	private ISaleBarginManageService saleBarginManageService; 
	@Autowired
	private ISaleProjectManageService saleProjectManageService;

	@RequestMapping("/getParentDeptName")
	@ResponseBody
	public String getParentDeptName(Integer principalDeptId)throws JsonProcessingException {
		SysDept sysDept = new SysDept();
		if(principalDeptId != null) {
			sysDept = saleProjectManageService.findDeptByDeptId(principalDeptId);
			if(sysDept != null && sysDept.getParentId() == 3) {
				sysDept = saleProjectManageService.findDeptByDeptId(sysDept.getParentId());
				return JSONObject.toJSONString(sysDept);
			}
		}
		return null;
	}
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/sale/barginManage/list";
	}
	
	@RequestMapping("/toListNew")
	public String toListNew() {
		return "manage/sale/barginManage/listNew";
	}
	
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
	
		Page<SaleBarginManage> page = saleBarginManageService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}

	@RequestMapping("/getListNew")
	@ResponseBody
	public String getListNew(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
	
		Page<SaleBarginManage> page = saleBarginManageService.findByPageNew(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/sendMail")
	@ResponseBody
	public CrudResultDTO sendMail(@Param("id")Integer id,
								  @Param("comment")String comment){
		CrudResultDTO result = saleBarginManageService.sendMail(id,comment);
		return result;
	}
	
	
	@RequestMapping("/getBarginListForDialog")
	@ResponseBody
	public String getBarginListForDialog(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<SaleBarginManage> page = saleBarginManageService.getBarginListForDialog(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/view")
	public String view(Integer id ,Model model) {
		if(id != null){
			SaleBarginManage saleBarginManage = saleBarginManageService.findById(id);
			model.addAttribute("saleBarginManage", saleBarginManage);
		}
		
		return "manage/sale/barginManage/view";
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id ,Model model,HttpServletRequest request,Integer projectId) {
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		SaleBarginManage saleBarginManage =new SaleBarginManage();
		if(id != null){
			 saleBarginManage = saleBarginManageService.findById(id);
		}
		if(projectId !=null) {
			SaleProjectManage saleProjectManage=saleProjectManageService.findById(projectId);
			if(saleProjectManage != null) {
				saleBarginManage.setProjectManage(saleProjectManage);
				saleBarginManage.setProjectManageId(saleProjectManage.getId());
			}
		}
		saleBarginManage.setIsNewProject(1);// 标识为新项目管理模块创建的合同  -- 开发时 区分了旧数据，杨博的意思是合并一起
		model.addAttribute("saleBarginManage", saleBarginManage);
		if (ismobile){
			return "manage/sale/barginManage/mobileAddOrEdit";
		}else{
			return "manage/sale/barginManage/addOrEdit";
		}

	}
	
	@RequestMapping(value="/saveInfo", method=RequestMethod.POST)
	@ResponseBody
	public String saveInfo(@RequestBody JSONObject json) {
		CrudResultDTO result = saleBarginManageService.saveInfo(json);
		
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/submit", method=RequestMethod.POST)
	@ResponseBody
	public String submit(@RequestBody JSONObject json) {
		
		CrudResultDTO result = saleBarginManageService.submit(json);
		
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return saleBarginManageService.setStatus(id, status);
	}
	
	@RequestMapping("/setStatus2")
	@ResponseBody
	public CrudResultDTO setStatus2(Integer id, String status, String remark) {
		return saleBarginManageService.setStatus2(id, status, remark);
	}

	@RequestMapping("/updateConfirm")
	@ResponseBody
	public CrudResultDTO updateConfirm(Integer id ,String barginConfirm) {
		return saleBarginManageService.updateConfirm(id,barginConfirm);
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(@RequestBody JSONObject json) {
		CrudResultDTO result = saleBarginManageService.delete(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/deleteAttach")
	@ResponseBody
	public CrudResultDTO deleteAttach(String path,Integer id){
			logger.info(getUser().getName()+"删除了合同ID为"+id+"的附件");
			return saleBarginManageService.deleteAttach(path, id);
	}

	@RequestMapping("/deleteAttach2")
	@ResponseBody
	public CrudResultDTO deleteAttach2(String path,Integer id){
		logger.info(getUser().getName()+"删除了合同ID为"+id+"的附件");
		return saleBarginManageService.deleteAttach2(path, id);
	}
	

	@RequestMapping(value="/findbargin",method=RequestMethod.POST)
	@ResponseBody
	public String findbargin(Integer barginManageId) {
		SaleBarginManage barginManage =	saleBarginManageService.findById(barginManageId);
		return JSON.toJSONString(barginManage);
	}
	
	@RequestMapping("/findById")
	@ResponseBody
	public String findById(Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		SaleBarginManage barginManage =	saleBarginManageService.findById(id);
		result = new CrudResultDTO(CrudResultDTO.SUCCESS,barginManage);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/findByProjectId")
	@ResponseBody
	public String findByProjectId(Integer projectId) {
		CrudResultDTO result = saleBarginManageService.findByProjectId(projectId); 
		return JSON.toJSONString(result);
	}
	
	//合同已付款已出纳填写为准，所以出纳填写后更改合同
	@RequestMapping("/updateBarginInfo")
	@ResponseBody
	public String updateBarginInfo(@RequestBody JSONObject json) {
		CrudResultDTO result = saleBarginManageService.updateBarginInfo(json);
		return JSON.toJSONString(result);
	}
	
	
		//合同更新某些字段
		@RequestMapping(value="/updateBargin",method=RequestMethod.POST)
		@ResponseBody
		public String updateBargin(@RequestBody JSONObject json) {
			CrudResultDTO result = saleBarginManageService.updateBarginInfo(json);
			return JSON.toJSONString(result);
		}
	
	@RequestMapping("/findByBarginName")
	@ResponseBody
	public String findByBarginName(@RequestBody JSONObject json) {
		CrudResultDTO result = saleBarginManageService.findByBarginName(json); 
		return JSON.toJSONString(result);
	}
	
}