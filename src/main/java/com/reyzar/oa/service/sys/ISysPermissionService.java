package com.reyzar.oa.service.sys;

import java.util.List;

import com.reyzar.oa.domain.SysPermission;

public interface ISysPermissionService {
	
	public List<SysPermission> findByMenuid(Integer menuid);
	
	public void insertAll(List<SysPermission> permissionList);
	
	public void deleteByMenuid(Integer menuid);
	
	public void deleteByMenuids(List<Integer> ids);
	
	public void deleteByIds(List<Integer> idList);
	
}