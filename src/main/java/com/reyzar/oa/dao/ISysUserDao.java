package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysUser;

@MyBatisDao
public interface ISysUserDao {
	
	public Page<SysUser> findByPage(Map<String, Object> params);
	
	public SysUser findByAccount(String account);
	
	public SysUser findById(Integer id);
	
	public SysUser findAllById(Integer id);
	
	public List<SysUser> findByDeptid(Integer deptId);
	
	public SysUser findManagerByDeptcode(String deptCode);
	
	public List<SysUser> findByPositionCode(String positionCode);
	
	public List<SysUser> findByPositionId(Integer positionId);
	
	public List<SysUser> findByUserIds(@Param(value="userIdList")List<Integer> userIdList);
	
	public List<SysUser> findByDeptIds(@Param(value="deptIdList")List<Integer> deptIdList);
	
	public List<SysUser> findAll();
	
	public List<SysUser> findAllByMeeting();
	
	public void save(SysUser user);
	
	public void update(SysUser user);
	
	public void deleteById(Integer id);
	
	public void setNullByDeptid(Integer deptId);

	public List<Integer> findIdByPrincipalId(Integer principalId);
	
	public Integer findMaxId();	
	
	public SysUser finNewUser();

	public List<SysUser> findDeleteUsersByMonth(Map<String, Object> params);

	public Page<SysUser> findByPage2(Map<String, Object> params);
	
	public int updateLogin(SysUser user);

	public List<SysUser> findByName(String name);
}