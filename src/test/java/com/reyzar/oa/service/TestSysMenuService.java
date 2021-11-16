package com.reyzar.oa.service;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import com.reyzar.oa.JUnitActionBase;
import com.reyzar.oa.service.sys.ISysMenuService;

public class TestSysMenuService extends JUnitActionBase {

	@Autowired
	ISysMenuService menuService;
	
	@Test
	public void testMenuList() {
		String menuJson = menuService.findMenuForJson();
		/*System.out.println(menuJson);
		
		PageHelper.startPage(1, 3);
		List<SysMenu> menuList = menuService.findAll();
		
		if(menuList instanceof Page) {
			Page<SysMenu> page = (Page<SysMenu>) menuList;
			System.out.println(page);
		} else {
			System.out.println(menuList);
		}*/
		
	}
}
