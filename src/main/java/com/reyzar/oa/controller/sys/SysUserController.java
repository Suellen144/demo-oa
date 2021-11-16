package com.reyzar.oa.controller.sys;

import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
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
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.OffNotice;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.office.IOffNoticeService;
import com.reyzar.oa.service.office.IOffPendflowService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysRoleService;
import com.reyzar.oa.service.sys.ISysUserService;

@Controller
@RequestMapping("/manage/sys/user")
public class SysUserController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SysUserController.class);

	@Autowired
	private ISysUserService userService;
	@Autowired
	private ISysRoleService roleServie;
	@Autowired
	private IOffNoticeService noticeService;
	@Autowired
	private IOffPendflowService taskService;
	@Autowired
	private IAdRecordService recordService;
	@Autowired
	private ISysDeptService deptService;
	
	@RequiresPermissions("sys:user:view")
	@RequestMapping("/toList")
	public String toList() {
		return "manage/sys/user/list";
	}
	
	@RequestMapping("/getUserList")
	@ResponseBody
	public String getUserList(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<SysUser> page = userService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}
	
	@RequestMapping("/getUserList2")
	@ResponseBody
	public String getUserList2(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<SysUser> page = userService.findByPage2(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(@RequestParam(required=false)Integer id, Model model) {
		List<SysRole> roleList = roleServie.findAll();
		SysUser user = new SysUser();
		if(id != null) {
			user = userService.findById(id);
		}
		
		model.addAttribute("userJson", JSONObject.toJSONString(user));
		model.addAttribute("user", user);
		model.addAttribute("roleList", roleList);
		return "manage/sys/user/addOrEdit";
	}
	
/*	查找用户名称*/
	@RequestMapping("findByUserIds")
	@ResponseBody
	public String findByUserIds(@RequestParam List<Integer> userIdList) {
		List<SysUser> userlists = userService.findByUserIds(userIdList);
		List<String>  namelists = Lists.newArrayList();
		for (SysUser temp : userlists) {
			namelists.add(temp.getName());
		}
		return JSON.toJSONString(namelists);
	} 
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(SysUser user, String positionId, 
			@RequestParam(value="roleidList[]", required=false) List<Integer> roleidList) {
		CrudResultDTO result = userService.save(user, positionId, roleidList, getUser());
		
		return JSON.toJSONString(result);
	}
	
	/**
	 * 保存用户信息
	 * */
	@RequestMapping("/saveForDetail")
	@ResponseBody
	public String saveForDetail(SysUser user, HttpServletRequest req) {
        CrudResultDTO result = userService.modifyPhoto(user.getAccount(), user.getPhoto());
        return JSON.toJSONString(result);
	}
	
	@RequestMapping("/modifyPhoto")
	@ResponseBody
	public String modifyPhoto(String account, String photo, HttpServletRequest req) {
		SysUser dataUser = userService.findByAccount(account);
		req.getSession().setAttribute("user", dataUser);
		return JSON.toJSONString(userService.modifyPhoto(account, photo));
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(Integer id) {
		CrudResultDTO result = userService.delete(id);
		return JSON.toJSONString(result);
	} 
	
	@RequestMapping("/toDetail")
	public String toDetail(Model model) {
		SysUser user = userService.findById(getUser().getId());
		AdRecord record = recordService.findByUserid(getUser().getId());
		
		model.addAttribute("user", user);
		model.addAttribute("record", record);
		return "manage/sys/user/detail";
	}
	
	@RequestMapping("/toChangePwd")
	public String toChangePwd() {
		return "manage/sys/user/changepwd";
	}
	
	@RequestMapping("/toPersonHome")
	public String toPersonHome(Model model) {
		/*最新公告List*/
		Map<String, Object> requestMap = Maps.newHashMap();
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("off:notice:seeall")) {
			requestMap.put("seeall", true);
		} else {
			requestMap.put("seeall", false);
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
			} else {
				sb.append(idList.get(0));
			}
			
			requestMap.put("deptIdList", sb.toString());
		}
//		requestMap.put("userDeptId", getUser().getDeptId());
		requestMap.put("userId", getUser().getId());
		List<OffNotice> noticeList = noticeService.findByPage(requestMap, 1, 10);
		
		List<Map<String, Object>> taskList = taskService.findTaskByAssignee("user_" + getUser().getId().toString());
		List<AdPosition> positionList = getUser().getPositionList();
		if(positionList != null) {
			for(AdPosition position : positionList) {
				taskList.addAll(taskService.findTaskByAssignee("position_" + position.getId()));
			}
		}
		if(taskList != null && taskList.size() > 0) {
			for(Map<String, Object> map : taskList) {
				map.remove("variables");
				map.remove("task");
			}
		}
		/*获取请假统计数据，显示当月请假小时数*/
		Calendar cal = Calendar.getInstance();
		requestMap.put("year", cal.get(Calendar.YEAR));
		requestMap.put("month", cal.get(Calendar.MONTH) + 1);
	/*	Map<String, Object> leaveMap = userService.getLeaveData(requestMap);
		Map<String, Object> travelMap = userService.getTravelData(requestMap);*/
		SysUser user = userService.findById(getUser().getId());
		model.addAttribute("noticeList",noticeList);
		model.addAttribute("deptList", JSON.toJSONString(deptService.findAll()));
		model.addAttribute("user", user);
	/*	model.addAttribute("leaveMap", leaveMap);
		model.addAttribute("travelMap", travelMap);*/
		model.addAttribute("task", taskList);
		
		return "manage/sys/user/personHome";
	}
	
	@RequestMapping("/toPersonHome2")
	public String toPersonHome2(Model model) {
		/*最新公告List*/
		Map<String, Object> requestMap = Maps.newHashMap();
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("off:notice:seeall")) {
			requestMap.put("seeall", true);
		} else {
			requestMap.put("seeall", false);
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
			} else {
				sb.append(idList.get(0));
			}
			
			requestMap.put("deptIdList", sb.toString());
		}
//		requestMap.put("userDeptId", getUser().getDeptId());
		requestMap.put("userId", getUser().getId());
		List<OffNotice> noticeList = noticeService.findByPage(requestMap, 1, 10);
		
		List<Map<String, Object>> taskList = taskService.findTaskByAssignee("user_" + getUser().getId().toString());
		List<AdPosition> positionList = getUser().getPositionList();
		if(positionList != null) {
			for(AdPosition position : positionList) {
				taskList.addAll(taskService.findTaskByAssignee("position_" + position.getId()));
			}
		}
		if(taskList != null && taskList.size() > 0) {
			for(Map<String, Object> map : taskList) {
				map.remove("variables");
				map.remove("task");
			}
		}
		/*获取请假统计数据，显示当月请假小时数*/
		Calendar cal = Calendar.getInstance();
		requestMap.put("year", cal.get(Calendar.YEAR));
		requestMap.put("month", cal.get(Calendar.MONTH) + 1);
	/*	Map<String, Object> leaveMap = userService.getLeaveData(requestMap);
		Map<String, Object> travelMap = userService.getTravelData(requestMap);*/
		SysUser user = userService.findById(getUser().getId());
		model.addAttribute("noticeList",noticeList);
		model.addAttribute("deptList", JSON.toJSONString(deptService.findAll()));
		model.addAttribute("user", user);
	/*	model.addAttribute("leaveMap", leaveMap);
		model.addAttribute("travelMap", travelMap);*/
		model.addAttribute("task", taskList);
		
		return "manage/sys/user/personHome2";
	}
	
	@RequestMapping("/checkAccount")
	@ResponseBody
	public String checkAccount(String account) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "账号不存在！");
		if(account != null) {
			if(userService.findByAccount(account.trim()) != null) {
				result = new CrudResultDTO(CrudResultDTO.FAILED, "账号已存在！");
			}
		}
		
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/modifyPassword", method=RequestMethod.POST)
	@ResponseBody
	public String modifyPassword(String account, String password) {
		return JSON.toJSONString(userService.modifyPassword(account, password));
	}
	
	
	@RequiresPermissions("sys:user:pwd")
	@RequestMapping(value="/resetPassword", method=RequestMethod.POST)
	@ResponseBody
	public String resetPassword(Integer userId) {
		return JSON.toJSONString(userService.resetPassword(userId));
	}
}