package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdPostAppointment;

@MyBatisDao
public interface IAdPostAppointmentDao {

	public List<AdPostAppointment> findByRecordId(Integer recordId);
	
	public void save(AdPostAppointment adPostAppointment);
	
	public void insertAll(List<AdPostAppointment> postAppointmentList);
	
	public void update(AdPostAppointment adPostAppointment);
	
	public void batchUpdate(@Param(value="postAppointmentList") List<AdPostAppointment> postAppointmentList);
	
	public void deleteByIdList(List<Integer> idList);
}
