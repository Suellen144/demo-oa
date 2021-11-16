package com.reyzar.oa.service.sys.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.shiro.CustomRealm;
import com.reyzar.oa.common.util.SpringContextUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IRoleMenuDao;
import com.reyzar.oa.dao.IRolePermissionDao;
import com.reyzar.oa.dao.ISysRoleDao;
import com.reyzar.oa.dao.IUserRoleDao;
import com.reyzar.oa.domain.SysDataPermission;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysDataPermissionService;
import com.reyzar.oa.service.sys.ISysRoleService;

@Service
@Transactional(propagation=Propagation.REQUIRED,rollbackFor={Exception.class,RuntimeException.class})
public class SysRoleServiceImpl implements ISysRoleService {

	@Autowired
	private ISysRoleDao roleDao;
	@Autowired
	private IRoleMenuDao roleMenuDao;
	@Autowired
	private IRolePermissionDao rolePermissionDao;
	@Autowired
	private IUserRoleDao userRoleDao;
	@Autowired
	private ISysDataPermissionService dataPermissionService;
	
	@Override
	public List<SysRole> findAll() {
		return roleDao.findAll();
	}
	
	@Override
	public Page<SysRole> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<SysRole> page = roleDao.findByPage(params);
		
		return page;
	}
	
	@Override
	public SysRole findById(Integer id) {
		return roleDao.findById(id);
	}
	
	@Override
	public SysRole save(SysRole role) {
		if(role.getId() == null) {
			roleDao.save(role);
		} else {
			SysRole old = roleDao.findById(role.getId());
			if( !old.getEnabled().equals(role.getEnabled()) ) {
				// 更新所有用户关联的权限
				CustomRealm realm = SpringContextUtils.getBean(CustomRealm.class);
				realm.clearAllCachedInfo();
			}
			
			roleDao.update(role);
		}
		return role;
	}

	@Override
	public boolean revoke(Integer id) {
		try {
			SysRole sysRole=roleDao.findById(id);
			if(sysRole!=null) {
				sysRole.setIsDeleted("1");
			}
			roleDao.update(sysRole);
			//roleMenuDao.delByRoleid(id);
			//rolePermissionDao.delByRoleid(id);
			//userRoleDao.delByRoleid(id);
			
			// 更新所有用户关联的权限
			//CustomRealm realm = SpringContextUtils.getBean(CustomRealm.class);
		//	realm.clearAllCachedInfo();
		} catch(Exception e) {
			return false;
		}
		
		return true;
	}

	//删除
	@Override
	public boolean delete(Integer id) {
		try {
			roleDao.delete(id);
		} catch(Exception e) {
			return false;
		}
		return true;
	}

	private boolean saveRoleMenu(Integer roleId, List<Integer> menuidList) {
		List<Integer> oldMenuidList = roleMenuDao.findRoleMenu(roleId);
		Set<Integer> oldmenuidSet = new HashSet<Integer>(oldMenuidList);
		List<Integer> newMenuidList = new ArrayList<Integer>();
		
		for(Integer menuid : menuidList) {
			if(!oldmenuidSet.contains(menuid)) {
				newMenuidList.add(menuid);
			}
		}
		
		try {
			roleMenuDao.delete(roleId, menuidList);
			if(newMenuidList.size() > 0) {
				roleMenuDao.insertAll(roleId, newMenuidList);
			}
			
		} catch(Exception e) {
			return false;
		}
		return true;
	}

	private boolean saveRolePermission(Integer roleId, List<Integer> permissionidList) {
		List<Integer> oldPermissionidList = rolePermissionDao.findRolePermission(roleId);
		Set<Integer> oldPermissionidSet = new HashSet<Integer>(oldPermissionidList);
		List<Integer> newPermissionidList = new ArrayList<Integer>();
		
		for(Integer permissionid : permissionidList) {
			if(!oldPermissionidSet.contains(permissionid)) {
				newPermissionidList.add(permissionid);
			}
		}
		
		try {
			rolePermissionDao.delete(roleId, permissionidList);
			if(newPermissionidList.size() > 0) {
				rolePermissionDao.insertAll(roleId, newPermissionidList);
			}
			
		} catch(Exception e) {
			return false;
		}
		return true;
	}
	
	private boolean saveDataPermission(List<SysDataPermission> dataPermissionList) {
		List<SysDataPermission> addList = Lists.newArrayList();
		List<SysDataPermission> modList = Lists.newArrayList();
		try {
			SysUser user = UserUtils.getCurrUser();
			for(SysDataPermission dataPermission : dataPermissionList) {
				if(dataPermission.getId() == null) {
					dataPermission.setCreateBy(user.getAccount());
					dataPermission.setCreateDate(new Date());
					
					addList.add(dataPermission);
				} else {
					dataPermission.setUpdateBy(user.getAccount());
					dataPermission.setUpdateDate(new Date());
					
					modList.add(dataPermission);
				}
			}
			
			if(addList.size() > 0) {
				dataPermissionService.batchSave(addList);
			}
			if(modList.size() > 0) {
				dataPermissionService.batchUpdate(modList);
			}
		} catch(Exception e) {
			return false;
		}
		
		return true;
	}

	@Override
	public CrudResultDTO saveAuthority(List<Integer> menuidList, List<Integer> permissionidList, 
			Integer roleId, List<SysDataPermission> dataPermissionList) {
		try {
			boolean roleMenuFlag = saveRoleMenu(roleId, menuidList);
			boolean rolePermissionFlag = saveRolePermission(roleId, permissionidList);
			boolean dataPermissionFlag = saveDataPermission(dataPermissionList);
			if(roleMenuFlag && rolePermissionFlag && dataPermissionFlag) {
				SysRole role = findById(roleId);
				save(role);
				
				// 更新所有用户关联的权限
				CustomRealm realm = SpringContextUtils.getBean(CustomRealm.class);
				realm.clearAllCachedInfo();
				return new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功");
			} else {
				return new CrudResultDTO(CrudResultDTO.FAILED, "保存失败");
			}
		} catch(Exception e) {
			throw new BusinessException(e.getMessage());
		}
	}

	@Override
	public SysRole findByName(String name,Integer id) {
		return roleDao.findByName(name,id);
	}

	@Override
	public List<SysRole> getSysRole() {
		return roleDao.getSysRole();
	}

	@Override
	public int update(SysRole role) {
		return roleDao.update(role);
	}

	@Override
	public List<SysRole> findByDeptId(Integer deptId, Integer isDelete) {
		return roleDao.findByDeptId(deptId, isDelete);
	}

	@Override
	public List<SysRole> findByRoleId(Integer id) {
		return roleDao.findByRoleId(id);
	}

}