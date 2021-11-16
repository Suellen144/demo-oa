package com.reyzar.oa.dao;


import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.Responsibility;
@MyBatisDao
public interface IResponsibilityDao {

	public void saveByDept(Map<String, String> param);

	public Responsibility findByDeptId2(Integer id);

	public void updateByDeptId(Map<String, String> param);

	public Responsibility findById(Integer id);
	
	public List<Responsibility> findByDeptId(Responsibility responsibility);
	
	public Integer save(Responsibility responsibility);
	
	public void update(Responsibility responsibility);
	
	public void delete(Integer id);

}
