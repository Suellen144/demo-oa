package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.RecordExcelDTO;
import com.reyzar.oa.domain.AdRecord;

@MyBatisDao
public interface IAdRecordDao {

	public Integer findByEmail2(String email);
	
	public Page<AdRecord> findByPage(Map<String, Object> params);
	
	public AdRecord findById(int id);

	public AdRecord findByEmail(String email);
	
	public List<AdRecord> findAll();
	
	public AdRecord findOne(Integer userId);
	
	public AdRecord findByUserid(Integer userId);
	
	public List<AdRecord> findByDeptIds(List<Integer> deptIdList);
	
	public List<String> findEmailsByUserIdList(List<Integer> userIdList);

	public void save(AdRecord record);
	
	public void update(AdRecord record);

	public void deleteById(int id);
	
	public Page<AdRecord> showContacts(Map<String, Object> params);

	public AdRecord getByName(String name);

	public List<RecordExcelDTO> getExcelData(Map<String, Object> paramMap);
	
	public Integer findMaxId();

	public List<AdRecord> findByDeptIds2(Map<String, String> param);

}
