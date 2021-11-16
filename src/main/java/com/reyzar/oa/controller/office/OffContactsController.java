package com.reyzar.oa.controller.office;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.sys.ISysUserService;

/**
 * 
* @Description: 公司通讯录
*
 */
@Controller
@RequestMapping("/manage/office/contacts")
public class OffContactsController  extends BaseController {
	
	private final Logger logger = Logger.getLogger(OffContactsController.class);
	
	@Autowired
	private IAdRecordService recordService;
	@Autowired
	private ISysUserService userService;
	
	@RequestMapping("/toList")
	public String toList(){
		return "manage/office/contacts/list";
	}
	
	@RequestMapping("/getContactsList")
	@ResponseBody
	public String getContactsList(@RequestBody Map<String, Object> requestMap)
	{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<AdRecord> page = recordService.showContacts(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()),  
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	
	@RequestMapping("/getContacts")
	@ResponseBody
	public String getContacts(Integer userId)
	{
		if(userId==null) {
			return "";
		}
		AdRecord record = recordService.findByUserid(userId);
		return JSON.toJSONString(record);
		
	}
	
}
