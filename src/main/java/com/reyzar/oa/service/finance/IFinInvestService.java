package com.reyzar.oa.service.finance;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.FinInvest;

public interface IFinInvestService {
	
	public List<FinInvest> findAll();
	
	public Page<FinInvest> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public FinInvest findById(Integer id);

	public CrudResultDTO save(FinInvest invest);
	
	public CrudResultDTO delete(Integer id);
}