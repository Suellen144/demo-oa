package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.OffNotice;

@MyBatisDao
public interface IOffNoticeDao {
	
	public int getNoticeCount(Map<String, Object> params);
	
	public int getUnreadCount(Map<String, Object> params);
	
	Page<OffNotice> findByPage(Map<String, Object> params);
	
	public List<OffNotice> getUnpublishNotice(@Param("actualPublishTime") String actualPublishTime);
	
	public void save(OffNotice notice);
	
	public void update(OffNotice notice);
	
	public void batchUpdateIsPublished(@Param("noticeList") List<OffNotice> noticeList);

	public OffNotice findById(Integer id);
	
	public void deleteById(Integer id);

	public Page<OffNotice> findPointByPage(Map<String, Object> params);
	
	public List<OffNotice> getTop5Notice(Map<String, Object> params);
	
}
