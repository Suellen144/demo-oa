package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdPayAdjustment;

@MyBatisDao
public interface IAdPayAdjustmentDao {

	public List<AdPayAdjustment> findAll();
	
	public List<AdPayAdjustment> findByRecordId(Integer recordId);
	
	public void save(AdPayAdjustment adPayAdjustment);
	
	public void insertAll(List<AdPayAdjustment> payAdjustmentList);
	
	public void update(AdPayAdjustment adPayAdjustment);
	
	public void batchUpdate(@Param(value="payAdjustmentList") List<AdPayAdjustment> payAdjustmentList);

	public void deleteByIdList(List<Integer> idList);
}
