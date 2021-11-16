package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysPermission;

@MyBatisDao
public interface ISysPermissionDao {
	
	public List<SysPermission> findByMenuid(Integer menuid);
	
	public void insertAll(List<SysPermission> permissionList);
	
	public void deleteByMenuid(Integer menuid);
	
	public void deleteByMenuids(List<Integer> ids);
	
	public void deleteByIds(List<Integer> idList);
	
}