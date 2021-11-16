package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.domain.AdRecordSalaryHistory;
import com.reyzar.oa.domain.SysUser;

/**
 * @author since
 */
public interface IAdRecordSalaryHistoryService {

	List<AdRecordSalaryHistory> findByUserId(Integer userId);

	public  AdRecordSalaryHistory findOne(Integer userId);

	Object saveBatchSalaryHistory(JSONObject jsonObject, Integer userId);

	Page<AdRecordSalaryHistory> findByPage(Map<String, Object> paramsMap, Integer valueOf, Integer valueOf2,
			SysUser user);
}