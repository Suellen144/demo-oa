package com.reyzar.oa.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdCertificate;

@MyBatisDao
public interface IAdCertificateDao {

	public List<AdCertificate> findByRecordId(Integer recordId);
	
	public void save(AdCertificate adCertificate);
	
	public void insertAll(List<AdCertificate> certificateList);
	
	public void update(AdCertificate adCertificate);
	
	public void batchUpdate(@Param(value="certificateList") List<AdCertificate> certificateList);
	
	public void deleteByIdList(List<Integer> idList);
}
