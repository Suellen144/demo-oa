package com.reyzar.oa.service.ad;

import java.util.List;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdRulesRegulation;
import com.reyzar.oa.domain.AdRulesRegulationOutline;

public interface IAdRulesRegulationService {
	
	public List<AdRulesRegulationOutline> getAllOutline();
	
	public AdRulesRegulationOutline findByParentId(Integer parentId);
	
	public AdRulesRegulation findFirst();
	
	public CrudResultDTO save(AdRulesRegulation rulesRegulation);
	
	public CrudResultDTO approve(Integer id);
	
	public CrudResultDTO saveOrUpdateTitle(AdRulesRegulationOutline rulesRegulationOutline);
	
	public CrudResultDTO saveOrUpdateContent(AdRulesRegulation rulesRegulation);
	
	public CrudResultDTO deleteTitle(Integer id);
	
	public boolean hasUnpublic();
}