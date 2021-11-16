package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdEducation;

@MyBatisDao
public interface IAdEducationDao {

	
	public List<AdEducation> findByRecordId(Integer recordId);
	
	public void save(AdEducation adEducation);
	
	public void insertAll(List<AdEducation> educationList);
	
	public void update(AdEducation adEducation);
	
	public void batchUpdate(@Param(value="educationList") List<AdEducation> educationList);
	
	public void deleteByIdList(List<Integer> idList);
}
