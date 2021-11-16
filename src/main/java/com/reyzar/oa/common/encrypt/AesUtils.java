package com.reyzar.oa.common.encrypt;

import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;

import com.reyzar.oa.common.exception.BusinessException;

/**
 * @ClassName: AesUtils
 * @Description: AES算法工具
 * @author Lin
 * @date 2016年11月25日 上午11:18:53
 * 
 */
public class AesUtils {
	
	private final static Logger logger = Logger.getLogger(AesUtils.class);
	private static Base64 base64 = new Base64();
	
	private static String aesIv = "123456789abcdefg"; // 向量
	
	// 以后可能开放 AES 模式，现在是 private
	private final static String CIPHER_ALGORITHM_CBC = "AES/CBC/PKCS5Padding"; // CBC
	private final static String CIPHER_ALGORITHM_ECB = "AES/ECB/PKCS5Padding"; // ECB

	/*public static void main(String[] args) throws Exception {
		String content = "42000";
		String key = MD5Utils.get32Code("reyzar_oa");
		
		String encryptContent = AesUtils.encryptCBC(content, key, MD5Utils.get16Code(key));
		String decryptContent = AesUtils.decryptCBC(encryptContent, key, MD5Utils.get16Code(key));

		System.out.println("加密Key：" + key);
//		System.out.println("二次加密Key：" + MD5Utils.get32Code(key));
//		System.out.println("16位向量：" + MD5Utils.get16Code(key));
		System.out.println("加密前的内容：" + content);
		System.out.println("加密后的内容：" + encryptContent);
		System.out.println("解密后的内容：" + decryptContent);
		
	}*/

	/**
	* @Title: encryptCBC
	* @Description: 加密 (CBC模式)
	* @param content
	* @param key
	* @param iv 向量
	* @return String
	* @throws
	 */
	public static String encryptCBC(String content, String key, String iv) {
		try {
			String aesIv = AesUtils.aesIv;
			// 构建IV
			if(iv != null && !"".equals(iv.trim()) && iv.length() == 16) {
				aesIv = iv;
			}
	        
	        // 初始化密码器
			Cipher cipher = Cipher.getInstance(AesUtils.CIPHER_ALGORITHM_CBC);
			cipher.init(Cipher.ENCRYPT_MODE, genKey(key), new IvParameterSpec(aesIv.getBytes()));
			
			// 加密
			byte[] byteContent = content.getBytes("UTF-8");
			byte[] encryptData = cipher.doFinal(byteContent);

			return base64.encodeToString(encryptData);
		} catch (Exception e) {
			logger.info("加密失败！失败信息：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
	}

	/**
	* @Title: decryptCBC
	* @Description: 解密 (CBC模式)
	* @param content
	* @param key
	* @param iv 向量
	* @return String
	* @throws
	 */
	public static String decryptCBC(String content, String key, String iv) {
		try {
			String aesIv = AesUtils.aesIv;
			// 构建IV
			if(iv != null && !"".equals(iv.trim()) && iv.length() == 16) {
				aesIv = iv;
			}
			
	        // 初始化密码器
			Cipher cipher = Cipher.getInstance(AesUtils.CIPHER_ALGORITHM_CBC);
			cipher.init(Cipher.DECRYPT_MODE, genKey(key), new IvParameterSpec(aesIv.getBytes()));
			
			// 解密
			byte[] base64DataOfContent = base64.decode(content.getBytes());
			byte[] decryptData = cipher.doFinal(base64DataOfContent);

			return new String(decryptData, "UTF-8");
		} catch (Exception e) {
			logger.info("解密失败！失败信息：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
	}

	private static SecretKeySpec genKey(String key) {
		byte[] enCodeFormat = { 0 };
		try {
			KeyGenerator kgen = KeyGenerator.getInstance("AES");
			SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG");
			secureRandom.setSeed(key.getBytes("UTF-8"));
			kgen.init(128, secureRandom);
			SecretKey secretKey = kgen.generateKey();
			enCodeFormat = secretKey.getEncoded();
		} catch (Exception e) {
			logger.info("生成密码Key失败！失败信息：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}

		return new SecretKeySpec(enCodeFormat, "AES");
	}
	
	
	/**
	* @Title: encryptECB
	* @Description: 加密 (ECB模式)
	* @param content
	* @param key
	* @return String
	* @throws
	 */
	public static String encryptECB(String content, String key) {
		try {
			if(key == null || "".equals(key.trim())) {
				throw new BusinessException("加密Key不能为空！");
			}
			key = MD5Utils.get16Code(key);
	        
	        // 初始化密码器
			byte[] raw = key.getBytes("utf-8");
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
			Cipher cipher = Cipher.getInstance(AesUtils.CIPHER_ALGORITHM_ECB);
			cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
			
			// 加密
			byte[] byteContent = content.getBytes("UTF-8");
			byte[] encryptData = cipher.doFinal(byteContent);

			return base64.encodeToString(encryptData);
		} catch (Exception e) {
			logger.info("加密失败！失败信息：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
	}
	
	/**
	* @Title: decryptECB
	* @Description: 解密 (ECB模式)
	* @param content
	* @param key
	* @param iv 向量
	* @return String
	* @throws
	 */
	public static String decryptECB(String content, String key) {
		try {
			if(key == null || "".equals(key.trim())) {
				throw new BusinessException("解密Key不能为空！");
			}
			key = MD5Utils.get16Code(key);
			
	        // 初始化密码器
			byte[] raw = key.getBytes("utf-8");
            SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
			Cipher cipher = Cipher.getInstance(AesUtils.CIPHER_ALGORITHM_ECB);
			cipher.init(Cipher.DECRYPT_MODE, skeySpec);
			
			// 解密
			byte[] base64DataOfContent = base64.decode(content.getBytes());
			byte[] decryptData = cipher.doFinal(base64DataOfContent);

			return new String(decryptData, "UTF-8");
		} catch (Exception e) {
			logger.info("解密失败！失败信息：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
	}
}
