package com.reyzar.oa.service.sys;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SysUser;

public interface ISysUserService {
	
	public Page<SysUser> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public SysUser findByAccount(String account);
	
	public SysUser findById(Integer id);
	
	public List<SysUser> findByDeptid(Integer deptId);
	
	public SysUser findManagerByDeptcode(String deptCode);
	
	public List<SysUser> findByPositionCode(String positionCode);
	
	public List<SysUser> findByUserIds(List<Integer> userIdList);
	
	public List<SysUser> findByDeptIds(List<Integer> deptIdList);
	
	public List<SysUser> findAll();
	
	public List<SysUser> findDeleteUsersByMonth(Map<String, Object> params);
	
	public List<SysUser> findAllByMeeting();
	
	public CrudResultDTO save(SysUser user, String positionId, List<Integer> roleidList, SysUser currUser);

	public CrudResultDTO delete(Integer id);
	
	public void setNullByDeptid(Integer deptId);
	
	public CrudResultDTO save(SysUser user,SysUser currUser);
	
	public CrudResultDTO modifyPassword(String account, String photo);
	
	public CrudResultDTO modifyPhoto(String account, String photo);
	
	public CrudResultDTO resetPassword(Integer userId);

	public Map<String, Object> getLeaveChartData(Map<String, Object> paramsMap);
	
	public Map<String, Object> getLeaveData(Map<String, Object> paramsMap);
	
	public Map<String, Object> getTravelData(Map<String, Object> paramsMap);

	public SysUser findAllById(Integer id);

	public void sendMail(SysUser user,String passwd,Integer type);

	public List<Integer> findIdByPrincipalId(SysUser user);
	
	public Integer findMaxId();
	
	public SysUser finNewUser();

	public Page<SysUser> findByPage2(Map<String, Object> params, int pageNum, int pageSize);
	
	public int modify(SysUser user);
	
	public List<SysUser> findByName(String name);
}