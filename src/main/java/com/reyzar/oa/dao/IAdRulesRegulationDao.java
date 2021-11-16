package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdRulesRegulation;


@MyBatisDao
public interface IAdRulesRegulationDao {
	
	public List<AdRulesRegulation> findAll();
	
	public AdRulesRegulation findByOutlinId(Integer OutlinId);
	
	public AdRulesRegulation findById(Integer id);
	
	public void save(AdRulesRegulation adRulesRegulation);
	
	public void update(AdRulesRegulation adRulesRegulation);
	
	public void deleteById(Integer id);
	
	public void deleteByOutlineId(Integer id);
	
	public int countUnpublic();
}