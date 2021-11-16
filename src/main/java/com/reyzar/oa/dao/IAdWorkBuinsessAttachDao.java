package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdWorkBuinsessAttach;


@MyBatisDao
public interface IAdWorkBuinsessAttachDao {
	
	public List<AdWorkBuinsessAttach> findAll();
	
	public AdWorkBuinsessAttach findById(Integer id);
	
	public void save(AdWorkBuinsessAttach adWorkBuinsessAttach);
	
	public void insertAll(List<AdWorkBuinsessAttach> buinsessAttachsList);

	public void batchUpdate(@Param(value="buinsessAttachsList") List<AdWorkBuinsessAttach> buinsessAttachsList);
	
	public void update(AdWorkBuinsessAttach adWorkBuinsessAttach);
	
	public void deleteById(Integer id);
	
	public void deleteByIdList(List<Integer> idList);
}