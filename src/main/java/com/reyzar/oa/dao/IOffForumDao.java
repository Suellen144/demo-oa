package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.OffForum;

@MyBatisDao
public interface IOffForumDao {
	public Page<OffForum> findByPage(Map<String, Object> params);
	
	public List<OffForum> findAll();
	
	public OffForum findById(Integer id);
	
	public void save(OffForum offForum);
	
	public void update(OffForum offForum);
	
	public void deleteById(Integer id);
}
