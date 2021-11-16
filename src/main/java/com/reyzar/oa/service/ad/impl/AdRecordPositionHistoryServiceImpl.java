package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordPositionHistoryDao;
import com.reyzar.oa.domain.AdRecordDeptHistory;
import com.reyzar.oa.domain.AdRecordPositionHistory;
import com.reyzar.oa.service.ad.IAdRecordPositionHistoryService;


@Service
public class AdRecordPositionHistoryServiceImpl implements IAdRecordPositionHistoryService {

	@Autowired
	private IAdRecordPositionHistoryDao recordPositionHistoryDao;
	
	@Override
	public List<AdRecordPositionHistory> findByUserId(Integer userId) {
		
		return recordPositionHistoryDao.findByUserId(userId);
	}

	@Override
	public CrudResultDTO saveBatchPositionHistory(JSONObject jsonObject) {
		CrudResultDTO resultDTO = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功！");
		
		Set<String> keys   = jsonObject.keySet();
		Integer userId = null;
		for (String key : keys) {
			AdRecordPositionHistory history = jsonObject.getObject(key, AdRecordPositionHistory.class);
			userId = history.getUserId();
		}
		
		List<AdRecordPositionHistory> allHistories = recordPositionHistoryDao.findByUserId(userId);
		Map<Integer, AdRecordPositionHistory> originAdRecordPositionHistoryMap = Maps.newHashMap();
		for (AdRecordPositionHistory adRecordPositionHistory : allHistories) {
			originAdRecordPositionHistoryMap.put(adRecordPositionHistory.getId(), adRecordPositionHistory);
		}
		
		for (String key : keys) {
			AdRecordPositionHistory positionHistory =  jsonObject.getObject(key, AdRecordPositionHistory.class);
			Integer id = positionHistory.getId() ;
			if ( id != null && !id.equals("")) {
				originAdRecordPositionHistoryMap.remove(id);
				positionHistory.setUpdateBy(UserUtils.getCurrUser().getAccount());
				positionHistory.setUpdateDate(new Date());
				AdRecordPositionHistory  originPosition = recordPositionHistoryDao.findById(id);
				BeanUtils.copyProperties(positionHistory, originPosition);
				recordPositionHistoryDao.update(originPosition);
			}else {
				positionHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
				positionHistory.setCreateDate(new Date());
				recordPositionHistoryDao.save(positionHistory);
			}
		}
		
		
		List<Integer> ids = Lists.newArrayList();
		ids.addAll(originAdRecordPositionHistoryMap.keySet());
		
		if(ids != null && ids.size() > 0){
			recordPositionHistoryDao.deleteByIds(ids);
		}
		
		return resultDTO;
	}
	
}