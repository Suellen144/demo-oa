package com.reyzar.oa.service.institution.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.dao.IInstitutionDao;
import com.reyzar.oa.domain.Institution;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.service.institution.IInstitutionService;

import net.sf.json.JSONArray;

@Service
@Transactional
public class InstitutionServiceImpl implements IInstitutionService {

	@Autowired
	private IInstitutionDao institutionDao;
	

	@Override
	public List<Institution> findByParentid(Map<String, String> param) {
		return institutionDao.findByParentid(param);
	}

//=========================================================================================================

	@Override
	public List<Institution> organizationList() {
		List<Institution> organizationList=institutionDao.organizationList();
		return organizationList;
	}
	
	@Override
	public List<Institution> organizationList2() {
		List<Institution> organizationList=institutionDao.organizationList2();
		return organizationList;
	}

	@Override
	public Institution queryOrganization(String id) {
		Institution organization=institutionDao.queryOrganization(id);
		return organization;
	}

	@Override
	public void saveOrganization(Map<String, String> param) {
		institutionDao.saveOrganization(param);
	}

	@Override
	public String queryInstitutionById2(Map<String, String> param) {
		Institution institution = institutionDao.queryInstitutionById2(param);
		String pid=institution.getId();
		return pid;
	}

	@Override
	public Organization queryOrganizationById23(Map<String, String> param) {
		Organization organization = institutionDao.queryOrganizationById23(param);
		return organization;
	}

	@Override
	public Institution queryInstitutionById(Map<String, Object> param) {
		Institution institution=institutionDao.queryInstitutionById(param);
		return institution;
	}

	@Override
	public void saveOrUpdateInstitution(Map<String, Object> param) {
		if(!StringUtils.isEmpty(param.get("id"))){
			SysRole role=institutionDao.querySysRoleById(param.get("position").toString());
			if(!StringUtils.isEmpty(role)){
				param.put("name", role.getName());
			}else{
				param.put("name", param.get("position"));
				param.put("position", "");
			}
			param.put("is_dept", param.get("is_dept"));
			institutionDao.updateInstitutionById2(param);
		}else{
			Map<String, Object> param2 =new HashMap<String, Object>();
			param2.put("id", UUID.randomUUID().toString().trim().replaceAll("-", ""));
			param2.put("parentId", param.get("parentId"));
			param2.put("position", param.get("position"));
			SysRole role=institutionDao.querySysRoleById(param.get("position").toString());
			if(!StringUtils.isEmpty(role)){
				param2.put("name", role.getName());
			}else{
				param2.put("name", param.get("position"));
				param2.put("position", "");
			}
			param2.put("sort", param.get("sort"));
			param2.put("is_dept", param.get("is_dept"));
			institutionDao.saveInstitution(param2);
		}
		
	}

	@Override
	public void delInstitutionById(Map<String, String> param) {
		//删除前，查询所有父id等于当前id的数据
		List<Institution> institutionList=institutionDao.queryInstitutionListByParentId(param.get("id"));
		if(institutionList.size()>0){//如果存在
			for (Institution institution : institutionList) {//进行遍历
				if(institution.getChildren().size()>0){//如果它的子类还有子节点
					for (Institution institution2 : institution.getChildren()) {//再进行遍历
						Map<String, String> param2 =new HashMap<String, String>();
						param2.put("id",institution2.getId());
						delInstitutionById(param2);//进行循环删除操作
					}
				}
				//删除
				param.put("parentId", institution.getParentId());
				institutionDao.delInstitutionByParentId(param);
			}
		}
		//删除本身
		institutionDao.delInstitutionById(param);
		String json = param.get("data");
		JSONArray jsonArray = JSONArray.fromObject(json);
		Object[] os = jsonArray .toArray();
		Map<String,Object> map = new HashMap<String, Object>();
		for(int i=0; i<os.length; i++) {
		    net.sf.json.JSONObject jsonObj = net.sf.json.JSONObject.fromObject(os[i]);
		    map.put("id", jsonObj.get("id"));
		    map.put("sort", jsonObj.get("sort"));
		    institutionDao.moveUpOrDownById(map);
		}
	}

	@Override
	public void updateInstitutions(Map<String, String> param) {
		//撤销前，查询所有父id等于当前id的数据
		List<Institution> institutionList=institutionDao.queryInstitutionListByParentId(param.get("id"));
		if(institutionList.size()>0){
			for (Institution institution : institutionList) {//遍历所有的父id为当前id的数据
				if(institution.getChildren().size()>0){//如果它的子类还有子节点
					for (Institution institution2 : institution.getChildren()) {//再进行遍历
						Map<String, String> param2 =new HashMap<String, String>();
						param2.put("id",institution2.getId());
						updateInstitutions(param2);
					}
				}
				Map<String, String> param2 =new HashMap<String, String>();
				param2.put("isUndo", "1");
				param2.put("id", institution.getId());
				institutionDao.updateInstitutionById(param2);
			}
		}
		//更新本身
		param.put("isUndo", "1");
		institutionDao.updateInstitutionById(param);
	}
	
	@Override
	public void updateInstitutions2(Map<String, String> param) {
		//恢复前，查询所有父id等于当前id的数据
		List<Institution> institutionList=institutionDao.queryInstitutionListByParentId(param.get("id"));
		if(institutionList.size()>0){
			for (Institution institution : institutionList) {//遍历所有的父id为当前id的数据
				if(institution.getChildren().size()>0){//如果它的子类还有子类
					for (Institution institution2 : institution.getChildren()) {//再进行遍历
						Map<String, String> param2 =new HashMap<String, String>();
						param2.put("id",institution2.getId());
						//再次执行恢复数据更新操作
						updateInstitutions2(param2);
					}
				}
				//继续往下执行更新
				Map<String, String> param2 =new HashMap<String, String>();
				param2.put("isUndo", "0");
				param2.put("id", institution.getId());
				institutionDao.updateInstitutionById(param2);
			}
		}
		//更新本身
		param.put("isUndo", "0");
		institutionDao.updateInstitutionById(param);
	}

	@Override
	public void saveGWZZInfo(Map<String, Object> param) {
		institutionDao.updateInstitutionById3(param);
	}

	@Override
	public List<SysRole> getRoleList() {
		List<SysRole> sysRoles=institutionDao.getRoleList();
		return sysRoles;
	}

	@Override
	public void moveUpOrDownById(JSONObject json) {
		@SuppressWarnings({ "unchecked" })
		List<Object> objectList =(List<Object>)json.get("data");
		if(objectList.size()>0){
			for (Object object : objectList) {
				Map<String,Object> map = getValue(object.toString());
				institutionDao.moveUpOrDownById(map);
			}
		}
	}
	
	public  Map<String,Object> getValue(String param) {
        Map<String,Object> map = new HashMap<String,Object>();
        String str = "";
        String key = "";
        Object value = "";
        char[] charList = param.toCharArray();
        boolean valueBegin = false;
        for (int i = 0; i < charList.length; i++) {
            char c = charList[i];
            if (c == '{') {
                if (valueBegin == true) {
                    value = getValue(param.substring(i, param.length()));
                    i = param.indexOf('}', i) + 1;
                    map.put(key, value);
                }
            } else if (c == '=') {
                valueBegin = true;
                key = str;
                str = "";
            } else if (c == ',') {
                valueBegin = false;
                value = str;
                str = "";
                map.put(key, value);
            } else if (c == '}') {
                if (str != "") {
                    value = str;
                }
                map.put(key, value);
                return map;
            } else if (c != ' ') {
                str += c;
            }
        }
        return map;
    }
	
	
}