package com.reyzar.oa.service.finance;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelReimbursHistory;
import com.reyzar.oa.domain.FinTravelreimburse;
import com.reyzar.oa.domain.FinTravelreimburseAttach;

public interface IFinTravelReimbursService {
	
	public Page<FinTravelreimburse> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public FinTravelreimburse findById(Integer id);
	
	public CrudResultDTO deleteAttach(String path,Integer id);

	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO submitinfo(JSONObject json);
	
	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public CrudResultDTO setStatus(Integer id, String status);
	
	public void saveBankInfo(Integer userId, String payee, String bankAccount, String bankAddress);

	public List<FinTravelReimbursHistory> getBankInfoByUserId(Integer userId);
	
	public List<FinTravelReimbursHistory> getMainBankInfo(Integer userId,Integer type);
	
	public CrudResultDTO lock(JSONObject json);

	public List<FinTravelreimburseAttach> findByProjectId(Integer id);

	public Page<FinReimburseAttach> findPageByProjectId(Map<String, Object> paramsMap, Integer pageNum,
			Integer pageSize);

	public CrudResultDTO unbound(JSONObject json);

	public CrudResultDTO remove(Integer id);

	public CrudResultDTO setAssistantAffirm(Integer id, String assistantStatus);
	
	public void sendMailToApple(Integer id,String contents);
	
	public Double findByIdAndUser(Integer id,Integer userId,String startDate,String endDate);
}
