package com.reyzar.oa.service.sys;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;

public interface ISysDeptService {

    public CrudResultDTO delete(Integer id);

	public void delByDeteleId(Integer id);

	public List<SysDept> findByParentidAndIsCompanyTwo(String parentId);

	public void updateByDeteleId(Integer id);

	public List<SysDept> findDeptByNameAndId(String name , String id);

	public void updateDept(Map<String, String> param);

	public void saveDept(Map<String, String> param);
	
	public List<SysDept> findAll();
	
	public SysDept findById(Integer id);
	
	public List<SysDept> findByUserId(Integer userId);
	
	public List<SysDept> findByParentid(Integer parentId);

	public List<SysDept> findByParentid2(Integer parentId);

	public List<SysDept> findByParentidAndCompany(Integer parentId);
	
	public SysDept findByCode(String code);
	
	public List<SysDept> findByIds(List<Integer> idList);
	
	public List<Map<String, Object>> getDeptWithPositionInList(String root);
	
	public List<Map<String, Object>> getDeptWithUserInList(String root);
	
	public List<SysDept> getDeptLink(Integer id);
	
	public SysDept getCompanyById(Integer id);
	
	public List<SysDept> findByLevel(Integer level);
	
	public void getIds(SysDept dept, List<Integer> idList);
	
	public void save(SysDept dept, SysUser user);
	
	public CrudResultDTO revoke(Integer id);
	
	public CrudResultDTO truedelete(Integer id);
	
	public String getDeptJson();
	
	public void setNullByUserid(Integer userId);
	
	public CrudResultDTO checkCode(Integer id, String code);

	public SysDept findByName(String dept,Integer id);
	
	public SysDept findByNameByisDeleted(String dept);

	public CrudResultDTO findUpDept(Integer id);
	
	public List<Integer> findByPosition(Integer id);

	public CrudResultDTO setSort(List<String> deptList);
	
	public CrudResultDTO findCompany(Integer id);
	
	public List<SysDept> findByGenerateKpi();
	
	public List<SysDept> getDeptAndPosition(Integer id,Integer isDelete,String sign);
	
	public List<SysDept> organizationList(Integer isDeleted);
	
	public CrudResultDTO saveDeptOrRole(JSONObject json);
	
	public void update(SysDept dept);
}