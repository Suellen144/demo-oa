package com.reyzar.oa.service.finance;

import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.domain.FinResultsRecognition;
/**
 *  收入确认 &业绩贡献
 * @author ljd
 *
 */
@Service
@Transactional
public interface IFinResultsRecognitionService {

	public FinResultsRecognition findById(Integer id);
	
	public void save(JSONObject json);
	
	public void saveOrUpdate(JSONObject json);
	
	Page<FinResultsRecognition> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
}
