package com.reyzar.oa.service.finance.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IFinInvestDao;
import com.reyzar.oa.domain.FinInvest;
import com.reyzar.oa.service.finance.IFinInvestService;

/** 
* @ClassName: FinInvestServiceImpl 
* @Description: 费用归属
* @author Lin 
* @date 2016年10月26日 上午10:40:07 
*  
*/
@Service
@Transactional
public class FinInvestServiceImpl implements IFinInvestService {
	
	@Autowired
	private IFinInvestDao investDao;

	@Override
	public Page<FinInvest> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<FinInvest> page = investDao.findByPage(params);
		return page;
	}
	
	@Override
	public List<FinInvest> findAll() {
		return investDao.findAll();
	}
	
	@Override
	public FinInvest findById(Integer id) {
		return investDao.findById(id);
	}

	@Override
	public CrudResultDTO save(FinInvest invest) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		try {
			if(invest.getId() == null) {
				invest.setCreateBy(UserUtils.getCurrUser().getAccount());
				invest.setCreateDate(new Date());
				investDao.save(invest);
			} else {
				invest.setUpdateBy(UserUtils.getCurrUser().getAccount());
				invest.setUpdateDate(new Date());
				
				FinInvest old = findById(invest.getId());
				BeanUtils.copyProperties(invest, old);
				investDao.update(old);
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			investDao.deleteById(id);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

}