package com.reyzar.oa.common.timer;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.google.common.collect.Maps;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.dao.IAdLeaveDao;
import com.reyzar.oa.domain.AdLeave;

/** 
* @ClassName: LeaveBackTimer 
* @Description: 自动销假，因为Activiti自动任务并不十分可靠，所以加入自定义销假任务
* @author Lin 
* @date 2017年2月17日 上午9:13:05 
*  
*/
@Component
@Lazy(value=false)
public class LeaveBackTimer {
	
	private final static Logger logger = Logger.getLogger(LeaveBackTimer.class);
	private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private final static String LEAVE_STATUS = "4";
	
	@Autowired
	private IAdLeaveDao leaveDao;
	@Autowired
	private ActivitiUtils activitiUtils;

	@SuppressWarnings("unchecked")
	@Scheduled(cron="0 0 */1 * * ?")
	public void task() {
		String now = dateFormat.format(new Date());
		List<AdLeave> leaveList = leaveDao.findByEndTimeAndStatus(now, LEAVE_STATUS);
		if( leaveList != null && leaveList.size() > 0 ) {
			for(AdLeave leave : leaveList) {
				try {
					List<Task> taskList = activitiUtils.getActivityTask(leave.getProcessInstanceId());
					for(Task task : taskList) {
						Map<String, Object> variables = activitiUtils.getVariablesByTaskid(task.getId());
						List<Map<String, Object>> commentList = (List<Map<String, Object>>)variables.get("commentList");
						Map<String, Object> commentMap = Maps.newHashMap();
						commentMap.put("node", "销假");
						commentMap.put("approver", leave.getApplicant().getName());
						commentMap.put("comment", "自动销假");
						commentMap.put("approveResult", "销假成功");
						commentMap.put("approveDate", new Date());
						commentList.add(commentMap);
						variables.put("commentList", commentList); // 初始化提交申请节点的备注列表
						
						activitiUtils.completeTask(task.getId(), variables);
					}
					
					leave.setStatus("5");
					leave.setBackTime(new Date());
					leave.setBackWay("0");
					leaveDao.update(leave);
				} catch(Exception e) {
					logger.error("自动销假任务发生异常，请假ID["+leave.getId()+"] 异常信息：" + e.getMessage());
				}
			}
		}
	}
}
