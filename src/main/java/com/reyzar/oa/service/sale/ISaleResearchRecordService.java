package com.reyzar.oa.service.sale;

import java.util.List;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleResearchRecord;

public interface ISaleResearchRecordService {
	
	public SaleResearchRecord findById(Integer id);
	
	public CrudResultDTO save(Integer id, double money);

	public List<SaleResearchRecord> findByProjectId(Integer projectId);
}