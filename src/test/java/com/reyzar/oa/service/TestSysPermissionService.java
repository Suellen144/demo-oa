package com.reyzar.oa.service;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.reyzar.oa.JUnitActionBase;
import com.reyzar.oa.domain.SysPermission;
import com.reyzar.oa.service.sys.ISysPermissionService;

public class TestSysPermissionService extends JUnitActionBase {

	@Autowired
	private ISysPermissionService permissionService;
	
	@Test
	public void testFindByMenuid() {
		List<SysPermission> permissionList = permissionService.findByMenuid(1);
		
		System.out.println(permissionList);
	}
}
