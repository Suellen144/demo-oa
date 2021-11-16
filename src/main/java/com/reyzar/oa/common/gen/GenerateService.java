package com.reyzar.oa.common.gen;

import java.util.HashMap;
import java.util.Map;

import com.reyzar.oa.common.gen.util.FreemarkerUtil;

public class GenerateService extends GenerateTemplate {

	@Override
	protected void generate(Object... args) {
		// 生成接口
		String className = args[0].toString();
		boolean isStandard = Boolean.parseBoolean(args[1].toString()); // 是否标准命名接口，首字母有I即为标准  
		
		Map<String, Object> root = new HashMap<String, Object>();
		root.put("packageName", "com.reyzar.oa.service");
		root.put("className", className);
		
		FreemarkerUtil.generateFile("service.ftl", root, "java/com/reyzar/oa/service/"+className+".java");
		
		// 生成接口实现
		if(isStandard) {
			className = className.substring(1);
		}
		className += "Impl";
		
		root.clear();
		root.put("packageName", "com.reyzar.oa.service.impl");
		root.put("className", className);
		root.put("interface", "com.reyzar.oa.service." + args[0].toString());
		root.put("interfaceName", args[0].toString());
		
		FreemarkerUtil.generateFile("serviceImpl.ftl", root, "java/com/reyzar/oa/service/"+className+".java");
	}

	@Override
	protected <T> T getData(Object... args) {
		// TODO Auto-generated method stub
		return null;
	}

}
