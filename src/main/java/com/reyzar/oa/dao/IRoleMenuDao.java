package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;

@MyBatisDao
public interface IRoleMenuDao {
	
	public List<Integer> findRoleMenu(@Param(value="roleId")Integer roleId);
	
	public void delete(@Param(value="roleId")Integer roleId, @Param(value="menuidList")List<Integer> menuidList);
	
	public void delByRoleid(Integer roleId);
	
	public void delByMenuids(List<Integer> ids);
	
	public void insertAll(@Param(value="roleId")Integer roleId, @Param(value="menuidList")List<Integer> menuidList);
}
