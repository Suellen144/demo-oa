package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdClientManageDao;
import com.reyzar.oa.domain.AdClientManage;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdClientManageService;

@Service
@Transactional
public class AdClientManageServiceImpl implements IAdClientManageService {
	@Autowired
	private IAdClientManageDao clientManageDao;
	
	@Override
	public Page<AdClientManage> findByPage(Map<String, Object> params, int pageNum,int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.Client);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		return  clientManageDao.findByPage(params);
	}
	
	@Override
	public AdClientManage findById(Integer id) {
		return clientManageDao.findById(id);
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		CrudResultDTO result = null;
		AdClientManage clientManage = json.toJavaObject(AdClientManage.class);
		if (clientManage.getId() == null) {
			result = save(clientManage);
		}
		else {
			result = Update(clientManage);
		}
		return result;
	}
	
	
	public CrudResultDTO save(AdClientManage clientManage){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功");
		SysUser user = UserUtils.getCurrUser();
		clientManage.setUserId(user.getId());
		clientManage.setDeptId(user.getDeptId());
		clientManage.setCreateBy(user.getAccount());
		clientManage.setCreateDate(new Date());
		clientManage.setIsDeleted("n");
		
		clientManageDao.save(clientManage);
		
		return result;
	}
	
	
	public CrudResultDTO Update(AdClientManage clientManage){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		clientManage.setUpdateBy(user.getAccount());
		clientManage.setUpdateDate(new Date());
		AdClientManage origin = clientManageDao.findById(clientManage.getId());
		BeanUtils.copyProperties(clientManage, origin);
		if (clientManage.getClientId() == null) {
			origin.setClientId(null);
		}
		if (clientManage.getPreClientId() == null) {
			origin.setPreClientId(null);
		}
		if (clientManage.getProjectId() == null) {
			origin.setProjectId(null);
		}
		clientManageDao.update(origin);
		
		return result;
	}


	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		AdClientManage clientManage = clientManageDao.findById(id);
		SysUser user = UserUtils.getCurrUser();
		clientManage.setUpdateBy(user.getAccount());
		clientManage.setUpdateDate(new Date());
		clientManage.setIsDeleted("y");
		
		clientManageDao.update(clientManage);
		
		return result;
	}

	@Override
	public CrudResultDTO findByProjectId(Integer projectId) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			List<SaleBarginManage> barginManages = clientManageDao.findByProjectManageId(projectId);
			result = new CrudResultDTO(CrudResultDTO.SUCCESS,barginManages);
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}
	
}