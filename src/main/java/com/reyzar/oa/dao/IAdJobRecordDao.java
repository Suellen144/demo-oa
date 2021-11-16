package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdJobRecord;

@MyBatisDao
public interface IAdJobRecordDao {

	
	public List<AdJobRecord> findByRecordId(Integer recordId);
	
	public void save(AdJobRecord adJobRecord);
	
	public void insertAll(List<AdJobRecord> jobRecordList);
	
	public void update(AdJobRecord adJobRecord);
	
	public void batchUpdate(@Param(value="jobRecordList") List<AdJobRecord> jobRecordList);
	
	public void deleteByIdList(List<Integer> idList);
}
