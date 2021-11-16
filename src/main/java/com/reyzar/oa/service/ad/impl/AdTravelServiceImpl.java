package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdTravelAttachDao;
import com.reyzar.oa.dao.IAdTravelDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.AdTravel;
import com.reyzar.oa.domain.AdTravelAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.service.ad.IAdTravelService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

@Service
@Transactional
public class AdTravelServiceImpl implements IAdTravelService {
	
	private final Logger logger = Logger.getLogger(AdTravelServiceImpl.class);

	@Autowired
	private IAdTravelDao travelDao;
	@Autowired
	private IAdTravelAttachDao travelAttachDao;
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private IUserPositionDao userPositionDao;
	@Autowired
	private ISysUserService userService;

	@Override
	public CrudResultDTO updateTravelResult(Integer id ,String travelResult) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		travelDao.updateTravelResult(id,travelResult);
		return result;
	}

	@Override
	public Page<AdTravel> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<AdTravel> page = travelDao.findByPage(params);
		return page;
	}
	
	@Override
	public AdTravel findById(Integer id) {
		return travelDao.findById(id);
	}


	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;
		try {
			// 保存出差信息
			AdTravel travel = json.toJavaObject(AdTravel.class);
			travel.setUserId(user.getId());
			travel.setApplyTime(new Date());
			travel.setStatus("0");
			travel.setCreateBy(user.getAccount());
			travel.setCreateDate(new Date());
			travelDao.save(travel);
			SysDept sysDept=deptService.findById(user.getDept().getId());
			
			for(AdTravelAttach travelAttach : travel.getTravelAttachList()) {
				travelAttach.setTravelId(travel.getId());
				travelAttach.setCreateBy(user.getAccount());
				travelAttach.setCreateDate(new Date());
			}
			travelAttachDao.insertAll(travel.getTravelAttachList());
			
			// 启动出差流程
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			businessParams.put("paramValue", new Object[] { travel.getId() }); // 方法参数的值集合
			
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
			variables.put("isOk", user.getDeptId() == 5 || sysDept.getParentId() == 5 ? true : false); // 是否经过项目经理审批
			variables.put("isOk1", user.getDeptId() == 3 || sysDept.getParentId() == 3 ? true : false); // 是否经过项目经理审批
			
			processInstance = activitiUtils.startProcessInstance(ActivitiUtils.TRAVEL_KEY, user.getId().toString(), travel.getId().toString(), variables);
			
			// 跳过初始时的提交申请节点
			List<Map<String, Object>> commentList = Lists.newArrayList(); 
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "提交申请");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "提交成功");
			commentMap.put("approveDate", travel.getCreateDate());
			commentList.add(commentMap);
			
			variables.put("commentList", commentList); // 初始化提交申请节点的备注列表
			
			SysUserPosition userPosition = userPositionDao.findByDeptAndLevel2(user.getDept().getId());
			if(user.getDeptId() == 5 || sysDept.getParentId() == 5) {
				if(userPosition!=null && userPosition.getUserId()!=null) {
					variables.put("userId3", userPosition.getUserId());
					SysUser user2=userService.findById(userPosition.getUserId());
					if(user2.getDept().getId() != 5) {
						SysDept sysDept2=deptService.findById(user2.getDept().getId());
						SysUserPosition userPosition1 = userPositionDao.findByDeptAndLevel2(sysDept2.getParentId());
						variables.put("userId2", userPosition1.getUserId());
					}
				}
			}
			List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
			for(Task task : taskList) {
				if(task.getName().equals("提交申请")) {
					activitiUtils.completeTask(task.getId(), variables);
					break ;
				}
			}
			
			logger.info("");
			// 如果下一位执行者还是当前提交人，则直接执行处理下一步流程
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			// 设置业务表与Activiti表双向关联
			travel.setProcessInstanceId(processInstance.getId());
			travel.setStatus(status);
			travelDao.update(travel);
		} catch(Exception e) {
			if(processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}
	
	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		
		AdTravel travel = json.toJavaObject(AdTravel.class);
		AdTravel originTravel = travelDao.findById(travel.getId());
		travel.setUpdateBy(user.getAccount());
		travel.setUpdateDate(new Date());
		BeanUtils.copyProperties(travel, originTravel);
		List<AdTravelAttach> originTravelAttachList = travelAttachDao.findByTravelId(travel.getId());
		List<AdTravelAttach> travelAttachList = travel.getTravelAttachList();
		
		List<AdTravelAttach> saveList = Lists.newArrayList();
		List<AdTravelAttach> updateList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, AdTravelAttach> originTravelAttachMap = Maps.newHashMap();
		for(AdTravelAttach travelAttach : originTravelAttachList) {
			originTravelAttachMap.put(travelAttach.getId(), travelAttach);
		}
		
		for(AdTravelAttach travelAttach : travelAttachList) {
			if(travelAttach.getId() != null) {
				travelAttach.setUpdateBy(user.getAccount());
				travelAttach.setUpdateDate(new Date());
				
				AdTravelAttach origin = originTravelAttachMap.get(travelAttach.getId());
				if(origin != null) {
					BeanUtils.copyProperties(travelAttach, origin);
					updateList.add(origin);
					originTravelAttachMap.remove(origin.getId());
				}
			} else {
				travelAttach.setTravelId(travel.getId());
				travelAttach.setCreateBy(user.getAccount());
				travelAttach.setCreateDate(new Date());
				saveList.add(travelAttach);
			}
		}
		delList.addAll(originTravelAttachMap.keySet());
		
		travelDao.update(originTravel);
		if(saveList.size() > 0) {
			travelAttachDao.insertAll(saveList);
		}
		if(updateList.size() > 0) {
			travelAttachDao.batchUpdate(updateList);
		}
		if(delList.size() > 0) {
			travelAttachDao.deleteByIdList(delList);
		}
		
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			AdTravel travel = travelDao.findById(id);
			if(travel != null) {
				travel.setStatus(status);
				travelDao.update(travel);
				
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("操作成功!");
			} else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("没有ID为：" + id + " 的对象！");
			}
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
		}
		return result;
	}

	@Override
	public List<Map<String, Object>> getTraveData(Map<String, Object> paramsMap) {
		
		return travelDao.getTraveData(paramsMap);
	}

	@Override
	public List<AdTravel> findByIds(String travelId) {
		String[] ids = travelId.split(",");
		List<Integer> idInt =Lists.newArrayList();
		for (String id : ids) {
			idInt.add(Integer.parseInt(id.trim()));
		}
		
		return travelDao.findByIds(idInt);
	}

}
