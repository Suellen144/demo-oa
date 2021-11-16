package com.reyzar.oa.common.encrypt;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.apache.log4j.Logger;

/**
 * @ClassName: MD5Util
 * @Description: MD5加密工具类
 * @author Lin
 * @date 2016年5月5日 上午9:15:56
 * 
 */
public final class MD5Utils {
	
	private static Logger logger = Logger.getLogger(MD5Utils.class);
	
	/**
	 * 获取32位MD5代码
	 * */
	public static String get32Code(String text) {
		StringBuffer buf = new StringBuffer("");
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(text.getBytes());
			byte bytes[] = md.digest();

			int base;
			for (int offset = 0; offset < bytes.length; offset++) {
				base = bytes[offset];
				if (base < 0)
					base += 256;
				if (base < 16)
					buf.append("0");
				buf.append(Integer.toHexString(base));
			}
		} catch (NoSuchAlgorithmException e) {
			logger.info("MD5加密失败");
		}
		
		return buf.toString(); //32位的加密
	}

	/**
	 * 获取16位MD5代码
	 * */
	public static String get16Code(String text) {
		return get32Code(text).substring(8, 24); //16位的加密;
	}
	
}
