package com.reyzar.oa.service.sys.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.dao.ISysDataPermissionDao;
import com.reyzar.oa.domain.SysDataPermission;
import com.reyzar.oa.service.sys.ISysDataPermissionService;

@Service
@Transactional
public class SysDataPermissionServiceImpl implements ISysDataPermissionService {
	
	@Autowired
	private ISysDataPermissionDao dataPermissionDao;
	
	@Override
	public List<SysDataPermission> findByRoleId(Integer roleId) {
		return dataPermissionDao.findByRoleId(roleId);
	}

	@Override
	public void batchSave(List<SysDataPermission> dataPermissionList) {
		dataPermissionDao.batchSave(dataPermissionList);
	}

	@Override
	public void batchUpdate(List<SysDataPermission> dataPermissionList) {
		dataPermissionDao.batchUpdate(dataPermissionList);
	}

	@Override
	public List<SysDataPermission> findByRoleIdAndMenuId(List<Integer> roleIdList, Integer menuId) {
		return dataPermissionDao.findByRoleIdAndMenuId(roleIdList, menuId);
	}

	@Override
	public boolean isHavePermission(List<Integer> roleIdList, Integer menuId) {
		Integer count = dataPermissionDao.getCountByRoleIdAndMenuId(roleIdList, menuId); 
		return (count != null && count > 0);
	}
	
}