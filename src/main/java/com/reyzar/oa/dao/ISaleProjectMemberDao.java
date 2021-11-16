package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.domain.SaleProjectMemberHistory;
import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SaleProjectMember;

@MyBatisDao
public interface ISaleProjectMemberDao {
	
	public SaleProjectMember findById(Integer id);
	
	public void save(SaleProjectMember member);
	
	public void update(SaleProjectMember member);
	
	public void delete(Integer id);
	
	public void deleteByProjectId(Integer ProjectId);

	public List<SaleProjectMember> findByProjectId(@Param("projectId") Integer projectId);
	
	public void insertAll(List<SaleProjectMember> saleProjectMemberList);

	public void insertAll2(List<SaleProjectMemberHistory> saleProjectMemberList);
	
	public void batchUpdate(@Param(value="saleProjectMemberList") List<SaleProjectMember> saleProjectMemberList);
}