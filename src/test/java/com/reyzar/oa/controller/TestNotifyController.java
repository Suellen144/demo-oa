package com.reyzar.oa.controller;

import org.junit.Test;
import org.springframework.test.web.servlet.MvcResult;

import com.reyzar.oa.JUnitActionBase;

public class TestNotifyController extends JUnitActionBase {

	@Test
	public void testGetNotify() throws Exception {
		MvcResult result = this.executeActionForHttpRequest("/notify/getNotifyById?id=1");
		
		/*Map<String, String[]> params = new HashMap<String, String[]>();
		params.put("id", new String[]{"1"});
		MvcResult result = this.executeActionForHttpRequest("get","/notify/getNotifyById", params);*/
		
		System.out.println(result.getResponse().getContentAsString());
	}
}
