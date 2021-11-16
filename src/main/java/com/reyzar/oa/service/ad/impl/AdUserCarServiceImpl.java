package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdUserCarDao;
import com.reyzar.oa.domain.AdUserCar;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdUserCarService;

@Service
@Transactional
public class AdUserCarServiceImpl implements IAdUserCarService {
	@SuppressWarnings("unused")
	private final static Logger logger = Logger.getLogger(AdUserCarServiceImpl.class);
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdUserCarDao usercarDao;

	@Override
	public Page<AdUserCar> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.usercar);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		
		paramsMap.put("userId", user.getId());
		paramsMap.put("deptIdSet", deptIdSet);
		
		PageHelper.startPage(pageNum, pageSize);
		
		Page<AdUserCar> page = usercarDao.findByPage(paramsMap);
		return page;
	}

	@Override
	public AdUserCar findById(Integer id) {
		return usercarDao.findById(id);
	}

	@Override
	public CrudResultDTO save(AdUserCar userCar) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;
		try {
			userCar.setStatus("0");
			userCar.setApplyTime(new Date());
			userCar.setCreateDate(new Date());
			userCar.setCreateBy(user.getAccount());
			usercarDao.save(userCar);
			
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			
			businessParams.put("paramValue", new Object[] { userCar.getId() }); // 方法参数的值集合
			variables.put("businessParams", businessParams);
			
			processInstance = activitiUtils.startProcessInstance(ActivitiUtils.CAR_KEY, user.getId().toString(), userCar.getId().toString(), variables);
			
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "提交申请");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "提交成功");
			commentMap.put("approveDate", userCar.getCreateDate());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // 初始化提交申请节点的备注列表

			List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
			
			for (Task task : taskList) {
				if (task.getName().equals("提交申请")) {
					activitiUtils.completeTask(task.getId(), variables);
					break;
				}
			}
			//如果下一位执行者还是当前提交人，则直接执行处理下一步流程
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			// 设置业务表与Activiti表双向关联
			userCar.setProcessInstanceId(processInstance.getId());
			userCar.setStatus(status);
			usercarDao.update(userCar);
			
		} catch (Exception e) {
			if (processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO update(AdUserCar userCar) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		userCar.setUpdateBy(user.getAccount());
		userCar.setUpdateDate(new Date());
		
		AdUserCar old = usercarDao.findById(userCar.getId());
		BeanUtils.copyProperties(userCar, old);
		old.setReason(userCar.getReason());
		usercarDao.update(old);
		
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			AdUserCar car = usercarDao.findById(id);
			if(car != null) {
				car.setStatus(status);
				usercarDao.update(car);
				
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("操作成功!");
			} else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("没有ID为：" + id + " 的对象！");
			}
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}
}