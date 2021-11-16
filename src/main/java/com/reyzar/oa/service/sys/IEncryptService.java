package com.reyzar.oa.service.sys;

import java.util.List;

import org.apache.poi.ss.formula.functions.T;

/** 
* @ClassName: IEncryptService 
* @Description: 该接口提供更新表加密数据的功能，凡是有加密需求功能模块的Service都必须实现此接口！
* @author Lin 
* @date 2017年3月1日 下午3:36:41 
*  
*/
public interface IEncryptService {

	/**
	* @Title: updateEncryptedData
	* @Description: 更新加密数据，用旧密钥解密后再用新密钥进行加密
	  @param oldEncryptionKey 旧密钥
	  @param newEncryptionKey 新密钥
	* @return void
	 */
	public void updateEncryptedData(String oldEncryptionKey, String newEncryptionKey);
	
	/**
	* @Title: decryptData
	* @Description: 使用旧密钥还原数据
	* @param list 已加密的数据列表
	*  @param oldEncryptionKey 旧密钥
	* @return void
	*/
	@SuppressWarnings("hiding")
	public <T> void decryptData(List<T> list, String oldEncryptionKey);
	
	/***
	* @Title: encryptData
	* @Description: 使用新密钥加密数据
	* @param list 已还原过的原始数据
	* @param newEncryptionKey 新密钥
	* @return void
	 */
	@SuppressWarnings("hiding")
	public <T> void encryptData(List<T> list, String newEncryptionKey);
}
