package com.reyzar.oa.service.organization;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.domain.Organization;

public interface IOrganizationService {

	public void delOrganizationById(Map<String, String> param);

	public void recoveryOrganizationById(String id,String sign);

	public Organization findById(String id);

	public List<Organization> findByparentIdAndDelete(String id);

	public List<Organization> findByNameAndId(String name ,String id);

	public Organization findByParentid(Map<String, String> param);

	public Organization findByParentid2(Map<String, String> param);

	public Object getDeptWithPositionInList(Map<String, String> param);

	public Organization queryOrganizationById(Map<String, String> param);

	public void saveOrUpdateOrganization(Map<String, String> param);

	public void revokeOrganizationById(Map<String, String> param);

	public List<Organization> selectOgnList();

	public List<Organization> queryOrganizationChangeInfoListByOgnId(Map<String, String> param);

	public List<Organization> organizationChangeBGXMSelect();

	public void delChangeInfoById(Map<String, String> param);

	public void updateChangeInfoByJson(JSONObject json);

	void delInstitutionById(Map<String, String> param);

}
