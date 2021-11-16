package com.reyzar.oa.dao;

import java.util.Map;

import com.reyzar.oa.common.annotation.MyBatisDao;


@MyBatisDao
public interface JobManagerDao {
	
	public int getJobOff(String jobName);
	
	public void updateJobStatus(Map<String,Object> map);
}