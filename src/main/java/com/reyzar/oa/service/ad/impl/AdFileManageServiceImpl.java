package com.reyzar.oa.service.ad.impl;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdDirectoryManageDao;
import com.reyzar.oa.dao.IAdFileManageDao;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.domain.AdDirectoryManage;
import com.reyzar.oa.domain.AdFileManage;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdFileManageService;

@Service
@Transactional
public class AdFileManageServiceImpl implements IAdFileManageService {
	
	@Autowired
	private IAdFileManageDao fileManageDao;
	@Autowired
	private IAdDirectoryManageDao directoryManageDao;
	
	@Autowired
	private ISysDeptDao sysDeptDao;

	@Override
	public Page<AdFileManage> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<AdFileManage> page = fileManageDao.findByPage(params);
		
		return page;
	}
	
	@Override
	public Page<AdFileManage> findAll(Map<String, Object> params) {
		Page<AdFileManage> page = fileManageDao.findByPage(params);
		return page;
	}

	@Override
	public AdFileManage findById(Integer id) {
		return fileManageDao.findById(id);
	}

	@Override
	public CrudResultDTO save(AdFileManage fileManage) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		
		try {
			if(fileManage.getId() == null) {
				fileManage.setCreateBy(UserUtils.getCurrUser().getAccount());
				fileManage.setCreateDate(new Date());
				
				fileManageDao.save(fileManage);
			} else {
				fileManage.setUpdateBy(UserUtils.getCurrUser().getAccount());
				fileManage.setUpdateDate(new Date());
				
				AdFileManage old = findById(fileManage.getId());
				BeanUtils.copyProperties(fileManage, old);
				
				fileManageDao.update(old);;
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id, String filePath) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		fileManageDao.deleteById(id);
		try {
			FileUtil.forceDelete(filePath);
		} catch (IOException e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败，错误信息：" + e.getMessage());
			throw new RuntimeException(e.getMessage());
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> getDirWithFileInList(Integer deptId,Page<AdFileManage> page,String root) {
		Map<String, Integer> deptIds=Maps.newHashMap();
		deptIds.put("deptId",deptId);
		List<AdDirectoryManage> dirList = directoryManageDao.findByDeptId(deptIds);
		List<AdFileManage> fileList = Lists.newArrayList();
		for (AdFileManage fileManage: page) {
			fileList.add(fileManage);
		}
		List<Map<String, Object>> result = Lists.newArrayList();
		if(dirList != null) {
			for(AdDirectoryManage dir : dirList) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", "dir_" + dir.getId());
				map.put("parentId", "dir_" + dir.getParentId());
				map.put("parentsId", dir.getParentsId());
				map.put("deptIds", dir.getDeptIds());
				map.put("name", dir.getName());
				map.put("comment", dir.getComment());
				map.put("icon", root+"/static/images/dir.png");
				if(dir.getId() == 1) {
					map.put("isRoot", true);
				} else {
					map.put("isDir", true);
				}
				
				result.add(map);
			}
		}
		if(fileList != null) {
			for(AdFileManage file : fileList) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", "file_" + file.getId());
				map.put("parentId", "dir_" + file.getDirectoryId());
				map.put("filePath", file.getFilePath());
				map.put("name", file.getOriginName());
				map.put("fileName", file.getName());
				map.put("originName", file.getOriginName());
				map.put("type", file.getType());
				map.put("comment", file.getComment());
				map.put("isFile", true);
				map.put("icon", root+"/static/images/file.png");
				
				result.add(map);
			}
		}
		
		return result;
	}

	@Override
	public CrudResultDTO exists(Integer parentId, Integer id, String name, int type) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, false);
		int count = 0;
		if(type == 0) {
			count = directoryManageDao.dirExists(parentId, name);
		} else {
			count = fileManageDao.fileExists(parentId, id, name);
		}
		if(count > 0) {
			result.setResult(true);
		}
		return result;
	}

	@Override
	public CrudResultDTO dirSaveOrUpdate(AdDirectoryManage directoryManage) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		SysUser user = UserUtils.getCurrUser();
		
		AdDirectoryManage dir = null;
		if(directoryManage.getId() == null) {
			directoryManage.setCreateBy(user.getAccount());
			directoryManage.setCreateDate(new Date());
			directoryManage.setIsDeleted("n");
			
			directoryManageDao.save(directoryManage);
			dir = directoryManage;
		} else {
			directoryManage.setUpdateBy(user.getAccount());
			directoryManage.setUpdateDate(new Date());
			AdDirectoryManage old = directoryManageDao.findById(directoryManage.getId());
			BeanUtils.copyProperties(directoryManage, old);
			
			directoryManageDao.update(old);
			directoryManageDao.updateByParentId(old);
			dir = directoryManageDao.findById(directoryManage.getId());
		}
		
		result.setResult(dir);
		return result;
	}
	
	@Override
	public CrudResultDTO fileSaveOrUpdate(AdFileManage fileManage) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		SysUser user = UserUtils.getCurrUser();
		
		AdFileManage file = null;
		if(fileManage.getId() == null) {
			fileManage.setCreateBy(user.getAccount());
			fileManage.setCreateDate(new Date());
			fileManage.setIsDeleted("n");
			
			fileManageDao.save(fileManage);
			file = fileManage;
		} else {
			fileManage.setUpdateBy(user.getAccount());
			fileManage.setUpdateDate(new Date());
			AdFileManage old = fileManageDao.findById(fileManage.getId());
			BeanUtils.copyProperties(fileManage, old);
			
			fileManageDao.update(old);
			file = old;
		}
		
		result.setResult(file);
		return result;
	}

	@Override
	public CrudResultDTO dirDelete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		if(id != null) {
			AdDirectoryManage dir = directoryManageDao.findById(id);
			dir.setIsDeleted("y");
			dir.setUpdateBy(UserUtils.getCurrUser().getAccount());
			dir.setUpdateDate(new Date());
			
			directoryManageDao.update(dir);
			directoryManageDao.deleteDirByParentId(id);
			fileManageDao.deleteFileByDirectoryId(id);
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("没有ID为 " + id + " 的对象！");
		}
		
		return result;
	}

	@Override
	public CrudResultDTO fileDelete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		if(id != null) {
			AdFileManage file = fileManageDao.findById(id);
			file.setIsDeleted("y");
			file.setUpdateBy(UserUtils.getCurrUser().getAccount());
			file.setUpdateDate(new Date());
			
			fileManageDao.update(file);
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("没有ID为 " + id + " 的对象！");
		}
		
		return result;
	}

	@Override
	public CrudResultDTO ajaxDepts(String parentDepts, String currDepts) {
		
		CrudResultDTO result = new CrudResultDTO();
		
		try {
			List<SysDept> parent_deptList = sysDeptDao.findByIds(StringParseInteger(parentDepts));

			List<String> parent_company_nodeList = new ArrayList<>();
			List<String> parent_dept_nodeList = new ArrayList<>();
			
			//分别存储父级公司和部门的节点信息
			for (SysDept sysDept : parent_deptList) {
				if(sysDept.getNodeLinks().length() == 3){
					parent_company_nodeList.add(sysDept.getNodeLinks());
				}else{
					parent_dept_nodeList.add(sysDept.getNodeLinks());
				}
			}
			
			List<SysDept> curr_deptList = sysDeptDao.findByIds(StringParseInteger(currDepts));
			List<String> curr_nodeList = new ArrayList<>();
			for (SysDept sysDept : curr_deptList) {
				curr_nodeList.add(sysDept.getNodeLinks());
			}

			if(parent_company_nodeList != null && !parent_company_nodeList.equals("") && parent_company_nodeList.size()>0){
				for (String parent_company_node : parent_company_nodeList) {
					if(curr_nodeList != null && !curr_nodeList.equals("") && curr_nodeList.size()>0){
						for(int i = 0 ; i < curr_nodeList.size() ; i++){
							
							//查看是否属于上级公司的下级，是就移除
							if(curr_nodeList.get(i).indexOf(parent_company_node) > 0){
								curr_nodeList.remove(i);
							}else {
								//查看是否是上级部门的下级
								if (parent_dept_nodeList != null && !parent_dept_nodeList.equals("") && parent_dept_nodeList.size()>0) {
									for (String parent_dept_node : parent_dept_nodeList) {
										if (curr_nodeList.get(i).indexOf(parent_dept_node) > 0) {
											curr_nodeList.remove(i);
										}
									}
								}
							}
						}
					}
				}	
			}else {
				if (parent_dept_nodeList != null && !parent_dept_nodeList.equals("") && parent_dept_nodeList.size()>0) {
					for (String parent_dept_node : parent_dept_nodeList) {
						for (int i = 0; i < curr_nodeList.size(); i++) {
							if (curr_nodeList.get(i).indexOf(parent_dept_node) > -1) {
								System.out.println("curr_nodeList.get(i).indexOf(parent_dept_node):"+curr_nodeList.get(i).indexOf(parent_dept_node));
								curr_nodeList.remove(i);
							}
						}
					}
				}
			}
			
			result = new CrudResultDTO(CrudResultDTO.SUCCESS,curr_nodeList);
		} catch (Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}
	
	public List<Integer> StringParseInteger(String deptIds){
		String[] ids =  deptIds.split(",");
		
		List<Integer> idList = new ArrayList<>();
		for (String id : ids) {
			idList.add(Integer.valueOf(id));
		}

		return idList;
	}

	@Override
	public CrudResultDTO ajaxCurrDept(String deptIds) {
		CrudResultDTO result = new CrudResultDTO();
		
		try {
			int id = Integer.parseInt(deptIds);
			SysDept dept =  sysDeptDao.findById(id);
			
			List<Integer>   idList  =  StringParseInteger(dept.getNodeLinks());
			
			if (idList.size() == 4) {
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult(dept.getId());
			}else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("上级部门不是第三级部门");
			}
			
		} catch (Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public AdFileManage existsAdFileManage(Integer parentId, Integer id, String dirName) {
		return fileManageDao.existsAdFileManage(parentId, id, dirName);
	}

	//判断给目录是否是二级目录及其下面是否包含子级目录
	@Override
	public CrudResultDTO checkDir(Integer id) {
		CrudResultDTO crudResultDTO=new CrudResultDTO();
		crudResultDTO.setCode(1);
		int count=directoryManageDao.findChild(id);
		int parentId=directoryManageDao.findParentById(id);
		System.out.println("子级数量为"+count+"是否是二级目录"+parentId);
		if(count!=0 && parentId==-1){
			crudResultDTO.setResult(false);
		}else if(count>0 && parentId==1){
			crudResultDTO.setResult(true);
		}else if(count==0 && parentId!=1){
			crudResultDTO.setResult(true);
		}else if(count!=0 && parentId!=1){
			crudResultDTO.setResult(true);
		}else{
			crudResultDTO.setResult(false);
		}
		return crudResultDTO;
	}
}


