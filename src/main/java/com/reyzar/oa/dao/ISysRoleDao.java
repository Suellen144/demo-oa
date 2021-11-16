package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysRole;

@MyBatisDao
public interface ISysRoleDao {
	
	public List<SysRole> findAll();
	
	public List<SysRole> getSysRole();

	public Page<SysRole> findByPage(Map<String, Object> params);
	
	public SysRole findById(Integer id);
	
	public SysRole findByName(@Param("name")String name,@Param("id")Integer id);
	
	public List<SysRole> findByDeptId(@Param("deptId") Integer deptId,@Param("isDeleted")Integer isDelete);
	
	public void save(SysRole role);
	
	public int update(SysRole role);
	
	public int delete(Integer id);
	
	public List<SysRole> findByRoleId(Integer id);
}