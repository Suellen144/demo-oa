package com.reyzar.oa.service.sale.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISaleResearchRecordDao;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SaleResearchRecord;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleResearchRecordService;

@Service
@Transactional
public class SaleResearchRecordServiceImpl implements ISaleResearchRecordService {

	@Autowired
	private ISaleResearchRecordDao researchRecordDao;
	
	@Autowired
	private ISaleProjectManageDao projectManageDao;

	@Override
	public CrudResultDTO save(Integer id, double money) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		
		SysUser user = UserUtils.getCurrUser();
		SaleResearchRecord record = new SaleResearchRecord();
		
		try {
			SaleProjectManage project = projectManageDao.findById(id);
			record.setUserId(user.getId());
			record.setProjectManageId(id);
			record.setMtime(new Date());
			record.setCost(money);
			record.setCreateBy(user.getAccount());
			record.setCreateDate(new Date());
			researchRecordDao.save(record);
			
			project.setResearchCostLines(money);
			project.setUpdateBy(user.getAccount());
			project.setCreateDate(new Date());
			projectManageDao.updateCost(project);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public SaleResearchRecord findById(Integer id) {
		SaleResearchRecord record = researchRecordDao.findById(id);
		return record;
	}

	@Override
	public List<SaleResearchRecord> findByProjectId(Integer projectId) {
		return researchRecordDao.findByProjectId(projectId);
	}

}