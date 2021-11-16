package com.reyzar.oa.controller.ad;

import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
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
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdMeeting;
import com.reyzar.oa.service.ad.IAdMeetingService;

@Controller
@RequestMapping(value="/manage/ad/meeting")
public class AdMeetingController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdMeetingController.class);
	
	@Autowired
	private IAdMeetingService meetingService;
	
	@RequestMapping(value="/toList")
	public String toList(Model model){
		return "manage/ad/meeting/list";
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) 
			throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Subject subject = SecurityUtils.getSubject();
		if (subject.isPermitted("ad:meeting:seeall")) {
			paramsMap.put("seeall", true);
		}
		else {
			paramsMap.put("seeall", false);
			paramsMap.put("userIdList", UserUtils.getCurrUser().getId().toString());
		}
		Page<AdMeeting> page = meetingService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}
	
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Integer id , Model model) {
		if (id != null ) {
			AdMeeting meeting = meetingService.findById(id);
			model.addAttribute("meeting", meeting);
		}
		return "manage/ad/meeting/addOrEdit";
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(AdMeeting meeting) {
		CrudResultDTO result = meetingService.save(meeting);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(AdMeeting meeting) {
		CrudResultDTO result = meetingService.update(meeting);
		return JSON.toJSONString(result);
	}
	
	
	@RequestMapping("/getMeeting")
	@ResponseBody
	public AdMeeting getMeeting(Integer id) {
		return meetingService.findById(id);
	}
	
	
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(Integer id) {
		return JSON.toJSONString(meetingService.deleteById(id));
	}
	
}