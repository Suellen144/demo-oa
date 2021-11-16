package com.reyzar.oa.dao;

import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdSalaryAttach;


@MyBatisDao
public interface IAdSalaryAttachDao {
	
	public List<AdSalaryAttach> findAll();
 
	public AdSalaryAttach findById(Integer id);
	
	public List<AdSalaryAttach> findBySalaryId(Integer salaryId);
	
	public void save(AdSalaryAttach adSalaryAttach);
	
	public void update(AdSalaryAttach adSalaryAttach);
	
	public void insertAll(List<AdSalaryAttach> salaryAttachList);
	
	public void batchUpdate(@Param(value="salaryAttachList") List<AdSalaryAttach> salaryAttachList);
	
	public void deleteByIdList(List<Integer> idList);
	
	public void deleteById(Integer id);

	public List<AdSalaryAttach> findByIds(@Param("ids") Collection<Integer> ids);
	
}