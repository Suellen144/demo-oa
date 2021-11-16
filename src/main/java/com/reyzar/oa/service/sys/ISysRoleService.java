package com.reyzar.oa.service.sys;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SysDataPermission;
import com.reyzar.oa.domain.SysRole;

public interface ISysRoleService {
	
	public List<SysRole> findAll();
	
	public List<SysRole> getSysRole();
	
	public Page<SysRole> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public SysRole findById(Integer id);
	
	public SysRole findByName(String name,Integer id);
	
	public SysRole save(SysRole role);
	
	public CrudResultDTO saveAuthority(List<Integer> menuidList, List<Integer> permissionidList, 
			Integer roleId, List<SysDataPermission> dataPermissionList);
	
	public boolean revoke(Integer id);

	public boolean delete(Integer id);
	
	public int update(SysRole role);
	
	public List<SysRole> findByDeptId(Integer deptId,Integer isDelete);
	
	public List<SysRole> findByRoleId(Integer id);
}