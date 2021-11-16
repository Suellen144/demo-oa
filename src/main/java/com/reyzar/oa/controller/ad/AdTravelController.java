package com.reyzar.oa.controller.ad;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdTravel;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdTravelService;
import com.reyzar.oa.service.sys.ISysDeptService;

/**
 * 
* @Description: 出差
* @author zhouShaoFeng
* @date 2016年7月13日 上午9:11:57 
*
 */
@Controller
@RequestMapping("/manage/ad/travel")
public class AdTravelController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdTravelController.class);
	
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdTravelService travelService;
	@Autowired
	private ISysDeptService deptService;
	
	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/ad/chkatt/travel/list";
	}
	
	@RequestMapping("/getTravelList")
	@ResponseBody
	public String getTravelList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		SysUser user = getUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.TRAVEL);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		Set<Integer> userIdSet = UserUtils.getPrincipalIdList(user);
		paramsMap.put("userId", user.getId());
		paramsMap.put("deptIdSet", deptIdSet);
		paramsMap.put("userIdSet",userIdSet);
		Page<AdTravel> page = travelService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	/**
	 * 提供给搜索框使用，只能获取本人的数据
	 * */
	@RequestMapping("/getTravelListForDialog")
	@ResponseBody
	public String getTravelListForDialog(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		SysUser user = getUser();
		Set<Integer> deptIdSet = Sets.newConcurrentHashSet();
		List<SysDept> deptList = deptService.findAll();
		for (SysDept sysDept : deptList) {
			deptIdSet.add(sysDept.getId());
		}
		paramsMap.put("userId", user.getId());
		paramsMap.put("deptIdSet", deptIdSet);
		paramsMap.put("status", "2"); // 查询流程已结束的数据
		Page<AdTravel> page = travelService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	@RequestMapping("/toAdd")
	public String toAdd(HttpServletRequest request) {
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		if (ismobile){
			return "manage/ad/chkatt/travel/mobileadd";
		}else{
			return "manage/ad/chkatt/travel/add";
		}

	}
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		CrudResultDTO result = travelService.save(json);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value="/saveOrUpdate",method=RequestMethod.POST)
	@ResponseBody
	public String saveOrUpdate(@RequestBody JSONObject json) {
		return JSON.toJSONString(travelService.saveOrUpdate(json));
	}

	@RequestMapping("/updateTravelResult")
	@ResponseBody
	public String updateTravelResult(Integer id ,String travelResult) {
		return JSON.toJSONString(travelService.updateTravelResult(id,travelResult));
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return travelService.setStatus(id, status);
	}
	
	@RequestMapping("/getProcessImg")
	public void getProcessImg(String processInstanceId, HttpServletResponse response) throws IOException {
		InputStream is = activitiUtils.getProcessImgByProcessInstanceId(processInstanceId);
		
		OutputStream outstr = response.getOutputStream();
		BufferedOutputStream bufferOut = new BufferedOutputStream(outstr);
		BufferedInputStream bufferIn = new BufferedInputStream(is);
		 
		byte[] buffer = new byte[2048];
		int size = bufferIn.read(buffer);
		while(size != -1){
		    bufferOut.write(buffer, 0, size);
		    size = bufferIn.read(buffer);
		}
		bufferIn.close();
		bufferOut.close();
	}
	
}
