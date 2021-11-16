package com.reyzar.oa.service.finance.impl;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IFinCommonReceivedAttachDao;
import com.reyzar.oa.dao.IFinCommonReceivedDao;
import com.reyzar.oa.domain.FinCommonReceived;
import com.reyzar.oa.domain.FinCommonReceivedAttach;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.finance.IFinCommonReceivedService;

@Service
public class FinCommonReceivedServiceImpl implements IFinCommonReceivedService{

	@Autowired
	private IFinCommonReceivedDao commonReceivedDao;
	@Autowired
	private IFinCommonReceivedAttachDao commonReceivedAttachDao;
	
	@Override
	public FinCommonReceived findById(Integer id) {
		return commonReceivedDao.findById(id);
	}
	
	@Override
	public Page<FinCommonReceived> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.COMMON_RECEIVED);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		
		PageHelper.startPage(pageNum, pageSize);
		
		Page<FinCommonReceived> page = commonReceivedDao.findByPage(params);
		return page;
	}

	@Override
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		try{
			commonReceivedDao.deleteById(id);
		}catch (Exception e){
			e.printStackTrace();
		}
		try{
			commonReceivedAttachDao.deleteByCommonReceivedId(id);
		}catch (Exception e){
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public CrudResultDTO saveInfo(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		FinCommonReceived commonReceived = json.toJavaObject(FinCommonReceived.class);
		SysUser user = UserUtils.getCurrUser();
		if (commonReceived.getId() == null) {
			commonReceived.setCreateBy(user.getAccount());
			commonReceived.setCreateDate(new Date());
			commonReceived.setUserId(user.getId());
			commonReceived.setDeptId(user.getDeptId());
			commonReceivedDao.save(commonReceived);
			
			List<FinCommonReceivedAttach>  attachs=  commonReceived.getCommonReceivedAttachs();
			if (attachs != null) {
				for (FinCommonReceivedAttach finCommonReceivedAttach : attachs) {
					finCommonReceivedAttach.setCommonReceivedId(commonReceived.getId());
					finCommonReceivedAttach.setCreateBy(user.getAccount());
					finCommonReceivedAttach.setCreateDate(new Date());
					commonReceivedAttachDao.save(finCommonReceivedAttach);
				}
			}
		}else {
			FinCommonReceived oldCommonReceived = commonReceivedDao.findById(commonReceived.getId());
			commonReceived.setUpdateBy(user.getAccount());
			commonReceived.setUpdateDate(new Date());
			BeanUtils.copyProperties(commonReceived, oldCommonReceived);
			commonReceivedDao.update(oldCommonReceived);
			
			List<FinCommonReceivedAttach> newCommonReceivedAttachList = commonReceived.getCommonReceivedAttachs();
			List<FinCommonReceivedAttach> oldCommonReceivedAttachList = commonReceivedAttachDao.findByReceivedId(commonReceived.getId());
			
			List<FinCommonReceivedAttach> saveList = Lists.newArrayList();
			List<FinCommonReceivedAttach> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();
			
			Map<Integer, FinCommonReceivedAttach> oldCommonReceivedAttachMap = Maps.newHashMap();
			for (FinCommonReceivedAttach FinCommonReceivedAttach : oldCommonReceivedAttachList) {
				oldCommonReceivedAttachMap.put(FinCommonReceivedAttach.getId(), FinCommonReceivedAttach);
			}
			
			for (FinCommonReceivedAttach newFinCommonReceivedAttach : newCommonReceivedAttachList) {
				if (newFinCommonReceivedAttach.getId() != null) {
					newFinCommonReceivedAttach.setUpdateBy(user.getAccount());
					newFinCommonReceivedAttach.setUpdateDate(new Date());
					
					FinCommonReceivedAttach oldFinCommonPayAttach = oldCommonReceivedAttachMap.get(newFinCommonReceivedAttach.getId());
					if (oldFinCommonPayAttach != null) {
						BeanUtils.copyProperties(newFinCommonReceivedAttach, oldFinCommonPayAttach);
						updateList.add(oldFinCommonPayAttach);
						oldCommonReceivedAttachMap.remove(newFinCommonReceivedAttach.getId());
					}
				}else {
					newFinCommonReceivedAttach.setCommonReceivedId(commonReceived.getId());
					newFinCommonReceivedAttach.setCreateBy(user.getAccount());
					newFinCommonReceivedAttach.setCreateDate(new Date());
					saveList.add(newFinCommonReceivedAttach);
				}
			}
			delList.addAll(oldCommonReceivedAttachMap.keySet());
			
			if(saveList.size() > 0){ 
				commonReceivedAttachDao.insertAll(saveList);
			}
			if(updateList.size() > 0) {
				commonReceivedAttachDao.batchUpdate(updateList);
			}
			if(delList.size() > 0) {
				commonReceivedAttachDao.deleteByIdList(delList);
			}
		}
		
		return result;
	}
	@Override
	public CrudResultDTO deleteAttach(String path, Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		FinCommonReceived commonReceived = commonReceivedDao.findById(id);
		if (commonReceived.getAttachments() != null) {
			try {
				FileUtil.forceDelete(path);
				commonReceived.setAttachName("");
				commonReceived.setAttachments("");
				commonReceivedDao.update(commonReceived);
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("删除成功！");
			} catch (IOException e) {
				e.printStackTrace();
			}
		
		}
		else{
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("附件不存在！");
		}
		return result;
	}
}