package com.reyzar.oa.service;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;

import com.reyzar.oa.JUnitActionBase;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysUserService;

public class TestSysUserService extends JUnitActionBase {

	@Autowired
	private ISysUserService sysUserService;
	
	@Test
	public void testGetUser() {
		SysUser user = sysUserService.findByAccount("abc");
		
		Assert.notNull(user);
		System.out.println(user);
	}
}
