package com.reyzar.oa.controller.sys;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.constant.PermissionConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.StringUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysDataPermissionService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysRoleService;
import com.reyzar.oa.service.sys.ISysUserService;

/** 
* @ClassName: SysDeptController 
* @Description: 部门控制器
* @author Lin 
* @date 2016年6月20日 上午11:38:03 
*  
*/
@Controller
@RequestMapping("/manage/sys/dept")
public class SysDeptController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SysDeptController.class);
	
	private final static Integer ROOT_DEPT = -1; // 根部门ID
	
	@Autowired
	private ISysDeptService deptService;
	
	@Autowired
	private ISysUserService userService;
	
	@Autowired
	private ISysRoleService sysRoleService;
	
	@Autowired
	private ISysDataPermissionService dataPermissionService;
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/sys/dept/list";
	}
	
	@RequestMapping("/getDeptList")
	public void getDeptList(HttpServletResponse response) {
		List<SysDept> deptList = deptService.findByParentid(ROOT_DEPT);
		renderJSONString(response, deptList.get(0));
	}
	
	@RequestMapping("/getDeptListOnJson")
	@ResponseBody
	public String getDeptListOnJson() {
		String deptJson = deptService.getDeptJson();
		return deptJson;
	}
	
	
	@RequestMapping("/getPoistionUser")
	@ResponseBody
	public String getPoistionUser(@RequestParam Integer id) {
		List<Integer> idList = deptService.findByPosition(id);
		List<String> namelist = Lists.newArrayList();
		for (Integer userId : idList) {
			SysUser user= userService.findById(userId);
			if (user != null) {
				namelist.add(user.getName());
			}
		}
		return JSON.toJSONString(namelist);
	}
	
	@RequestMapping("/findByDeptId")
	@ResponseBody
	public String findByDeptId(Integer deptId) {
		return JSON.toJSONString(deptService.findById(deptId));
	}
	
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(@RequestParam Integer id, 
			@RequestParam(value="isEdit", required=false) String isEdit,
			Model model) {
		
		SysDept self = null;
		SysDept parent = null;
		
		// 编辑操作
		if(!StringUtils.isBlank(isEdit) && "true".equals(isEdit)) {
			self = deptService.findById(id);
			parent = deptService.findById(self.getParentId());
		} else { // 添加子菜单操作，当前ID是父级菜单ID
			self = new SysDept();
			parent = deptService.findById(id); 
		}
		
		model.addAttribute("dept", self);
		model.addAttribute("parent", parent);
		
		return "manage/sys/dept/addOrEdit";
	}
	
	@RequestMapping("/save")
	public String save(SysDept dept) {
		deptService.save(dept, getUser());
		
		return "redirect:toList";
	}
	
	@RequestMapping("/delete/{id}")
	@ResponseBody
	public String delete(@PathVariable("id") Integer id) {
		CrudResultDTO res = deptService.delete(id);
		
		return JSON.toJSONString(res);
	}
	
	@RequestMapping("/truedel/{id}")
	@ResponseBody
	public String truedel(@PathVariable("id") Integer id) {
		CrudResultDTO res = deptService.truedelete(id);
		
		return JSON.toJSONString(res);
	}
	
	@RequestMapping("/checkCode")
	@ResponseBody
	public String checkCode(@RequestParam(required=false)Integer id, String code) {
		return JSON.toJSONString(deptService.checkCode(id, code));
	} 
	
	//查找部门经理，没有找副经理
	@RequestMapping("/findManager")
	@ResponseBody
	public String findManager(Integer deptId) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功！");
		SysDept dept = deptService.findById(deptId);
		SysUser assignee = userService.findById(dept.getUserId()); // 获取部门经理
		if( assignee == null ) {
			assignee = userService.findById(dept.getAssistantId()); // 获取部门副经理
		}
		String name = assignee.getName();
		result.setResult(name);
		return JSON.toJSONString(result);
	} 
	
	
	@RequestMapping("/getDeptWithPositionInList")
	@ResponseBody
	public String getDeptWithPositionInList(HttpServletRequest request) {
		return JSON.toJSONString(deptService.getDeptWithPositionInList(request.getContextPath()));
	} 
	
	@RequestMapping("/getDeptWithUserInList")
	@ResponseBody
	public String getDeptWithUserInList(HttpServletRequest request) {
		return JSON.toJSONString(deptService.getDeptWithUserInList(request.getContextPath()));
	} 
	
	
	@RequestMapping("/findUpDept")
	@ResponseBody
	public String findUpDept(@RequestParam Integer id ) {
		return JSON.toJSONString(deptService.findUpDept(id));
	} 
	
	
	@RequestMapping("/setSort")
	@ResponseBody
	public String setSort(@RequestParam(value="deptList")List<String> deptList) {
		return JSON.toJSONString(deptService.setSort(deptList));
	} 
	
	//撤销
	@RequestMapping("/revokeDeptOrRole")
	@ResponseBody
	public String revokeDeptOrRole(@RequestParam Integer id,@RequestParam Integer status) {
		
		CrudResultDTO res =new CrudResultDTO();
		if(status == 1) {
			res=deptService.revoke(id);
		}else if(status == 2) {
			boolean isok=sysRoleService.revoke(id);
			if(isok) {
				res.setCode(1);
				res.setResult("撤销成功!");
			}
		}
		
		return JSON.toJSONString(res);
	}

	//删除
	@RequestMapping("/deleteDeptOrRole")
	@ResponseBody
	public String deleteDeptOrRole(@RequestParam Integer id,@RequestParam Integer status) {

		CrudResultDTO res =new CrudResultDTO();
		if(status == 1) {
			res=deptService.delete(id);
		}else if(status == 2) {
			boolean isok=sysRoleService.delete(id);
			if(isok) {
				res.setCode(1);
				res.setResult("删除成功!");
			}
		}

		return JSON.toJSONString(res);
	}

	@RequestMapping("/getDeptOrRole")
	@ResponseBody
	public String getDeptOrRole(@RequestParam Integer id,@RequestParam Integer status) {
		SysDept sysDept=new SysDept();
		if(status == 1) {
			sysDept=deptService.findById(id);
		}else if(status == 2) {
			SysRole sysRole =new SysRole();
			sysRole=sysRoleService.findById(id);
			sysDept.setName(sysRole.getName());
			sysDept.setOriginName(sysRole.getEnname());
			sysDept.setId(sysRole.getId());
		}
		return JSON.toJSONString(sysDept);
	}
	@RequestMapping("/getDeptAndPosition")
	@ResponseBody
	public String getDeptAndPosition(Integer id,Integer isDelete,String sign) {
		List<SysDept> sysDeptList = deptService.getDeptAndPosition(id,isDelete,sign);
		return JSON.toJSONString(sysDeptList);
	}
	
	@RequestMapping("/getOpenDeptIdOrRoleId")
	@ResponseBody
	public String getOpenDeptIdOrRoleId(@RequestParam Integer id,@RequestParam Integer titleOrContent) {
		Map<String, Object> objects=new HashMap<String, Object>();
		if(id !=null && titleOrContent == 2) {
			SysRole role = sysRoleService.findById(id);
			if(role!=null) {
				// 获取具有数据权限的模块
				List<String> moduleList = DataPermissionModuleConstant.getValues();
				Map<String, Boolean> dpModule = Maps.newHashMap();
				if(moduleList != null) {
					for(String module : moduleList) {
						dpModule.put(module, true);
					}
				}
				Map<String, String> permissMap = PermissionConstant.getClone();
				objects.put("role", role);
				objects.put("permissMap", permissMap);
				objects.put("dpModule", dpModule);
				objects.put("dataPermissionList", dataPermissionService.findByRoleId(role.getId()));
			}
		}
		return JSON.toJSONString(objects);
	}
	
	
	//获取公司下拉列表
	@RequestMapping("/organizationList")
	@ResponseBody
	public List<SysDept> organizationList(HttpServletRequest request, HttpServletResponse response,Integer isDeleted) {
		List<SysDept> organizationList=deptService.organizationList(isDeleted);
		return organizationList;
	}
	
	@RequestMapping(value="/saveDeptOrRole",method=RequestMethod.POST)
	@ResponseBody
	public String saveDeptOrRole(@RequestBody JSONObject json) {
		CrudResultDTO res =new CrudResultDTO();
		res=deptService.saveDeptOrRole(json);
		return JSON.toJSONString(res);
		}
	
	@RequestMapping("/validationName")
	@ResponseBody
	public String validationName(@RequestParam String name,Integer status,Integer id) {
		CrudResultDTO res =new CrudResultDTO();
		if(status == 1) {
			SysDept sysDept=deptService.findByName(name,id);
			if(sysDept !=null && sysDept.getId()!=null) {
				res.setCode(CrudResultDTO.SUCCESS);
			}else {
				res.setCode(CrudResultDTO.EXCEPTION);
			}
		}else if(status == 2) {
			SysRole sysRole=sysRoleService.findByName(name,id);
			if(sysRole !=null && sysRole.getId()!=null) {
				res.setCode(CrudResultDTO.SUCCESS);
			}else {
				res.setCode(CrudResultDTO.EXCEPTION);
			}
		}
		return JSON.toJSONString(res);
	}
	
	@RequestMapping("/getRole")
	@ResponseBody
	public List<SysRole> getRole(@RequestParam Integer id) {
		List<SysRole> sysRoles=sysRoleService.getSysRole();
		return sysRoles;
	}
	
	@RequestMapping("/restoreNew")
	@ResponseBody
	public String restoreNew(@RequestParam Integer id,Integer status) {
		CrudResultDTO res =new CrudResultDTO();
		if(status == 1) {
			SysDept sysDept=deptService.findById(id);
			if(sysDept !=null && sysDept.getId()!=null) {
				sysDept.setIsDeleted("0");
				deptService.update(sysDept);
				res.setCode(CrudResultDTO.SUCCESS);
			}else {
				res.setCode(CrudResultDTO.EXCEPTION);
			}
		}else if(status == 2) {
			SysRole sysRole=sysRoleService.findById(id);
			if(sysRole !=null && sysRole.getId()!=null) {
				sysRole.setIsDeleted("0");
				sysRoleService.update(sysRole);
				res.setCode(CrudResultDTO.SUCCESS);
			}else {
				res.setCode(CrudResultDTO.EXCEPTION);
			}
		}
		return JSON.toJSONString(res);
	}
	
}