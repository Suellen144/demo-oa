package com.reyzar.oa.service.finance;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.FinInvoiced;
import com.reyzar.oa.domain.FinInvoicedAttach;

public interface IFinInvoicedService {
	public List<FinInvoicedAttach> findAttachByInvoicedID(Integer invoicedId);

	public List<FinInvoiced> findByBarginId(Integer barginId);
	
	public List<FinInvoiced> findByBarginIdAndCreateDate(Integer barginId,Date createDate);

	public FinInvoiced findById(Integer id);
	
	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public Page<FinInvoiced> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	public Page<FinInvoiced> findByPageList(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	public CrudResultDTO saveInfo(JSONObject json);
	
	CrudResultDTO deleteAttach(String path, Integer id);
	
	public CrudResultDTO submitinfo(JSONObject json);
	
	public CrudResultDTO setStatus(Integer id, String status);
	
	public void sendMailToApple(Integer id,String contents);

}