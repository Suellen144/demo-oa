package com.reyzar.oa.controller.ad;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.service.ad.IAdPositionService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Controller
@RequestMapping("/manage/ad/position")
public class AdPositionController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdPositionController.class);
	
	@Autowired
	private IAdPositionService positionService;
	
	@Autowired
	private ISysDeptService deptService;
	
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/ad/position/list";
	}
	
	@RequestMapping("/getPositionList")
	@ResponseBody
	public String getProjectList(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<AdPosition> page = positionService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}
	
	
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(@RequestParam(required=false)Integer id, Model model) {
		AdPosition position = new AdPosition();
		if(id != null) {
			position = positionService.findById(id);
		}
		
		model.addAttribute("position", position);
		return "manage/ad/position/addOrEdit";
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(AdPosition position) {
		CrudResultDTO result = positionService.save(position);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/delete")
	public void delete(@RequestParam Integer id, HttpServletResponse response) {
		CrudResultDTO result = positionService.delete(id);
		renderJSONString(response, result);
	}
	
	@RequestMapping("/details")
	@ResponseBody
	public String details(Integer id) {
		if(id==null) {
			return "";
		}
		AdPosition position = positionService.findById(id);
		return JSON.toJSONString(position);
	}
	
	
	@RequestMapping("/findUpPosition")
	@ResponseBody
	public String findUpPosition(@RequestParam Integer[] ids) {
		CrudResultDTO finalResult = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功！");
		
		List<String> positionName = new ArrayList<>();
		for (Integer id : ids) {
			AdPosition position = positionService.findById(id);
			
			SysDept dept = deptService.findById(position.getDeptId());
			CrudResultDTO result = deptService.findUpDept(dept.getId());
			String upDeptName = (String) result.getResult()+position.getName(); 
			
			positionName.add(upDeptName);
		}
		finalResult.setResult(positionName);
		return JSON.toJSONString(finalResult);
	}
	
}