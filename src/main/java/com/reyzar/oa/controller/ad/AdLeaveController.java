package com.reyzar.oa.controller.ad;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.util.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdLeave;
import com.reyzar.oa.service.ad.IAdLeaveService;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/manage/ad/leave")
public class AdLeaveController extends BaseController {

	@Autowired
	private IAdLeaveService leaveService;

	@RequestMapping(value="/toList")
	public String toList(Model model) {
		return "manage/ad/chkatt/leave/list";
	}

	@RequestMapping("/getLeaveList")
	@ResponseBody
	public String getLeaveList(@RequestBody Map<String, Object> requestMap)
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);

		Page<AdLeave> page = leaveService.findByPage(paramsMap,
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
			return "manage/ad/chkatt/leave/mobileadd";
		}else {
			return "manage/ad/chkatt/leave/add";
		}


	}
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(AdLeave leave) {
		CrudResultDTO result = leaveService.save(leave);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(AdLeave leave) {
		CrudResultDTO result = leaveService.update(leave);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/setStatus")
	@ResponseBody
	public CrudResultDTO setStatus(Integer id, String status) {
		return leaveService.setStatus(id, status);
	}
	
	@RequestMapping("/setBackLeave")
	@ResponseBody
	public CrudResultDTO setBackLeave(Integer id) {
		return leaveService.setBackLeave(id);
	}
	
	@RequestMapping("/checkDate")
	@ResponseBody
	public CrudResultDTO checkDate(String startTime,String endTime){
		return leaveService.checkDate(startTime,endTime);
	}
	
	@RequestMapping("/getLeaveByUserId")
	@ResponseBody
	public String getLeaveByUserId(Integer userId) {
		int casualLeave = 0;
		int sickLeave = 0;
		int vacation = 0;
		Map<String,Object> map = new HashMap<String,Object>();
		List<AdLeave> list = leaveService.findByUserId(userId);
		for (AdLeave adLeave : list) {
			if(adLeave.getLeaveType().equals("0")) {
				if(adLeave.getDays() >= 1) {
					casualLeave += (adLeave.getDays() * 7.5);
				}
				if(adLeave.getHours() > 0) {
					casualLeave += adLeave.getHours();
				}
			}else if(adLeave.getLeaveType().equals("2")) {
				if(adLeave.getDays() >= 1) {
					vacation += (adLeave.getDays() * 7.5);
				}
				if(adLeave.getHours() > 0) {
					vacation += adLeave.getHours();
				}
			}else if(adLeave.getLeaveType().equals("3")) {
				if(adLeave.getDays() >= 1) {
					sickLeave += (adLeave.getDays() * 7.5);
				}
				if(adLeave.getHours() > 0) {
					sickLeave += adLeave.getHours();
				}
			}
		}
		map.put("casualLeave", casualLeave);
		map.put("sickLeave", sickLeave);
		map.put("vacation", vacation);
		return JSON.toJSONString(map);
	}
	
}
