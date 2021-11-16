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
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		Map<String, Object> map = Maps.newHashMap();
//		String month = startTime.substring(0, 7);
		Double hour = 0.0;
		map.put("dateBelongs", "");// 查找与该月对应的数据
		try {
			Date startDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", startTime);
			Date endDate = DateUtils.strToDate("yyyy-MM-dd HH:mm", endTime);
			if(startDate.getTime()>endDate.getTime()){
				result = new CrudResultDTO(2, "开始时间不能大于结束时间");
			}else{	
				/*if (!checkTime(startTime)) {
					result = new CrudResultDTO(2, "开始时间不能小于19点");
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
	
	// 判断开始时间不小于19点
		public boolean checkTime(String checkDate) {
			boolean flag = true;
			String strDate = checkDate.substring(0, 10);
			Date checkTime = DateUtils.strToDate("yyyy-MM-dd HH:mm", checkDate);
			Date startJB = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "19:00"); // 加班开始时间
			if (checkTime.getTime() < startJB.getTime()) {
				return false;
			}
			return flag;
		}
	
	//算出加班时间
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
	
	// 算出每天的加班时间
		public Double calcHoure(String startTime, String endTime) {
			Double hour = 0.0;
			Double hour2 = 0.0;
			String normFlag = "yyyy-MM-dd HH:mm";
			// 加班开始、结束时间
			Date startDate = DateUtils.strToDate(normFlag, startTime);
			Date endDate = DateUtils.strToDate(normFlag, endTime);
			String strDate = startTime.substring(0, 10);
			String eDate = endTime.substring(0, 10);
			Date startTimes = DateUtils.strToDate("yyyy-MM-dd HH:mm", startTime);
			Date endTimes = DateUtils.strToDate("yyyy-MM-dd HH:mm", endTime);
			Date startJB = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "12:30"); // 上午下班时间
			Date endJB = DateUtils.strToDate("yyyy-MM-dd HH:mm", eDate + " " + "14:00"); // 下午上班时间
			Date endJB2 = DateUtils.strToDate("yyyy-MM-dd HH:mm", eDate + " " + "18:00"); // 下午下班时间
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
			// 判断加班开始时间和结束时间是否是在同一天
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
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;
		
		/*保存加班信息并启动加班流程*/
		
		try {	
			overTime.setStatus("0");
			overTime.setApplyTime(new Date());
			overTime.setCreateBy(user.getAccount());
			overTime.setCreateDate(new Date());
			overtimeDao.save(overTime);
			
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			
			businessParams.put("paramValue", new Object[] { overTime.getId() }); // 方法参数的值集合
			
			variables.put("businessParams", businessParams);
			variables.put("toCeo", (user.getDeptId() == 3 || user.getDept().getParentId() == 3 ? true :false)); // 是否经过总经理审批
			variables.put("isOk", user.getDeptId() == 5 || user.getDept().getParentId() == 5 ? true : false); // 是否经过项目经理审批
			
			//是否经过总经理审批
			boolean toCeo2=false;
			//获取外部配置文件数据
			String[] overTimeManagers = StringUtils.split(SystemConstant.getValue("overTimeManagers"), ",");
			if(Arrays.asList(overTimeManagers).contains(Integer.toString(user.getId()))){//如果存在对应的用户ID
				toCeo2=true;//走总经理审批流程
			}
			variables.put("toCeo2",toCeo2); 
			
			processInstance = activitiUtils.startProcessInstance(ActivitiUtils.OVERTIME_KEY, user.getId().toString(), overTime.getId().toString(), variables);
			
			// 跳过初始时的提交申请节点
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "提交申请");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "提交成功");
			commentMap.put("approveDate", overTime.getCreateDate());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // 初始化提交申请节点的备注列表
			variables.put("toCeo", (user.getDeptId() == 3 || user.getDept().getParentId() == 3 ? true : false)); // 是否经过总经理审批
			variables.put("toCeo2",toCeo2); //是否经过总经理审批
			variables.put("isOk",user.getDeptId() == 5 || user.getDept().getParentId() == 5 ? true : false); //是否经过项目经理审批
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
				if (task.getName().equals("提交申请")) {
					activitiUtils.completeTask(task.getId(), variables);
					break;
				}
			}
			
			// 设置业务表与Activiti表双向关联
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
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败：" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO update(AdOverTime overTime) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
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