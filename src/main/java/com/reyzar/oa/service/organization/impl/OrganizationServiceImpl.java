package com.reyzar.oa.service.organization.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.reyzar.oa.common.constant.deptUtilsConstant;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.dao.ISysRoleDao;
import com.reyzar.oa.domain.SysRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IInstitutionDao;
import com.reyzar.oa.dao.IOrganizationDao;
import com.reyzar.oa.domain.Institution;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.organization.IOrganizationService;

@Service
@Transactional
public class OrganizationServiceImpl implements IOrganizationService {

	@Autowired
	private IOrganizationDao organizationDao;
	@Autowired
	private IInstitutionDao institutionDao;
	@Autowired
	private ISysDeptDao sysDeptDao;
	@Autowired
	private ISysRoleDao iSysRoleDao;

	@Override
	public Organization  findById(String id) {
		return organizationDao.findById(id);
	}

	@Override
	public void  recoveryOrganizationById(String id ,String sign) {
		if(sign.equals("1")) {
			sysDeptDao.recoveryOrganizationById(Integer.parseInt(id));
			//更新sys_role 表为恢复状态
			List<SysRole> sysRoles=iSysRoleDao.findByDeptId(Integer.parseInt(id),1);
			if(sysRoles!=null && sysRoles.size()>0) {
				for (int i = 0; i < sysRoles.size(); i++) {
					sysRoles.get(i).setIsDeleted("0");
					iSysRoleDao.update(sysRoles.get(i));
				}
			}
		}else {
			organizationDao.recoveryOrganizationById(id);
		}
	}

	@Override
	public List<Organization>  findByparentIdAndDelete(String id) {
		return organizationDao.findByparentIdAndDelete(id);
	}

	@Override
	public List<Organization>  findByNameAndId(String name ,String id) {
		return organizationDao.findByNameAndId(name,id);
	}

	@Override
	public Organization findByParentid(Map<String, String> param) {
		List<Organization> organizationList = organizationDao.selectOrgByDeptData(deptUtilsConstant.getDeptId("companyId"));
		Organization organization = organizationDao.findByParentid(param);
		List<Organization> organizationList2 = new ArrayList<>();
		organizationList2.addAll(organizationList);
		if(organization!=null&&organization.getChildren()!=null) {
			organizationList2.addAll(organization.getChildren());
			organization.setChildren(organizationList2);
		}else {
			organization=new Organization();
			organization.setChildren(organizationList2);
		}
		return organization;
	}

	@Override
	public Organization findByParentid2(Map<String, String> param) {
		List<Organization> organizationList = organizationDao.selectOrgByDeptData2(deptUtilsConstant.getDeptId("companyId"));
		Organization organization = organizationDao.findByParentid2(param);
		List<Organization> organizationList2 = new ArrayList<>();
		organizationList2.addAll(organizationList);
		if(organization!=null&&organization.getChildren()!=null) {
			organizationList2.addAll(organization.getChildren());
			organization.setChildren(organizationList2);
		}else {
			organization=new Organization();
			organization.setChildren(organizationList2);
		}
		return organization;
	}

	@Override
	public Object getDeptWithPositionInList(Map<String, String> param) {
		List<Organization> deptList = organizationDao.findAll(param);
		List<Map<String, Object>> result = Lists.newArrayList();
		if (deptList != null) {
			for (Organization dept : deptList) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", "dept_" + dept.getId());
				map.put("parentId", "dept_" + dept.getParentId());
				map.put("name", dept.getName());
				map.put("code", dept.getCode());
				map.put("icon", param.get("root") + "/static/images/dept.png");
				map.put("nodetype", "dept");

				map.put("clrq", dept.getClrq());
				map.put("zczb", dept.getZczb());
				map.put("frdb", dept.getFrdb());
				map.put("cjsj", dept.getCreateDate());
				result.add(map);
			}
		}
		return result;
	}
//=========================================================================================================
	@Override
	public Organization queryOrganizationById(Map<String, String> param) {
		return organizationDao.queryOrganizationById(param);
	}

	@Override
	public void saveOrUpdateOrganization(Map<String, String> param) {
		SysUser user = UserUtils.getCurrUser();//获取当前用户
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//保存之前查询该id是否已经存在
		Organization organization = organizationDao.queryOrganizationInfoById(param.get("id"));
		if(StringUtils.isEmpty(organization)){
			//param.put("id", UUID.randomUUID().toString().trim().replaceAll("-", ""));
			param.put("createby", user.getAccount());
			param.put("createdate", sdf.format(new Date()));
			param.put("ognid", UUID.randomUUID().toString().trim().replaceAll("-", ""));//关联公司变更记录id
			organizationDao.saveOrganization(param);
			Organization organization2 = organizationDao.findById(param.get("sjdw"));
			Organization organization3 = organizationDao.selectByDateAndGenerateKpi();
			StringBuilder sb = new StringBuilder();
			sb.append(organization2.getNodeLinks());
			sb.append(",");
			sb.append(organization3.getId());
			param.put("nodeLinks",sb.toString());
			param.put("currenId",String.valueOf(organization3.getId()));
			organizationDao.updateNodeLinksById(param);
			/*param.put("changeUUID", UUID.randomUUID().toString().trim().replaceAll("-", ""));//变更主键
			organizationDao.saveOrganizationChangeInfo(param);//保存变更信息*/
		}else{
			if(param.get("sjdw")==""&&param.get("sjdw").equals("")){
				param.put("sjdw", "0");
			}
			param.put("updateby", user.getAccount());
			param.put("updatedate", sdf.format(new Date()));
			organizationDao.updateOrganization(param);
		}
		
	}

	@Override
	public void revokeOrganizationById(Map<String, String> param) {
		List<Organization> ognlist=organizationDao.selectOgnList();//查询出所有的公司（不包括根节点）
		if(ognlist.size()<1){
			//更新
		}else{
			//根据id查询出对应公司
			Organization organization = organizationDao.queryOrganizationById(param);
			if(!StringUtils.isEmpty(organization)){//如果不为空
				//查询所有父id等于当前公司id的数据
				List<Organization> organizations= organizationDao.queryOrganizationByParentId(organization.getId());
				if(organizations.size()>0){
					for (Organization ogn : organizations) {
						if(ogn.getChildren().size()>0){
							for (Organization ogn3 : ogn.getChildren()) {
								Map<String, String> param3 =new HashMap<String, String>();
								param3.put("id", ogn3.getId());
								//删除机构设置表中为该公司的数据
								//delInstitutionById(param3);
								
								//删除该公司的变更记录
								param3.put("ognid",ogn3.getOgnid());
								//organizationDao.delOrganizationChangeInfoByOgnid(param3);
								
								//再次进入删除操作
								revokeOrganizationById(param3);
							}
						}
						Map<String, String> param2 =new HashMap<String, String>();
						//删除机构设置表中对应该公司的记录
						param2.put("id",ogn.getId());
						//delInstitutionById(param2);
						
						//删除公司之前，先删除变更记录
						param2.put("ognid",ogn.getOgnid());
						//organizationDao.delOrganizationChangeInfoByOgnid(param2);
						
						//删除公司
						param2.put("parentId", ogn.getParentId());
						organizationDao.delOrganizationByParentId(param2);
					}
				}
				//删除机构设置表中对应该公司的记录
				//delInstitutionById(param);
				
				//删除公司之前，先删除变更记录
				param.put("ognid",organization.getOgnid());
				//organizationDao.delOrganizationChangeInfoByOgnid(param);
				
				//删除公司
				organizationDao.revokeOrganizationById(param);
			}
		}
	}

	@Override
	public void delOrganizationById(Map<String, String> param) {
		organizationDao.delOrganizationById(param);
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
	}

	@Override
	public List<Organization> selectOgnList() {
		List<Organization> ognlist=organizationDao.selectOgnList();
		return ognlist;
	}

	@Override
	public List<Organization> queryOrganizationChangeInfoListByOgnId(Map<String, String> param) {
		List<Organization> organizationChangeInfoList=organizationDao.queryOrganizationChangeInfoListByOgnId(param);
		return organizationChangeInfoList;
	}

	@Override
	public List<Organization> organizationChangeBGXMSelect() {
		List<Organization> ognlist=organizationDao.organizationChangeBGXMSelect();
		return ognlist;
	}

	@Override
	public void delChangeInfoById(Map<String, String> param) {
		//根据id查找变更表信息
		Organization ogn =organizationDao.queryOrganizationChangeInfoById(param);
		if(!StringUtils.isEmpty(ogn)){
			//获取该id在变更表中对应的ognid
			Map<String, String> param2=new HashMap<String, String>();
			param2.put("ognid", ogn.getOgnid());
			//查询出所有的ognid对应的list数据
			List<Organization> organizationChangeInfoList = organizationDao.queryOrganizationChangeInfoListByOgnId(param2);
			//如果只剩一条则进行更新而不进行删除
			if(organizationChangeInfoList.size()==1){
				param.put("bgrq", "");
				param.put("bgxm", "");
				param.put("bgq", "");
				param.put("bgh", "");
				organizationDao.updateOrganizationChangeInfoById(param);
			}else{//否则进行删除操作
				organizationDao.delOrganizationChangeInfoById(param);
			}
		}
		
	}

	@Override
	public void updateChangeInfoByJson(JSONObject json) {
		String id = json.get("changeId").toString();
		String ognid="";
		//根据变更id查询出变更记录中的ognid
		Organization organizationInFo = organizationDao.queryOrganizationInfoById(id);
		if(!StringUtils.isEmpty(organizationInFo)){
			 ognid=organizationInFo.getOgnid();
		}
		//插入逻辑
		@SuppressWarnings("unchecked")
		List<Object> objectList =(List<Object>) json.get("changeInfoList");
		Map<String,Object> map2 = new HashMap<String,Object>();
		if(objectList.size()>0){
			for (Object object : objectList) {
				Map<String,Object> map = getValue(object.toString());
				if(!StringUtils.isEmpty(map.get("uuid"))){
					//如果uuid存在，则进行更新
					String bgxm = organizationDao.findChangeHByIdAndchangeXM((String)map.get("uuid"),(String)map.get("changeXM"));
					if(bgxm.equals(map.get("changeH"))){
						//map2.put((String)map.get("changeXM"),"1");
					}else {
						map.put("changeQ",bgxm);
						organizationDao.updateOrganizationChangeInfoByUUID2(map);
						map2.put((String)map.get("changeXM"),"2");
					}
				}else{
					if((String)map2.get(map.get("changeXM")) == null || !map2.get(map.get("changeXM")).equals("2")) {
						if(!StringUtils.isEmpty(map.get("changeH"))){
							//如果changeH存在，则进行新增
							map.put("uuid", UUID.randomUUID().toString().trim().replaceAll("-", ""));
							map.put("ognid", ognid);
							organizationDao.saveOrganizationChangeInfo2(map);
							map2.put((String)map.get("changeXM"),"1");
						}
					}
				}
			}
		}
		
		Map<String,String> param=new HashMap<String,String>();
		param.put("ognid", ognid);
		//插入完毕之后查询出所有的变更信息，并获取每个变更项目的数据最新的数据
		List<Organization> organizationChangeInfoList = organizationDao.queryOrganizationChangeInfoListByOgnId2(param);
		for (Organization organization : organizationChangeInfoList) {
			String bgxm = organization.getBgxm();
			if(bgxm.equals("0")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}

				
				Map<String,String> param1=new HashMap<String,String>();
 				//获取到变更后的值
				param1.put("zczb", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			
			if(bgxm.equals("1")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
 				//获取到变更后的值
				param1.put("frdb", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("2")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("dszzxds", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("3")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("zjl", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("4")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("cwzj", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("5")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("jshzxjs", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("6")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("lxdh", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("7")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("gsdz", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("8")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("gszh", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("9")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("zhmc", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("10")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("khyh", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("11")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("khhdz", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("13")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("sjcgbl", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
			if(bgxm.equals("14")){
				//根据变更项目及ognid查询出最新的数据
				Map<String,String> param0=new HashMap<String,String>();
				param0.put("bgxm", bgxm);
				param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}
				
				Map<String,String> param1=new HashMap<String,String>();
				//获取到变更后的值
				param1.put("jyfw", ogn.getBgh());
				param1.put("ognid", ognid);
				//更新公司基本信息表
				organizationDao.updateOrganizationByOgnId(param1);
			}
            if(bgxm.equals("15")){
                //根据变更项目及ognid查询出最新的数据
                Map<String,String> param0=new HashMap<String,String>();
                param0.put("bgxm", bgxm);
                param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}

                Map<String,String> param1=new HashMap<String,String>();
                //获取到变更后的值
                param1.put("shxydm", ogn.getBgh());
                param1.put("ognid", ognid);
                //更新公司基本信息表
                organizationDao.updateOrganizationByOgnId(param1);
            }
            if(bgxm.equals("16")){
                //根据变更项目及ognid查询出最新的数据
                Map<String,String> param0=new HashMap<String,String>();
                param0.put("bgxm", bgxm);
                param0.put("ognid", ognid);
				Organization ogn = null;
				if(map2.get(bgxm) == "1"){
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm(param0);
				}else {
					ogn=organizationDao.queryOrganizationChangeInfoByOgnIdAndBgxm2(param0);
				}

                Map<String,String> param1=new HashMap<String,String>();
                //获取到变更后的值
                param1.put("name", ogn.getBgh());
                param1.put("ognid", ognid);
                //更新公司基本信息表
                organizationDao.updateOrganizationByOgnId(param1);
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
				String [] result = param.split(",");
				for(int a = 0;a<result.length;a++){
					if(result[a].contains("changeH")) {
						String [] result2 = result[a].split("=");
						for(int b = 0;b<result2.length;b++){
							if(result2[b].equals("}")) {
								map.put("changeH", "");
							}
						}
					}
				}
                return map;
            } else if (c != ' ') {
                str += c;
            }
        }
        return map;
    }
}