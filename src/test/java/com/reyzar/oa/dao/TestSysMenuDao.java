package com.reyzar.oa.dao;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.reyzar.oa.JUnitActionBase;
import com.reyzar.oa.domain.SysMenu;

public class TestSysMenuDao extends JUnitActionBase {

	@Autowired
	private ISysMenuDao menuDao;
	
	@Test
	public void testFind() {
		SysMenu menu = menuDao.findById(1);
		
		SysMenu parent = menuDao.findParentById(1);
		
		System.out.println(menu);
		System.out.println(parent);
	}
}
