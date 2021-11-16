package com.reyzar.oa.service.sale;

import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleBarginManage;

public interface ISaleBarginManageService {

	Page<SaleBarginManage> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	Page<SaleBarginManage> findByPageNew(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	Page<SaleBarginManage> findByPage1(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	CrudResultDTO submit(JSONObject json);

	CrudResultDTO findByBarginName(JSONObject json);

	CrudResultDTO delete(JSONObject json);

	SaleBarginManage findById(Integer id);

	CrudResultDTO saveInfo(JSONObject json);

	CrudResultDTO setStatus(Integer id, String status);

	CrudResultDTO setStatus2(Integer id, String status, String remark);

	CrudResultDTO updateConfirm(Integer id,String barginConfirm);

	List<SaleBarginManage> findByProjectManageId(Integer projectManageId);

	Page<SaleBarginManage> getBarginListForDialog(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);

	CrudResultDTO findByProjectId(Integer projectId);

	CrudResultDTO updateBarginInfo(JSONObject json);

	CrudResultDTO deleteAttach(String path, Integer id);

	CrudResultDTO deleteAttach2(String path, Integer id);

	CrudResultDTO sendMail(Integer id,String comment);

	SaleBarginManage findByContractAmount(Integer projectId);
	
	SaleBarginManage findByIncome(Integer projectId);
	
	SaleBarginManage findByChannelHave(Integer projectId);

}