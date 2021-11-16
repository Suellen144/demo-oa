package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinReimburse;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelreimburse;


@MyBatisDao
public interface IFinTravelreimburseDao {
	
	public Page<FinTravelreimburse> findByPage(Map<String, Object> params);
	
	public FinTravelreimburse findById(Integer id);
	
	public List<FinTravelreimburse> findByEncrypted(String encrypted);
	
	public FinTravelreimburse findByProcessId(String processId);
	
	public void save(FinTravelreimburse travelReimburs);
	
	public void update(FinTravelreimburse travelReimburs);
	
	public void deleteById(Integer id);
	
	public String getMaxOrderNo();

	public void setAssistantAffirm(@Param("id")Integer id, @Param("assistantStatus")String assistantStatus);
	
	public Page<FinTravelreimburse> findByPage1(Map<String, Object> params);
	
	public FinTravelreimburse findByExpenditure(@Param("projectId") Integer projectId);
	
	public FinTravelreimburse findByClearanceBeen(@Param("projectId") Integer projectId);
	
	public FinTravelreimburse findByClearanceBeenTo(@Param("projectId") Integer projectId,@Param("reimbursid") Integer reimbursid,@Param("travelreimburseid")Integer travelreimburseid);
	
	public Double findByIdAndUser(@Param("id")Integer id,@Param("userId")Integer userId,@Param("startDate")String startDate,@Param("endDate")String endDate);
}