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
import com.reyzar.oa.domain.AdWorkMarket;
import com.reyzar.oa.domain.AdWorkMarketAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdWorkMarketService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

@Controller
@RequestMapping("/manage/ad/workMarket")
public class AdWorkMarketController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdWorkMarketController.class);
	@Autowired
	private IAdWorkMarketService marketSeavice;
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private ISysUserService userService;
	@RequestMapping("/toAdd")
	public String toAdd(Model model) {
		return "manage/ad/workMarket/add";
	}
	
	@RequestMapping("/toEdit")
	public String toEdit(Integer id,Model model) {
		AdWorkMarket market = marketSeavice.findById(id);
		SysUser user = userService.findById(market.getUserId());
		SysDept dept = deptService.findById(market.getDeptId());
		List<AdWorkMarketAttach> marketAttachs = market.getMarketAttachsList();
		model.addAttribute("market", market);
		model.addAttribute("marketAttachs", marketAttachs);
		model.addAttribute("dept", dept);
		model.addAttribute("user", user);
		return "manage/ad/workMarket/edit";
	}
	
	@RequestMapping("/toList")
	public String toList(Integer id,Model model) {
		AdWorkMarket market = marketSeavice.findById(id);
		SysUser user = userService.findById(market.getUserId());
		SysDept dept = deptService.findById(market.getDeptId());
		List<AdWorkMarketAttach> marketAttachs = market.getMarketAttachsList();
		model.addAttribute("market", market);
		model.addAttribute("marketAttachs", marketAttachs);
		model.addAttribute("dept", dept);
		model.addAttribute("user", user);
		return "manage/ad/workMarket/list";
	}
	
	@RequestMapping(value="/saveOrUpdate", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json) {
		return JSON.toJSONString(marketSeavice.saveOrUpdate(json));
	}
	
	@RequestMapping(value="/getWorkMarket")
	@ResponseBody
	public AdWorkMarket getWorkMarket(Integer id) {
		return marketSeavice.findById(id);
	}

	@RequestMapping("/rejectProcess")
	@ResponseBody
	public CrudResultDTO rejectProcess(Integer id,String contents){
		return marketSeavice.rejectProcess(id,contents);
	}
}