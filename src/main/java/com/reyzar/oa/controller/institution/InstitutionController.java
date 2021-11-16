package com.reyzar.oa.controller.institution;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.constant.PermissionConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.WebUtil;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.Institution;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.service.institution.IInstitutionService;
import com.reyzar.oa.service.sys.ISysRoleService;

/** 
* @ClassName: InstitutionsController
* @Description: 机构设置控制器
* @author LWY
* @date 2018年07月19日
*  
*/
@Controller
@RequestMapping("/manage/institution")
public class InstitutionController extends BaseController {
	@Autowired
	private IInstitutionService institutionService;
	
	@Autowired
	private ISysRoleService roleService;
	
	@RequestMapping("/toList")
	public String toList(HttpServletRequest request) {
		return "manage/institution/list";
		
	}
	/**==============================================树菜单开始=====================================================*/
	@RequestMapping("/getInstitutionList")
	public void getInstitutionList(HttpServletRequest request,HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		if(!StringUtils.isEmpty(param.get("id"))){
			//根据id查询机构表是否存在该公司
			Institution ist=institutionService.queryOrganization(param.get("id"));
			
			if(StringUtils.isEmpty(ist)){//不存在，则新增到机构表
				Map<String, String> param2 =new HashMap<String, String>();
				param2.put("id", param.get("id"));
				Organization ogn=institutionService.queryOrganizationById23(param2);
				Map<String, String> param3 =new HashMap<String, String>();
				param3.put("id", param.get("id"));
				param3.put("pid",UUID.randomUUID().toString().trim().replaceAll("-", ""));
				param3.put("name",ogn.getName());
				param3.put("is_dept","0");
				institutionService.saveOrganization(param3);
				param.put("parentId", param3.get("pid"));
			}else{
				param.put("parentId", ist.getParentId());
			}
		}else{
			param.put("parentId", "-1");
		}
		List<Institution> institutionList = institutionService.findByParentid(param);
		if(institutionList.size()>0){
			renderJSONString(response, institutionList.get(0));
		}else{
			renderJSONString(response, new ArrayList<Institution>());
		}
	}
	
	/**==============================================树菜单结束=====================================================*/
	
	//获取公司下拉列表
	@RequestMapping("/organizationList")
	@ResponseBody
	public List<Institution> organizationList(HttpServletRequest request, HttpServletResponse response) {
		List<Institution> organizationList=institutionService.organizationList();
		return organizationList;
	}
	
	//获取公司下拉列表2
	@RequestMapping("/organizationList2")
	@ResponseBody
	public List<Institution> organizationList2(HttpServletRequest request, HttpServletResponse response) {
		List<Institution> organizationList=institutionService.organizationList2();
		return organizationList;
	}
	
	//根据ID查询机构信息
	@RequestMapping("/queryInstitutionById")
	@ResponseBody
	public Institution queryInstitutionById(HttpServletRequest request, HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, Object> param = WebUtil.paramsToMap(request.getParameterMap());
		Institution institution=institutionService.queryInstitutionById(param);
		return institution;
	}
	
	//保存：新增同级、下级，编辑部门信息
	@RequestMapping("/saveInstitution")
	@ResponseBody
	public void saveInstitution(HttpServletRequest request, HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, Object> param = WebUtil.paramsToMap(request.getParameterMap());
		institutionService.saveOrUpdateInstitution(param);
	}
	
	//上移或下移
	@RequestMapping("/moveUpOrDownById")
	@ResponseBody
	public CrudResultDTO moveUpOrDownById(@RequestBody JSONObject json) {
		institutionService.moveUpOrDownById(json);
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		return result;
	}
	
	//撤销
	@RequestMapping("/updateInstitutions")
	@ResponseBody
	public void updateInstitutions(HttpServletRequest request, HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		institutionService.updateInstitutions(param);
	}
	
	//恢复
	@RequestMapping("/updateInstitutions2")
	@ResponseBody
	public void updateInstitutions2(HttpServletRequest request, HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		institutionService.updateInstitutions2(param);
	}
	
	//删除
	@RequestMapping("/delInstitutionById")
	@ResponseBody
	public String delInstitutionById(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		institutionService.delInstitutionById(param);
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"删除成功！");
		return JSON.toJSONString(result);
	}
	
	//设置岗位职责
	@RequestMapping("/setGWZZAndQXDY")
	@ResponseBody
	public Map<String,Object> setGWZZ(HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> results =new HashMap<String, Object>();
		@SuppressWarnings("unchecked")
		Map<String, Object> param = WebUtil.paramsToMap(request.getParameterMap());
		Institution institution=institutionService.queryInstitutionById(param);
		
		//权限定义
		if(!StringUtils.isEmpty(institution)){
			if(!StringUtils.isEmpty(institution.getRole_id())){
				SysRole role = roleService.findById(Integer.valueOf(institution.getRole_id()));
				// 获取具有数据权限的模块
				List<String> moduleList = DataPermissionModuleConstant.getValues();
				Map<String, Boolean> dpModule = Maps.newHashMap();
				if(moduleList != null) {
					for(String module : moduleList) {
						dpModule.put(module, true);
					}
				}
				Map<String, String> permissMap = PermissionConstant.getClone();
				results.put("role", role);
				results.put("permissMap", permissMap);
				results.put("dpModule", dpModule);
			}
		}
		results.put("institution", institution);
		return results;
	}

	//保存：岗位职责信息
	@RequestMapping("/saveGWZZInfo")
	@ResponseBody
	public void saveGWZZInfo(HttpServletRequest request, HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, Object> param = WebUtil.paramsToMap(request.getParameterMap());
		institutionService.saveGWZZInfo(param);
	}
	//===============================================================================================
	//获取角色下拉列表
	@RequestMapping("/getRoleList")
	@ResponseBody
	public List<SysRole> getRoleList(HttpServletRequest request, HttpServletResponse response) {
		List<SysRole> sysRoles=institutionService.getRoleList();
		return sysRoles;
	}
	
}