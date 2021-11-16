package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdWorkReportAttach;


@MyBatisDao
public interface IAdWorkReportAttachDao {
	
	public List<AdWorkReportAttach> findAll();
	
	public AdWorkReportAttach findById(Integer id);
	
	public void save(AdWorkReportAttach adWorkReportAttach);
	
	public void insertAll(List<AdWorkReportAttach> workReportAttachList);
	
	public void update(AdWorkReportAttach adWorkReportAttach);
	
	public void batchUpdate(@Param(value="workReportAttachList") List<AdWorkReportAttach> workReportAttachList);
	
	public void deleteById(Integer id);
	
	public void deleteByIdList(List<Integer> idList);
}