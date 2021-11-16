package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysUserPosition;

@MyBatisDao
public interface IUserPositionDao {

	public void insertAll(@Param(value="userId")Integer userId, @Param(value="positionIdList")List<Integer> positionIdList);

	public void delByPositionId(Integer positionId);
	
	public void delByUserId(Integer userId);
	
	public List<Map<Integer, Integer>> findbypostionId(Integer positionId);
	
	public SysUserPosition findByDeptAndLevel(Integer deptId);

	public SysUserPosition findByDeptAndLevel2(Integer deptId);	
}
