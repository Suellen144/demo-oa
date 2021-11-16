package com.reyzar.oa.service.ad;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdPayAdjustment;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.SysUser;

public interface IAdPayAdjustmentService {

	public List<AdPayAdjustment> findAll();
		
	public List<AdPayAdjustment> findByRecordId(Integer recordId);
	
	public void save(AdRecord record,AdPayAdjustment adPayAdjustment);
	
	public CrudResultDTO insertAll(AdRecord record,List<AdPayAdjustment> payAdjustmentList);
	
	public CrudResultDTO update(AdRecord record,AdPayAdjustment adPayAdjustment);
	
	public CrudResultDTO batchUpdate(@Param(value="payAdjustmentList") List<AdPayAdjustment> payAdjustmentList,AdRecord record);
	
	
	
}
