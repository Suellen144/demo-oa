package com.reyzar.oa.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.OffInReply;

@MyBatisDao
public interface IOffInReplyDao {

	public List<OffInReply> findAll();
	
	public OffInReply findById(Integer id);
	
	public void save(OffInReply offInReply);
	
	public void update(OffInReply offInReply);
	
	public void deleteById(Integer id);

	public List<OffInReply> findByInReplyId(Integer id);

	public void insertAll(List<OffInReply> inReplys);

	public void batchUpdate(List<OffInReply> updateList);

	public void deleteByIdList(List<Integer> delList);
	
}
