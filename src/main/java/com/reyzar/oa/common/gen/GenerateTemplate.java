package com.reyzar.oa.common.gen;

/** 
* @ClassName: GenerateTemplate 
* @Description: 生成构件模板
* @author Lin 
* @date 2016年5月24日 下午6:20:28 
*  
*/
public abstract class GenerateTemplate {

	public <T> void build(Object ...args) {
//		T data = (T)getData();
		generate(args);
	}
	
	protected abstract void generate(Object ...args);
	protected abstract <T> T getData(Object ...args);
}
