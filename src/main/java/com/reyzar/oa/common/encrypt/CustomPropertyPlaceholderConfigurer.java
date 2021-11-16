package com.reyzar.oa.common.encrypt;

import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;

/** 
* @ClassName: DecryptProperties 
* @Description: 属性文件解密
* @author Lin 
* @date 2016年11月25日 下午3:51:53 
*  
*/
public class CustomPropertyPlaceholderConfigurer extends PropertyPlaceholderConfigurer {

	private final static String KEY = "reyzar_oa";
	
	@Override
	protected void processProperties(ConfigurableListableBeanFactory beanFactory, Properties props) {
		Pattern patter = Pattern.compile("^encrypt\\[(.*)\\]$");
		String key = MD5Utils.get32Code(KEY);
		String iv = MD5Utils.get16Code(key);
		
		Set<Entry<Object, Object>> entrySet = props.entrySet();
		for(Entry<Object, Object> entry : entrySet) {
			String value = entry.getValue().toString();
			Matcher matcher = patter.matcher(value);
			
			if(matcher.matches()) {
				entry.setValue(AesUtils.decryptCBC(matcher.group(1), key, iv));
			}
		}
		
		super.processProperties(beanFactory, props);
	}
}
