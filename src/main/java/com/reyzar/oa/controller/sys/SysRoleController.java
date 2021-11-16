package com.reyzar.oa.controller.sys;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.constant.PermissionConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SysDataPermission;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.service.sys.ISysDataPermissionService;
import com.reyzar.oa.service.sys.ISysRoleService;

@Controller
@RequestMapping("/manage/sys/role")
public class SysRoleController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SysRoleController.class);
	
	@Autowired
	private ISysRoleService roleService;
	@Autowired
	private ISysDataPermissionService dataPermissionService;
	
	@RequiresPermissions("sys:role:view")
	@RequestMapping("/toList")
	public String toList() {
		return "manage/sys/role/list";
	}
	
	@RequestMapping("/getRoleList")
	@ResponseBody
	public String getRoleList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<SysRole> page = roleService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(@RequestParam Integer id, Model model) {
		
		SysRole role = new SysRole();
		if(id != null) {
			role = roleService.findById(id);
		}
		
		model.addAttribute("role", role);
		return "manage/sys/role/addOrEdit";
	}
	
	@RequestMapping("/toAuthority")
	public String toAuthority(@RequestParam Integer id, Model model) {
		SysRole role = roleService.findById(id);
		// 获取具有数据权限的模块
		List<String> moduleList = DataPermissionModuleConstant.getValues();
		Map<String, Boolean> dpModule = Maps.newHashMap();
		if(moduleList != null) {
			for(String module : moduleList) {
				dpModule.put(module, true);
			}
		}
		
		Map<String, String> permissMap = PermissionConstant.getClone();
		model.addAttribute("role", JSON.toJSONString(role));
		model.addAttribute("permissMap", JSON.toJSONString(permissMap));
		model.addAttribute("dpModule", JSON.toJSONString(dpModule));
		model.addAttribute("dataPermissionList", JSON.toJSONString(dataPermissionService.findByRoleId(role.getId())));
		
		return "manage/sys/role/authority";
	}
	
	@RequestMapping("/saveAuthority")
	@ResponseBody
	public CrudResultDTO saveAuthority(@RequestParam(value="menuidList[]", required=false) List<Integer> menuidList, 
			@RequestParam(value="permissionidList[]", required=false) List<Integer> permissionidList, 
			@RequestParam(value="dataPermissionList", required=false) String dataPermission,
			@RequestParam Integer roleId) {
		
		List<SysDataPermission> dataPermissionList = JSONArray.parseArray(dataPermission, SysDataPermission.class);
		if(menuidList == null) {
			menuidList = Lists.newArrayList();
		}
		if(permissionidList == null) {
			permissionidList = Lists.newArrayList();
		}
		if(dataPermissionList == null) {
			dataPermissionList = Lists.newArrayList();
		}
		
		return roleService.saveAuthority(menuidList, permissionidList, roleId, dataPermissionList);
	}
	
	@RequestMapping("/save")
	public String save(SysRole role) {
		roleService.save(role);
		
		return "redirect:toList";
	}
	
	@RequestMapping("/delete")
	public void delete(@RequestParam Integer id, HttpServletResponse response) {
		
		boolean isDel = roleService.delete(id);
		if(isDel) {
			renderJSONString(response, new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功"));
		} else {
			renderJSONString(response, new CrudResultDTO(CrudResultDTO.SUCCESS, "删除失败"));
		}
	}
}