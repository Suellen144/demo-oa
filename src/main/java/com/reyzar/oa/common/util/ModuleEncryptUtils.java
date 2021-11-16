package com.reyzar.oa.common.util;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.dao.ICommonEncryptionKeyDao;

/** 
* @ClassName: ModuleEncryptUtils 
* @Description: 各个模块加密工具类
* @author Lin 
* @date 2017年2月28日 下午5:33:31 
*  
*/
public class ModuleEncryptUtils {

	public final static String ENCRYPT_ORIGINAL_TEXT = "reyzar"; // 以此原文来进行加密，保存到common_encryption_key表
	
	private static ICommonEncryptionKeyDao encryptionKeyDao = SpringContextUtils.getBean(ICommonEncryptionKeyDao.class);
	
	/**
	* @Title: validEncryptionKey
	* @Description: 验证密钥是否有效密钥
	* @param encryptionKey 密钥
	* @return boolean
	* 			true: 有效
	* 			false: 无效
	 */
	public static boolean validEncryptionKey(String encryptionKey) {
		boolean validation = false;
		
		if( encryptionKey != null && !"".equals(encryptionKey.trim()) ) {
			String ciphertext = encryptionKeyDao.findOne();
			String ciphertext2 = AesUtils.encryptECB(ModuleEncryptUtils.ENCRYPT_ORIGINAL_TEXT, encryptionKey);
			
			if( ciphertext.equals(ciphertext2) ) {
				validation = true;
			}
		}
		
		return validation;
	}
	
	public static void setEncryptionKeyToSession(String encryptionKey) {
		if( encryptionKey != null && !"".equals(encryptionKey.trim()) ) {
			Subject subject = SecurityUtils.getSubject();
			subject.getSession(true).setAttribute("encryptionKey", encryptionKey.trim());
		}
	}
	
	public static String getEncryptionKeyFromSession() {
		Subject subject = SecurityUtils.getSubject();
		Object temp = subject.getSession(true).getAttribute("encryptionKey");
		String encryptionKey = temp != null ? temp.toString() : null;
		
		return encryptionKey;
	}
	
	public static String encryptText(String originalText, String encryptionKey) {
		String ciphertext = null;
		try {
			ciphertext = AesUtils.encryptECB(originalText, encryptionKey);
		} catch(Exception e) {}
		
		return ciphertext;
	}
	
	public static String decryptText(String ciphertext, String encryptionKey) {
		String originalText = null;
		try {
			originalText = AesUtils.decryptECB(ciphertext, encryptionKey);
		} catch(Exception e) {}
		
		return originalText;
	}
	
	public static void updateCipertextToDatabase(String ciphertext) {
		encryptionKeyDao.update(ciphertext);
	}
	
	public static String getCipertextFromDatabase() {
		return encryptionKeyDao.findOne();
	}
	
}
