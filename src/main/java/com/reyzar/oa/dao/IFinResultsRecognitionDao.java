package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinResultsRecognition;

@MyBatisDao
public interface IFinResultsRecognitionDao {
	
	public FinResultsRecognition findById(Integer id);
	
	public void save(FinResultsRecognition finResultsRecognition);
	
	public void update(FinResultsRecognition finResultsRecognition);

	public Page<FinResultsRecognition> findByPage(Map<String, Object> params);
	
	public List<FinResultsRecognition> findByFinInvoicedId(@Param("finInvoicedId")Integer finInvoicedId);
	
	public void updateByShareDate(FinResultsRecognition finResultsRecognition);
	
}
