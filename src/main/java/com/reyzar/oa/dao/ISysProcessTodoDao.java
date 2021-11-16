package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysProcessTodo;
import com.reyzar.oa.domain.SysProcessTodoNode;


@MyBatisDao
public interface ISysProcessTodoDao {
	
	public List<SysProcessTodo> findAll();
	
	public SysProcessTodo findById(Integer id);
	
	public SysProcessTodo findByCompanyIdAndProcess(@Param("companyId") Integer companyId, @Param("process") String process);
	
	public void save(SysProcessTodo sysProcessTodo);
	
	public void update(SysProcessTodo sysProcessTodo);
	
	public void deleteById(Integer id);
	
	public void batchUpdate(@Param("processTodoList") List<SysProcessTodo> processTodoList);
	
	public void batchSave(@Param("processTodoList") List<SysProcessTodo> processTodoList);
	
	public void batchUpdateNode(@Param("nodeList") List<SysProcessTodoNode> nodeList);
	
	public void batchSaveNode(@Param("nodeList") List<SysProcessTodoNode> nodeList);
}