package com.reyzar.oa.controller.sys;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SysProcessTodo;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysProcessTodoService;

@Controller
@RequestMapping("/manage/sys/processtodo")
public class SysProcessTodoController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SysProcessTodoController.class);
	private final static int COMPANY_LEVEL = 1;
	
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private ISysProcessTodoService processTodoService;
	
	@RequestMapping("/toPage")
	public String toPage(Model model) {
		model.addAttribute("companyList", deptService.findByLevel(COMPANY_LEVEL));
		return "manage/sys/processtodo/list";
	}
	
	@RequestMapping("/getAllData")
	@ResponseBody
	public List<SysProcessTodo> getAllData() {
		List<SysProcessTodo> processTodoList = processTodoService.getAllData();
		return processTodoList;
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public CrudResultDTO save(@RequestBody List<SysProcessTodo> processTodoList) {
		return processTodoService.save(processTodoList);
	}
}