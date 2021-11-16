package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinRevenueRecognition;

@MyBatisDao
public interface IFinRevenueRecognitionDao {
	
	public FinRevenueRecognition findById(Integer id);
	
	public void save(FinRevenueRecognition finRevenueRecognition);
	
	public void update(FinRevenueRecognition finRevenueRecognition);

	public Page<FinRevenueRecognition> findByPage(Map<String, Object> params);
	
	public List<FinRevenueRecognition> findByFinInvoicedId(@Param("finInvoicedId") Integer finInvoicedId);
	
	public List<FinRevenueRecognition> findByConfirmWay();
	
	public List<FinRevenueRecognition> findBybarginIds(@Param(value="barginId") List<String> barginId);
}
