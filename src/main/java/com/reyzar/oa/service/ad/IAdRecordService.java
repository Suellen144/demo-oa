package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.SysUser;

public interface IAdRecordService {

	public Integer findByEmail2(String email);
	
	public Page<AdRecord> findByPage(Map<String, Object> params, int pageNum, int pageSize,SysUser user);
 	
	public AdRecord findById(int id);

	public AdRecord findByEmail(String email);
	
	public AdRecord findOne(Integer userId);
	
	public AdRecord findByUserid(Integer userId);
	
	public List<AdRecord> findByDeptIds(List<Integer> deptList);
	
	public CrudResultDTO save(AdRecord record,SysUser user);
	
	public CrudResultDTO saveForUser(AdRecord record);
	
	public CrudResultDTO delete(int id);

	Page<AdRecord> showContacts(Map<String, Object> params, int pageNum,
			int pageSize);

	public AdRecord getByName(String name);

	public void exportExcel(ServletOutputStream outputStream, Map<String, Object> paramMap);

	public Integer findMaxId();

	public List<AdRecord> findByDeptIds2(Map<String, String> param);

}
