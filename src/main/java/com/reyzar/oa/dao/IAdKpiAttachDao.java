package com.reyzar.oa.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AdKpi;
import com.reyzar.oa.domain.AdKpiAttach;


@MyBatisDao
public interface IAdKpiAttachDao {

	public List<AdKpiAttach> findAllByDpetIdAndDate2(Map<String,Object> parms);
	
	public List<AdKpiAttach> findAllByDpetIdAndDate(@Param("deptId") Integer deptId,@Param("date")Date date);
	
	public Page<AdKpiAttach> findByPage(Map<String, Object> params);
	
	public List<AdKpiAttach> findByKpiId(Integer KpiId);
	
	public AdKpiAttach findById(Integer id);
	
	public void deleteById(Integer id);
	
	public void save(AdKpiAttach adKpiAttach);
	
	public void insertAll(List<AdKpiAttach> kpiAttachs);
	
	public void update(AdKpiAttach adKpiAttach);
	
	public void batchUpdate(@Param(value="kpiAttachList") List<AdKpiAttach> kpiAttachs);

	public void batchUpdate2(@Param(value="kpiAttachList") List<AdKpiAttach> kpiAttachs);
	
	public void OtherUpdate(@Param(value="kpiAttachs") List<AdKpiAttach> kpiAttachs);
	
	public void deleteByIdList(List<Integer> delList);
	
	public void deleteByDeptIdList(List<Integer> delList);
	
	public List<AdKpiAttach> findByUserIdAndTime(@Param("userId")Integer userId, @Param("startTime")String startTime, @Param("endTime")String endTime);
	
}