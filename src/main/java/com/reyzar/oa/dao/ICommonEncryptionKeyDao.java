package com.reyzar.oa.dao;

import com.reyzar.oa.common.annotation.MyBatisDao;


@MyBatisDao
public interface ICommonEncryptionKeyDao {
	
	public String findOne();
	public void update(String ciphertext);
}