package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinTravelReimbursHistory;


@MyBatisDao
public interface IFinTravelReimbursHistoryDao {
	
	public List<FinTravelReimbursHistory> findAll();
	
	public List<FinTravelReimbursHistory> findByUserId(Integer userId);
	
	public List<FinTravelReimbursHistory> findByUserIdAndType(@Param(value="userId") Integer userId,@Param(value="type") Integer type);
	
	public List<FinTravelReimbursHistory> findByCondition(Map<String, Object> paramsMap);
	
	public FinTravelReimbursHistory findById(Integer id);
	
	public void save(FinTravelReimbursHistory finTravelReimbursHistory);
	
	public void update(FinTravelReimbursHistory finTravelReimbursHistory);
	
	public void deleteById(Integer id);
}