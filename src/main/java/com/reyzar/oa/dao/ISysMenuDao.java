package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysMenu;

@MyBatisDao
public interface ISysMenuDao {
	
	public List<SysMenu> findAll();
	
	public List<SysMenu> findByUserid(Integer userId);
	
	public List<SysMenu> findByUserId(Integer userId);
	
	public SysMenu findById(Integer id);
	
	public List<SysMenu> findByParentid(Integer parentId);
	
	public SysMenu findParentById(Integer parentId);
	
	public SysMenu findByName(String name);
	
	public int deleteById(Integer id);
	
	public int deleteByIds(List<Integer> ids);
	
	public void insert(SysMenu menu);
	
	public int update(SysMenu menu);
}