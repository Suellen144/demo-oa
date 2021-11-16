package com.reyzar.oa.controller;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;
import org.springframework.test.web.servlet.MvcResult;

import com.reyzar.oa.JUnitActionBase;

public class TestMenuController extends JUnitActionBase {

	@Test
	public void testSave() throws Exception {
		//this.isDetail = false;
		Map<String, String[]> params = new HashMap<String, String[]>();
		params.put("id", new String[]{"2"});
		params.put("sort", new String[]{"100"});
		
		MvcResult result = this.executeActionForHttpRequest("post","/sys/menu/save", params);
		
		System.out.println(result.getResponse().getContentAsString());
	}
}
