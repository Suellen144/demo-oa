package com.reyzar.oa.controller.ad;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.reyzar.oa.domain.*;
import com.reyzar.oa.service.ad.IAdKpiService;
import com.reyzar.oa.service.ad.IAdRecordSalaryHistoryService;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.ad.IAdrewardService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import com.reyzar.oa.controller.BaseController;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/manage/ad/reward")
public class AdrewardController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdrewardController.class);

	@Autowired
	private IAdrewardService rewardService;
	@Autowired
	private IAdRecordService recordService;
	@Autowired
	private ISysUserService userService;
	@Autowired
	private IAdRecordSalaryHistoryService salaryHistoryService;
	@Autowired
	private IAdKpiService kpiService;
	@Autowired
	private ISysDeptService sysDeptService;

	@RequestMapping("/toList")
	public String toList(Model model){
		return "manage/ad/reward/list";
	}

	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);

		Page<Adreward> page = rewardService.findByPage(paramsMap,
				Integer.valueOf(paramsMap.get("pageNum").toString()),
				Integer.valueOf(paramsMap.get("pageSize").toString()));

		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
	}

	@RequestMapping("/toAdd")
	public String toAdd(String startTime, String endTime,Model model) throws ParseException{
		List<Integer> deptIdList = Lists.newArrayList();
		deptIdList.add(2);
		deptIdList.add(10);
		deptIdList.add(3);
		deptIdList.add(6);
		deptIdList.add(5);
		deptIdList.add(4);
		deptIdList.add(20);
		List<SysDept> sysDept=sysDeptService.findByParentid(3);
		for (int i = 0; i < sysDept.size(); i++) {
			deptIdList.add(sysDept.get(i).getId());
		}
		sysDept=sysDeptService.findByParentid(6);
		for (int i = 0; i < sysDept.size(); i++) {
			deptIdList.add(sysDept.get(i).getId());
		}
		sysDept=sysDeptService.findByParentid(5);
		for (int i = 0; i < sysDept.size(); i++) {
			deptIdList.add(sysDept.get(i).getId());
		}
		sysDept=sysDeptService.findByParentid(4);
		for (int i = 0; i < sysDept.size(); i++) {
			deptIdList.add(sysDept.get(i).getId());
		}
		List<AdRecord> userList = recordService.findByDeptIds(deptIdList);
		List listAll = new ArrayList();
		List<AdrewardAttach> rewardListGl = Lists.newArrayList();
		List<AdrewardAttach> rewardListSc = Lists.newArrayList();
		List<AdrewardAttach> rewardListGc = Lists.newArrayList();
		List<AdrewardAttach> rewardListYf = Lists.newArrayList();
		List<AdrewardAttach> rewardListXz = Lists.newArrayList();
		List<AdrewardAttach> rewardListzjb = Lists.newArrayList();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Calendar c = new GregorianCalendar();
		Date date = null;
		for(AdRecord adRecord : userList){
			c.setTime(adRecord.getEntryTime());
			c.add(Calendar.MONTH,3);
			date = c.getTime();
			String time = df.format(date);
			AdrewardAttach attach = new AdrewardAttach();
			if(startTime != "" && endTime == "") {
				if(df.parse(time).getTime() >= df.parse(startTime).getTime()) {
					String[] strs = adRecord.getPosition().split(",");
					adRecord.setPosition(strs[0].toString());
					AdRecordSalaryHistory salary = salaryHistoryService.findOne(adRecord.getUserId());
					List<AdKpiAttach> list = kpiService.findByUserIdAndTime(adRecord.getUserId(), startTime, endTime);
					if(list.get(0) != null) {
						adRecord.setScore(list.get(0).getCeoScore().toString());
					}
					attach.setSalary(salary);
					attach.setRecord(adRecord);
					if(adRecord.getDept().equals("总经理") || adRecord.getDept().equals("副总经理")) {
						rewardListGl.add(attach);
					}else if(adRecord.getDeptId()==3 || adRecord.getDeptId()==35|| adRecord.getDeptId()==36|| adRecord.getDeptId()==37|| adRecord.getDeptId()==38|| adRecord.getDeptId()==39) {
						rewardListSc.add(attach);
					}else if(adRecord.getDeptId() == 6) {
						rewardListGc.add(attach);
					}else if(adRecord.getDeptId()==5 || adRecord.getDeptId()==40|| adRecord.getDeptId()==41|| adRecord.getDeptId()==42|| adRecord.getDeptId()==43|| adRecord.getDeptId()==44) {
						rewardListYf.add(attach);
					}else if(adRecord.getDeptId()==4){
						rewardListXz.add(attach);
					}else {
						rewardListzjb.add(attach);
					}
				}
			}else if(startTime == "" && endTime != "") {
				if(df.parse(time).getTime() <= df.parse(endTime).getTime()) {
					String[] strs = adRecord.getPosition().split(",");
					adRecord.setPosition(strs[0].toString());
					AdRecordSalaryHistory salary = salaryHistoryService.findOne(adRecord.getUserId());
					List<AdKpiAttach> list = kpiService.findByUserIdAndTime(adRecord.getUserId(), startTime, endTime);
					if(list.get(0) != null) {
						adRecord.setScore(list.get(0).getCeoScore().toString());
					}
					attach.setSalary(salary);
					attach.setRecord(adRecord);
					if(adRecord.getDept().equals("总经理") || adRecord.getDept().equals("副总经理")) {
						rewardListGl.add(attach);
					}else if(adRecord.getDeptId()==3 || adRecord.getDeptId()==35|| adRecord.getDeptId()==36|| adRecord.getDeptId()==37|| adRecord.getDeptId()==38|| adRecord.getDeptId()==39) {
						rewardListSc.add(attach);
					}else if(adRecord.getDeptId() == 6) {
						rewardListGc.add(attach);
					}else if(adRecord.getDeptId()==5 || adRecord.getDeptId()==40|| adRecord.getDeptId()==41|| adRecord.getDeptId()==42|| adRecord.getDeptId()==43|| adRecord.getDeptId()==44) {
						rewardListYf.add(attach);
					}else if(adRecord.getDeptId()==4){
						rewardListXz.add(attach);
					}else {
						rewardListzjb.add(attach);
					}
				}
			}else if(startTime != "" && endTime != "") {
				if(df.parse(time).getTime() >= df.parse(startTime).getTime() && df.parse(time).getTime() <= df.parse(endTime).getTime()) {
					String[] strs = adRecord.getPosition().split(",");
					adRecord.setPosition(strs[0].toString());
					AdRecordSalaryHistory salary = salaryHistoryService.findOne(adRecord.getUserId());
					List<AdKpiAttach> list = kpiService.findByUserIdAndTime(adRecord.getUserId(), startTime, endTime);
					if(list.get(0) != null) {
						adRecord.setScore(list.get(0).getCeoScore().toString());
					}
					attach.setSalary(salary);
					attach.setRecord(adRecord);
					if(adRecord.getDept().equals("总经理") || adRecord.getDept().equals("副总经理")) {
						rewardListGl.add(attach);
					}else if(adRecord.getDeptId()==3 || adRecord.getDeptId()==35|| adRecord.getDeptId()==36|| adRecord.getDeptId()==37|| adRecord.getDeptId()==38|| adRecord.getDeptId()==39) {
						rewardListSc.add(attach);
					}else if(adRecord.getDeptId() == 6) {
						rewardListGc.add(attach);
					}else if(adRecord.getDeptId()==5 || adRecord.getDeptId()==40|| adRecord.getDeptId()==41|| adRecord.getDeptId()==42|| adRecord.getDeptId()==43|| adRecord.getDeptId()==44) {
						rewardListYf.add(attach);
					}else if(adRecord.getDeptId()==4){
						rewardListXz.add(attach);
					}else {
						rewardListzjb.add(attach);
					}
				}
			}else if(startTime == "" && endTime == "") {
				String[] strs = adRecord.getPosition().split(",");
				adRecord.setPosition(strs[0].toString());
				AdRecordSalaryHistory salary = salaryHistoryService.findOne(adRecord.getUserId());
				List<AdKpiAttach> list = kpiService.findByUserIdAndTime(adRecord.getUserId(), startTime, endTime);
				if(list.get(0) != null) {
					adRecord.setScore(list.get(0).getCeoScore().toString());
				}
				attach.setSalary(salary);
				attach.setRecord(adRecord);
				if(adRecord.getDept().equals("总经理") || adRecord.getDept().equals("副总经理")) {
					rewardListGl.add(attach);
				}else if(adRecord.getDeptId()==3 || adRecord.getDeptId()==35|| adRecord.getDeptId()==36|| adRecord.getDeptId()==37|| adRecord.getDeptId()==38) {
					rewardListSc.add(attach);
				}else if(adRecord.getDeptId() == 6) {
					rewardListGc.add(attach);
				}else if(adRecord.getDeptId()==5 || adRecord.getDeptId()==40|| adRecord.getDeptId()==41|| adRecord.getDeptId()==42|| adRecord.getDeptId()==43|| adRecord.getDeptId()==44) {
					rewardListYf.add(attach);
				}else if(adRecord.getDeptId()==4){
					rewardListXz.add(attach);
				}else {
					rewardListzjb.add(attach);
				}
			}
		}
		listAll.add(rewardListGl);
		listAll.add(rewardListzjb);
		listAll.add(rewardListSc);
		listAll.add(rewardListGc);
		listAll.add(rewardListYf);
		listAll.add(rewardListXz);
		model.addAttribute("list", listAll);
		return "manage/ad/reward/add";
	}


	@RequestMapping("/toEdit")
	public String toEdit(Integer id,Model model){
		List listAll = new ArrayList();
		List<AdrewardAttach> rewardListGl = Lists.newArrayList();
		List<AdrewardAttach> rewardListSc = Lists.newArrayList();
		List<AdrewardAttach> rewardListGc = Lists.newArrayList();
		List<AdrewardAttach> rewardListYf = Lists.newArrayList();
		List<AdrewardAttach> rewardListXz = Lists.newArrayList();
		List<AdrewardAttach> rewardListzjb = Lists.newArrayList();
		Adreward reward = rewardService.findById(id);
		List<AdrewardAttach> rewardList = reward.getAdrewardAttachList();
		for (AdrewardAttach adrewardAttach : rewardList) {
			String[] strs = adrewardAttach.getRecord().getPosition().split(",");
			adrewardAttach.getRecord().setPosition(strs[0].toString());
			if(adrewardAttach.getDpetId()==null && adrewardAttach.getUserId()!=null) {
				SysUser sysUser=userService.findAllById(adrewardAttach.getUserId());
				if(sysUser!=null) {
					adrewardAttach.setDpetId(sysUser.getDeptId());
				}
			}
				if(adrewardAttach.getDpetId() == 2 || adrewardAttach.getDpetId() == 10) {
					rewardListGl.add(adrewardAttach);
				}else if(adrewardAttach.getDpetId()==3 || adrewardAttach.getDpetId()==35|| adrewardAttach.getDpetId()==36|| adrewardAttach.getDpetId()==37|| adrewardAttach.getDpetId()==38|| adrewardAttach.getDpetId()==39) {
					rewardListSc.add(adrewardAttach);
				}else if(adrewardAttach.getDpetId() == 6) {
					rewardListGc.add(adrewardAttach);
				}else if(adrewardAttach.getDpetId()==5 || adrewardAttach.getDpetId()==40|| adrewardAttach.getDpetId()==41|| adrewardAttach.getDpetId()==42|| adrewardAttach.getDpetId()==43|| adrewardAttach.getDpetId()==44) {
					rewardListYf.add(adrewardAttach);
				}else if(adrewardAttach.getDpetId()==4){
					rewardListXz.add(adrewardAttach);
				}else  {
					rewardListzjb.add(adrewardAttach);
				}
			
		}
		model.addAttribute("reward", reward);
		listAll.add(rewardListGl);
		listAll.add(rewardListzjb);
		listAll.add(rewardListSc);
		listAll.add(rewardListGc);
		listAll.add(rewardListYf);
		listAll.add(rewardListXz);
		model.addAttribute("list", listAll);
		/*model.addAttribute("rewardList", rewardList);*/
		return "manage/ad/reward/edit";
	}


	@RequestMapping(value="/save", method= RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json){
		return JSON.toJSONString(rewardService.save(json));
	}

	@RequestMapping(value="/update", method= RequestMethod.POST)
	@ResponseBody
	public String update(@RequestBody JSONObject json){
		return JSON.toJSONString(rewardService.update(json));
	}

	@RequestMapping("/exportExcel")
	@ResponseBody
	public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
		Map<String,Object> paramMap=parseRequestMap(request);
		String fileName = "年度留任奖表格.xls";
		String agent = request.getHeader("USER-AGENT").toLowerCase();
		if (agent.contains("firefox")){
			response.setCharacterEncoding("UTF-8");
			fileName = new String(fileName.getBytes(),"ISO8859-1");
		} else {
			fileName = java.net.URLEncoder.encode(fileName,"UTF-8");
		}
		response.setContentType("application/vnd.ms-excel;charset=utf-8");
		response.addHeader("Content-Disposition","attachment;filenaem="+fileName);
		rewardService.exportExcel(response.getOutputStream(), paramMap);
	}

}