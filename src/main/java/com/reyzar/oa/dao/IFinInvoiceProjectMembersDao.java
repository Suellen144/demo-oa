package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinInvoiceProjectMembers;

@MyBatisDao
public interface IFinInvoiceProjectMembersDao {

	public List<FinInvoiceProjectMembers> findAll();
	
	public FinInvoiceProjectMembers findById(Integer id);
	
	public List<FinInvoiceProjectMembers> findByFinInvoicedId(@Param("finInvoicedId") Integer finInvoicedId);
	
	public void save(FinInvoiceProjectMembers finInvoiceProjectMembers);
	
	public void update(FinInvoiceProjectMembers finInvoiceProjectMembers);
	
	public void insertAll(List<FinInvoiceProjectMembers> finInvoiceProjectMembersList);
	
	public void batchUpdate(@Param(value="finInvoiceProjectMembersList") List<FinInvoiceProjectMembers> finInvoiceProjectMembersList);
	
	public void deleteByIdList(List<Integer> idList);
}
