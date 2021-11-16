package com.reyzar.oa.common.timer;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.ISysProcessTodoNoticeDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.dao.JobManagerDao;
import com.reyzar.oa.domain.SysProcessTodoNotice;
import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: ProcessRemindTimer 
* @Description: 流程处理提醒任务。定时查询是否有未处理的流程任务，用邮件提醒
* @author Lin 
* @date 2017年2月16日 上午11:46:24 
*  
*/
@Component
@Lazy(value=false)
public class ProcessRemindTimer {

	private final static Logger logger = Logger.getLogger(ProcessRemindTimer.class);
	private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	private static String executeDate = ""; // 执行日期
	private final static int EXECUTE_HOUR = 9; // 第几小时才执行
	
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
	
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private ISysUserDao userDao;
	@Autowired
	private ISysProcessTodoNoticeDao processTodoNoticeDao;
	@Autowired
	private IAdRecordDao recordDao;
	@Autowired
	private JobManagerDao jobManagerDao;
	
	@Scheduled(cron = "0 */30 * * * ?")
	public void change() {
		String jobName = "流程处理";
		String status = "off";
		Map<String, Object> map = new HashMap<>();
		if(jobManagerDao.getJobOff(jobName) == 0) {
			map.put("jobName", jobName);
			map.put("serverIp", serverIp);
			map.put("status", status);
			jobManagerDao.updateJobStatus(map);
		}
	}
	
	@Scheduled(cron="0 0 */1 * * ?")
	public void task() {
		String jobName = "流程处理";
		try {
			if(canExecute(jobName)) {
				send();
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	public void send() {
		try {
			String today = dateFormat.format(new Date());
			int hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
			
			// 今天已执行过任务检测，则退出方法等明天再执行
			if( (!"".equals(executeDate) && today.equals(executeDate)) || hour < EXECUTE_HOUR ) {
				return ;
			} else {
				int count = processTodoNoticeDao.countBySendDate(today);
				if(count > 0) {
					return ;
				}
			}
			
			// 计算出所有任务的办理人
			List<Task> taskList = activitiUtils.findAllTask();
			Map<String, List<Integer>> taskUserMap = Maps.newHashMap();
			if( taskList != null ) {
				for(Task task : taskList) {
					List<String> taskUserList = activitiUtils.findAllTaskUser(task.getId());
					List<Integer> userIdList = Lists.newArrayList();
					
					for(String user : taskUserList) {
						if( user.startsWith("user_") ) {
							userIdList.add( Integer.valueOf(user.split("_")[1]) );
						} else {
							String positionId = user.split("_")[1];
							List<SysUser> userList = userDao.findByPositionId(Integer.valueOf(positionId));
							for(SysUser tempUser : userList) {
								userIdList.add(tempUser.getId());
							}
						}
					}
					taskUserMap.put(task.getId(), userIdList);
				}
			}
			
			// 过滤掉已发送过邮件的用户任务
			Set<String> keys = taskUserMap.keySet();
			Iterator<String> itKeys = keys.iterator();
			while( itKeys.hasNext() ) {
				String taskId = itKeys.next();
				List<Integer> userIdList = taskUserMap.get(taskId);
				if( userIdList.size() == 1 ) {
					int count = processTodoNoticeDao.countByTaskIdAndUserId(taskId, userIdList.get(0));
					if(count > 0) { userIdList.clear(); }
				} else if(userIdList.size() > 1) {
					Iterator<Integer> itUserId = userIdList.iterator();
					while( itUserId.hasNext() ) {
						int count = processTodoNoticeDao.countByTaskIdAndUserId(taskId, itUserId.next());
						if(count > 0) {
							itUserId.remove();
						}
					}
				}
			}
			
			// 获取用户ID集合，用以查找用户邮箱帐号
			Set<Integer> userIdSet = Sets.newHashSet();
			List<SysProcessTodoNotice> processTodoNoticeList = Lists.newArrayList();
			itKeys = keys.iterator();
			while( itKeys.hasNext() ) {
				String taskId = itKeys.next();
				List<Integer> userIdList = taskUserMap.get(taskId);
				if( userIdList.size() == 1 ) {
					userIdSet.add(userIdList.get(0));
					
					SysProcessTodoNotice processTodoNotice = new SysProcessTodoNotice();
					processTodoNotice.setTaskId(taskId);
					processTodoNotice.setUserId(userIdList.get(0));
					processTodoNotice.setSendDate(today);
					processTodoNoticeList.add(processTodoNotice);
					
				} else if(userIdList.size() > 1) {
					for(Integer userId : userIdList) {
						userIdSet.add(userId);
						
						SysProcessTodoNotice processTodoNotice = new SysProcessTodoNotice();
						processTodoNotice.setTaskId(taskId);
						processTodoNotice.setUserId(userId);
						processTodoNotice.setSendDate(today);
						processTodoNoticeList.add(processTodoNotice);
					}
				}
			}
			
			if( userIdSet.size() > 0 ) {
				List<String> emailList = recordDao.findEmailsByUserIdList(new ArrayList<Integer>(userIdSet));
				
				StringBuffer receiver = new StringBuffer();
				if( emailList != null ) {
					for(String email : emailList) {
						receiver.append(email);
						receiver.append(",");
					}
				}
				logger.info("执行待办流程提醒任务！办理人列表：[" + receiver.delete(receiver.length()-1, receiver.length()) + "]");
				
				if( "y".equals(SystemConstant.getValue("devMode")) ) {
					emailList.clear();
				}
				MailUtils.sendHtmlMail(emailList, "流程任务待办提醒", "<h3>您在OA上有待办流程任务，请及时登录OA进行处理！</h3>");
				
				processTodoNoticeDao.batchSave(processTodoNoticeList);
				executeDate = today;
			}
		} catch(Exception e) {
			logger.error("执行检测流程待办任务异常，异常信息：" + e.getMessage());
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
	
}
