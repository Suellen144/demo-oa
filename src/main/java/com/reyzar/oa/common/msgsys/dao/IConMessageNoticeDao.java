package com.reyzar.oa.common.msgsys.dao;

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.msgsys.entity.ConMessageNoticeEntity;

@MyBatisDao
public interface IConMessageNoticeDao {

	// 读取未结束的消息
	public List<ConMessageNoticeEntity> findNotEnd();
	
	public void save(ConMessageNoticeEntity entity);
	
	public void update(ConMessageNoticeEntity entity);
	
	public ConMessageNoticeEntity findByRelId(String relId);
}
