package com.reyzar.oa.service.sys.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.reyzar.oa.common.constant.deptUtilsConstant;
import com.reyzar.oa.dao.IOrganizationDao;
import com.reyzar.oa.dao.IResponsibilityDao;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.domain.Responsibility;
import org.apache.commons.lang.StringUtils;
import org.omg.CORBA.PUBLIC_MEMBER;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.dao.ISysRoleDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdPositionService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

@Service
@Transactional
public class SysDeptServiceImpl implements ISysDeptService {

	@Autowired
	private ISysDeptDao deptDao;
	@Autowired
	private ISysUserService userService;
	@Autowired
	private IAdPositionService positionService;
	@Autowired
	private IUserPositionDao positionDao;
	@Autowired
	private ISysRoleDao iSysRoleDao;
	@Autowired
	private IOrganizationDao organizationDao;
	@Autowired
	private IResponsibilityDao responsibilityDao;

	@Override
	public List<SysDept> findByParentidAndIsCompanyTwo(String parentId) {
		List<SysDept> sysDeptList= deptDao.findByParentidAndIsCompany(parentId);
		for(int a = 0; a <sysDeptList.size(); a++) {
			List<SysDept> deptList = deptDao.findProjectTeam(String.valueOf(sysDeptList.get(a).getId()));
			for(int b = deptList.size() - 1; b >=0; b--){
				List<SysRole> roleList = iSysRoleDao.findByDeptId(deptList.get(b).getId(), 0);
				List<SysDept> deptLists = deptDao.findProjectTeam(String.valueOf(deptList.get(b).getId()));
				if (roleList.size() == 0 && deptLists.size() == 0) {
					deptList.remove(b);
				}
			}
			sysDeptList.get(a).setChildren(deptList);
		}
		List<SysDept> sysDept= deptDao.findByParentid(Integer.parseInt(deptUtilsConstant.getDeptId("sysRoleId")));
		sysDeptList.addAll(sysDept);
		return sysDeptList;
	}

	@Override
	public void  delByDeteleId(Integer id) {
		//删除部门下面的角色
		List<SysRole> sysRoles=iSysRoleDao.findByDeptId(id,0);
		if(sysRoles!=null && sysRoles.size()>0) {
			for (int i = 0; i < sysRoles.size(); i++) {
				iSysRoleDao.delete(sysRoles.get(i).getId());
			}
		}
		deptDao.delete(id);
	}

	@Override
	public void  updateByDeteleId(Integer id) {
		//更新sys_role 表为撤销状态
		List<SysRole> sysRoles=iSysRoleDao.findByDeptId(id,0);
		if(sysRoles!=null && sysRoles.size()>0) {
			for (int i = 0; i < sysRoles.size(); i++) {
				sysRoles.get(i).setIsDeleted("1");
				iSysRoleDao.update(sysRoles.get(i));
			}
		}
		deptDao.updateByDeteleId(id);
	}

	@Override
	public void  updateDept(Map<String, String> param) {
		SysUser user = UserUtils.getCurrUser();
		if(param.get("createDate") == "") {
			param.put("createDate",null);
		}
		if(param.get("deptRevokeDate") == "") {
			param.put("deptRevokeDate",null);
		}
		param.put("updateBy",user.getAccount());
		deptDao.updateDept(param);
		Responsibility responsibility = responsibilityDao.findByDeptId2(Integer.parseInt(param.get("id")));
		if(responsibility == null) {
			param.put("deptId",param.get("id"));
			param.put("createBy",user.getAccount());
			param.put("titleOrContent","1");
			responsibilityDao.saveByDept(param);
		}else {
			param.put("updateBy",user.getAccount());
			responsibilityDao.updateByDeptId(param);
		}
	}

	@Override
	public void  saveDept(Map<String, String> param) {
		SysUser user = UserUtils.getCurrUser();
		if(param.get("createDate") == "") {
			param.put("createDate",null);
		}
		if(param.get("deptRevokeDate") == "") {
			param.put("deptRevokeDate",null);
		}
		param.put("createBy",user.getAccount());
		param.put("isAccording","2");
		param.put("generateKpi","1");
		param.put("parentId",param.get("parentId"));
		SysDept dept = deptDao.findById(Integer.parseInt(param.get("parentId")));
		if(param.get("sign").equals("1")) {
			param.put("isCompany","1");
		}else if(param.get("sign").equals("0")){
			if(dept.getIsCompany() != null && dept.getIsCompany().equals("1")) {
				param.put("isCompany","1");
			}else {
				param.put("isCompany","0");
			}
		}else {
			param.put("isCompany","0");
		}
		deptDao.saveDept(param);
		SysDept sysDept2 = deptDao.selectByDateAndGenerateKpi();
		param.put("titleOrContent","1");
		param.put("deptId",String.valueOf(sysDept2.getId()));
		responsibilityDao.saveByDept(param);
		Organization organization = organizationDao.findById(param.get("parentId"));
		StringBuilder sb = new StringBuilder();
		if(param.get("sign").equals("1")) {
			sb.append(organization.getNodeLinks());
		}else {
			if(dept != null) {
				sb.append(dept.getNodeLinks());
			}
		}
		sb.append(",");
		sb.append(sysDept2.getId());
		param.put("nodeLinks",sb.toString());
		param.put("currenId",String.valueOf(sysDept2.getId()));
		deptDao.updateNodeLinksById(param);
	}

	@Override
	public List<SysDept>  findDeptByNameAndId(String name ,String id) {
		return deptDao.findDeptByNameAndId(name,id);
	}

	@Override
	public List<SysDept> findAll() {
		return deptDao.findAll();
	}

	@Override
	public SysDept findById(Integer id) {
		return deptDao.findById(id);
	}

	@Override
	public List<SysDept> findByParentid(Integer parentId) {
		return deptDao.findByParentid(parentId);
	}

	@Override
	public List<SysDept> findByParentidAndCompany(Integer parentId) {
		return deptDao.findByParentidAndCompany(parentId,1);
	}

	@Override
	public List<SysDept> findByParentid2(Integer parentId) {
		return deptDao.findByParentid2(parentId);
	}

	@Override
	public String getDeptJson() {
		List<SysDept> deptList = deptDao.findAll();
		for (SysDept dept : deptList) {
			dept.setOriginName(dept.getName());
			//if (dept.getAlias() != null && !"".equals(dept.getAlias().trim())) {
			//	dept.setName(dept.getAlias().trim());
		//	}
		}
		return JSON.toJSONString(deptList);
	}

	@Override
	public void save(SysDept dept, SysUser user) {
		if (dept.getId() == null) {
			SysDept parent = deptDao.findById(dept.getParentId());
			dept.setIsDeleted("0");
			dept.setCode(getMaxCode());
			dept.setCreateBy(user.getAccount());
			dept.setCreateDate(new Date());
			deptDao.save(dept);
			dept.setNodeLinks(parent.getNodeLinks() + "," + dept.getId());
			deptDao.update(dept);
		} else {
			SysDept old = deptDao.findById(dept.getId());

			List<SysDept> children = Lists.newArrayList();
			if (!old.getParentId().equals(dept.getParentId())) {
				SysDept parent = deptDao.findById(dept.getParentId());
				setNodeLinks(parent.getNodeLinks() + "," + old.getId(), old, children);
			}
			BeanUtils.copyProperties(dept, old);

			old.setUserId(dept.getUserId());
			old.setAssistantId(dept.getAssistantId());
			old.setAlias(dept.getAlias());
			old.setLevel(dept.getLevel());
			old.setUpdateBy(user.getAccount());
			old.setUpdateDate(new Date());
			deptDao.update(old);

			for (SysDept child : children) {
				deptDao.update(child);
			}
		}
	}

	private void setNodeLinks(String nodeLinks, SysDept dept, List<SysDept> children) {
		dept.setNodeLinks(nodeLinks);
		if (dept.getChildren() != null && dept.getChildren().size() > 0) {
			for (SysDept child : dept.getChildren()) {
				setNodeLinks(dept.getNodeLinks() + "," + child.getId(), child, children);
				children.add(child);
			}
		}
	}

	/* 用于撤销部门 */
	@Override
	public CrudResultDTO revoke(Integer id) {
		CrudResultDTO res = new CrudResultDTO(CrudResultDTO.SUCCESS, "撤销成功！");
		try {
			if (id == null) {
				res = new CrudResultDTO(CrudResultDTO.FAILED, "撤销失败！部门ID不能为空！");
			}

			List<SysUser> userList = userService.findByDeptid(id);
			if (userList.size() > 0) {
				res = new CrudResultDTO(CrudResultDTO.FAILED, "撤销失败！该部门下有其他用户，请先转移或撤销用户后再操作！");
			} else {
				SysDept dept = deptDao.findById(id);
				List<Integer> idList = Lists.newArrayList();
				getIds(dept, idList);

				List<SysDept> deptList = Lists.newArrayList();

				for (Integer ids : idList) {
					SysDept dept2 = new SysDept();
					dept2.setId(ids);
					dept2.setUpdateBy(UserUtils.getCurrUser().getAccount());
					dept2.setUpdateDate(new Date());
					dept2.setIsDeleted("1");
					deptList.add(dept2);
				}

				deptDao.revokeByDeptList(deptList);
				userService.setNullByDeptid(id);
				//更新sys_role 表为撤销状态
				List<SysRole> sysRoles=iSysRoleDao.findByDeptId(id,0);
				if(sysRoles!=null && sysRoles.size()>0) {
					for (int i = 0; i < sysRoles.size(); i++) {
						sysRoles.get(i).setIsDeleted("1");
						iSysRoleDao.update(sysRoles.get(i));
					}
				}
			}
		} catch (Exception e) {
			res = new CrudResultDTO(CrudResultDTO.FAILED, "系统发生异常，请联系管理员！");
			e.printStackTrace();
			e.getMessage();
		}

		return res;
	}

	/* 用于删除部门 */
	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO res = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			if (id == null) {
				res = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败！部门ID不能为空！");
			}
			List<SysUser> userList = userService.findByDeptid(id);
			List<SysDept> SysDeptList = deptDao.findByParentid(id);
			if (userList.size() > 0 || SysDeptList.size()>0) {
				res = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败，请先删除下级部门或用户");
			} else {
				//删除部门下面的角色
				List<SysRole> sysRoles=iSysRoleDao.findByDeptId(id,0);
				if(sysRoles!=null && sysRoles.size()>0) {
					for (int i = 0; i < sysRoles.size(); i++) {
						iSysRoleDao.delete(sysRoles.get(i).getId());
					}
				}
				deptDao.delete(id);
			}
		} catch (Exception e) {
			res = new CrudResultDTO(CrudResultDTO.FAILED, "系统发生异常，请联系管理员！");
			e.printStackTrace();
			e.getMessage();
		}
		return res;
	}

	@Override
	public CrudResultDTO truedelete(Integer id) {
		CrudResultDTO res = new CrudResultDTO(CrudResultDTO.SUCCESS, "撤销成功！");
		try {
			if (id == null) {
				res = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败！部门ID不能为空！");
			} else {
				List<SysUser> userList = userService.findByDeptid(id);
				if (userList.size() > 0) {
					res = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败！该部门下有其他用户，请先转移或删除用户后再操作！");
				} else {
					SysDept dept = deptDao.findById(id);
					List<Integer> idList = Lists.newArrayList();
					getIds(dept, idList);

					List<SysDept> deptList = Lists.newArrayList();

					for (Integer ids : idList) {
						SysDept dept2 = new SysDept();
						dept2.setId(ids);
						deptList.add(dept2);
					}

					deptDao.deletetrueByDeptList(deptList);
					userService.setNullByDeptid(id);
				}
			}
		} catch (Exception e) {
			res = new CrudResultDTO(CrudResultDTO.FAILED, "系统发生异常，请联系管理员！");
			e.printStackTrace();
			e.getMessage();
		}
		return res;
	}

	/**
	 * 递归获取部门、子部门的ID集合
	 */
	@Override
	public void getIds(SysDept dept, List<Integer> idList) {
		if (dept.getChildren() != null || dept.getChildren().size() > 0) {
			for (SysDept child : dept.getChildren()) {
				getIds(child, idList);
			}
			idList.add(dept.getId());
		} else {
			idList.add(dept.getId());
		}
	}

	@Override
	public void setNullByUserid(Integer userId) {
		deptDao.setNullByUserid(userId);
	}

	@Override
	public SysDept findByCode(String code) {
		return deptDao.findByCode(code);
	}

	@Override
	public List<SysDept> findByIds(List<Integer> idList) {
		return deptDao.findByIds(idList);
	}

	@Override
	public List<SysDept> findByUserId(Integer userId) {
		return deptDao.findByUserId(userId);
	}

	@Override
	public List<Map<String, Object>> getDeptWithPositionInList(String root) {
		List<SysDept> deptList = deptDao.findAll();
		List<AdPosition> positionList = positionService.findAll();
		List<Map<String, Object>> result = Lists.newArrayList();
		if (deptList != null) {
			for (SysDept dept : deptList) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", "dept_" + dept.getId());
				map.put("parentId", "dept_" + dept.getParentId());
				map.put("name", dept.getName());
				map.put("code", dept.getCode());
				map.put("icon", root + "/static/images/dept.png");
				map.put("nodetype", "dept");

				result.add(map);
			}
		}
		if (positionList != null) {
			for (AdPosition position : positionList) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", "position_" + position.getId());
				map.put("parentId", "dept_" + position.getDeptId());
				map.put("name", position.getName());
				map.put("enname", position.getEnname());
				map.put("code", position.getCode());
				map.put("nodelevel", position.getLevel());
				map.put("icon", root + "/static/images/position.png");
				map.put("nodetype", "position");
				result.add(map);
			}
		}
		return result;

	}

	@Override
	public List<Map<String, Object>> getDeptWithUserInList(String root) {
		List<SysDept> deptList = deptDao.findAllByMetting();
		List<SysUser> userList = userService.findAllByMeeting();
		List<Map<String, Object>> result = Lists.newArrayList();
		if (deptList != null) {
			for (SysDept dept : deptList) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", "dept_" + dept.getId());
				map.put("parentId", "dept_" + dept.getParentId());
				map.put("name", dept.getName());
				map.put("code", dept.getCode());
				map.put("icon", root + "/static/images/dept.png");

				result.add(map);
			}
		}
		if (userList != null) {
			for (SysUser user : userList) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", "user_" + user.getId());
				map.put("parentId", "dept_" + user.getDeptId());
				map.put("name", user.getName());
				map.put("isUser", true);
				map.put("icon", root + "/static/images/position.png");

				result.add(map);
			}
		}

		return result;
	}

	@Override
	public CrudResultDTO checkCode(Integer id, String code) {
		int count = deptDao.checkCode(id, code);
		if (count <= 0) {
			return new CrudResultDTO(CrudResultDTO.SUCCESS, "部门代码[" + code + "]不存在！");
		} else {
			return new CrudResultDTO(CrudResultDTO.FAILED, "部门代码[" + code + "]已存在！");
		}
	}

	private String getMaxCode() {
		String code = "001";
		List<Map<String, Object>> codeList = deptDao.getMaxCode();
		if (codeList != null) {
			int max = 0;
			for (Map<String, Object> map : codeList) {
				String value = map.get("code").toString();
				if (value.startsWith("00")) {
					value = value.replaceFirst("00", "");
				} else if (value.startsWith("0")) {
					value = value.replaceFirst("0", "");
				}

				max = Math.max(max, Integer.parseInt(value));
			}

			max++;
			if (String.valueOf(max).length() == 1) {
				code = "00" + max;
			} else if (String.valueOf(max).length() == 2) {
				code = "0" + max;
			} else {
				code = String.valueOf(max);
			}
		}

		return code;
	}

	/**
	 * 获取部门所在的公司
	 */
	@Override
	public SysDept getCompanyById(Integer id) {
		if (id != null) {
			SysDept dept = findById(id);
			String[] ids = dept.getNodeLinks().split(",");
			List<Integer> idList = Lists.newArrayList();
			for (String idstr : ids) {
				idList.add(Integer.valueOf(idstr));
			}

			List<SysDept> tempList = findByIds(idList);
			for (SysDept temp : tempList) {
				if (temp.getLevel() != null && temp.getLevel() == 1) {
					return temp;
				}
			}
		}
		return null;
	}

	@Override
	public List<SysDept> getDeptLink(Integer id) {
		List<SysDept> result = Lists.newArrayList();
		if (id != null) {
			List<SysDept> deptList = deptDao.findChilrenByNodelinksLike(id);
			if (deptList != null && deptList.size() > 0) { // 有子部门，则查询从根 -> 当前部门
															// -> 子部门
				Set<Integer> idSet = Sets.newHashSet();
				for (SysDept dept : deptList) {
					idSet.add(dept.getId());
				}

				result = this.findByIds(Lists.newArrayList(idSet));
			}
			// 查询 根 -> 当前部门
			String[] ids = this.findById(id).getNodeLinks().split(",");
			List<Integer> idList = Lists.newArrayList();
			for (String idStr : ids) {
				idList.add(Integer.valueOf(idStr));
			}
			result.addAll(this.findByIds(idList));
		}

		return result;
	}

	@Override
	public List<SysDept> findByLevel(Integer level) {
		return deptDao.findByLevel(level);
	}

	@Override
	public SysDept findByName(String name,Integer id) {
		return deptDao.findByName(name,id);
	}

	@Override
	public CrudResultDTO findUpDept(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");

		SysDept dept = deptDao.findById(id);
	/*	String nodes = dept.getNodeLinks().substring(6);

		String[] ids = nodes.split(",");
		List<Integer> idList = new ArrayList<>();
		for (int i = 0; i < ids.length; i++) {
			idList.add(Integer.valueOf(ids[i]));
		}
		StringBuffer newDeptName = new StringBuffer();
		for (Integer deptId : idList) {
			newDeptName.append(deptDao.findById(deptId).getName() + ",");
		}
		String newDept = newDeptName.toString().replace(" ", "");
		result.setResult(newDept);*/
		result.setResult(dept.getName());
		return result;
	}

	@SuppressWarnings("unlikely-arg-type")
	@Override
	public List<Integer> findByPosition(Integer id) {
		List<Map<Integer, Integer>> maps = Lists.newArrayList();
		List<Integer> result = Lists.newArrayList();
		maps = positionDao.findbypostionId(id);
		for (Map<Integer, Integer> map : maps) {
			Integer i = map.get("USER_ID");
			result.add(i);
		}
		return result;
	}

	@Override
	public CrudResultDTO setSort(List<String> deptList) {

		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		List<Integer> positionList = Lists.newArrayList();
		for (int i = 0; i < deptList.size(); i++) {
			if (deptList.get(i).indexOf("position_") > -1) {
				positionList.add(Integer.parseInt(deptList.get(i).replace("position_", "")));
			} else {
				Integer id = Integer.parseInt(deptList.get(i));
				SysDept dept = deptDao.findById(id);
				dept.setSort((deptList.size() - i) * 10);
				deptDao.update(dept);
			}
		}

		if (positionList != null && positionList.size() > 0) {
			for (int i = 0; i < positionList.size(); i++) {
				AdPosition position = positionService.findById(positionList.get(i));
				position.setSort((positionList.size() - i) * 10);
				positionService.update(position);

			}
		}
		return result;
	}

	@Override
	public CrudResultDTO findCompany(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");

		SysDept dept = deptDao.findById(id);
		String nodes = dept.getNodeLinks().substring(6);

		String[] ids = nodes.split(",");
		List<Integer> idList = new ArrayList<>();
		for (int i = 0; i < ids.length; i++) {
			idList.add(Integer.valueOf(ids[i]));
		}
		StringBuffer newDeptName = new StringBuffer();
		for (Integer deptId : idList) {
			newDeptName.append(deptDao.findById(deptId).getName() + ",");
		}
		String newDept = newDeptName.toString().replace(" ", "");
		result.setResult(newDept);
		return result;
	}

	@Override
	public List<SysDept> findByGenerateKpi() {
		return deptDao.findByGenerateKpi();
	}

	@Override
	public List<SysDept> getDeptAndPosition(Integer id,Integer isDelete,String sign) {
		List<SysDept> sysDepts=null;
		if(id != null) {
			if(id != Integer.parseInt(deptUtilsConstant.getDeptId("companyId")) &&
			   id != Integer.parseInt(deptUtilsConstant.getDeptId("sysRoleId"))){
				sysDepts=deptDao.getDeptAndPosition2(id,isDelete.toString());
			}else {
				if(StringUtils.isBlank(sign) || sign.equals("0")) {
					sysDepts=deptDao.getDeptAndPosition(id,isDelete.toString());
				}else {
					sysDepts=deptDao.getDeptAndPosition2(id,isDelete.toString());
				}
			}
		}else {
			sysDepts=deptDao.getDeptAndPosition(id,isDelete.toString());
		}

		 for (int i = 0; i < sysDepts.size(); i++) {
			 List<SysRole> sysRole= iSysRoleDao.findByDeptId(sysDepts.get(i).getId(),isDelete);
			 if(sysRole!=null) {
				 sysDepts.get(i).setChildrenPosition(sysRole);
			 }else {
				 sysDepts.get(i).setChildrenPosition(new  ArrayList<SysRole>());
			 }
			 finishingSysDept2(sysDepts.get(i).getChildren(),isDelete);
		}
		 finishingSysDept(sysDepts,0);
		return sysDepts;
	}
	private List<SysDept> finishingSysDept2(List<SysDept> sysDepts,Integer isDelete){
		 for (int j = 0; j < sysDepts.size(); j++) {
			 if(isDelete == 0) {
				 if("1".equals(sysDepts.get(j).getIsDeleted())) {
					 sysDepts.remove(j);
					 j--;
					 continue;
				 }
			 }
			 List<SysRole> sysRole1= iSysRoleDao.findByDeptId(sysDepts.get(j).getId(),isDelete);
			 if(sysRole1!=null) {
				 sysDepts.get(j).setChildrenPosition(sysRole1);
			 }else {
				 sysDepts.get(j).setChildrenPosition(new  ArrayList<SysRole>());
			 }
			 if(sysDepts.get(j).getChildren()!=null && sysDepts.get(j).getChildren().size()>0) {
				 finishingSysDept2(sysDepts.get(j).getChildren(),isDelete);
			 }
		}
		return sysDepts;
	}
	private Integer index=2;
	private List<SysDept> finishingSysDept(List<SysDept> sysDepts,Integer index){
		for (int i = 0; i < sysDepts.size(); i++) {
			sysDepts.get(i).setIndex(this.index++);
			if(index !=0)
			sysDepts.get(i).setParentId(index);
			if(sysDepts.get(i).getChildren()!=null && sysDepts.get(i).getChildren().size()>0) {
				finishingSysDept(sysDepts.get(i).getChildren(),sysDepts.get(i).getIndex());
			}
			if(sysDepts.get(i).getChildrenPosition()!=null && sysDepts.get(i).getChildrenPosition().size()>0) {
				finishingAdPosition(sysDepts.get(i).getChildrenPosition(),sysDepts.get(i).getIndex());
			}
		}
		return sysDepts;
	}
	private List<SysRole> finishingAdPosition(List<SysRole> sysRole,Integer Index){
		for (int i = 0; i < sysRole.size(); i++) {
			sysRole.get(i).setIndex(index++);
			sysRole.get(i).setDeptId(Index);
		}
		return sysRole;
	}
	@Override
	public List<SysDept> organizationList(Integer isDeleted) {
		List<SysDept> sysDeptList = new ArrayList<>();
		List<SysDept> sysDept = deptDao.findByDeleteAndId(isDeleted.toString(), deptUtilsConstant.getDeptId("companyId"));
		List<SysDept> sysDept2 = deptDao.findByDeleteAndId(isDeleted.toString(), deptUtilsConstant.getDeptId("sysRoleId"));
		List<SysDept> sysDeptList2 = deptDao.findByOrganization(deptUtilsConstant.getDeptId("companyId"),String.valueOf(isDeleted));
		sysDeptList.addAll(sysDept);
		sysDeptList.addAll(sysDeptList2);
		sysDeptList.addAll(sysDept2);
		return sysDeptList;
	}

	@Override
	public CrudResultDTO saveDeptOrRole(JSONObject json) {
		CrudResultDTO res =new CrudResultDTO();
		SysUser user = UserUtils.getCurrUser();
		try {
			Integer status=json.getInteger("status");
			Integer id=json.getInteger("id");
			Integer deptId=json.getInteger("deptId");
			String name=json.getString("name");
			Integer generateKpi= 1;
			Integer parentId=json.getInteger("parentId");
			Integer operation= json.getInteger("operation");
			String eDeptName=json.getString("eDeptName");
			switch (operation) {
			case 1: //新增同级部门
				if(deptId!=null) {
					SysDept sysDept=deptDao.findById(deptId);
					if(sysDept!=null) {
						SysDept sysDept1=new SysDept();
						sysDept1.setName(name);
						sysDept1.setParentId(sysDept.getParentId());
						sysDept1.setCreateBy(user.getAccount());
						sysDept1.setCreateDate(new Date());
						sysDept1.setGenerateKpi(generateKpi);
						List<String> result = Arrays.asList(sysDept.getNodeLinks().split(","));
						List<String> results=new ArrayList<>();
						for (int i = 0; i < result.size(); i++) {
							if(i == result.size()-1) {
								break;
							}else {
								results.add(result.get(i));
							}
						}
						sysDept1.setNodeLinks(StringUtils.join(results.toArray(), ","));
						sysDept1.setIsAccording(2);
						sysDept1.setIsDeleted("0");
						deptDao.save(sysDept1);
						//sysDept1.setId(id1);
						sysDept1.setNodeLinks(sysDept1.getNodeLinks()+","+sysDept1.getId());
						deptDao.update(sysDept1);
					}
				}
				break;
			case 2://新增下级部门
				if(parentId!=null) {
					SysDept sysDept=new SysDept();
					sysDept.setParentId(parentId);
					sysDept.setName(name);
					sysDept.setCreateBy(user.getAccount());
					sysDept.setCreateDate(new Date());
					sysDept.setGenerateKpi(generateKpi);
					sysDept.setIsAccording(2);
					deptDao.save(sysDept);
					SysDept sysDept1=deptDao.findById(parentId);
					if(sysDept1!=null) {
						sysDept.setNodeLinks(sysDept1.getNodeLinks()+","+sysDept.getId());
						deptDao.update(sysDept);
					}
				}
				break;
			case 3://新增岗位
				SysRole sysRole = new SysRole();
				sysRole.setCreateBy(user.getAccount());
				sysRole.setCreateDate(new Date());
				sysRole.setDeptId(deptId);
				sysRole.setEnabled("1");
				sysRole.setName(name);
				sysRole.setEnname(eDeptName);
				iSysRoleDao.save(sysRole);
				break;
			case 4://编辑
				//等于1 ，则是部门，等于2，则是岗位
				if(id !=null) {
					if(status == 1) {
						SysDept sysDept=deptDao.findById(id);
						if(sysDept!=null) {
							sysDept.setName(name);
							sysDept.setGenerateKpi(generateKpi);
							sysDept.setUpdateBy(user.getAccount());
							sysDept.setUpdateDate(new Date());
							deptDao.update(sysDept);
						}
					}else if(status == 2) {
						SysRole sysRole1=iSysRoleDao.findById(id);
						if(sysRole1!=null) {
							sysRole1.setName(name);
							sysRole1.setEnname(eDeptName);
							sysRole1.setUpdateBy(user.getAccount());
							sysRole1.setUpdateDate(new Date());
							iSysRoleDao.update(sysRole1);
						}
					}
				}
				break;
			default:
				break;
			}
			res.setCode(CrudResultDTO.SUCCESS);
			res.setResult( "保存成功！");
		} catch (Exception e) {
			res.setCode(CrudResultDTO.EXCEPTION);
			res.setResult("网络错误，请稍后重试！");
			e.printStackTrace();
		}
		return res;
	}

	@Override
	public SysDept findByNameByisDeleted(String dept) {
		return deptDao.findByNameByisDeleted(dept);
	}

	@Override
	public void update(SysDept dept) {
		deptDao.update(dept);
		//更新sys_role 表为恢复状态
		List<SysRole> sysRoles=iSysRoleDao.findByDeptId(dept.getId(),1);
		if(sysRoles!=null && sysRoles.size()>0) {
			for (int i = 0; i < sysRoles.size(); i++) {
				sysRoles.get(i).setIsDeleted("0");
				iSysRoleDao.update(sysRoles.get(i));
			}
		}
	}
}