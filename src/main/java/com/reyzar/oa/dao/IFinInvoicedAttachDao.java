package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinInvoicedAttach;
import com.reyzar.oa.domain.FinTravelreimburseAttach;


@MyBatisDao
public interface IFinInvoicedAttachDao {
	
	public List<FinInvoicedAttach> findAll();
	
	public List<FinInvoicedAttach> findByInvoicedId(Integer invoicedId);
	
	public FinInvoicedAttach findById(Integer id);
	
	public void save(FinInvoicedAttach finInvoicedAttach);
	
	public void insertAll(List<FinInvoicedAttach> invoicedAttachList);
	
	public void update(FinInvoicedAttach finInvoicedAttach);
	
	public void batchUpdate(@Param(value="invoicedAttachList") List<FinInvoicedAttach> invoicedAttachList);
	
	public void deleteById(Integer id);
	
	public void deleteByIdList(List<Integer> idList);
	
	public void deleteByInvoicedId(Integer invoicedId);
}