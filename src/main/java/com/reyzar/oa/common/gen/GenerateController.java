package com.reyzar.oa.common.gen;

import java.util.HashMap;
import java.util.Map;

import com.reyzar.oa.common.gen.util.FreemarkerUtil;

public class GenerateController extends GenerateTemplate {

	@Override
	protected void generate(Object... args) {
		String className = args[0].toString();
		
		Map<String, Object> root = new HashMap<String, Object>();
		root.put("packageName", "com.reyzar.oa.controller");
		root.put("className", className);
		
		FreemarkerUtil.generateFile("controller.ftl", root, "java/com/reyzar/oa/controller/"+className+".java");
	}

	@Override
	protected <T> T getData(Object... args) {
		// TODO Auto-generated method stub
		return null;
	}

}
