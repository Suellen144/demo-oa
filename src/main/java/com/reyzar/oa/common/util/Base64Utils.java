package com.reyzar.oa.common.util;

import org.apache.commons.codec.binary.Base64;

/** 
* @ClassName: Base64Utils 
* @Description: Base64加解密（必须要commons-codec.jar）
* @author Lin 
* @date 2016年6月17日 下午5:06:19 
*  
*/
public class Base64Utils {

	/** 
     * @param bytes 
     * @return 
     */  
    public static byte[] decode(final byte[] bytes) {  
        return Base64.decodeBase64(bytes);  
    }  
  
    /** 
     * 二进制数据编码为BASE64字符串 
     * 
     * @param bytes 
     * @return 
     * @throws Exception 
     */  
    public static String encode(final byte[] bytes) {  
        return new String(Base64.encodeBase64(bytes));  
    }  
}
