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
import com.reyzar.oa.dao.IFinCommonPayAttachDao;
import com.reyzar.oa.dao.IFinCommonPayDao;
import com.reyzar.oa.domain.FinCommonPay;
import com.reyzar.oa.domain.FinCommonPayAttach;
import com.reyzar.oa.domain.FinPay;
import com.reyzar.oa.domain.FinReimburse;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.SysUser;


@Service
public class FinCommonPayServiceImpl implements com.reyzar.oa.service.finance.IFinCommonPayService {

	@Autowired
	private IFinCommonPayDao commonPayDao;
	@Autowired
	private IFinCommonPayAttachDao commonPayAttachDao;
	
	@Override
	public Page<FinCommonPay> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.COMMON_PAY);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		
		PageHelper.startPage(pageNum, pageSize);
		
		Page<FinCommonPay> page = commonPayDao.findByPage(params);
		return page;
	}
	
	@Override
	public FinCommonPay findById(Integer id) {
		return commonPayDao.findById(id);
	}
	@Override
	public CrudResultDTO saveInfo(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		FinCommonPay commonPay = json.toJavaObject(FinCommonPay.class);
		SysUser user = UserUtils.getCurrUser();
		if (commonPay.getId() == null) {
			commonPay.setCreateBy(user.getAccount());
			commonPay.setCreateDate(new Date());
			commonPay.setUserId(user.getId());
			commonPay.setDeptId(user.getDeptId());
			commonPayDao.save(commonPay);
			
			List<FinCommonPayAttach> attachs =  commonPay.getCommonPayAttachs();
			if (attachs != null) {
				for (FinCommonPayAttach finCommonPayAttach : attachs) {
					finCommonPayAttach.setCommonPayId(commonPay.getId());
					finCommonPayAttach.setCreateBy(user.getAccount());
					finCommonPayAttach.setCreateDate(new Date());
					commonPayAttachDao.save(finCommonPayAttach);
				}
			}
		}else {
			FinCommonPay oldCommonPay = commonPayDao.findById(commonPay.getId());
			commonPay.setUpdateBy(user.getAccount());
			commonPay.setUpdateDate(new Date());
			BeanUtils.copyProperties(commonPay, oldCommonPay);
			commonPayDao.update(oldCommonPay);
			
			List<FinCommonPayAttach> newCommonPayAttachList = commonPay.getCommonPayAttachs();
			List<FinCommonPayAttach> oldCommonPayAttachList = commonPayAttachDao.findByCommonId(commonPay.getId());
			
			List<FinCommonPayAttach> saveList = Lists.newArrayList();
			List<FinCommonPayAttach> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();
			
			Map<Integer, FinCommonPayAttach> oldCommonPayAttachMap = Maps.newHashMap();
			for (FinCommonPayAttach finCommonPayAttach : oldCommonPayAttachList) {
				oldCommonPayAttachMap.put(finCommonPayAttach.getId(), finCommonPayAttach);
			}
			
			for (FinCommonPayAttach newFinCommonPayAttach : newCommonPayAttachList) {
				if (newFinCommonPayAttach.getId() != null) {
					newFinCommonPayAttach.setUpdateBy(user.getAccount());
					newFinCommonPayAttach.setUpdateDate(new Date());
					
					FinCommonPayAttach oldFinCommonPayAttach = oldCommonPayAttachMap.get(newFinCommonPayAttach.getId());
					if (oldFinCommonPayAttach != null) {
						BeanUtils.copyProperties(newFinCommonPayAttach, oldFinCommonPayAttach);
						updateList.add(oldFinCommonPayAttach);
						oldCommonPayAttachMap.remove(newFinCommonPayAttach.getId());
					}
				}else {
					newFinCommonPayAttach.setCommonPayId(commonPay.getId());
					newFinCommonPayAttach.setCreateBy(user.getAccount());
					newFinCommonPayAttach.setCreateDate(new Date());
					saveList.add(newFinCommonPayAttach);
				}
			}
			delList.addAll(oldCommonPayAttachMap.keySet());
			
			if(saveList.size() > 0){ 
				commonPayAttachDao.insertAll(saveList);
			}
			if(updateList.size() > 0) {
				commonPayAttachDao.batchUpdate(updateList);
			}
			if(delList.size() > 0) {
				commonPayAttachDao.deleteByIdList(delList);
			}
		}
		
		return result;
	}

	@Override
	public CrudResultDTO deleteAttach(String path, Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		FinCommonPay commonPay = commonPayDao.findById(id);
		if (commonPay.getAttachments() != null) {
			try {
				FileUtil.forceDelete(path);
				commonPay.setAttachName("");
				commonPay.setAttachments("");
				commonPayDao.update(commonPay);
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

	/**
	 * 根据ID进行删除
	 * @param id
	 * @return
	 */
	@Override
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		try{
			commonPayDao.deleteById(id);
		}catch (Exception e){
			e.printStackTrace();
		}
		try{
			commonPayAttachDao.deleteByCommonPayId(id);
		}catch (Exception e){
			e.printStackTrace();
		}
		return result;
	}


}