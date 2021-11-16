package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.Institution;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.domain.SysRole;
@MyBatisDao
public interface IInstitutionDao {

	public List<Institution> findByParentid(Map<String, String> param);

	public List<Institution> organizationList();

	public Institution queryOrganization(String id);

	public void saveOrganization(Map<String, String> param);

	public Institution queryInstitutionById2(Map<String, String> param);
	
	public Institution queryInstitutionById(Map<String, Object> param);

	public Organization queryOrganizationById23(Map<String, String> param);

	public void saveInstitution(Map<String, Object> param);

	public void delInstitutionById(Map<String, String> param);

	public void delInstitutionByParentId(Map<String, String> param);

	public List<Institution> queryInstitutionListByParentId(String string);

	public void updateInstitutionById(Map<String, String> param);

	public void updateInstitutionById2(Map<String, Object> param);

	public void updateInstitutionById3(Map<String, Object> param);

	public List<SysRole> getRoleList();

	public SysRole querySysRoleById(String roleId);

	public void moveUpOrDownById(Map<String, Object> param);

	public List<Institution> organizationList2();

}
