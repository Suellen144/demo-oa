package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;

@MyBatisDao
public interface IRolePermissionDao {

	public List<Integer> findRolePermission(@Param(value="roleId")Integer roleId);
	
	public void delete(@Param(value="roleId")Integer roleId, @Param(value="permissionidList")List<Integer> permissionidList);
	
	public void delByRoleid(Integer roleId);
	
	public void delByMenuids(List<Integer> idList);
	
	public void delByPermissionids(List<Integer> idList);
	
	public void insertAll(@Param(value="roleId")Integer roleId, @Param(value="permissionidList")List<Integer> permissionidList);
}
