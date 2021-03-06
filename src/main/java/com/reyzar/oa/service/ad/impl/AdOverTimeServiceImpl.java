package com.reyzar.oa.service.ad.impl;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.DateUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdLegalHolidayDao;
import com.reyzar.oa.dao.IAdOverTimeDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.AdOverTime;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.service.ad.IAdOverTimeService;

@Service
@Transactional
public class AdOverTimeServiceImpl implements IAdOverTimeService {
	
	@SuppressWarnings("unused")
	private final static Logger logger = Logger.getLogger(AdOverTimeServiceImpl.class);
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdOverTimeDao overtimeDao;
	@Autowired
	private IUserPositionDao userPositionDao;
	@Autowired
	private ISysUserDao sysUserDao;
	@Autowired
	IAdLegalHolidayDao legalHolidayDao;
	
	@Override
	public CrudResultDTO checkDate(String startTime, String endTime) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		Map<String, Object> map = Maps.newHashMap();
//		String month = startTime.substring(0, 7);
		Double hour = 0.0;
		map.put("dateBelongs", "");// ??????????????????????????????
		try {
			Date startDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", startTime);
			Date endDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", endTime);
			if(startDate.getTime()>endDate.getTime()){
				result = new CrudResultDTO(2, "????????????????????????????????????");
			}else{	
				/*if (!checkTime(startTime)) {
					result = new CrudResultDTO(2, "????????????????????????19???");
				}else {*/
					hour = calcHoure(startTime,endTime);
					Map<String, Object> resultMap = calcDayByTime(hour);
					result = new CrudResultDTO(1, resultMap);
				/*}*/
			}
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}
	
	// ???????????????????????????19???
		public boolean checkTime(String checkDate) {
			boolean flag = true;
			String strDate = checkDate.substring(0, 10);
			Date checkTime = DateUtils.strToDate("yyyy-MM-dd HH:mm", checkDate);
			Date startJB = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "19:00"); // ??????????????????
			if (checkTime.getTime() < startJB.getTime()) {
				return false;
			}
			return flag;
		}
	
	//??????????????????
		public Map<String, Object> calcDayByTime(Double hours){
			Map<String, Object> map = Maps.newHashMap();
			Double day = 0.0;
			map.put("hour", 0.0);
			map.put("day", 0.0);
			if(hours > 7.5){
				day = (double)((int)(hours*10)/(int)(7.5*10));
				hours = hours - 7.5*day;
				map.put("hour", hours);
				map.put("day", day);
			}else if(hours == 7.5){
				map.put("day", 1.0);
			}else{
				map.put("hour", hours);
			}
			return map;
		}
	
	// ???????????????????????????
		public Double calcHoure(String startTime, String endTime) {
			Double hour = 0.0;
			Double hour2 = 0.0;
			String normFlag = "yyyy-MM-dd HH:mm";
			// ???????????????????????????
			Date startDate = DateUtils.strToDate(normFlag, startTime);
			Date endDate = DateUtils.strToDate(normFlag, endTime);
			String strDate = startTime.substring(0, 10);
			String eDate = endTime.substring(0, 10);
			Date startTimes = DateUtils.strToDate("yyyy-MM-dd HH:mm", startTime);
			Date endTimes = DateUtils.strToDate("yyyy-MM-dd HH:mm", endTime);
			Date startJB = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "12:30"); // ??????????????????
			Date endJB = DateUtils.strToDate("yyyy-MM-dd HH:mm", eDate + " " + "14:00"); // ??????????????????
			Date endJB2 = DateUtils.strToDate("yyyy-MM-dd HH:mm", eDate + " " + "18:00"); // ??????????????????
			Date endJB3 = DateUtils.strToDate("yyyy-MM-dd HH:mm", eDate + " " + "19:00");
			if(startTimes.getTime() <= startJB.getTime() && endTimes.getTime() >= endJB.getTime()) {
				hour = 1.5;
			}
			if(startTimes.getTime() < endJB2.getTime() && endTimes.getTime() > endJB2.getTime()) {
				hour2 = 1.0;
			}
			if(startTimes.getTime() < endJB2.getTime() && endTimes.getTime() > endJB2.getTime() && endTimes.getTime() < endJB3.getTime()) {
				hour2 = 0.5;
			}
			// ????????????????????????????????????????????????????????????
			return (double) ((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 1.0) - hour - hour2);
		}
	
	@Override
	public Page<AdOverTime> findByPage(Map<String, Object> params,Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.OVERTIME);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		
		PageHelper.startPage(pageNum, pageSize);
		
		Page<AdOverTime> page = overtimeDao.findByPage(params);
		
		return page;
	}

	@Override
	public AdOverTime findById(Integer id) {
		AdOverTime adOverTime = overtimeDao.findById(id);
		SysUser user = UserUtils.getCurrUser();
		if(user.getDeptId() == 5 || user.getDept().getParentId() == 5) {
			adOverTime.setIsOk("true");
		}else {
			adOverTime.setIsOk("false");
		}
		return adOverTime ;
	}

	@Override
	public CrudResultDTO save(AdOverTime overTime) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;
		
		/*???????????????????????????????????????*/
		
		try {	
			overTime.setStatus("0");
			overTime.setApplyTime(new Date());
			overTime.setCreateBy(user.getAccount());
			overTime.setCreateDate(new Date());
			overtimeDao.save(overTime);
			
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
			businessParams.put("class", this.getClass().getName()); // ?????????????????????
			businessParams.put("method", "findById"); // ????????????
			
			businessParams.put("paramValue", new Object[] { overTime.getId() }); // ????????????????????????
			
			variables.put("businessParams", businessParams);
			variables.put("toCeo", (user.getDeptId() == 3 || user.getDept().getParentId() == 3 ? true :false)); // ???????????????????????????
			variables.put("isOk", user.getDeptId() == 5 || user.getDept().getParentId() == 5 ? true : false); // ??????????????????????????????
			
			//???????????????????????????
			boolean toCeo2=false;
			//??????????????????????????????
			String[] overTimeManagers = StringUtils.split(SystemConstant.getValue("overTimeManagers"), ",");
			if(Arrays.asList(overTimeManagers).contains(Integer.toString(user.getId()))){//???????????????????????????ID
				toCeo2=true;//????????????????????????
			}
			variables.put("toCeo2",toCeo2); 
			
			processInstance = activitiUtils.startProcessInstance(ActivitiUtils.OVERTIME_KEY, user.getId().toString(), overTime.getId().toString(), variables);
			
			// ????????????????????????????????????
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "????????????");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "????????????");
			commentMap.put("approveDate", overTime.getCreateDate());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // ??????????????????????????????????????????
			variables.put("toCeo", (user.getDeptId() == 3 || user.getDept().getParentId() == 3 ? true : false)); // ???????????????????????????
			variables.put("toCeo2",toCeo2); //???????????????????????????
			variables.put("isOk",user.getDeptId() == 5 || user.getDept().getParentId() == 5 ? true : false); //??????????????????????????????
			SysUserPosition userPosition = userPositionDao.findByDeptAndLevel2(user.getDept().getId());
			if(user.getDeptId() == 5 || user.getDept().getParentId() == 5) {
				if(userPosition!=null && userPosition.getUserId()!=null) {
					variables.put("userId3", userPosition.getUserId());
					SysUser user2=sysUserDao.findById(userPosition.getUserId());
					if(user2.getDept().getId() != 5) {
						SysUserPosition userPosition1 = userPositionDao.findByDeptAndLevel2(user2.getDept().getParentId());
						variables.put("userId2", userPosition1.getUserId());
					}
				}
			}
			List<Task> taskList = activitiUtils.getActivityTask(processInstance
					.getId());
			for (Task task : taskList) {
				if (task.getName().equals("????????????")) {
					activitiUtils.completeTask(task.getId(), variables);
					break;
				}
			}
			
			// ??????????????????Activiti???????????????
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			overTime.setProcessInstanceId(processInstance.getId());
			if(toCeo2){
				overTime.setStatus("9");
			}else{
				overTime.setStatus(status);
			}
			overtimeDao.update(overTime);

		} catch (Exception e) {
			if (processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO update(AdOverTime overTime) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SysUser user = UserUtils.getCurrUser();
		
		overTime.setUpdateBy(user.getAccount());
		overTime.setUpdateDate(new Date());
		
		AdOverTime old = overtimeDao.findById(overTime.getId());
		BeanUtils.copyProperties(overTime, old);
		old.setDays(overTime.getDays());
		old.setHours(overTime.getHours());
		overtimeDao.update(old);
		
		List<Task> taskList = activitiUtils.getActivityTask(old.getProcessInstanceId());
		for(Task task : taskList) {
			activitiUtils.setTaskVariables(task.getId(), "endTime", DateFormatUtils.format(old.getEndTime(), "yyyy-MM-dd'T'HH:mm:ss"));
			break ;
		}
		
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			AdOverTime overTime = overtimeDao.findById(id);
			if(overTime != null) {
				overTime.setStatus(status);
				overtimeDao.update(overTime);
				
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("????????????!");
			} else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("??????ID??????" + id + " ????????????");
			}
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}
	
}