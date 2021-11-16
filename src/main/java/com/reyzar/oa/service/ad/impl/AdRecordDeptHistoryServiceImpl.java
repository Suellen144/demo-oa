package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordDeptHistoryDao;
import com.reyzar.oa.domain.AdRecordDeptHistory;
import com.reyzar.oa.service.ad.IAdRecordDeptHistoryService;


@Service
public class AdRecordDeptHistoryServiceImpl implements IAdRecordDeptHistoryService {

	@Autowired
	private IAdRecordDeptHistoryDao deptHistoryDao;
	
	@Autowired
	private IAdRecordDeptHistoryDao recordDeptHistoryDao;
	
	@Override
	public List<AdRecordDeptHistory> findByUserId(Integer userId) {
		// TODO Auto-generated method stub
		return deptHistoryDao.findByUserId(userId);
	}
	
	//批量保存部门历史数据
	@Override
	public CrudResultDTO saveBatchDeptHistory(JSONObject jsonObject) {
		CrudResultDTO resultDTO = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功！");
		
		Set<String> keys   = jsonObject.keySet();
		Integer userId = null;
		for (String key : keys) {
			AdRecordDeptHistory adRecordDeptHistory =  jsonObject.getObject(key, AdRecordDeptHistory.class);
			userId = adRecordDeptHistory.getUserId();
		}
		List<AdRecordDeptHistory> allHistories = recordDeptHistoryDao.findByUserId(userId); 
		Map<Integer, AdRecordDeptHistory> originAdRecordDeptHistoryMap = Maps.newHashMap();
		for (AdRecordDeptHistory adRecordDeptHistory : allHistories) {
			originAdRecordDeptHistoryMap.put(adRecordDeptHistory.getId(), adRecordDeptHistory);
		}
		
		for (String key : keys) {
			AdRecordDeptHistory adRecordDeptHistory =  jsonObject.getObject(key, AdRecordDeptHistory.class);
			Integer id = adRecordDeptHistory.getId() ;
			if ( id != null && !id.equals("")) {
				originAdRecordDeptHistoryMap.remove(id);
				AdRecordDeptHistory  originDept = recordDeptHistoryDao.findById(id);
				originDept.setUpdateBy(UserUtils.getCurrUser().getAccount());
				originDept.setUpdateDate(new Date());
				BeanUtils.copyProperties(adRecordDeptHistory, originDept);
				recordDeptHistoryDao.update(originDept);
			}else {
				adRecordDeptHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
				adRecordDeptHistory.setCreateDate(new Date());
				recordDeptHistoryDao.save(adRecordDeptHistory);
			}
		}
		List<Integer> ids = Lists.newArrayList();
		ids.addAll(originAdRecordDeptHistoryMap.keySet());
		
		if(ids != null && ids.size() > 0){
			recordDeptHistoryDao.deleteByIds(ids);
		}
		
		return resultDTO;
	}
		
	
}