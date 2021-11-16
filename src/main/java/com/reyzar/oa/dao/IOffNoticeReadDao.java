package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;

import com.reyzar.oa.domain.OffNoticeRead;


@MyBatisDao
public interface IOffNoticeReadDao {
	
	public List<OffNoticeRead> findAll();
	
	public OffNoticeRead findById(Integer id);
	
	public List<Map<String, Object>> getReadNotice(@Param(value="params") Map<String, Object> params);
	
	public int getCountByUserIdWithNoticeId(@Param(value="userId") Integer userId, @Param(value="noticeId") Integer noticeId);
	
	public void save(OffNoticeRead offNoticeRead);
	
	public void update(OffNoticeRead offNoticeRead);
	
	public void deleteById(Integer id);
}