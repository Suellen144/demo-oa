package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.WorkManageDTO;
import com.reyzar.oa.domain.AdWorkBuinsess;


@MyBatisDao
public interface IAdWorkBuinsessDao {
	
	public List<AdWorkBuinsess> findAll();
	
	public AdWorkBuinsess findById(Integer id);
	
	public Page<WorkManageDTO> findAllByPage(Map<String, Object> params);
	
	public void save(AdWorkBuinsess adWorkBuinsess);
	
	public void update(AdWorkBuinsess adWorkBuinsess);
	
	public void deleteById(Integer id);
	
	public void setSstatus(AdWorkBuinsess adWorkBuinsess);
}