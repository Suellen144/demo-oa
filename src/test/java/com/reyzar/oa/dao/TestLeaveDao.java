package com.reyzar.oa.dao;

import java.util.Map;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.google.common.collect.Maps;
import com.reyzar.oa.JUnitActionBase;

public class TestLeaveDao extends JUnitActionBase {

	@Autowired
	private IAdLeaveDao leaveDao;
	
	@Test
	public void testPage() {
		Map<String, Object> params = Maps.newHashMap();
		params.put("userId", "1");
		
		leaveDao.findByPage(params);
	}
}
