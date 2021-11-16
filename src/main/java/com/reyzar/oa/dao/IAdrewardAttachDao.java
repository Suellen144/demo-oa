package com.reyzar.oa.dao;

import java.util.Collection;
import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.AdrewardAttach;
import org.apache.ibatis.annotations.Param;


@MyBatisDao
public interface IAdrewardAttachDao {
	
	public List<AdrewardAttach> findAll();
	
	public AdrewardAttach findById(Integer id);

	public  List<AdrewardAttach> findByRewardId(Integer rewardId);
	
	public void save(AdrewardAttach adrewardAttach);
	
	public void update(AdrewardAttach adrewardAttach);

	public void insertAll(List<AdrewardAttach> adrewardAttachList);

	public void batchUpdate(@Param(value="adrewardAttachList") List<AdrewardAttach> adrewardAttachList);

	public void deleteByIdList(List<Integer> idList);
	
	public void deleteById(Integer id);

	public List<AdrewardAttach> findByIds(@Param("ids") Collection<Integer> ids);
}