package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.domain.SaleProjectMember;
import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SaleProjectMemberHistory;

@MyBatisDao
public interface ISaleProjectMemberHistoryDao {

	public void updateIsDelete();
	
	public SaleProjectMemberHistory findById(Integer id);
	
	public List<SaleProjectMemberHistory> findByProjectId(Integer projectId);
	
	public void save(SaleProjectMemberHistory memberHistory);
	
	public void update(SaleProjectMemberHistory member);

	public int update2(SaleProjectMember member);
	
	public void delete(Integer id);
	
	public void deleteByProjectId(Integer id);
	
	public void insertAll(List<SaleProjectMemberHistory> saleProjectMemberHistoryList);

	public void insertAll2(List<SaleProjectMember> saleProjectMemberHistoryList);
	
	public void batchUpdate(@Param(value="saleProjectMemberHistoryList") List<SaleProjectMemberHistory> saleProjectMemberHistoryList);
}