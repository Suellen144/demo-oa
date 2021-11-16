package com.reyzar.oa.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.junit.Test;
import org.springframework.test.web.servlet.MvcResult;

import com.reyzar.oa.JUnitActionBase;

public class TestMainController extends JUnitActionBase  {

	@Test
	public void testGetMenuList() throws Exception {
		Subject user = SecurityUtils.getSubject();
		UsernamePasswordToken token = new UsernamePasswordToken("admin", "admin");
		user.login(token);
		
		Map<String, String[]> params = new HashMap<String, String[]>();
		MvcResult result = this.executeActionForHttpRequest("get","/manage/sys/menu/toList", params);
		
		System.out.println(result.getResponse().getContentAsString());
	}
}
