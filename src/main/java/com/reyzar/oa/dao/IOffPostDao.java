package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.OffPost;

@MyBatisDao
public interface IOffPostDao {
		
	public Page<OffPost> findByPage(Map<String, Object> params);
	
	public List<OffPost> findAll(Map<String, Object> params);
	
	public OffPost findById(Integer id);
	
	public void save(OffPost offPost);
	
	public void update(OffPost offPost);
	
	public void deleteById(Integer id);
	
	public void updateAudit(OffPost offPost);
	
	public void updateStatus(OffPost offPost);

}
