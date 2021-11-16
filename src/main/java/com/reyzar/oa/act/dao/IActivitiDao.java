package com.reyzar.oa.act.dao;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;

/** 
* @ClassName: IActivitiDao 
* @Description: TODO
* @author Lin 
* @date 2016年9月22日 下午3:36:58 
*  
*/
@MyBatisDao
public interface IActivitiDao {

	public List<Map<String, Object>> findOne(@Param("tableName") String tableName, @Param("id") Integer id);
	
	public List<Map<String, Object>> findByColumn(@Param("tableName") String tableName, @Param("columnsMap") Map<String, Object> columnsMap);
	
	public List<Map<String, Object>> findInAssignColumn(@Param("tableName") String tableName, @Param("column") String column, @Param("dataList") Collection<Object> dataList);
}
