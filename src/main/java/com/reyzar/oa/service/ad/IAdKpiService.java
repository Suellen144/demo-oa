package com.reyzar.oa.service.ad;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdKpi;
import com.reyzar.oa.domain.AdKpiAttach;

public interface IAdKpiService {

	public List<AdKpiAttach> findAllByDpetIdAndDate2(Map<String,Object> params);
	
	public AdKpi findById(Integer id);
	
	public List<AdKpi> findAll();
	
	public AdKpi findBydeptIdAndDate(Integer deptId,String time);
	
	public Integer getStatus(Integer deptId,String time);
	
	public CrudResultDTO save(JSONObject json);
	
	public CrudResultDTO saveOrUpdate(JSONObject json) throws ParseException;

	public abstract List<AdKpiAttach> findAllByDpetIdAndDate(Integer deptId,Date date);
	
	public abstract Page<AdKpiAttach> findByPage(Map<String, Object> params, int pageNum, int pageSize);

	public CrudResultDTO approve(JSONObject json) throws ParseException;
	
	public CrudResultDTO saveall(JSONObject json) throws ParseException;

	public CrudResultDTO saveone(JSONObject json) throws ParseException;
	
	public abstract List<AdKpiAttach> findByUserIdAndTime(Integer userId, String startTime, String endTime);

}