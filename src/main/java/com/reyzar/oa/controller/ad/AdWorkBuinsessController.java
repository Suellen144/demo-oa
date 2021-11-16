package com.reyzar.oa.controller.ad;

import java.util.List;

import com.reyzar.oa.common.dto.CrudResultDTO;
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
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdWorkBuinsess;
import com.reyzar.oa.domain.AdWorkBuinsessAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdWorkBuinsessService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

@Controller
@RequestMapping("/manage/ad/workBiness")
public class AdWorkBuinsessController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdWorkBuinsessController.class);
	@Autowired
	private IAdWorkBuinsessService buinessService;
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private ISysUserService userService;
	
	@RequestMapping("/toAdd")
	public String toAdd(Model model) {
		return "manage/ad/workBiness/add";
	}
	
	
	@RequestMapping("/toEdit")
	public String toEdit(Integer id,Model model) {
		AdWorkBuinsess buinsess = buinessService.findById(id);
		SysUser user = userService.findById(buinsess.getUserId());
		SysDept dept = deptService.findById(buinsess.getDeptId());
		List<AdWorkBuinsessAttach> buinsessAttachs = buinsess.getBuinsessAttachsList();
		model.addAttribute("dept", dept);
		model.addAttribute("user", user);
		model.addAttribute("buinsess", buinsess);
		model.addAttribute("buinsessAttachs", buinsessAttachs);
		return "manage/ad/workBiness/edit";
	}
	

	@RequestMapping("/toList")
	public String toList(Integer id,Model model) {
		AdWorkBuinsess buinsess = buinessService.findById(id);
		SysUser user = userService.findById(buinsess.getUserId());
		SysDept dept = deptService.findById(buinsess.getDeptId());
		List<AdWorkBuinsessAttach> buinsessAttachs = buinsess.getBuinsessAttachsList();
		model.addAttribute("dept", dept);
		model.addAttribute("user", user);
		model.addAttribute("buinsess", buinsess);
		model.addAttribute("buinsessAttachs", buinsessAttachs);
		return "manage/ad/workBiness/list";
	}
	
	@RequestMapping(value="/saveOrUpdate", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		return JSON.toJSONString(buinessService.saveOrUpdate(json));
	}
	
	@RequestMapping(value="/getWorkBiness")
	@ResponseBody
	public AdWorkBuinsess getWorkBiness(Integer id) {
		return buinessService.findById(id);
	}


	/**
	 * 驳回流程
	 * @param id
	 * @return
	 */
	@RequestMapping("/rejectProcess")
	@ResponseBody
	public CrudResultDTO rejectProcess(Integer id,String contents){
		return buinessService.rejectProcess(id,contents);
	}
}