package com.reyzar.oa.service.sys.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Random;

import javax.annotation.PostConstruct;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.collect.Lists;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.service.sys.IEncryptService;
import com.reyzar.oa.service.sys.ISysEncryptService;

@Service
@Transactional
public class SysEncryptServiceImpl implements ISysEncryptService {

	private final static Logger logger = Logger.getLogger(SysEncryptServiceImpl.class);
	
	private static List<String> baseList = Lists.newArrayList();
	private final int KEY_LENGTH = 128; // 生成加密 KEY 的位数
	
	@Autowired
	private List<IEncryptService> encryptServiceList;
	
	// 初始化生成加密 Key 的基数
	@PostConstruct
	public static void initBaseList() {
		char c_a = 'a';
		char c_A = 'A';
		char c_0 = '0';
		
		for(int index=0; index < 26; index++) {
			baseList.add( ((char)(c_a + index)) + "" );
			baseList.add( ((char)(c_A + index)) + "" );
		}
		
		for(int index=0; index < 10; index++) {
			baseList.add( ((char)(c_0 + index)) + "" );
		}
	}
	
	@Override
	public String getEncryptKey() {
		StringBuffer key = new StringBuffer();
		int baseSize = baseList.size();
		Random rd = new Random();
		
		for(int index=0; index < KEY_LENGTH; index++) {
			key.append( baseList.get(rd.nextInt(baseSize)) );
		}
		
		return key.toString();
	}

	@Override
	public CrudResultDTO checkEncryptionKey(MultipartFile file) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "密钥检查通过！");
		try {
			byte[] bytes = file.getBytes();
			String encryptionKey = new String(bytes);
			encryptionKey = encryptionKey.trim();
			
			if( "".equals(encryptionKey) ) {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("更改密钥失败，密钥字符为空，请导入正确的文件！");
			} else if( !ModuleEncryptUtils.validEncryptionKey(encryptionKey) ) {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("更改密钥失败，旧密钥不正确！");
			} else {
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult(encryptionKey);
			}
		} catch (IOException e) {
			logger.error("更改密钥发生异常，异常信息：" + e.getMessage());
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("更改密钥发生异常，请联系管理员！");
		}
		
		return result;
	}

	@Override
	public CrudResultDTO updateCryptedData(String oldEncryptionKey, String newEncryptionKey) {
		CrudResultDTO result = null;
		File encryptionKeyFile = null;
		try {
			// 服务器保存临时密钥文件
			encryptionKeyFile = new File(FileUtil.getProjectPath() + File.separatorChar + "tempKey.txt");
			FileUtil.makeFileByPath(encryptionKeyFile.getAbsolutePath());
			FileOutputStream fos = new FileOutputStream(encryptionKeyFile);
			fos.write(newEncryptionKey.getBytes());
			fos.flush();
			fos.close();
			
			// 更新每个具有加密数据的模块，先用旧密钥解密再用新密钥加密
			for( IEncryptService service : encryptServiceList ) {
				service.updateEncryptedData(oldEncryptionKey, newEncryptionKey);
			}
			
			result = new CrudResultDTO(CrudResultDTO.SUCCESS, encryptionKeyFile.getAbsolutePath());
		} catch(Exception e) {
			if(encryptionKeyFile != null && encryptionKeyFile.exists()) {
				encryptionKeyFile.delete();
			}
			logger.error("新密钥更新加密数据时发生异常，异常信息：" + e.getMessage());
			result = new CrudResultDTO(CrudResultDTO.SUCCESS, "更新加密数据时发生异常，请联系管理员！");
			throw new BusinessException(e);
		}
		
		return result;
	}

}



