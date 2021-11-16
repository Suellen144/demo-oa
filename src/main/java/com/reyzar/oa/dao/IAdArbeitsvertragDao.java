package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdArbeitsvertrag;


@MyBatisDao
public interface IAdArbeitsvertragDao {

	public List<AdArbeitsvertrag> findByRecordId(Integer recordId);
	
	public void save(AdArbeitsvertrag adArbeitsvertrag);
	
	public void insertAll(List<AdArbeitsvertrag> arbeitsvertragList);
	
	public void update(AdArbeitsvertrag adArbeitsvertrag);
	
	public void batchUpdate(@Param(value="arbeitsvertragList") List<AdArbeitsvertrag> arbeitsvertragList);
	
	public void deleteByIdList(List<Integer> idList);
}
