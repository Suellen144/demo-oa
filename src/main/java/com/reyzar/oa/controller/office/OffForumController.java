package com.reyzar.oa.controller.office;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.service.office.IOffForumService;
import com.reyzar.oa.service.sys.ISysUserService;

@Controller
@RequestMapping("/manage/office/forum")
public class OffForumController extends BaseController {

	@Autowired
	private IOffForumService forumService;
	
	@RequestMapping("/toList")
	public String toList(){
		return "manage/office/forum/list";
	}
	
	
}
