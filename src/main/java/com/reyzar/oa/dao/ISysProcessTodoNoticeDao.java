package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysProcessTodoNotice;


@MyBatisDao
public interface ISysProcessTodoNoticeDao {
	
	public List<SysProcessTodoNotice> findAll();
	
	public SysProcessTodoNotice findById(Integer id);
	
	public void save(SysProcessTodoNotice sysProcessTodoNotice);
	
	public void update(SysProcessTodoNotice sysProcessTodoNotice);
	
	public void deleteById(Integer id);
	
	public int countByTaskIdAndUserId(@Param("taskId") String taskId, @Param("userId") Integer userId);
	
	public int countBySendDate(String sendDate);
	
	public void batchSave(@Param("processTodoNoticeList") List<SysProcessTodoNotice> processTodoNoticeList);
}