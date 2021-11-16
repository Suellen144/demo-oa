package com.reyzar.oa.common.timer;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.reyzar.oa.dao.IAdKpiAttachDao;
import com.reyzar.oa.dao.IAdKpiDao;
import com.reyzar.oa.dao.JobManagerDao;
import com.reyzar.oa.domain.AdKpi;
import com.reyzar.oa.domain.AdKpiAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

@Component
@Lazy(value = false)
public class InsertKpiTimer {

	@Autowired
	private IAdKpiDao kpiDao;
	@Autowired
	private IAdKpiAttachDao kpiAttachDao;
	@Autowired
	private JobManagerDao jobManagerDao;
	@Autowired
	private ISysUserService userService;
	@Autowired
	private ISysDeptService deptService;

	private final static Logger logger = Logger.getLogger(InsertKpiTimer.class);
	private static String serverIp = null;

	static {
		// 获取服务器的IP地址，便于后续追踪
		try {
			InetAddress address = InetAddress.getLocalHost();
			serverIp = address.getHostAddress();
		} catch (Exception e) {
			logger.error("获取服务器IP地址有误！！");
			e.printStackTrace();
		}
	}
	
	@Scheduled(cron = "0 59 23 31 1 ?")
	@Scheduled(cron = "0 59 23 28 2 ?")
	@Scheduled(cron = "0 59 23 30 3 ?")
	@Scheduled(cron = "0 59 23 28 4 ?")
	@Scheduled(cron = "0 59 23 31 5 ?")
	@Scheduled(cron = "0 59 23 29 6 ?")
	@Scheduled(cron = "0 59 23 31 7 ?")
	@Scheduled(cron = "0 59 23 30 8 ?")
	@Scheduled(cron = "0 59 23 28 9 ?")
	@Scheduled(cron = "0 59 23 31 10 ?")
	@Scheduled(cron = "0 59 23 29 11 ?")
	@Scheduled(cron = "0 59 23 31 12 ?")
	public void change() {
		String jobName = "绩效考核";
		String status = "off";
		Map<String, Object> map = new HashMap<>();
		if(jobManagerDao.getJobOff(jobName) == 0) {
			map.put("jobName", jobName);
			map.put("serverIp", serverIp);
			map.put("status", status);
			jobManagerDao.updateJobStatus(map);
		}
	}
	
	@Scheduled(cron = "0 01 09 31 1 ?")
	@Scheduled(cron = "0 01 09 28 2 ?")
	@Scheduled(cron = "0 01 09 30 3 ?")
	@Scheduled(cron = "0 01 09 28 4 ?")
	@Scheduled(cron = "0 01 09 31 5 ?")
	@Scheduled(cron = "0 01 09 29 6 ?")
	@Scheduled(cron = "0 01 09 31 7 ?")
	@Scheduled(cron = "0 01 09 30 8 ?")
	@Scheduled(cron = "0 30 15 28 9 ?")
	@Scheduled(cron = "0 01 09 31 10 ?")
	@Scheduled(cron = "0 01 09 29 11 ?")
	@Scheduled(cron = "0 01 09 31 12 ?")
	public void task() {
		logger.info("job start");
		String jobName = "绩效考核";
		long startTime = new Date().getTime();
		try {
			if (canExecute(jobName)) {
				insert();
				logger.info(jobName + "执行完成，耗时:" + (new Date().getTime() - startTime) + "毫秒！");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private Boolean canExecute(String jobName) throws Exception {
		int max = 10000;
		int min = (int) Math.round(Math.random() * 8000);
		long sleepTime = Math.round(Math.random() * (max - min));
		String status = "on";
		Thread.sleep(sleepTime);

		if (jobManagerDao.getJobOff(jobName) == 1) {
			Map<String, Object> map = new HashMap<>();
			map.put("jobName", jobName);
			map.put("serverIp", serverIp);
			map.put("status", status);
			jobManagerDao.updateJobStatus(map);
			return true;
		}
		logger.info(jobName + "已被其他服务器执行");
		return false;
	}

	public void insert() {
		SimpleDateFormat sdf0 = new SimpleDateFormat("yyyy-MM");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("date", sdf0.format(new Date()));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		List<SysUser> userList = userService.findAll();
		/** 获取本月离职人员 */
		Date date = new Date();
		SimpleDateFormat updateTime = new SimpleDateFormat("yyyy-MM");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("updateTime", updateTime.format(date));
		List<SysUser> userList2 = userService.findDeleteUsersByMonth(params);
		/** 获取本月离职人员结束 */
		List<SysDept> deptList = deptService.findByGenerateKpi();
		for (SysDept dept : deptList) {
				AdKpi kpi = new AdKpi();
				kpi.setDeptId(dept.getId());
				kpi.setDate(new Date());
				kpi.setTime(sdf.format(new Date()));
				kpi.setCreateDate(new Date());
				kpiDao.save(kpi);
		}
		for (SysUser user : userList) {
			if (user.getId() != 1 && user.getId() != 2 && user.getDeptId() != null) {
				AdKpiAttach kpiAttach = new AdKpiAttach();
					AdKpi kpi = kpiDao.findBydeptIdAndDate(user.getDeptId(), sdf.format(new Date()));
					if(kpi!=null) {
						SysDept sysDept=deptService.findById(user.getDeptId());
						if(sysDept!=null) {
							kpiAttach.setKpiId(kpi.getId());
							kpiAttach.setUserName(user.getName());
							kpiAttach.setUserId(user.getId());
							kpiAttach.setDeptName(sysDept.getName());
							kpiAttach.setDeptId(user.getDeptId());
							kpiAttach.setDate(new Date());
							kpiAttach.setCreateDate(new Date());
							kpiAttachDao.save(kpiAttach);
						}
					}
			}
		}
		for (SysUser user : userList2) {
			if (user.getId() != 1 && user.getId() != 2 && user.getDeptId() != null) {
				AdKpiAttach kpiAttach = new AdKpiAttach();
					AdKpi kpi = kpiDao.findBydeptIdAndDate(user.getDeptId(), sdf.format(new Date()));
					if(kpi!=null) {
						SysDept sysDept=deptService.findById(user.getDeptId());
						if(sysDept!=null) {
							kpiAttach.setKpiId(kpi.getId());
							kpiAttach.setUserName(user.getName());
							kpiAttach.setUserId(user.getId());
							kpiAttach.setDeptName(sysDept.getName());
							kpiAttach.setDeptId(user.getDeptId());
							kpiAttach.setDate(new Date());
							kpiAttach.setCreateDate(new Date());
							kpiAttachDao.save(kpiAttach);
						}
					}
			}
		}
	}
}
