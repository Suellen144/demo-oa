package com.reyzar.oa.service.sale.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.dao.ISaleProjectMemberHistoryDao;
import com.reyzar.oa.domain.SaleProjectMemberHistory;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleProjectMemberHistoryService;

@Service
@Transactional
public class SaleProjectMemberHistoryServiceImpl implements ISaleProjectMemberHistoryService {

	@Autowired
	private ISaleProjectMemberHistoryDao iSaleProjectMemberHistoryDao;

	@Override
	public CrudResultDTO save(JSONObject json, SysUser user) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SaleProjectMemberHistory member = json.toJavaObject(SaleProjectMemberHistory.class);
		
		try {
			if(member.getId() == null) {
				member.setCreateBy(user.getAccount());
				member.setCreateDate(new Date());
				iSaleProjectMemberHistoryDao.save(member);
			} else {	
				SaleProjectMemberHistory old = iSaleProjectMemberHistoryDao.findById(member.getId());
				BeanUtils.copyProperties(member, old);
				old.setUserId(member.getUserId());
				old.setUpdateBy(user.getAccount());
				old.setUpdateDate(new Date());
				
				iSaleProjectMemberHistoryDao.update(old);
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public SaleProjectMemberHistory findById(Integer id) {
		SaleProjectMemberHistory member = iSaleProjectMemberHistoryDao.findById(id);
		return member;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<SaleProjectMemberHistory> findByProjectId(Integer projectId) {
		return iSaleProjectMemberHistoryDao.findByProjectId(projectId);
	}

}