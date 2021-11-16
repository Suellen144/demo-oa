package com.reyzar.oa.service.institution;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.domain.Institution;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.domain.SysRole;

public interface IInstitutionService {

	public List<Institution> findByParentid(Map<String, String> param);

	public List<Institution> organizationList();

	public Institution queryOrganization(String id);

	public void saveOrganization(Map<String, String> param);

	public String queryInstitutionById2(Map<String, String> param);

	public Organization queryOrganizationById23(Map<String, String> param);

	public Institution queryInstitutionById(Map<String, Object> param);

	public void saveOrUpdateInstitution(Map<String, Object> param);

	public void delInstitutionById(Map<String, String> param);

	public void updateInstitutions(Map<String, String> param);

	public void updateInstitutions2(Map<String, String> param);

	public void saveGWZZInfo(Map<String, Object> param);

	public List<SysRole> getRoleList();

	public void moveUpOrDownById(JSONObject json);

	public List<Institution> organizationList2();

}
