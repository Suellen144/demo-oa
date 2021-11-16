package com.reyzar.oa.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.FinInvoiced;


@MyBatisDao
public interface IFinInvoicedDao {

	public List<FinInvoiced> findByBarginId(Integer barginId);
	
	public List<FinInvoiced> findByBarginIdAndCreateDate(@Param("barginId") Integer barginId,@Param("createDate") Date createDate);
	
	public List<FinInvoiced> findAll();
	
	public FinInvoiced findById(Integer id);
	
	public void save(FinInvoiced finInvoiced);
	
	public void update(FinInvoiced finInvoiced);
	
	public void deleteById(Integer id);
	
	public Page<FinInvoiced> findByPage(Map<String, Object> params);

	public int updateInvoice(Integer id);
}