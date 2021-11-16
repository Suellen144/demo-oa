package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.AdMeeting;


@MyBatisDao
public interface IAdMeetingDao {
	public Page<AdMeeting> findByPage(Map<String, Object> params);
	
	public List<AdMeeting> findAll();
	
	public AdMeeting findById(Integer id);

	public List<AdMeeting> findByDeptId(Integer id);
	
	public String getMaxnumber();
	
	public void save(AdMeeting adMeeting);
	
	public void update(AdMeeting adMeeting);

	public void updateList(List<AdMeeting> adMeetingList);
	
	public void deleteById(Integer id);
}