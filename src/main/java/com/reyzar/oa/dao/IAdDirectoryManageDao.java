package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdDirectoryManage;


@MyBatisDao
public interface IAdDirectoryManageDao {
	
	public List<AdDirectoryManage> findAll();
	
	public AdDirectoryManage findById(Integer id);
	
	public void save(AdDirectoryManage adDirectoryManage);
	
	public void update(AdDirectoryManage adDirectoryManage);
	
	public void deleteById(Integer id);
	
	public int dirExists(@Param(value="parentId") Integer parentId, @Param(value="name") String dirName);
	
	public int deleteDirByParentId(Integer id);
	
	public  List<AdDirectoryManage> findByDeptId(Map<String, Integer> deptIds);
	
	public int findParentById(Integer id);
	
	public int findChild(@Param(value="parentId") Integer parentId);
	
	public void updateByParentId(AdDirectoryManage adDirectoryManage);
	
}