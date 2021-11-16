package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdWorkBuinsessAttach;
import com.reyzar.oa.domain.AdWorkMarketAttach;


@MyBatisDao
public interface IAdWorkMarketAttachDao {
	
	public List<AdWorkMarketAttach> findAll();
	
	public AdWorkMarketAttach findById(Integer id);
	
	public void save(AdWorkMarketAttach adWorkMarket);
	
	public void update(AdWorkMarketAttach adWorkMarket);
	
	public void deleteById(Integer id);
	
	public void deleteByIdList(List<Integer> idList);

	public void insertAll(List<AdWorkMarketAttach> marketAttachsList);
	
	public void batchUpdate(@Param(value="marketAttachsList") List<AdWorkMarketAttach> marketAttachsList);
}