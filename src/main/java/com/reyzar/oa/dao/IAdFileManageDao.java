package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.AdFileManage;
import com.reyzar.oa.domain.SysUser;


@MyBatisDao
public interface IAdFileManageDao {
	
	public Page<AdFileManage> findByPage(Map<String, Object> params);
	
	public List<AdFileManage> findAll();
	
	public AdFileManage findById(Integer id);
	
	public void save(AdFileManage adFileManage);
	
	public void update(AdFileManage adFileManage);
	
	public void deleteById(Integer id);

	public int deleteFileByDirectoryId(Integer directoryId);
	
	public int fileExists(@Param(value="parentId") Integer parentId, 
			@Param(value="id") Integer id, 
			@Param(value="name") String fileName);
	public AdFileManage existsAdFileManage(@Param(value="parentId") Integer parentId, 
			@Param(value="id") Integer id, 
			@Param(value="name") String fileName);
}