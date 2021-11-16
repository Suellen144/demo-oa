package com.reyzar.oa.common.gen;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.google.common.collect.Sets;
import com.reyzar.oa.common.gen.util.ConvertUtil;
import com.reyzar.oa.common.gen.util.DBManager;
import com.reyzar.oa.common.gen.util.FreemarkerUtil;

@SuppressWarnings("unchecked")
public class GenerateEntity extends GenerateTemplate {

	/**
	 * @param args
	 * 	param1 tableName 表名
	 *  param2 className 类名
	 * */
	@Override
	protected void generate(Object... args) {
		String tableName = args[0].toString();
		String className = args[1].toString();
		
		Map<String, Object> map = getData(tableName);
		Map<String, Object> root = new HashMap<String, Object>();
		root.put("packageName", "com.reyzar.oa.domain");
		root.put("className", className);
		root.put("dataMap", map);
		
		FreemarkerUtil.generateFile("entity.ftl", root, "java/com/reyzar/oa/domain/"+className+".java");
	}
	
	
	@Override
	protected Map<String, Object> getData(Object... args) {
		Connection conn = DBManager.getConnection();
		Map<String, Object> resMap = new HashMap<String, Object>(); // 结果Map
		List<Map<String, Object>> fieldList = new ArrayList<Map<String, Object>>(); // 字段以及字段类型、描述的Map
		Set<String> fullTypeSet = new HashSet<String>(); // 字段全限定类型
		
		try {
			DatabaseMetaData dbMetaData = conn.getMetaData();
			ResultSet dbRs = dbMetaData.getColumns(null, "", args[0].toString(), "");
			while (dbRs.next()) {
				if(excSet.contains(dbRs.getString("COLUMN_NAME").toUpperCase())) { // 忽略的字段
					continue ;
				}
				
				Map<String, Object> map = new HashMap<String, Object>();
				// 获取相关数据
				String fieldName = ConvertUtil.underlineToUpper(dbRs.getString("COLUMN_NAME").toLowerCase());
				Map<String, String> fieldType = ConvertUtil.getActualType(dbRs.getString("TYPE_NAME"));
				String remarks = dbRs.getString("REMARKS");
				
				map.put("fieldName", fieldName);
				Map<String, String> tempMap = new HashMap<String, String>();
				tempMap.put("remarks", remarks);
				tempMap.put("fieldType", fieldType.keySet().iterator().next());
				map.put("fieldMeta", tempMap);
				
				fullTypeSet.addAll(fieldType.values());
				fieldList.add(map);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBManager.closeConnection(conn);
		}
		
		resMap.put("fieldList", fieldList);
		resMap.put("fullTypeSet", fullTypeSet);

		return resMap;
	}

	// 排除的字段，不会生成到实体类
	private static Set<String> excSet = Sets.newHashSet();
	static {
		excSet.add("CREATE_BY");
		excSet.add("CREATE_DATE");
		excSet.add("UPDATE_BY");
		excSet.add("UPDATE_DATE");
		excSet.add("REMARK");
		excSet.add("IS_DELETED");
	}
}
