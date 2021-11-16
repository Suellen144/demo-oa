package com.reyzar.oa.service.sys;

import org.springframework.web.multipart.MultipartFile;

import com.reyzar.oa.common.dto.CrudResultDTO;

/** 
* @ClassName: ISysEncryptService 
* @Description: TODO
* @author Lin 
* @date 2017年3月2日 上午9:09:54 
*  
*/
public interface ISysEncryptService {

	public String getEncryptKey();
	
	public CrudResultDTO checkEncryptionKey(MultipartFile file);
	
	public CrudResultDTO updateCryptedData(String oldEncryptionKey, String newEncryptionKey);
}
