package com.reyzar.oa.controller.institution;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.Responsibility;
import com.reyzar.oa.service.institution.IResponsibilityService;

/**
 * 岗位职责
 * @author admin
 *
 */
@Controller
@RequestMapping("/manage/responsibility")
public class ResponsibilityController extends BaseController{

	@Autowired
	private IResponsibilityService iResponsibilityService;
	
	@RequestMapping("/getResponsibility")
	@ResponseBody
	public String getResponsibility(Integer id) {
		Responsibility responsibility=iResponsibilityService.findById(id);
		return JSONObject.toJSONString(responsibility);
	}
	
	@RequestMapping("/getResponsibilityByDeptId")
	@ResponseBody
	public String getResponsibilityByDeptId(Integer deptId,Integer titleOrContent) {
		Responsibility responsibility=new Responsibility();
		responsibility.setDeptId(deptId);
		responsibility.setTitleOrContent(titleOrContent);
		List<Responsibility>  responsibilitys=iResponsibilityService.findByDeptId(responsibility);
		if(responsibilitys!=null && responsibilitys.size()>0) {
			responsibility=responsibilitys.get(0);
		}
		return JSONObject.toJSONString(responsibility);
	}
	
	@RequestMapping("/saveResponsibility")
	@ResponseBody
	public CrudResultDTO saveResponsibility(@RequestBody JSONObject json) {
		Responsibility responsibility = json.toJavaObject(Responsibility.class);
		iResponsibilityService.saveOrUpdate(responsibility);
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		return result;
	}
}
