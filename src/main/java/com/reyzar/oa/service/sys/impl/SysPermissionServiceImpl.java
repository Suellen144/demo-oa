package com.reyzar.oa.service.sys.impl;

import java.util.List;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.dao.ISysPermissionDao;
import com.reyzar.oa.domain.SysPermission;
import com.reyzar.oa.service.sys.ISysPermissionService;

@Service
@Transactional
public class SysPermissionServiceImpl implements ISysPermissionService {

	@Autowired
	private ISysPermissionDao permissionDao;
	
	@Override
	public List<SysPermission> findByMenuid(Integer menuid) {
		return permissionDao.findByMenuid(menuid);
	}
	
	@Override
	public void insertAll(List<SysPermission> permissionList) {
		permissionDao.insertAll(permissionList);
	}

	@Override
	public void deleteByMenuid(Integer menuid) {
		permissionDao.deleteByMenuid(menuid);
	}
	
	@Override
	public void deleteByMenuids(List<Integer> ids) {
		permissionDao.deleteByMenuids(ids);
	}

	@Override
	public void deleteByIds(List<Integer> idList) {
		permissionDao.deleteByIds(idList);
	}

}