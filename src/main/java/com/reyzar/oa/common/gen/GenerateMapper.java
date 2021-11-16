package com.reyzar.oa.common.gen;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.gen.util.ConvertUtil;
import com.reyzar.oa.common.gen.util.DBManager;
import com.reyzar.oa.common.gen.util.FreemarkerUtil;

@SuppressWarnings("unchecked")
public class GenerateMapper extends GenerateTemplate {

	@Override
	protected void generate(Object... args) {
		String tableName = args[0].toString();
		String className = args[1].toString();
		String sName = className.substring(0,1).toLowerCase() + className.substring(1);
		
		List<Map<String, String>> fieldList = getData(tableName); 
		Map<String, Object> root = new HashMap<String, Object>();
		
		root.put("classPackage", "com.reyzar.oa.dao." + "I"+className+"Dao");
		root.put("fieldList", fieldList);
		root.put("rmId", sName+"Result");
		root.put("rmType", sName);
		root.put("tableName", tableName);
		
		FreemarkerUtil.generateFile("mapper.ftl", root, "resources/mappings/"+args[1].toString()+"Mapper"+".xml");
	}

	@Override
	protected List<Map<String, String>> getData(Object... args) {
		Connection conn = DBManager.getConnection();
		List<Map<String, String>> resList = new ArrayList<Map<String, String>>(); // 字段以及字段类型、描述的Map
		
		try {
			DatabaseMetaData dbMetaData = conn.getMetaData();
			ResultSet dbRs = dbMetaData.getColumns(null, "", args[0].toString(), "");
			
			while (dbRs.next()) {
				Map<String, String> tempMap = new HashMap<String, String>();
				
				// 数据库字段原名称
				String originFieldName = dbRs.getString("COLUMN_NAME").toLowerCase();
				// 转化后的字段名
				String transFieldName = ConvertUtil.underlineToUpper(dbRs.getString("COLUMN_NAME").toLowerCase());
				
				tempMap.put(originFieldName, transFieldName);
				resList.add(tempMap);
			}
			
		
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBManager.closeConnection(conn);
		}
		
		return resList;
	}

}
