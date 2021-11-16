package com.reyzar.oa.common.timer;

import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.reyzar.oa.dao.JobManagerDao;
import com.reyzar.oa.domain.OffNotice;
import com.reyzar.oa.service.office.IOffNoticeService;

/** 
* @ClassName: NoticeTimer 
* @Description: 信息发布定时器。定时扫描未发送过邮件通知的公告
* @author Lin 
* @date 2017年2月7日 下午3:08:38 
*  
*/
@Component
@Lazy(value=false)
public class NoticeTimer {
	
	private final static Logger logger = Logger.getLogger(NoticeTimer.class);
	
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
	private IOffNoticeService noticeService;
	
	@Autowired
	private JobManagerDao jobManagerDao;
	
	@Scheduled(cron = "*/30 * * * * ?")
	public void change() {
		String jobName = "信息发布";
		String status = "off";
		Map<String, Object> map = new HashMap<>();
		if(jobManagerDao.getJobOff(jobName) == 0) {
			map.put("jobName", jobName);
			map.put("serverIp", serverIp);
			map.put("status", status);
			jobManagerDao.updateJobStatus(map);
		}
	}
	
	@Scheduled(cron="0 */1 * * * ?")
	public void task() {
		String jobName = "信息发布";
		try {
			if(canExecute(jobName)) {
				send();
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	public void send() {
		List<OffNotice> noticeList = noticeService.getUnpublishNotice();
		if( noticeList != null && noticeList.size() > 0 ) {
			for(OffNotice notice : noticeList) {
				try {
					noticeService.sendMail(notice);
					notice.setIsPublished(1);
					logger.info("信息发布定时任务自动发送了一封公告邮件！公告ID：" + notice.getId());
				} catch(Exception e) { 
					logger.error("信息发布定时任务发送邮件失败！公告ID：["+notice.getId()+"]    失败信息："+e.getMessage()); 
				}
			}
			noticeService.batchUpdateIsPublished(noticeList);
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
