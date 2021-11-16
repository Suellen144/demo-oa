package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.domain.SysDept;
import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.ProjectDTO;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysDictData;

@MyBatisDao
public interface ISaleProjectManageDao {

	public SysDept findDeptByDeptId(Integer id);
	
	public Page<SaleProjectManage> findByPage(Map<String, Object> params);
	
	public Page<SaleProjectManage> findByPage2(Map<String, Object> params);
	
	public Page<SaleProjectManage> findByPage3(Map<String, Object> params);
	
	public Page<SaleProjectManage> findList(Map<String, Object> params);
	
	public SaleProjectManage findById(Integer id);
	
	public SaleProjectManage findByIdByCreateDate(Integer id);
	
	public void save(SaleProjectManage project);
	
	public void update(SaleProjectManage project);
	
	public void updateCost(SaleProjectManage project);
	
	public void setStatus(SaleProjectManage project);
	
	public void delete(Integer id);

	public List<SaleProjectManage> findAll();

	public List<SaleProjectManage> ajaxName(SaleProjectManage projectManage);

	public List<SaleProjectManage> findByName(String name);

	public List<SaleProjectManage> findByIdList(List<Integer> projectIdList);
	
	public List<ProjectDTO> getExcelData(Map<String, Object> paramMap);
	
	public List<SaleProjectManage> getExcelDataList(Map<String, Object> paramMap);
	
	public List<SysDictData> getProjectTyoe();
	
	public List<SaleProjectManage> findProjectManageByBarginId(@Param("barginId") Integer barginId);
	
	public List<SaleProjectManage> findByProjectName(SaleProjectManage saleProjectManage);

	public List<SaleProjectManage> findStatisticsList(Map<String, Object> paramMap);
}