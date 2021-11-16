package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SaleResearchRecord;

@MyBatisDao
public interface ISaleResearchRecordDao {
	
	public SaleResearchRecord findById(Integer id);
	
	public void save(SaleResearchRecord research);
	
	public void update(SaleResearchRecord research);

	public List<SaleResearchRecord> findByProjectId(@Param("projectId") Integer projectId);
}