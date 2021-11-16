package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdKpi;


@MyBatisDao
public interface IAdKpiDao {
	
	public Page<AdKpi> findByPage(Map<String, Object> params);
	
	public List<AdKpi> findAll();
	
	public AdKpi findById(Integer id);
	
	public AdKpi findBydeptIdAndDate(@Param("deptId") Integer deptId,@Param("time")String time);
	
	public void save(AdKpi adKpi);
	
	public void update(AdKpi adKpi);
	
	public void deleteById(Integer id);
	
	public List<AdKpi> queryIsRepeatKpi(Map<String, Object> params);
}