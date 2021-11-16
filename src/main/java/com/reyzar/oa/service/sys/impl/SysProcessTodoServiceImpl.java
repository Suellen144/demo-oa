package com.reyzar.oa.service.sys.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.dao.ISysProcessTodoDao;
import com.reyzar.oa.domain.SysProcessTodo;
import com.reyzar.oa.domain.SysProcessTodoNode;
import com.reyzar.oa.service.sys.ISysProcessTodoService;

@Service
@Transactional
public class SysProcessTodoServiceImpl implements ISysProcessTodoService {

	@Autowired
	private ISysProcessTodoDao processTodoDao;
	
	@Override
	public List<SysProcessTodo> getAllData() {
		return processTodoDao.findAll();
	}

	@Override
	public CrudResultDTO save(List<SysProcessTodo> processTodoList) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		
		try {
			if( processTodoList != null ) {
				for(SysProcessTodo processTodo : processTodoList) {
					if(processTodo.getId() != null) {
						processTodoDao.update(processTodo);
						processTodoDao.batchUpdateNode(processTodo.getNodeList());
					} else {
						processTodoDao.save(processTodo);
						for(SysProcessTodoNode node : processTodo.getNodeList()) {
							node.setProcessTodoId(processTodo.getId());
						}
						processTodoDao.batchSaveNode(processTodo.getNodeList());
					}
				}
			}
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("保存数据失败，请联系管理员！");
		}
		
		return result;
	}

	@Override
	public SysProcessTodo findByCompanyIdAndProcess(Integer companyId, String process) {
		return processTodoDao.findByCompanyIdAndProcess(companyId, process);
	}
	
}