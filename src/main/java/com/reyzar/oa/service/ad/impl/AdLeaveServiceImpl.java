package com.reyzar.oa.service.ad.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.mail.Message.RecipientType;

import com.reyzar.oa.service.sys.ISysUserService;
import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.SpringContextUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdLeaveDao;
import com.reyzar.oa.dao.IAdLegalHolidayDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.AdLeave;
import com.reyzar.oa.domain.AdLegalHoliday;
import com.reyzar.oa.domain.AdOverTime;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.service.ad.IAdLeaveService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Service
@Transactional
public class AdLeaveServiceImpl implements IAdLeaveService, JavaDelegate {

	private final static Logger logger = Logger.getLogger(AdLeaveServiceImpl.class);
	private final static String flag = "2";

	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdLeaveDao leaveDao;
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private ISysUserService userService;
	@Autowired
	IAdLegalHolidayDao legalHolidayDao;
	@Autowired
	private IUserPositionDao userPositionDao;

	@Override
	public Page<AdLeave> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.LEAVE);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		Set<Integer> userSet = UserUtils.getPrincipalIdList(user);

		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		params.put("userSet", userSet);

		PageHelper.startPage(pageNum, pageSize);
		Page<AdLeave> page = leaveDao.findByPage(params);
		return page;
	}

	@Override
	public AdLeave findById(Integer id) {
		AdLeave adLeave = leaveDao.findById(id);
		SysUser user = UserUtils.getCurrUser();
		SysDept sysDept=deptService.findById(user.getDept().getId());
		if(user.getDeptId() == 5 || sysDept.getParentId() == 5) {
			adLeave.setIsOk("true");
		}else {
			adLeave.setIsOk("false");
		}
		return adLeave ;
	}

	/**
	 * 保存请假信息并启动请假流程
	 * 
	 * @param leave
	 * @return boolean
	 */
	@Override
	public CrudResultDTO save(AdLeave leave) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;

		try {
			// 保存请假信息
			leave.setStatus("0");
			leave.setApplyTime(new Date());
			leave.setCreateBy(user.getAccount());
			leave.setCreateDate(new Date());
			leaveDao.save(leave);
			SysDept sysDept=deptService.findById(user.getDept().getId());

			List<SysDept> deptList = deptService.findByUserId(user.getId());
			boolean isDeptManager = (deptList != null && deptList.size() > 0) ? true : false;

			// 启动请假流程
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams
																	// 提供给
																	// ActivitiService
																	// 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			businessParams.put("paramValue", new Object[] { leave.getId() }); // 方法参数的值集合

			variables.put("businessParams", businessParams);
			variables.put("toCeo", (leave.getDays() != null && leave.getDays() >= 3) || isDeptManager ? true : false); // 是否经过总经理审批
			variables.put("isDeptManager", isDeptManager); // 部门管理请假要经过总经理
			variables.put("retraction", false); // 在总经理或销假环节进行撤销申请
			variables.put("endTime", DateFormatUtils.format(leave.getEndTime(), "yyyy-MM-dd'T'HH:mm:ss"));
			variables.put("isOk", user.getDeptId() == 5 || sysDept.getParentId() == 5 ? true : false); // 是否经过项目经理审批

			processInstance = activitiUtils.startProcessInstance(ActivitiUtils.LEVAE_KEY, user.getId().toString(),
					leave.getId().toString(), variables);

			// 跳过初始时的提交申请节点
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "提交申请");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "提交成功");
			commentMap.put("approveDate", leave.getCreateDate());
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
			for (Task task : taskList) {
				if (task.getName().equals("提交申请")) {
					activitiUtils.completeTask(task.getId(), variables);
					break;
				}
			}

			// 设置业务表与Activiti表双向关联
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			leave.setProcessInstanceId(processInstance.getId());
			leave.setStatus(status);
			leaveDao.update(leave);
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
	public List<Map<String, Object>> getLeaveDays(Map<String, Object> paramsMap) {
		List<Map<String, Object>> resultList = Lists.newArrayList();
		List<Map<String, Object>> dataList = Lists.newArrayList();
		dataList = leaveDao.getLeaveDays(paramsMap);
		String flagMonth = (String) paramsMap.get("yearWithMonth");
		List<Map<String, Object>> nameList = leaveDao.getNameList(paramsMap);
		List<AdLegalHoliday> legalHolidays = legalHolidayDao.getLegalHolidays(paramsMap);
		Double hour = 0.0;
		for (Map<String, Object> map : nameList) {
			hour = 0.0;
			Map<String, Object> resultMap = Maps.newHashMap();
			for (Map<String, Object> mapL : dataList) {
				if(map.get("name").equals(mapL.get("name"))){
					Calendar firstDate = Calendar.getInstance();
					firstDate.setTime(DateUtils.strToDate("yyyy-MM",flagMonth));
					firstDate.set(Calendar.DAY_OF_MONTH,1);  //设置为1号,当前日期既为本月第一天 
					firstDate.set(Calendar.HOUR, 00);
					firstDate.set(Calendar.MINUTE, 00);
					Calendar lastDate=Calendar.getInstance();
					lastDate.setTime(DateUtils.strToDate("yyyy-MM",flagMonth));
					lastDate.set(Calendar.DAY_OF_MONTH, lastDate.getActualMaximum(Calendar.DAY_OF_MONTH)); 
					lastDate.set(Calendar.HOUR, 23);
					lastDate.set(Calendar.MINUTE, 59);
					if(firstDate.getTime().getTime() > ((Date)mapL.get("start_time")).getTime()){
						hour += calcHoure(DateUtils.dateToStr(firstDate.getTime(), "yyyy-MM-dd HH:mm:ss"), DateUtils.dateToStr((Date)mapL.get("end_time"), "yyyy-MM-dd HH:mm:ss"), legalHolidays);
					}else if(lastDate.getTime().getTime()<((Date)mapL.get("end_time")).getTime()){
						hour += calcHoure(DateUtils.dateToStr((Date)mapL.get("start_time"), "yyyy-MM-dd HH:mm:ss"), DateUtils.dateToStr(lastDate.getTime(), "yyyy-MM-dd HH:mm:ss"), legalHolidays);
					}else{
						hour += calcHoure(DateUtils.dateToStr((Date)mapL.get("start_time"), "yyyy-MM-dd HH:mm:ss"), DateUtils.dateToStr((Date)mapL.get("end_time"), "yyyy-MM-dd HH:mm:ss"), legalHolidays);
						
					}
				}
			}
			resultMap.put("NAME", map.get("name"));
			Map<String, Object> flagReult = calcDayByTime(hour);
			Double day = (double) flagReult.get("day")*1.0;
			Double hours = (double) flagReult.get("hour");
			
			if(hours == 3.5 || hours == 4){
				day += 0.5;
			}else{
				day = (day+(Math.ceil((hours/7.5)*10)/10));
			}
			resultMap.put("DAYS", day);
			resultList.add(resultMap);
		}
		return resultList;
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			AdLeave leave = leaveDao.findById(id);
			if (leave != null) {
				leave.setStatus(status);
				leaveDao.update(leave);
				if (flag.equals(leave.getStatus())) {
					sendMail(leave);
				}

				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("操作成功!");
			} else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("没有ID为：" + id + " 的对象！");
			}
		} catch (Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	/**
	 * 进行销假处理
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public void execute(DelegateExecution execution) throws Exception {
		try {
			IAdLeaveDao leaveDao = SpringContextUtils.getBean(IAdLeaveDao.class);
			ActivitiUtils activitiUtils = SpringContextUtils.getBean(ActivitiUtils.class);

			Integer id = Integer.valueOf(execution.getBusinessKey());
			AdLeave leave = leaveDao.findById(id);

			List<Task> taskList = activitiUtils.getActivityTask(leave.getProcessInstanceId());
			for (Task task : taskList) {
				Map<String, Object> variables = activitiUtils.getVariablesByTaskid(task.getId());
				List<Map<String, Object>> commentList = (List<Map<String, Object>>) variables.get("commentList");
				Map<String, Object> commentMap = Maps.newHashMap();
				commentMap.put("node", "销假");
				commentMap.put("approver", leave.getApplicant().getName());
				commentMap.put("comment", "自动销假");
				commentMap.put("approveResult", "销假成功");
				commentMap.put("approveDate", new Date());
				commentList.add(commentMap);
				// 初始化提交申请节点的备注列表
				variables.put("commentList", commentList);

				activitiUtils.setTaskVariables(task.getId(), variables);
				break;
			}

			leave.setStatus("5");
			leave.setBackTime(new Date());
			leave.setBackWay("0");
			leaveDao.update(leave);
		} catch (Exception e) {
			logger.error("系统自动销假发生异常，请假ID：[" + execution.getBusinessKey() + "] 异常信息：" + e.getMessage());
		}
	}

	@Override
	public void sendMail(AdLeave leave) {
		// 获取有可视权限部门下的人员邮箱
		List<String> recipientsList = Lists.newArrayList();
		recipientsList.add(SystemConstant.getValue("mail"));
		String type;
		if (leave.getLeaveType().toString().equals("0")) {
			type = "事假";
		} else if (leave.getLeaveType().equals("1")) {
			type = "年假";
		} else if (leave.getLeaveType().equals("2")) {
			type = "调休";
		} else if (leave.getLeaveType().equals("3")) {
			type = "病假";
		} else if (leave.getLeaveType().equals("4")) {
			type = "婚假";
		} else if (leave.getLeaveType().equals("5")) {
			type = "产假";
		} else if (leave.getLeaveType().equals("6")) {
			type = "陪产假";
		} else {
			type = "其他";
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:ss");
		SysUser user = userService.findById(leave.getUserId());
		// 构造邮件
		String subject = "OA员工请假提示";
		String content = "<h3>" + user.getDept().getName() + "员工" + user.getName()
				+ "<span style=\"font-family:微软雅黑, Microsoft YaHei\">发起了" + type + "申请，" + "请假起始时间为 "
				+ sdf.format(leave.getStartTime()) + "至" + sdf.format(leave.getEndTime()) + ",&nbsp; <br>事由:"
				+ leave.getReason() + "<br>详情请登陆OA请假管理模块进行查看!</br>" + "</span>\r\n" + "</h3>";

		// 以线程方式发送邮件，避免邮件发送时间过长，造成前端等待过久
		Thread thread = new Thread() {
			private List<String> recipientsList;
			private String subject;
			private String content;
			private RecipientType recipientType;

			@Override
			public void run() {
				// 发送邮件
				// 以暗送的方式发送邮件
				MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType);
			}

			public Thread setParams(List<String> recipientsList, String subject, String content,
					RecipientType recipientType) {
				this.recipientsList = recipientsList;
				this.subject = subject;
				this.content = content;
				this.recipientType = recipientType;

				return this;
			}
		}.setParams(recipientsList, subject, content, MailUtils.BCC);

		if (!"y".equals(SystemConstant.getValue("devMode"))) {
			thread.start();
		}
	}

	@Override
	public CrudResultDTO update(AdLeave leave) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();

		// 保存请假信息
		leave.setUpdateBy(user.getAccount());
		leave.setUpdateDate(new Date());

		AdLeave old = leaveDao.findById(leave.getId());
		BeanUtils.copyProperties(leave, old);
		old.setDays(leave.getDays());
		old.setHours(leave.getHours());
		leaveDao.update(old);

		List<Task> taskList = activitiUtils.getActivityTask(old.getProcessInstanceId());
		for (Task task : taskList) {
			activitiUtils.setTaskVariables(task.getId(), "endTime",
					DateFormatUtils.format(old.getEndTime(), "yyyy-MM-dd'T'HH:mm:ss"));
			break;
		}

		return result;
	}

	@Override
	public CrudResultDTO setBackLeave(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");

		AdLeave leave = leaveDao.findById(id);
		leave.setBackTime(new Date());
		leave.setBackWay("1");
		leave.setUpdateBy(UserUtils.getCurrUser().getAccount());
		leave.setUpdateDate(new Date());
		leaveDao.update(leave);

		return result;
	}

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
			List<AdLegalHoliday> legalHolidays = legalHolidayDao.getLegalHolidays(map);
			if(startDate.getTime()>endDate.getTime()){
				result = new CrudResultDTO(2, "开始时间不能大于结束时间");
			}else{
				if (!checkDateRest(startDate, legalHolidays) || !checkDateRest(endDate, legalHolidays)) {
					result = new CrudResultDTO(2, "不要填写休息时间");
				} else if (!checkTime(startTime) || !checkTime(endTime)) {
					result = new CrudResultDTO(2, "请填写正确的请假时间");
				}else{
					hour = calcHoure(startTime,endTime,legalHolidays);
					Map<String, Object> resultMap = calcDayByTime(hour);
					result = new CrudResultDTO(1, resultMap);
				}
			}
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}
	
	//算出请假时间
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
	
	
	
	// 判断请假开始时间与结束时间是否为休息日或法定休息日
	public boolean checkDateRest(Date checkTime, List<AdLegalHoliday> legalHolidays) {
		boolean flag = true;
		Calendar calendar = Calendar.getInstance();
		Date check = DateUtils.dateToDate(checkTime, "yyyy-MM-dd");
		calendar.setTime(check);

		for (AdLegalHoliday adLegalHoliday : legalHolidays) {
			Calendar cl = Calendar.getInstance();
			Calendar c2 = Calendar.getInstance();
			cl.setTime(adLegalHoliday.getEndDate());
			c2.setTime(adLegalHoliday.getStartDate());
			
			if (check.getTime() >= adLegalHoliday.getStartDate().getTime()
					&& check.getTime() <= adLegalHoliday.getEndDate().getTime()) {
				return false;
			} else {
				if ((calendar.get(Calendar.DAY_OF_WEEK) == 1) || (calendar.get(Calendar.DAY_OF_WEEK) - 1 == 6)) {
					flag = false;
					if (adLegalHoliday.getBeforeLeave() != null && !"".equals(adLegalHoliday.getBeforeLeave())) {
						if (check.getTime() == adLegalHoliday.getBeforeLeave().getTime()) {
							flag = true;
						}
					}
					if (adLegalHoliday.getAfterLeave() != null && !"".equals(adLegalHoliday.getAfterLeave())) {
						if (check.getTime() == adLegalHoliday.getAfterLeave().getTime()) {
							flag = true;
						}
					}
				}
			}
		}
		return flag;
	}

	// 判断开始、结束时间不能小于9:00 、12:30-14:00之间，大于18:00 (本天)
	public boolean checkTime(String checkDate) {
		boolean flag = true;
		String strDate = checkDate.substring(0, 10);
		Date checkTime = DateUtils.strToDate("yyyy-MM-dd HH:mm", checkDate);
		Date startAM = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "09:00"); // 标准上班时间
		Date endAM = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "12:30"); // 标准上班时间
		Date startPM = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "14:00"); // 标准下班时间
		Date endPM = DateUtils.strToDate("yyyy-MM-dd HH:mm", strDate + " " + "18:00"); // 标准下班时间
		if (checkTime.getTime() < startAM.getTime()
				|| (checkTime.getTime() > endAM.getTime() && checkTime.getTime() < startPM.getTime())
				|| checkTime.getTime() > endPM.getTime()) {
			return false;
		}
		return flag;
	}
	// 算出每天的请假时间
	public Double calcHoure(String startTime, String endTime, List<AdLegalHoliday> legalHolidays) {
		Double houre = 0.0;
		String normFlag = "yyyy-MM-dd HH:mm";
		// 请假开始、结束时间
		Date startDate = DateUtils.strToDate(normFlag, startTime);
		Date endDate = DateUtils.strToDate(normFlag, endTime);
		String dateTime = "";
		// 判断请假开始时间和结束时间是否是在同一天
		if (DateUtils.dateToDate(startDate, "yyyy-MM-dd").getTime() == DateUtils.dateToDate(endDate, "yyyy-MM-dd")
				.getTime()) {
			dateTime = DateUtils.dateToStr(startDate, "yyyy-MM-dd");
			Date normAMstart = DateUtils.strToDate(normFlag, dateTime + " 09:00");// 上午上班时间
			Date normAMend = DateUtils.strToDate(normFlag, dateTime + " 12:30");// 上午下班时间
			Date normPMstart = DateUtils.strToDate(normFlag, dateTime + " 14:00");// 下午上班时间
			Date normPMend = DateUtils.strToDate(normFlag, dateTime + " 18:00");// 下午下班时间
			// 开始时间是今日
			// 1、请假开始时间为上午
			// 2、请假时间为下午
			if (startDate.getTime() >= normAMstart.getTime() && startDate.getTime() <= normAMend.getTime()) {// 请假时间在上午
				// 1、请假结束时间在上午
				// 2、请假结束时间在下午
				if (endDate.getTime() >= normAMstart.getTime() && endDate.getTime() <= normAMend.getTime()) {
					houre = (double) ((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 1.0));
				} else if (endDate.getTime() >= normPMstart.getTime() && endDate.getTime() <= normPMend.getTime()) {
					houre = (double) (((normAMend.getTime() - startDate.getTime())) / (1000 * 60 * 60 * 1.0));
					houre += (endDate.getTime() - normPMstart.getTime()) / (1000 * 60 * 60 * 1.0);
				}
			} else if (startDate.getTime() >= normPMstart.getTime() && startDate.getTime() <= normPMend.getTime()) {// 请假时间在下午
				houre = (double) ((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 1.0));
			}
		} else {// 开始时间和结束时间不在同一天
				// 1、计算出开始当天请假时间
				// 2、计算后面所请时间
			dateTime=DateUtils.dateToStr(startDate, "yyyy-MM-dd");
			Date normAMstart = DateUtils.strToDate(normFlag, dateTime + " 09:00");// 上午上班时间
			Date normAMend = DateUtils.strToDate(normFlag, dateTime + " 12:30");// 上午下班时间
			Date normPMstart = DateUtils.strToDate(normFlag, dateTime + " 14:00");// 下午上班时间
			Date normPMend = DateUtils.strToDate(normFlag, dateTime + " 18:00");// 下午下班时间
			if (startDate.getTime() >= normAMstart.getTime() && startDate.getTime() <= normAMend.getTime()) {// 请假时间在上午
					houre = (double) (((normAMend.getTime() - startDate.getTime())) / (1000 * 60 * 60 * 1.0))+4;
			} else if (startDate.getTime() >= normPMstart.getTime() && startDate.getTime() <= normPMend.getTime()) {// 请假时间在下午
				houre = (double) ((normPMend.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 1.0));
			}
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(DateUtils.dateToDate(startDate, "yyyy-MM-dd"));
			calendar.add(Calendar.DAY_OF_MONTH, +1);
			Calendar calendar2 = Calendar.getInstance();
			calendar2.setTime(DateUtils.dateToDate(endDate, "yyyy-MM-dd"));
			while(calendar.getTime().getTime() <= calendar2.getTime().getTime()){
				dateTime = DateUtils.dateToStr(calendar.getTime(), "yyyy-MM-dd");
				normAMstart = DateUtils.strToDate(normFlag, dateTime + " 09:00");// 上午上班时间
				normAMend = DateUtils.strToDate(normFlag, dateTime + " 12:30");// 上午下班时间
				normPMstart = DateUtils.strToDate(normFlag, dateTime + " 14:00");// 下午上班时间
				normPMend = DateUtils.strToDate(normFlag, dateTime + " 18:00");// 下午下班时间
				
				//判断是否是休息日或法定假日
				if(checkDateRest(calendar.getTime(),legalHolidays)){
					 //1、该天与结束日期相等
					if(calendar.getTime().getTime() == calendar2.getTime().getTime()){
						// 1、请假结束时间在上午
						// 2、请假结束时间在下午
						if (endDate.getTime() >= normAMstart.getTime() && endDate.getTime() <= normAMend.getTime()) {
							houre += (double) ((endDate.getTime() - normAMstart.getTime()) / (1000 * 60 * 60 * 1.0));
						} else if (endDate.getTime() >= normPMstart.getTime() && endDate.getTime() <= normPMend.getTime()) {
							houre += (endDate.getTime() - normPMstart.getTime()) / (1000 * 60 * 60 * 1.0)+3.5;
						}
					}else{	//2、该天与结束日期不相等
						houre += 7.5;
					}
				}
				calendar.add(Calendar.DAY_OF_MONTH, +1);
			}
		}
		return houre;
	}

	@Override
	public List<Map<String, Object>> getNameList(Map<String, Object> paramsMap) {
		return leaveDao.getNameList(paramsMap);
	}

	@Override
	public List<AdLeave> findByUserId(Integer id) {
		return leaveDao.findByUserId(id);
	}

}