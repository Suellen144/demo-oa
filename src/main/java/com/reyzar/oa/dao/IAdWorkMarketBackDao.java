package com.reyzar.oa.dao;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdWorkMarketBack;

@MyBatisDao
public interface IAdWorkMarketBackDao {

	public void save(AdWorkMarketBack adWorkMarketBack);

}
