package com.reyzar.oa.service.sys.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.dao.IRoleMenuDao;
import com.reyzar.oa.dao.IRolePermissionDao;
import com.reyzar.oa.dao.ISysMenuDao;
import com.reyzar.oa.domain.SysMenu;
import com.reyzar.oa.domain.SysPermission;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysMenuService;
import com.reyzar.oa.service.sys.ISysPermissionService;

@Service
@Transactional
public class SysMenuServiceImpl implements ISysMenuService {

	@Autowired
	private ISysMenuDao menuDao;
	@Autowired
	private IRolePermissionDao rolePermissionDao;
	@Autowired
	private IRoleMenuDao roleMenuDao;
	@Autowired
	private ISysPermissionService permissionService;
	
	@Override
	public String findMenuForJson() {
		Subject subject = SecurityUtils.getSubject();
		SysUser user = (SysUser) subject.getSession().getAttribute("user");
		
		List<SysMenu> menuList = menuDao.findByUserId(user.getId());
		List<Map<String, Object>> treeList = menuList2TreeList(menuList);
		ObjectMapper mapper = new ObjectMapper();
		String treeJson = "";
		try {
			treeJson = mapper.writeValueAsString(treeList);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return treeJson;
	}
	
	@Override
	public String findMenuForJson2() {
		Subject subject = SecurityUtils.getSubject();
		SysUser user = (SysUser) subject.getSession().getAttribute("user");
		
		List<SysMenu> menuList = menuDao.findByUserid(user.getId());
		List<Map<String, Object>> treeList = menuList2TreeList2(menuList);
		ObjectMapper mapper = new ObjectMapper();
		String treeJson = "";
		try {
			treeJson = mapper.writeValueAsString(treeList);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return treeJson;
	}
	
	/**
	 * ?????????List?????????JSTree?????????Map??????
	 * */
	private List<Map<String, Object>> menuList2TreeList(List<SysMenu> menuList) {
		List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
		for(SysMenu menu : menuList) {
			List<Map<String, Object>> childList = new ArrayList<Map<String, Object>>();
			
			if(menu.getParentId() == 1) {
				Map<String, Object> map = new LinkedHashMap<String, Object>();
				
				map.put("id", menu.getId());
				map.put("parent", menu.getParentId());
				map.put("text", menu.getName());
				map.put("icon", menu.getIcon());
				map.put("url", menu.getUrl());
				map.put("sort", menu.getSort());
				
				for(int i = 0;i < menuList.size(); i++) {
					Map<String, Object> map2 = new LinkedHashMap<String, Object>();
					
					if(menuList.get(i).getParentId().equals(menu.getId())) {
						map2.put("id", menuList.get(i).getId());
						map2.put("parent", menuList.get(i).getParentId());
						map2.put("name", menuList.get(i).getName());
						map2.put("icon", menuList.get(i).getIcon());
						map2.put("url", menuList.get(i).getUrl());
						map2.put("sort", menuList.get(i).getSort());
						
						childList.add(map2);
					}
				}
				map.put("children", childList);
				resList.add(map);
			}
		}
		return resList;
	}
	
	/**
	 * ?????????List?????????JSTree?????????Map??????
	 * */
	private List<Map<String, Object>> menuList2TreeList2(List<SysMenu> menuList) {
		List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
		
		for(SysMenu menu : menuList) {
			Map<String, Object> map = new LinkedHashMap<String, Object>();
			map.put("id", menu.getId());
			map.put("parent", menu.getParentId() == -1 ? "#" : menu.getParentId());
			map.put("text", menu.getName());
			map.put("icon", menu.getIcon());
			map.put("url", menu.getUrl());
			map.put("sort", menu.getSort());
			map.put("children", menu.getChildren());
			
			resList.add(map);
		}
		
		return resList;
	}

	@Override
	public List<SysMenu> findAll() {
		return menuDao.findAll();
	}

	@Override
	public SysMenu findById(Integer id) {
		return menuDao.findById(id);
	}
	
	@Override
	public List<SysMenu> findByParentid(Integer parentId) {
		return menuDao.findByParentid(parentId);
	}

	@Override
	public SysMenu findParentById(Integer parentId) {
		return menuDao.findParentById(parentId);
	}
	
	@Override
	public void deleteById(Integer id) {
		SysMenu menu = menuDao.findById(id);
		List<Integer> idList = Lists.newArrayList();
		getIds(menu, idList);
		
		// ????????????
		menuDao.deleteByIds(idList);
		// ????????????-??????????????????????????????
		rolePermissionDao.delByMenuids(idList);
		// ?????????????????????????????????????????????
		permissionService.deleteByMenuids(idList);
		// ????????????-????????????????????????
		roleMenuDao.delByMenuids(idList);
	}
	
	/**
	 * ???????????????????????????????????????ID??????
	 * */
	private void getIds(SysMenu menu, List<Integer> idList) {
		if(menu.getChildren() != null || menu.getChildren().size() > 0) {
			for(SysMenu child : menu.getChildren()) {
				getIds(child, idList);
			}
			idList.add(menu.getId());
		} else {
			idList.add(menu.getId());
		}
	} 

	@Override
	public void save(SysMenu menu) {
		
		SysUser user = (SysUser) SecurityUtils.getSubject().getSession().getAttribute("user");
		// ??????????????????
		if(menu.getId() == null) {
			SysMenu parent = menuDao.findParentById(menu.getParentId());
			
			menu.setCreateBy(user.getAccount());
			menu.setCreateDate(new Date());
			menu.setUpdateBy(user.getAccount());
			menu.setUpdateDate(new Date());
			menu.setIsDeleted("0");
			menu.setParentsId(parent.getParentsId() + "," + parent.getId());
			
			menuDao.insert(menu);
		} else {
			SysMenu old = menuDao.findById(menu.getId());
			
			List<SysMenu> children = Lists.newArrayList();
			if( !old.getParentId().equals(menu.getParentId()) ) { // ????????????????????????????????????parentsId
				SysMenu parent = menuDao.findById(menu.getParentId());
				setParentsId(parent.getParentsId() + "," + parent.getId(), old, children);
			}
			BeanUtils.copyProperties(menu, old);
			
			old.setUpdateBy(user.getAccount());
			old.setUpdateDate(new Date());
			
			menuDao.update(old);
			for(SysMenu child : children) {
				menuDao.update(child);
			}
			menu = old;
		}
		
		// ????????????
		if(menu.getId() != null) {
			updatePermission(menu);
		} else {
			addPermission(menu);
		}
	}
	
	private void setParentsId(String parentsId, SysMenu menu, List<SysMenu> children) {
		menu.setParentsId(parentsId);
		if( menu.getChildren() != null && menu.getChildren().size() > 0 ) {
			for(SysMenu child : menu.getChildren()) {
				setParentsId(menu.getParentsId()+","+menu.getId(), child, children);
				children.add(child);
			}
		}
	}
	
	/**
	 * ???????????????????????????????????????????????????
	 * */
	private void updatePermission(SysMenu menu) {
		
		List<SysPermission> saveList = Lists.newArrayList(); // ???????????? 
		List<Integer> delList = Lists.newArrayList(); // ?????????????????????ID
		Set<String> newPermissions = Sets.newHashSet();
		SysUser user = (SysUser) SecurityUtils.getSubject().getSession().getAttribute("user");
		
		// ????????????????????????menu?????????
		String menuPermissions = menu.getPermission();
		if(StringUtils.isBlank(menuPermissions)) {
			// ????????????-??????????????????????????????
			List<Integer> idList = Lists.newArrayList();
			idList.add(menu.getId());
			rolePermissionDao.delByMenuids(idList);
			
			// ?????????????????????????????????????????????
			permissionService.deleteByMenuid(menu.getId());
			return ;
		} else {
			if(menuPermissions.indexOf(",") > -1) { // ????????????????????????
				String[] tempPermission = menuPermissions.split(",");
				for(int index=0; index < tempPermission.length; index++) {
					newPermissions.add(tempPermission[index].trim());
				}
			} else {
				newPermissions.add(menuPermissions.trim());
			}
		}
		
		// ?????????????????????????????????
		List<SysPermission> oldPermissionList = permissionService.findByMenuid(menu.getId());
		for(SysPermission permission : oldPermissionList) {
			if(!newPermissions.contains(permission.getCode())) {
				delList.add(permission.getId());
			} else {
				newPermissions.remove(permission.getCode());
			}
		}
		
		for(String permCode : newPermissions) {
			SysPermission permission = new SysPermission();
			permission.setCode(permCode);
			permission.setMenuId(menu.getId());
			permission.setIsDeleted("0");
			permission.setCreateBy(user.getAccount());
			permission.setCreateDate(new Date());
			
			saveList.add(permission);
		}
		
		// ??????????????????
		if(delList.size() > 0) {
			permissionService.deleteByIds(delList);
			rolePermissionDao.delByPermissionids(delList);
		}
		
		// ??????????????????
		if(saveList.size() > 0) {
			permissionService.insertAll(saveList);
		}
	}
	
	/**
	 * ??????????????????
	 * */
	private void addPermission(SysMenu menu) {
		List<SysPermission> saveList = Lists.newArrayList(); // ?????????????????? 
		Set<String> newPermissions = Sets.newHashSet();
		SysUser user = (SysUser) SecurityUtils.getSubject().getSession().getAttribute("user");
		
		String menuPermissions = menu.getPermission();
		if(menuPermissions.indexOf(",") > -1) { // ????????????????????????
			String[] tempPermission = menuPermissions.split(",");
			for(int index=0; index < tempPermission.length; index++) {
				newPermissions.add(tempPermission[index].trim());
			}
		} else {
			newPermissions.add(menuPermissions.trim());
		}
		
		for(String permCode : newPermissions) {
			SysPermission permission = new SysPermission();
			permission.setCode(permCode);
			permission.setMenuId(menu.getId());
			permission.setIsDeleted("0");
			permission.setCreateBy(user.getAccount());
			permission.setCreateDate(new Date());
			
			saveList.add(permission);
		}
		
		// ??????????????????
		if(saveList.size() > 0) {
			permissionService.insertAll(saveList);
		}
	}

	@Override
	public SysMenu findByName(String name) {
		return menuDao.findByName(name);
	}

}