package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdPosition;


@MyBatisDao
public interface IAdPositionDao {
	
	public List<AdPosition> findAll();
	
	public Page<AdPosition> findByPage(Map<String, Object> params);
	
	public AdPosition findById(Integer id);
	
	public void save(AdPosition adPosition);
	
	public void update(AdPosition adPosition);
	
	public List<AdPosition> findByDeptId(Integer deptId);
	
	public void deleteById(Integer id);
	
	public AdPosition findByCode(String code);
	
	public List<Map<String, Object>> getMaxCode();
	
	public List<AdPosition> findPositionOfManagerByDeptIdAndLevel(@Param(value="deptId") Integer deptId, @Param(value="level") Integer level);
}