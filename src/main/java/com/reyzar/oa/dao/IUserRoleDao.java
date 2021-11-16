package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;

@MyBatisDao
public interface IUserRoleDao {
	
	public List<Integer> findRoleidByUserid(Integer userId);
	
	public void insertAll(@Param(value="userId")Integer userId, @Param(value="roleidList")List<Integer> roleidList);

	public void delByRoleid(Integer roleId);
	
	public void delByUserid(Integer userId);
	
	public void delByUseridAndNotRoleid(@Param(value="userId")Integer userId, @Param(value="roleidList")List<Integer> roleidList);
}
