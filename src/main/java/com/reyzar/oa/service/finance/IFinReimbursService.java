package com.reyzar.oa.service.finance;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.ReimburseDTO;
import com.reyzar.oa.domain.FinReimburse;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelreimburse;

public interface IFinReimbursService {
	
	public Page<FinReimburse> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public FinReimburse findById(Integer id);

	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO submitinfo(JSONObject json);

	public CrudResultDTO setStatus(Integer id, String status);
	
	public CrudResultDTO deleteAttach(String path,Integer id);
	
	public CrudResultDTO saveOrUpdate(JSONObject json) throws ParseException;

	Page<ReimburseDTO> findAllByPage(Map<String, Object> params, int pageNum,int pageSize);
	
	Page<ReimburseDTO> findMeByPage(Map<String, Object> params, int pageNum,int pageSize);
	
	public CrudResultDTO lock(JSONObject json);

	public List<FinReimburseAttach> findByProjectId(Integer id);

	public Page<FinReimburseAttach> findPageByProjectId(Map<String, Object> paramsMap, Integer valueOf, Integer valueOf2);

	public Page<ReimburseDTO> findAllByProjectId(Map<String, Object> paramsMap, Integer valueOf, Integer valueOf2);

	public CrudResultDTO unbound(JSONObject json);

	public CrudResultDTO initFindAllByProjectId(Integer id);

	public CrudResultDTO remove(Integer id);

	public CrudResultDTO setAssistantAffirm(Integer id, String assistantStatus);

	public Integer showSize();
	
	public void sendMailToApple(Integer id,String contents);
	
	public List<ReimburseDTO> findAllByProjectIdAndStatus(Integer id);
	
	public Page<FinTravelreimburse> findByPage1(Map<String, Object> params, int pageNum, int pageSize);
	
	public FinTravelreimburse findByExpenditure(Integer projectId);
	
	public FinTravelreimburse findByClearanceBeen(Integer projectId);
	
	public FinTravelreimburse findByClearanceBeenTo(Integer projectId,Integer reimbursid,Integer travelreimburseid);
	
	public Double findByIdAndUser(Integer id,Integer userId,String startDate,String endDate);
	
}
