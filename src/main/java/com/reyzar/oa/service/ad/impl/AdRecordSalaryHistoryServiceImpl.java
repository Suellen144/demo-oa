package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordPositionHistoryDao;
import com.reyzar.oa.dao.IAdRecordSalaryHistoryDao;
import com.reyzar.oa.domain.AdRecordPositionHistory;
import com.reyzar.oa.domain.AdRecordSalaryHistory;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdRecordSalaryHistoryService;
import com.reyzar.oa.service.sys.IEncryptService;


@Service
public  class AdRecordSalaryHistoryServiceImpl implements IAdRecordSalaryHistoryService,IEncryptService {

	@Autowired
	private  IAdRecordSalaryHistoryDao salaryHistoryDao;
	

	@Override
	public Page<AdRecordSalaryHistory> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize,
			SysUser user) {
		try {
			String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.SALARY_HISTORY);
			Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
			params.put("userId", user.getId());
			params.put("deptIdSet", deptIdSet);
			PageHelper.startPage(pageNum, pageSize);
		} catch (Exception e) {
			e.printStackTrace();
			throw new BusinessException();
		}
		return  salaryHistoryDao.findByPage(params);
	}
	
	
	@Override
	public List<AdRecordSalaryHistory> findByUserId(Integer userId) {
		return salaryHistoryDao.findByUserId(userId);
	}

	@Override
	public AdRecordSalaryHistory findOne(Integer userId) {
		return salaryHistoryDao.findByOne(userId);
	}

	@Override
	public Object saveBatchSalaryHistory(JSONObject jsonObject,Integer userId) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功！");
		
		List<AdRecordSalaryHistory> allHistories = salaryHistoryDao.findByUserId(userId);
		Map<Integer, AdRecordSalaryHistory> originSalaryHistoryMap = Maps.newHashMap();
		for (AdRecordSalaryHistory adRecordSalaryHistory : allHistories) {
			originSalaryHistoryMap.put(adRecordSalaryHistory.getId(), adRecordSalaryHistory);
		}
		
		Set<String> keys   = jsonObject.keySet();
		for (String key : keys) {
			AdRecordSalaryHistory  adRecordSalaryHistory =  jsonObject.getObject(key, AdRecordSalaryHistory.class);
			Integer id = adRecordSalaryHistory.getId() ;
			if ( id != null && !id.equals("")) {
				originSalaryHistoryMap.remove(id);
				AdRecordSalaryHistory  originSalary = salaryHistoryDao.findById(id);
				originSalary.setUpdateBy(UserUtils.getCurrUser().getAccount());
				originSalary.setUpdateDate(new Date());
				
				if (adRecordSalaryHistory.getSalary() != null && !adRecordSalaryHistory.getSalary().equals(originSalary.getSalary())) {
					String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
					if( encryptionKey == null ) {
						result.setCode(2);
						result.setResult("更改薪酬，请导入密钥！");
					}else if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
						result.setCode(3);
						result.setResult("密钥已更改，请重新导入新密钥！");
					}else {
						adRecordSalaryHistory.setSalary(AesUtils.encryptECB(adRecordSalaryHistory.getSalary(), encryptionKey));
						BeanUtils.copyProperties(adRecordSalaryHistory, originSalary);
						salaryHistoryDao.update(originSalary);
					}
				}else{
					BeanUtils.copyProperties(adRecordSalaryHistory, originSalary);
					salaryHistoryDao.update(originSalary);
				}
			}else {
				if (adRecordSalaryHistory.getSalary() != null ) {
					String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
					if( encryptionKey == null ) {
						result.setCode(2);
						result.setResult("添加薪酬，请导入密钥！");
					}else if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
						result.setCode(3);
						result.setResult("密钥已更改，请重新导入新密钥！");
					}else {
						adRecordSalaryHistory.setSalary(AesUtils.encryptECB(adRecordSalaryHistory.getSalary(), encryptionKey));
						adRecordSalaryHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
						adRecordSalaryHistory.setCreateDate(new Date());
						salaryHistoryDao.save(adRecordSalaryHistory);
					}
				}
				
			}
		}
		List<Integer> ids = Lists.newArrayList();
		ids.addAll(originSalaryHistoryMap.keySet());
		
		if(ids != null && ids.size() > 0){
			salaryHistoryDao.deleteByIds(ids);
		}
		
		return result;
	}


	@Override
	public void updateEncryptedData(String oldEncryptionKey, String newEncryptionKey) {
			List<AdRecordSalaryHistory> recordSalaryHistories=salaryHistoryDao.findAll();
			List<AdRecordSalaryHistory> recordSalaryHistories2=Lists.newArrayList();
			for (AdRecordSalaryHistory adRecordSalaryHistory : recordSalaryHistories) {
					adRecordSalaryHistory.setSalary(adRecordSalaryHistory.getSalary()==null?"":adRecordSalaryHistory.getSalary());
					recordSalaryHistories2.add(adRecordSalaryHistory);
			}
			decryptData(recordSalaryHistories2, oldEncryptionKey);
			
			List<AdRecordSalaryHistory> recordSalaryHistories3=Lists.newArrayList();
			for (AdRecordSalaryHistory adRecordSalaryHistory : recordSalaryHistories2) {
					adRecordSalaryHistory.setSalary(adRecordSalaryHistory.getSalary()==null?"":adRecordSalaryHistory.getSalary());
					recordSalaryHistories3.add(adRecordSalaryHistory);
			}
			encryptData(recordSalaryHistories3, newEncryptionKey);
			if(recordSalaryHistories3.size()>0){
				salaryHistoryDao.batchUpdate(recordSalaryHistories3);
			}
		
	}

	//进行解密
	@Override
	public <T> void decryptData(List<T> list, String oldEncryptionKey) {
		for (T t : list) {
			AdRecordSalaryHistory recordSalaryHistory=(AdRecordSalaryHistory) t;
			if(StringUtils.isNotEmpty(recordSalaryHistory.getSalary())){
				String salary=ModuleEncryptUtils.decryptText(recordSalaryHistory.getSalary(), oldEncryptionKey);
				if(StringUtils.isNotEmpty(salary)){
					recordSalaryHistory.setSalary(salary);
				}
			}
		}
		
	}

	//进行加密
	@Override
	public <T> void encryptData(List<T> list, String newEncryptionKey) {
		for (T t : list) {
			AdRecordSalaryHistory recordSalaryHistory=(AdRecordSalaryHistory) t;
			if(StringUtils.isNotEmpty(recordSalaryHistory.getSalary())){
				String salary=ModuleEncryptUtils.encryptText(recordSalaryHistory.getSalary(), newEncryptionKey);
				if(StringUtils.isNotEmpty(salary)){
					recordSalaryHistory.setSalary(salary);
				}
			}
		}
		
	}
	
}