package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdWorkMarket;


@MyBatisDao
public interface IAdWorkMarketDao {
	
	public List<AdWorkMarket> findAll();
	
	public AdWorkMarket findById(Integer id);
	
	public void save(AdWorkMarket adWorkMarket);
	
	public void update(AdWorkMarket adWorkMarket);
	
	public void deleteById(Integer id);
	
	public void setSstatus(AdWorkMarket adWorkMarket);
}