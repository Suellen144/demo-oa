package com.reyzar.oa.controller.ad;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.service.ad.IAdChkattRecordService;

/** 
* @ClassName: AdChkattRecordController 
* @Description: 考勤记录
* @author Lin 
* @date 2016年7月18日 上午9:47:27 
*/
@Controller
@RequestMapping("/manage/ad/chkattRecord")
public class AdChkattRecordController extends BaseController {
	
	@Autowired
	private IAdChkattRecordService chkattRecordService;
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/ad/chkatt/chkattRecord/list";
	}
	
	@RequestMapping("/getLeaveChartData")
	@ResponseBody
	public String getLeaveChartData(@RequestBody Map<String, Object> requestMap) {
		return JSON.toJSONString(chkattRecordService.getLeaveChartData(requestMap));
	}
	
}
