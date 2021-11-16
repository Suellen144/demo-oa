package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysDataPermission;


@MyBatisDao
public interface ISysDataPermissionDao {
	
	public List<SysDataPermission> findAll();
	
	public SysDataPermission findById(Integer id);
	
	public List<SysDataPermission> findByRoleId(Integer roleId);
	
	public List<SysDataPermission> findByRoleIdAndMenuId(@Param("roleIdList") List<Integer> roleIdList, @Param("menuId") Integer menuId);
	
	public Integer getCountByRoleIdAndMenuId(@Param("roleIdList") List<Integer> roleIdList, @Param("menuId") Integer menuId);
	
	public void save(SysDataPermission sysDataPermission);
	
	public void batchSave(@Param("dataPermissionList") List<SysDataPermission> dataPermissionList);
	
	public void update(SysDataPermission sysDataPermission);
	
	public void batchUpdate(@Param("dataPermissionList") List<SysDataPermission> dataPermissionList);
	
	public void deleteById(Integer id);
	
}