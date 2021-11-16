package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdRulesRegulationOutline;

@MyBatisDao
public interface IAdRulesRegulationOutlineDao {

	public List<AdRulesRegulationOutline> findAll();
	
	public AdRulesRegulationOutline findById(Integer id);
	
	public AdRulesRegulationOutline findByParentId(Integer parentId);
	
	public void save(AdRulesRegulationOutline rulesRegulationOutline);
	
	public void update(AdRulesRegulationOutline rulesRegulationOutline);
	
	public void deleteById(Integer id);
}
