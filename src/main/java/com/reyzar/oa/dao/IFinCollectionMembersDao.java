package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinCollectionMembers;

@MyBatisDao
public interface IFinCollectionMembersDao {

	public List<FinCollectionMembers> findAll();
	
	public FinCollectionMembers findById(Integer id);
	
	public List<FinCollectionMembers> findByFinCollectionId(Integer finCollectionId);
	
	public void save(FinCollectionMembers finCollectionMembers);
	
	public void update(FinCollectionMembers finCollectionMembers);
	
	public void deleteById(Integer id);
	
	public void insertAll(List<FinCollectionMembers> finCollectionMembersList);
	
	public void batchUpdate(@Param(value="finCollectionMembersList") List<FinCollectionMembers> saleProjectMemberList);
}
