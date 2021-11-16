package com.reyzar.oa.service.ad.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.reyzar.oa.common.dto.RecordExcelDTO;
import com.reyzar.oa.common.util.*;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.dao.IAdSalaryAttachDao;
import com.reyzar.oa.dao.IAdSalaryDao;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.AdSalary;
import com.reyzar.oa.domain.AdSalaryAttach;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdSalaryService;
import com.reyzar.oa.service.sys.IEncryptService;

import javax.servlet.ServletOutputStream;

@Service
@Transactional
public class AdSalaryServiceImpl implements IAdSalaryService,IEncryptService{
	private final static Logger logger = Logger.getLogger(AdSalaryServiceImpl.class);
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdSalaryDao salaryDao;
	@Autowired
	private IAdSalaryAttachDao attachDao;
	
	@Override
	public Page<AdSalary> findByPage(Map<String, Object> params,Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.SALARY);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		Page<AdSalary> page = salaryDao.findByPage(params);
		return page;
	}

	@Override
	public AdSalary findById(Integer id) {
		return salaryDao.findById(id);
	}

	@Override
	public List<AdSalary> findAll() {
		return salaryDao.findAll();
	}

	@Override
	public CrudResultDTO save(JSONObject json) {
		ProcessInstance processInstance = null;
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		try {
			AdSalary salary = json.toJavaObject(AdSalary.class);
			salary.setApplyTime(new Date());
			salary.setUserId(user.getId());
			salary.setDeptId(user.getDeptId());
			salary.setCreateBy(user.getAccount());
			salary.setCreateDate(new Date());
			salary.setEncrypted("n");
			salaryDao.save(salary);
			
			
			if (salary.getSalaryAttachList() != null) {
				for(AdSalaryAttach attach : salary.getSalaryAttachList()) {
					attach.setSalaryId(salary.getId());
					attach.setCreateBy(user.getAccount());
					attach.setCreateDate(new Date());
				}
				attachDao.insertAll(salary.getSalaryAttachList());
			}
			
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			businessParams.put("paramValue", new Object[] { salary.getId() }); // 方法参数的值集合
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
			
			processInstance = activitiUtils.startProcessInstance(
					ActivitiUtils.SALARY_KEY, user.getId().toString(), salary.getId().toString(), variables);
			// 跳过初始时的提交申请节点
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "提交申请");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "提交成功");
			commentMap.put("approveDate", new Date());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // 初始化提交申请节点的备注列表

			List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
			for(Task task : taskList) {
				if(task.getName().equals("提交申请")) {
					activitiUtils.completeTask(task.getId(), variables);
					break ;
				}
			}
			
			salary.setProcessInstanceId(processInstance.getId());
			salary.setStatus("1");
			salaryDao.update(salary);
			
			

			List<Task> taskList1 = activitiUtils.getTaskListByProcessInstanceId(processInstance.getId());
			for (Task task : taskList1) {
				if (!task.getName().equals("总经理")) {
					activitiUtils.completeTask(task.getId(), null);
				}
			}
			salary.setStatus("5");
			salaryDao.update(salary);
		} 
		catch (Exception e) {
			if(processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		AdSalary salary = salaryDao.findById(id);
		if(salary != null) {
			salary.setStatus(status);
			salaryDao.update(salary);
			
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult("操作成功!");
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("没有id为：" + id + " 的对象！");
		}
		return result;
	}
	
	@Override
	public CrudResultDTO update(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
		if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("密钥已更改，请重新导入新密钥！");
		}
		boolean hasEncryptionKey = encryptionKey != null && ModuleEncryptUtils.validEncryptionKey(encryptionKey) ? true : false;
		AdSalary salary = json.toJavaObject(AdSalary.class);
		AdSalary originSalary = salaryDao.findById(salary.getId());
		salary.setUpdateBy(user.getAccount());
		salary.setUpdateDate(new Date());
		BeanUtils.copyProperties(salary, originSalary);
		List<AdSalaryAttach> orginSalaryAttachList = attachDao.findBySalaryId(salary.getId());
		List<AdSalaryAttach> salaryAttachList = salary.getSalaryAttachList();
		
		List<AdSalaryAttach> saveList = Lists.newArrayList();
		List<AdSalaryAttach> updateList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		Map<Integer, AdSalaryAttach> originsalaryAttachMap = Maps.newHashMap();
		for (AdSalaryAttach salaryAttach : orginSalaryAttachList) {
			originsalaryAttachMap.put(salaryAttach.getId(), salaryAttach);
		}
		for (AdSalaryAttach attach : salaryAttachList) {
			if (attach.getId() != null) {
				attach.setUpdateBy(user.getAccount());
				attach.setUpdateDate(new Date());
				
				AdSalaryAttach origin = originsalaryAttachMap.get(attach.getId());
				if (origin != null) {
					if( "y".equals(originSalary.getEncrypted()) && !hasEncryptionKey ) {
						attach.setFinallySalary(origin.getFinallySalary());
					}
					BeanUtils.copyProperties(attach, origin);
					updateList.add(origin);
					originsalaryAttachMap.remove(origin.getId());
				}
			}else {
				attach.setSalaryId(salary.getId());
				attach.setCreateBy(user.getAccount());
				attach.setCreateDate(new Date());
				saveList.add(attach);
			}
		}
		delList.addAll(originsalaryAttachMap.keySet());
		salaryDao.update(originSalary);
		if (saveList.size()>0) {
			if ("y".equals(originSalary.getEncrypted()) && hasEncryptionKey) {
				encryptData(saveList, encryptionKey);
			}
			attachDao.insertAll(saveList);
		}
		if (updateList.size()>0) {
			if ("y".equals(originSalary.getEncrypted()) && hasEncryptionKey){
				decryptData(updateList, encryptionKey); // 先还原回原文，然后再加密。避免页面不修改密文而又重新加密一次
				encryptData(updateList, encryptionKey);
			}
			attachDao.batchUpdate(updateList);
		}
		return result;
	}
	
	
	@Override
	public CrudResultDTO lock(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "加密成功！");
		try {
			if( json == null ) {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("加密数据不能为空！");
			} else {
				String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
				
				if( encryptionKey == null ) {
					result.setCode(CrudResultDTO.FAILED);
					result.setResult("请导入密钥！");
				} else if( !ModuleEncryptUtils.validEncryptionKey(encryptionKey) ) {
					result.setCode(CrudResultDTO.FAILED);
					result.setResult("当前密钥已失效，请更新您的密钥！");
				} else {
					Integer id = json.getInteger("id");
					AdSalary salary = salaryDao.findById(id);
					
					if( !"y".equals(salary.getEncrypted()) ) {
						Set<Integer> idSet = Sets.newHashSet();
						Map<Integer, AdSalaryAttach> salaryAttachMap = Maps.newHashMap();
						JSONArray salaryAttachList = json.getJSONArray("salaryAttachList");
						
						for(int i=0; i < salaryAttachList.size(); i++) {
							AdSalaryAttach attach = salaryAttachList.getObject(i, AdSalaryAttach.class);
							if( attach.getFinallySalary() != null && attach.getFinallySalary() != "") {
								attach.setFinallySalary(AesUtils.encryptECB(attach.getFinallySalary(), encryptionKey));
							}
							AdSalaryAttach temp = salaryAttachMap.get(attach.getId());
							if( temp != null ) {
								BeanUtils.copyProperties(attach, temp);
							} else {
								salaryAttachMap.put(attach.getId(), attach);
							}
							idSet.add(attach.getId());
						}
						
						List<AdSalaryAttach> oldList = attachDao.findByIds(idSet);
						for( AdSalaryAttach oldAttach : oldList ) {
							AdSalaryAttach attach = salaryAttachMap.get(oldAttach.getId());
							BeanUtils.copyProperties(attach, oldAttach);
						}
						
						salary.setEncrypted("y");
						salaryDao.update(salary);
						attachDao.batchUpdate(oldList);
					} else {
						result.setCode(CrudResultDTO.FAILED);
						result.setResult("当前数据已加密，无须再次加密！");
					}
				}
			}
		} catch(Exception e) {
			logger.error("加密发生异常，异常信息：" + e.getMessage());
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("加密发生异常，请联系管理员！");
			throw new BusinessException(e);
		}
		
		return result;
	}

	@Override
	public void exportExcel(ServletOutputStream out, Map<String, Object> paramMap) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "导出Excel成功！");
		String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
		if( encryptionKey == null ) {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("请导入密钥！");
		}else if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("密钥已更改，请重新导入新密钥！");
		}else{
			if(paramMap.get("id")!=null&&paramMap.get("id")!=""){
				String idString= (String) paramMap.get("id");
				Integer id= Integer.valueOf(idString);
				AdSalary adSalary=new AdSalary();
				try{
					adSalary = this.findById(id);
				}catch (Exception e){
					logger.error("调薪内容查找失败"+e);
				}
				List<AdSalaryAttach> adSalaryAttachList = adSalary.getSalaryAttachList();
				this.decryptData(adSalaryAttachList,encryptionKey);
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				for (AdSalaryAttach attachItem:adSalaryAttachList) {
					RecordExcelDTO dto=new RecordExcelDTO();
					dto.setTime(formatter.format(attachItem.getRecord().getEntryTime()));
					attachItem.setRecordExcelDTO(dto);
					if (attachItem.getLastdate()!=null){
						attachItem.setLastDateString(formatter.format(attachItem.getLastdate()));
					}
				}
				Context context =new Context();
				context.putVar("year",adSalary.getTittle());
				context.putVar("dataList",adSalaryAttachList);
				//调用ExcelUtil 进行文件导出
				ExcelUtil.export("salary.xls", out, context);
			}
		}
	}

	@Override
	public void updateEncryptedData(String oldEncryptionKey,String newEncryptionKey) {
		List<AdSalary> salaryList = salaryDao.findByEncrypted("y");
		List<AdSalaryAttach> salaryAttachList = Lists.newArrayList();
		for(AdSalary salary : salaryList) {
			List<AdSalaryAttach> tempAttachList = salary.getSalaryAttachList();
			
			List<AdSalaryAttach> tempAttachList2 = Lists.newArrayList();
			
			Map<Integer, AdSalaryAttach> attachMap = Maps.newHashMap();
			for(AdSalaryAttach attach : tempAttachList) {
				AdSalaryAttach temp = new AdSalaryAttach();
				temp.setId(attach.getId());
				temp.setFinallySalary(attach.getFinallySalary() == null ? "" : attach.getFinallySalary());
				
				attachMap.put(attach.getId(), temp);
			}
			
			decryptData(tempAttachList, oldEncryptionKey);
			
			for(AdSalaryAttach attach : tempAttachList) {
				AdSalaryAttach temp = attachMap.get(attach.getId());
				if( !temp.getFinallySalary().equals(attach.getFinallySalary() == null ? "" : attach.getFinallySalary())) {
					tempAttachList2.add(attach);
				}
			}
			
			encryptData(tempAttachList2, newEncryptionKey);
			
			salaryAttachList.addAll(tempAttachList2);
		}
			
		if(salaryAttachList.size() > 0) {
			attachDao.batchUpdate(salaryAttachList);
		}
	}

	@Override
	public <T> void decryptData(List<T> list, String oldEncryptionKey) {
		for( T temp : list ) {
			AdSalaryAttach salaryAttach = (AdSalaryAttach) temp;
			if( StringUtils.isNotEmpty(salaryAttach.getFinallySalary()) ) {
				String salary = ModuleEncryptUtils.decryptText(salaryAttach.getFinallySalary(), oldEncryptionKey);
				if( StringUtils.isNotEmpty(salary) ) {
					salaryAttach.setFinallySalary(salary);
				}
			}
			
			}
	}

	@Override
	public <T> void encryptData(List<T> list, String newEncryptionKey) {
		for( T temp : list ) {
			AdSalaryAttach salaryAttach = (AdSalaryAttach) temp;
			if( StringUtils.isNotEmpty(salaryAttach.getFinallySalary()) ) {
				String salary = ModuleEncryptUtils.encryptText(salaryAttach.getFinallySalary(), newEncryptionKey);
				if( StringUtils.isNotEmpty(salary) ) {
					salaryAttach.setFinallySalary(salary);
				}
			}
			}
		
	}

	@Override
	public List<AdRecord> workingStateselectVal() {
		return salaryDao.workingStateselectVal();
	}
	
}