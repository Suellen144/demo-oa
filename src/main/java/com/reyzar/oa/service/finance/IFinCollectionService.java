package com.reyzar.oa.service.finance;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.*;

public interface IFinCollectionService {

	public Map<String,Object> findTaxesAndRelationshipByProjectId(Integer projectId,Integer barginId,Integer id);

	public FinCollection statisticsRelationship(Integer projectId);

	public int changeData(Integer id,double purchase,double taxes,double relationship,double other,double commissionBase);
	
	public Map<String, Object> findUser();	
	
	public Page<FinCollection> findByPage(Map<String, Object> params, int pageNum, int pageSize);	
	
	public Page<FinCollection> findByPageNew(Map<String, Object> params, int pageNum, int pageSize);
	
	public Page<FinCollection> findListByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public FinCollection findById(Integer id);
	
	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO submitinfo(JSONObject json);
	
	public CrudResultDTO saveOrUpdate(JSONObject json);
	
	public CrudResultDTO setStatus(Integer id, String status);

	public CrudResultDTO findCollectionInfo(Integer barginId , String  status);

	CrudResultDTO deleteAttach(String path, Integer id);
	
	public void sendMailToApple(Integer id,String contents);
	
	public List<FinCollection> findByBarginId(Integer barginId);
	
	public List<FinCollection> findByBarginIdAndCreateDate(Integer barginId,Date createDate);
	
}