package com.reyzar.oa.common.freemarker;

import java.io.IOException;

import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.jagregory.shiro.freemarker.ShiroTags;

import freemarker.template.TemplateException;

/** 
* @ClassName: ShiroTagFreeMarkerConfigurer 
* @Description: Freemarker扩展类，使Freemarker能使用Shiro标签
* @author Lin 
* @date 2016年5月20日 下午6:01:24 
*  
*/
public class ShiroTagFreeMarkerConfigurer extends FreeMarkerConfigurer {
	@Override  
    public void afterPropertiesSet() throws IOException, TemplateException {  
        super.afterPropertiesSet();  
        this.getConfiguration().setSharedVariable("shiro", new ShiroTags());  
    }
}
