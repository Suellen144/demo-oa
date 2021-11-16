package com.reyzar.oa.controller;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.springframework.test.web.servlet.MvcResult;

import com.reyzar.oa.JUnitActionBase;

public class TestLoginController extends JUnitActionBase {

	@Test
	public void testLogin() throws Exception {
		Map<String, String[]> params = new HashMap<String, String[]>();
		params.put("username", new String[]{"aaa"});
		params.put("password", new String[]{"bbb"});
		MvcResult result = this.executeActionForHttpRequest("post","/login", params);
		
		System.out.println(result.getResponse().getContentAsString());
	}
}
