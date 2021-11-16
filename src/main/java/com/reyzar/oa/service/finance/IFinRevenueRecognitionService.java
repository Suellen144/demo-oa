package com.reyzar.oa.service.finance;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.domain.FinRevenueRecognition;
/**
 *  收入确认
 * @author ljd
 *
 */
@Service
@Transactional
public interface IFinRevenueRecognitionService {

	public FinRevenueRecognition findById(Integer id);
	
	public void save(JSONObject json);
	
	public void saveOrUpdate(JSONObject json);
	
	Page<FinRevenueRecognition> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	public List<FinRevenueRecognition> findBybarginIds(List<String> barginId);
}
