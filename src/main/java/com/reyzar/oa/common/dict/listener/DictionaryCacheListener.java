package com.reyzar.oa.common.dict.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.apache.log4j.Logger;

import com.reyzar.oa.common.dict.cache.DictionaryCache;

/** 
* @ClassName: DictionaryCacheListener 
* @Description: 数据字典缓存监听器
* @author Lin 
* @date 2016年11月1日 下午3:28:15 
*  
*/
@WebListener
public class DictionaryCacheListener implements ServletContextListener {
	
	private Logger logger = Logger.getLogger(DictionaryCacheListener.class);

    public DictionaryCacheListener() {
        // TODO Auto-generated constructor stub
    }

    public void contextDestroyed(ServletContextEvent sce)  { 
         // TODO Auto-generated method stub
    }

    public void contextInitialized(ServletContextEvent sce)  { 
    	logger.info("初始化数据字典缓存.............");
    	DictionaryCache.initCache();
    }
	
}
