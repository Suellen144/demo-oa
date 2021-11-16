package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdPayAdjustmentDao;
import com.reyzar.oa.domain.AdPayAdjustment;
import com.reyzar.oa.domain.AdPostAppointment;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.FinCollectionAttach;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdPayAdjustmentService;
import com.reyzar.oa.service.sys.IEncryptService;

@Service
@Transactional
public class AdPayAdjustmentServiceImpl implements IAdPayAdjustmentService,IEncryptService{
	
	@Autowired
	private IAdPayAdjustmentDao payAdjustmentDao;
	
	@Override
	public List<AdPayAdjustment> findAll() {
		return payAdjustmentDao.findAll();
	}
	
	@Override
	public List<AdPayAdjustment> findByRecordId(Integer recordId) {
		return payAdjustmentDao.findByRecordId(recordId);
	}

	
	@Override
	public void save(AdRecord record,AdPayAdjustment adPayAdjustment) {
			adPayAdjustment.setCreateBy(record.getCreateBy());
			adPayAdjustment.setCreateDate(new Date());
			payAdjustmentDao.save(adPayAdjustment);
	}

	@Override
	public CrudResultDTO insertAll(AdRecord record, List<AdPayAdjustment> payAdjustmentList) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		if(payAdjustmentList.size()>0){
			String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
			boolean hasencryptionKey =encryptionKey!= null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey);
			if( encryptionKey == null ) {
				result.setCode(2);
				result.setResult("添加薪酬，请导入密钥！");
			}else if(hasencryptionKey) {
				result.setCode(3);
				result.setResult("密钥已更改，请重新导入新密钥！");
			}
			for (AdPayAdjustment payAdjustment : payAdjustmentList) {
				if (payAdjustment.getBasePay() != null ) {
						payAdjustment.setBasePay(AesUtils.encryptECB(payAdjustment.getBasePay(), encryptionKey));
				}
				if (payAdjustment.getMeritPay() != null ) {
					payAdjustment.setMeritPay(AesUtils.encryptECB(payAdjustment.getMeritPay(), encryptionKey));
				}
				if (payAdjustment.getTotal() != null ) {
					payAdjustment.setTotal(AesUtils.encryptECB(payAdjustment.getTotal(), encryptionKey));
				}
				payAdjustment.setRecordId(record.getId());
				payAdjustment.setCreateDate(new Date());
				payAdjustment.setCreateBy(record.getCreateBy());
				}
			payAdjustmentDao.insertAll(payAdjustmentList);
		}
		return result;
	}

	@Override
	public CrudResultDTO update(AdRecord record, AdPayAdjustment adPayAdjustment) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
			adPayAdjustment.setUpdateBy(record.getUpdateBy());
			adPayAdjustment.setUpdateDate(new Date());
			payAdjustmentDao.update(adPayAdjustment);
		return result;
	}

	@Override
	public CrudResultDTO batchUpdate(List<AdPayAdjustment> payAdjustmentList, AdRecord record) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		if(payAdjustmentList!=null){
			List<AdPayAdjustment> old=payAdjustmentDao.findByRecordId(record.getId());
			List<AdPayAdjustment> saveList = Lists.newArrayList();
			List<AdPayAdjustment> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, AdPayAdjustment> orginPayAdjustment = Maps.newHashMap();

			for (AdPayAdjustment payAdjustment : old) {
				orginPayAdjustment.put(payAdjustment.getId(), payAdjustment);
			}
			//得到密钥
			String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
			boolean hasencryptionKey =encryptionKey!= null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey);
			for (AdPayAdjustment payAdjustment : payAdjustmentList) {
				AdPayAdjustment orgin = orginPayAdjustment.get(payAdjustment.getId());
				if (orgin != null) {
					if(payAdjustment.getBasePay() != null && payAdjustment.getBasePay() != "" && !payAdjustment.getBasePay().equals(orgin.getBasePay())){
						if( encryptionKey == null ) {
							result.setCode(2);
							result.setResult("更改薪酬，请导入密钥！");
							return result;
						}else if(hasencryptionKey) {
							result.setCode(3);
							result.setResult("密钥已更改，请重新导入新密钥！");
							return result;
						}else {
							payAdjustment.setBasePay(AesUtils.encryptECB(payAdjustment.getBasePay(), encryptionKey));
						}
					}
					if(payAdjustment.getMeritPay() != null && payAdjustment.getMeritPay() != "" && !payAdjustment.getMeritPay().equals(orgin.getMeritPay())){
						if( encryptionKey == null ) {
							result.setCode(2);
							result.setResult("更改薪酬，请导入密钥！");
							return result;
						}else if(hasencryptionKey) {
							result.setCode(3);
							result.setResult("密钥已更改，请重新导入新密钥！");
							return result;
						}else {
							payAdjustment.setMeritPay(AesUtils.encryptECB(payAdjustment.getMeritPay(), encryptionKey));
						}
					}
					if(payAdjustment.getTotal() != null && payAdjustment.getTotal() != "" && !payAdjustment.getTotal().equals(orgin.getTotal())){
						if( encryptionKey == null ) {
							result.setCode(2);
							result.setResult("更改薪酬，请导入密钥！");
							return result;
						}else if(hasencryptionKey) {
							result.setCode(3);
							result.setResult("密钥已更改，请重新导入新密钥！");
							return result;
						}else {
							payAdjustment.setTotal(AesUtils.encryptECB(payAdjustment.getTotal(), encryptionKey));
						}
					}
					//更新的附表
					BeanUtils.copyProperties(payAdjustment, orgin);
					updateList.add(orgin);
					orginPayAdjustment.remove(orgin.getId());
				} else {
					if( encryptionKey == null ) {
						result.setCode(2);
						result.setResult("添加薪酬，请导入密钥！");
						return result;
					}else if(hasencryptionKey) {
						result.setCode(3);
						result.setResult("密钥已更改，请重新导入新密钥！");
						return result;
					}
					if (payAdjustment.getBasePay() != null ) {
						payAdjustment.setBasePay(AesUtils.encryptECB(payAdjustment.getBasePay(), encryptionKey));
					}
					if (payAdjustment.getMeritPay() != null ) {
						payAdjustment.setMeritPay(AesUtils.encryptECB(payAdjustment.getMeritPay(), encryptionKey));
					}
					if (payAdjustment.getTotal() != null ) {
						payAdjustment.setTotal(AesUtils.encryptECB(payAdjustment.getTotal(), encryptionKey));
					}
					//新增的附表
					payAdjustment.setRecordId(record.getId());
					payAdjustment.setCreateBy(record.getUpdateBy());
					payAdjustment.setCreateDate(new Date());
					payAdjustment.setUpdateBy(record.getUpdateBy());
					payAdjustment.setUpdateDate(new Date());
					saveList.add(payAdjustment);
				}
			}
			delList.addAll(orginPayAdjustment.keySet());

			if (saveList.size() > 0) {
				payAdjustmentDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				payAdjustmentDao.batchUpdate(updateList);
			}
			if (delList.size() > 0) {
				payAdjustmentDao.deleteByIdList(delList);
			}
		}else{
			List<AdPayAdjustment> old=payAdjustmentDao.findByRecordId(record.getId());
			List<Integer> delList=Lists.newArrayList();
			if(old.size()>0){
				for (AdPayAdjustment payAdjustment : old) {
					delList.add(payAdjustment.getId());
				}
				payAdjustmentDao.deleteByIdList(delList);
			}
		}
		return result;
	}
	
	//加密和解密
	@Override
	public void updateEncryptedData(String oldEncryptionKey, String newEncryptionKey) {
		List<AdPayAdjustment> payAdjustments=payAdjustmentDao.findAll();
		decryptData(payAdjustments, oldEncryptionKey);
		encryptData(payAdjustments, newEncryptionKey);
	}

	@Override
	public <T> void decryptData(List<T> list, String oldEncryptionKey) {
		for (T t : list) {
			AdPayAdjustment payAdjustment=(AdPayAdjustment) t;
			if (StringUtils.isNotEmpty(payAdjustment.getBasePay())) {
				String basePay = ModuleEncryptUtils.decryptText(payAdjustment.getBasePay(),oldEncryptionKey);
				if (StringUtils.isNotEmpty(basePay)) {
					payAdjustment.setBasePay(basePay);
				}
			}
			if (StringUtils.isNotEmpty(payAdjustment.getMeritPay())) {
				String meritPay = ModuleEncryptUtils.decryptText(payAdjustment.getMeritPay(),oldEncryptionKey);
				if (StringUtils.isNotEmpty(meritPay)) {
					payAdjustment.setMeritPay(meritPay);
				}
			}
			if (StringUtils.isNotEmpty(payAdjustment.getTotal())) {
				String total = ModuleEncryptUtils.decryptText(payAdjustment.getTotal(),oldEncryptionKey);
				if (StringUtils.isNotEmpty(total)) {
					payAdjustment.setTotal(total);
				}
			}
			payAdjustmentDao.update(payAdjustment);
		}
	}

	@Override
	public <T> void encryptData(List<T> list, String newEncryptionKey) {
		for (T t : list) {
			AdPayAdjustment payAdjustment=(AdPayAdjustment) t;
			if (StringUtils.isNotEmpty(payAdjustment.getBasePay())) {
				String basePay = ModuleEncryptUtils.encryptText(payAdjustment.getBasePay(),newEncryptionKey);
				if (StringUtils.isNotEmpty(basePay)) {
					payAdjustment.setBasePay(basePay);
				}
			}
			if (StringUtils.isNotEmpty(payAdjustment.getMeritPay())) {
				String meritPay = ModuleEncryptUtils.encryptText(payAdjustment.getMeritPay(),newEncryptionKey);
				if (StringUtils.isNotEmpty(meritPay)) {
					payAdjustment.setMeritPay(meritPay);
				}
			}
			if (StringUtils.isNotEmpty(payAdjustment.getTotal())) {
				String total = ModuleEncryptUtils.encryptText(payAdjustment.getTotal(),newEncryptionKey);
				if (StringUtils.isNotEmpty(total)) {
					payAdjustment.setTotal(total);
				}
			}
			payAdjustmentDao.update(payAdjustment);
		}
	}


	
	


}
