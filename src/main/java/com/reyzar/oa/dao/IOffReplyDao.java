package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.OffReply;

@MyBatisDao
public interface IOffReplyDao {

	public Page<OffReply> findByPage(Map<String, Object> params);
	
	public List<OffReply> findAll();
	
	public OffReply findById(Integer id);
	
	public void save(OffReply offReply);
	
	public void update(OffReply offReply);
	
	public void batchUpdate(List<OffReply> offReplies);
	
	public void deleteById(Integer id);
	
	public List<OffReply> findByPostId(Integer postId);

	
}
