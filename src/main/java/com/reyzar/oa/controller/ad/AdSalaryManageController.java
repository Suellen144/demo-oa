package com.reyzar.oa.controller.ad;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.reyzar.oa.controller.BaseController;

@Controller
@RequestMapping("/manage/ad/salaryManage")
public class AdSalaryManageController  extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdSalaryManageController.class);
	
	@RequestMapping("/toList")
	public String toList(){
		return "manage/ad/salaryManage/list";
	}
}









