package com.reyzar.oa.service.sys;

import java.util.List;

import com.reyzar.oa.domain.SysMenu;

public interface ISysMenuService {
	
	public String findMenuForJson();
	
	public String findMenuForJson2();
	
	public List<SysMenu> findAll();
	
	public SysMenu findById(Integer id);
	
	public List<SysMenu> findByParentid(Integer parentId);
	
	public SysMenu findParentById(Integer parentId);
	
	public SysMenu findByName(String name);
	
	public void save(SysMenu menu);
	
	public void deleteById(Integer id);
}