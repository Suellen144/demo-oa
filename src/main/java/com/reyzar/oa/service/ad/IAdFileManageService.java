package com.reyzar.oa.service.ad;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdDirectoryManage;
import com.reyzar.oa.domain.AdFileManage;

public interface IAdFileManageService {
	
	public Page<AdFileManage> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public AdFileManage findById(Integer id);
	
	public List<Map<String, Object>> getDirWithFileInList(Integer deptId,Page<AdFileManage> page,String root);
	
	public CrudResultDTO save(AdFileManage fileManage);
	
	public CrudResultDTO dirSaveOrUpdate(AdDirectoryManage directoryManage);
	
	public CrudResultDTO fileSaveOrUpdate(AdFileManage fileManage);
	
	public CrudResultDTO dirDelete(Integer id);
	
	public CrudResultDTO fileDelete(Integer id);
	
	public CrudResultDTO checkDir(Integer id);
	
	public CrudResultDTO delete(Integer id, String filePath);
	
	public CrudResultDTO exists(Integer parentId, Integer id, String dirName, int type);

	public CrudResultDTO ajaxDepts(String parentDepts, String currDepts);
	
	public CrudResultDTO ajaxCurrDept(String deptIds);
	
	public AdFileManage existsAdFileManage(Integer parentId, Integer id, String fileName);
	
	public Page<AdFileManage> findAll(Map<String, Object> params);
}