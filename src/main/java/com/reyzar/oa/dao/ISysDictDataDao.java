package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.domain.SysDictData;
import org.apache.ibatis.annotations.Param;

@MyBatisDao
public interface ISysDictDataDao {
	
	public List<SysDictData> findAll();
	 
	public Page<SysDictData> findByPage(Map<String, Object> params);
	
	public SysDictData findById(Integer id);
	
	public void save(SysDictData dictData);
	
	public void update(SysDictData dictData);
	
	public void delete(Integer id);
	
	public void deleteByTypeId(Integer typeid);

	public SysDictData findByTypeId(Integer typeID);

	public SysDictData  findByTypeIdAndValue(SysDictData dictData);

	public SysDictData findByValueAndTypeidNotDelet(@Param("value")Integer value, @Param("typeId")Integer typeId);

	public List<SysDictData> findByValueAndTypeidNotDeletList(@Param("generalId")List<String> generalId,@Param("typeId")Integer typeId);

}