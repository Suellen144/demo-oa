package com.reyzar.oa.service.finance;

import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.FinPay;

/** 
* @ClassName: FinInvestServiceImpl 
* @Description: 费用归属
* @author Lin 
* @date 2016年10月26日 上午10:40:07 
*  
*/
@Service
@Transactional
public interface FinPayService   {

	CrudResultDTO saveInfo(JSONObject json);

	Page<FinPay> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);

	Page<FinPay> findByPage2(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);

	Page<FinPay> findByPageNew(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);

	FinPay findById(Integer id);
	
	FinPay findPayMoneyNew(Integer barginManageId);

	CrudResultDTO submit(JSONObject json);

	CrudResultDTO setStatus(Integer id, String status);

	CrudResultDTO delete(JSONObject json);

	CrudResultDTO findPayInfo(Integer barginManageId, String status);

	CrudResultDTO deleteAttach(String path, Integer id);
	
	public void sendMailToApple(Integer id, String contents);
	
	CrudResultDTO getTaskNext(String taskId);
	
}