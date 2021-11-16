package com.reyzar.oa.service.sys;

import java.util.List;

import com.reyzar.oa.domain.SysDataPermission;

public interface ISysDataPermissionService {
	
	public List<SysDataPermission> findByRoleId(Integer roleId);
	
	public List<SysDataPermission> findByRoleIdAndMenuId(List<Integer> roleIdList, Integer menuId);
	
	public void batchSave(List<SysDataPermission> dataPermissionList);
	
	public void batchUpdate(List<SysDataPermission> dataPermissionList);
	
	public boolean isHavePermission(List<Integer> roleIdList, Integer menuId);
}