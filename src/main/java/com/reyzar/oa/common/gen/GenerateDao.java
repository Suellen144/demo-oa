package com.reyzar.oa.common.gen;

import java.util.HashMap;
import java.util.Map;

import com.alibaba.druid.sql.visitor.functions.Char;
import com.reyzar.oa.common.gen.util.FreemarkerUtil;

public class GenerateDao extends GenerateTemplate {

	@Override
	protected void generate(Object... args) {
		String className = args[0].toString();
		String entityName = new String(className);
		String entity = "";
		if(entityName.startsWith("I")) {
			entityName = entityName.substring(1);
		}
		if(entityName.endsWith("Dao")) {
			entityName = entityName.substring(0, entityName.lastIndexOf("Dao"));
		}
		String first = entityName.substring(0, 1).toLowerCase();
		entity = first + entityName.substring(1);
	
		
		Map<String, Object> root = new HashMap<String, Object>();
		root.put("packageName", "com.reyzar.oa.dao");
		root.put("entityPackageName", "com.reyzar.oa.domain."+entityName);
		root.put("className", className);
		root.put("entityName", entityName);
		root.put("entity", entity);
		
		FreemarkerUtil.generateFile("dao.ftl", root, "java/com/reyzar/oa/dao/"+className+".java");
	}

	@Override
	protected <T> T getData(Object... args) {
		// TODO Auto-generated method stub
		return null;
	}

	
}
