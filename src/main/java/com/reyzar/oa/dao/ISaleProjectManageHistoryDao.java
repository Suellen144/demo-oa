package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SaleProjectManageHistory;

@MyBatisDao
public interface ISaleProjectManageHistoryDao {
	
	public SaleProjectManageHistory findById(Integer id);
	
	public List<SaleProjectManageHistory> findByProjectId(Integer id);
	
	public void save(SaleProjectManageHistory projectHistory);
	
	public void update(SaleProjectManageHistory projectHistory);
	
	public void delete(Integer id);
		
}