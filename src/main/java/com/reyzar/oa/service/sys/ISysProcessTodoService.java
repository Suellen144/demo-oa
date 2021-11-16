package com.reyzar.oa.service.sys;

import java.util.List;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SysProcessTodo;

public interface ISysProcessTodoService {
	
	public List<SysProcessTodo> getAllData();
	
	public SysProcessTodo findByCompanyIdAndProcess(Integer companyId, String process);
	
	public CrudResultDTO save(List<SysProcessTodo> processTodoList);
}