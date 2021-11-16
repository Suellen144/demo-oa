package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdTravelAttach;


@MyBatisDao
public interface IAdTravelAttachDao {
	
	public List<AdTravelAttach> findAll();
	
	public AdTravelAttach findById(Integer id);
	
	public List<AdTravelAttach> findByTravelId(Integer travelId);
	
	public void save(AdTravelAttach adTravelAttach);
	
	public void insertAll(List<AdTravelAttach> travelAttachList);
	
	public void update(AdTravelAttach adTravelAttach);
	
	public void batchUpdate(@Param("travelAttachList") List<AdTravelAttach> travelAttachList);
	
	public void deleteById(Integer id);
	
	public void deleteByIdList(List<Integer> idList);
}