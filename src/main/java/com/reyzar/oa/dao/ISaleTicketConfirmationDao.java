package com.reyzar.oa.dao;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleTicketConfirmation;

@MyBatisDao
public interface ISaleTicketConfirmationDao {

	
	public SaleTicketConfirmation findById(Integer id);
	
	public void save(SaleTicketConfirmation saleTicketConfirmation);
	
	public void update(SaleTicketConfirmation saleTicketConfirmation);
	
	public Page<SaleTicketConfirmation> findByPage(Map<String, Object> params);
}
