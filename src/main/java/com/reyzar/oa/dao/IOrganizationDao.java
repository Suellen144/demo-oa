package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.Organization;
import org.apache.ibatis.annotations.Param;

@MyBatisDao
public interface IOrganizationDao {

	public Organization selectByDateAndGenerateKpi();

	public void updateNodeLinksById(Map<String, String> param);

	public List<Organization> selectOrgByDeptData2(String id);

	public List<Organization> selectOrgByDeptData(String id);

	public void save(Organization organization);

	public void recoveryOrganizationById(String id);

	public List<Organization> findByparentIdAndDelete(String id);

	public Organization findById(String id);

	public void saveData(@Param("name")String name ,@Param("id")String id,@Param("generateKpi")String generateKpi,@Param("parentId")String parentId);

	public void updateData(@Param("name")String name ,@Param("id")String id,@Param("generateKpi")String generateKpi);

	public List<Organization> findByNameAndId(@Param("name")String name ,@Param("id")String id);

	public String findChangeHByIdAndchangeXM(@Param("id") String id, @Param("xm")String xm);

	public Organization findByParentid(Map<String, String> param);

	public Organization findByParentid2(Map<String, String> param);

	public List<Organization> findAll(Map<String, String> param);

	public Organization queryOrganizationById(Map<String, String> param);
	
	public Organization queryOrganizationInfoById(String id);

	public void saveOrganization(Map<String, String> param);

	public void updateOrganization(Map<String, String> param);

	public void revokeOrganizationById(Map<String, String> param);

	public void delOrganizationById(Map<String, String> param);

	public List<Organization> selectOgnList();

	public void saveOrganizationChangeInfo(Map<String, String> param);

	public List<Organization> queryOrganizationChangeInfoListByOgnId(Map<String, String> param);

	public void delOrganizationChangeInfoByOgnid(Map<String, String> param2);

	public List<Organization> organizationChangeBGXMSelect();

	public Organization queryOrganizationChangeInfoById(Map<String, String> param);

	public void updateOrganizationChangeInfoById(Map<String, String> param);

	public void delOrganizationChangeInfoById(Map<String, String> param);

	public void updateOrganizationChangeInfoByUUID(Map<String, String> param2);

	public void updateOrganizationChangeInfoByUUID2(Map<String, Object> map);

	public void saveOrganizationChangeInfo2(Map<String, Object> map);

	public void updateOrganizationByOgnId(Map<String, String> param);

	public List<Organization> queryOrganizationChangeInfoListByOgnId2(Map<String, String> param);

	public Organization queryOrganizationChangeInfoByOgnIdAndBgxm(Map<String, String> param0);
	public Organization queryOrganizationChangeInfoByOgnIdAndBgxm2(Map<String, String> param0);

	public List<Organization> queryOrganizationByParentId(String parentId);

	public void delOrganizationByParentId(Map<String, String> param2);
}
