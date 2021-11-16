package com.reyzar.oa.service.sale;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleProjectAchievement;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;

public interface ISaleProjectManageService {

	public SysDept findDeptByDeptId(Integer id);
	
	public Page<SaleProjectManage> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public Page<SaleProjectManage> findByPage2(Map<String, Object> params, int pageNum, int pageSize);
	
	public Page<SaleProjectManage> findByPage3(Map<String, Object> params, int pageNum, int pageSize);
	
	public Page<SaleProjectManage> findAll(Map<String, Object> params, int pageNum, int pageSize);
	
	public SaleProjectManage findById(Integer id);
	
	public SaleProjectManage findByIdByCreateDate(Integer id);
	
	public CrudResultDTO save(JSONObject json, SysUser user);
	
	public CrudResultDTO saveInfoOld(JSONObject json, SysUser user);
	
	public CrudResultDTO setStatus(Integer id, String status);

	public CrudResultDTO delete(Integer id);

	public CrudResultDTO ajaxName(JSONObject json);
	
	public void exportExcel(ServletOutputStream outputStream, Map<String, Object> paramMap);
	
	public void exportExcelList(ServletOutputStream outputStream, Map<String, Object> paramMap);
	
	public List<SaleProjectManage> findProjectManageByBarginId(Integer barginId);
	
	CrudResultDTO setStatusNew(Integer id, String status);
	
	CrudResultDTO submit(JSONObject json);

	List<SaleProjectAchievement> findPerformanceContributionList(Map<String, Object> paramsMap);
	
	List<SaleProjectAchievement> findProjectAchievementList(Map<String, Object> paramsMap);
	
	CrudResultDTO findByProjectName(JSONObject json);

	public void exportExcelOne(ServletOutputStream outputStream, Map<String, Object> paramMap);
	
	CrudResultDTO updateIsDeleted(Integer id);
	
	CrudResultDTO deleteAttach(String path, Integer id);
	
	CrudResultDTO sendMail(Integer id,String comment);
}