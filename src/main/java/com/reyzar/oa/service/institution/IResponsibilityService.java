package com.reyzar.oa.service.institution;

import java.util.List;

import com.reyzar.oa.domain.Responsibility;

public interface IResponsibilityService {

	public Responsibility findById(Integer id);
	
	public List<Responsibility> findByDeptId(Responsibility responsibility);

	public Responsibility findByDeptId2(Integer  id);
	
	public Integer saveOrUpdate(Responsibility responsibility);
	
	public void delete(Integer id);
}
