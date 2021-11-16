package com.reyzar.oa.dao;

import java.util.List;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.reyzar.oa.JUnitActionBase;
import com.reyzar.oa.domain.SysRole;

public class TestSysRoleDao extends JUnitActionBase {

	@Autowired
	private IRoleMenuDao roleMenuDao;
	@Autowired
	private ISysRoleDao roleDao;
	
	@Test
	public void testRoleMenu() {
		List<Integer> menuids = roleMenuDao.findRoleMenu(1);
		SysRole role = roleDao.findById(47);
		
		System.out.println(menuids);
	}
}
