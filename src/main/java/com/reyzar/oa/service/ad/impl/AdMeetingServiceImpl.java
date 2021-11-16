package com.reyzar.oa.service.ad.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.mail.Message.RecipientType;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdMeetingDao;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.domain.AdMeeting;
import com.reyzar.oa.domain.OffNotice;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdMeetingService;

@Service
@Transactional
public class AdMeetingServiceImpl implements IAdMeetingService {
	private final Logger logger = Logger.getLogger(AdMeetingServiceImpl.class);
	@Autowired
	private IAdMeetingDao meetingDao;
	@Autowired
	private IAdRecordDao recordDao;
	@Override
	public AdMeeting findById(Integer id) {
		return meetingDao.findById(id);
	}

	@Override
	public Page<AdMeeting> findByPage(Map<String, Object> params,Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
//		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.MEETING); 
//		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
//		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		return meetingDao.findByPage(params);
	}

	@Override
	public CrudResultDTO save(AdMeeting meeting) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		SysUser user = UserUtils.getCurrUser();
		String number = null;
		try {
			if (meeting.getId() == null) {
				String orderNoBase = new SimpleDateFormat("yyyy").format(new Date()); 
				if (meetingDao.getMaxnumber() == null || "".equals(meetingDao.getMaxnumber()) || meetingDao.getMaxnumber().indexOf(orderNoBase) <= -1) {
					number = orderNoBase+"001";
				}
				else {
					number = (Long.valueOf(meetingDao.getMaxnumber()) + 1) + "";
				}
				meeting.setNumber(number);
				meeting.setApplyTime(new Date());
				meeting.setCreateBy(user.getAccount());
				meeting.setCreateDate(new Date());
				meetingDao.save(meeting);
				if (meeting.getStatus().equals("1")) {
					sendMail(meeting);
					if( UserUtils.getCurrUser() != null ) {
						logger.info("["+UserUtils.getCurrUser().getName()+"]" + "发送了一封会议纪要邮件！公告ID：" + meeting.getId());
					}
				}
			}
			else {
				AdMeeting old = meetingDao.findById(meeting.getId());
				meeting.setUpdateBy(user.getAccount());
				meeting.setUpdateDate(new Date());
				BeanUtils.copyProperties(meeting, old);
				meetingDao.update(old);
				if (old.getStatus().equals("1")) {
					sendMail(old);
					if( UserUtils.getCurrUser() != null ) {
						logger.info("["+UserUtils.getCurrUser().getName()+"]" + "发送了一封会议纪要邮件！公告ID：" + meeting.getId());
					}
				}
			}
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败：" + e.getMessage());
		
		}
		return result;
	}

	@Override
	public CrudResultDTO update(AdMeeting meeting) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		try {
			meeting.setUpdateBy(user.getAccount());
			meeting.setUpdateDate(new Date());
			meetingDao.update(meeting);
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败：" + e.getMessage());
		}
		return result;
	}

	@Override
	public void sendMail(AdMeeting meeting) {
		List<Integer> userIdSet =  Lists.newArrayList();
		List<String> recipientsList = Lists.newArrayList();
		if (meeting.getUserids() != "" && meeting.getUserids() != null) {
			String[] idStr = meeting.getUserids().split(",");
			for (String id : idStr) {
				userIdSet.add(Integer.valueOf(id));
			}
		}
		//获取选取发送人的邮箱
		if (userIdSet.size() > 0) {
			recipientsList = recordDao.findEmailsByUserIdList(userIdSet);
		}
		else {
			recipientsList.add("");
		}
		StringBuffer html = new StringBuffer();
		html.append("<table id=\"table1\" style=\"border:none;margin:5px 20px;\">")
			.append("<thead><tr><th colspan=\"8\" id=\"title\" style=\"padding:0.5em 0px;font-size:1.2em;\">{0}</th></tr></thead>")
			.append("<tbody>")
			.append("<tr><td colspan=\"8\"><div id=\"content\">{1}</div></td></tr>")
			.append("<tr><td><div style=\"padding: 0.5em 0;\"></div></td></tr>");
		html.append("<tr><td style=\"width:80%; text-align:right;\"><span></span></td>")
			.append("<td colspan=\"20\"><div style=\"width:100%;height:100%;border:none;font-size:1em;text-align:center;\">{2}</div></td>")
			.append("</tr><tr><td style=\"width:80%; text-align:right;\"><span></span></td>")
			.append("<td colspan=\"20\"><div style=\"width:100%;height:100%;border:none;font-size:1em;text-align:center;\">{3}</div></td></tr>")
			.append("</tbody></table>");
		
		//构造邮件
		String title = meeting.getTheme();
		if (title.length() > 40) {
			title = title.substring(0, 40) + "......";
		}
//		String subject = title;
		String subject = "OA会议纪要提示";
//		String content = "";
		String content = "<h3>您在OA上收到来自"
				+UserUtils.getCurrUser().getDept().getName()+"的"
				+meeting.getNumber()
				+"号会议纪要，"
				+ "<br>请及时登录OA会议纪要模块进行查阅！</br></h3>";
//		String content = "<h3>"
//				+UserUtils.getCurrUser().getDept().getName()+"员工"+ UserUtils.getCurrUser().getName() +"<span style=\"font-family:微软雅黑, Microsoft YaHei\">发起了"+type
//						+ "申请，"
//				+ "请假起始时间为 "+sdf.format(leave.getStartTime())+"至"+sdf.format(leave.getEndTime())
//				+ ",&nbsp; <br>事由:"+leave.getReason()
//				+ "<br>详情请登陆OA请假管理模块进行查看!</br>"
//				+ "</span>\r\n" + "</h3>";
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		content = MessageFormat.format(html.toString(), meeting.getTheme(), meeting.getComment(), 
//				 UserUtils.getCurrUser().getDept().getName(),sdf.format(meeting.getUpdateDate()));
//		
		// 以线程方式发送邮件，避免邮件发送时间过长，造成前端等待过久
		Thread thread = new Thread() {
			private List<String> recipientsList;
			private String subject;
			private String content;
			private RecipientType recipientType;

			@Override
			public void run() {
				// 发送邮件
				MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType); // 以暗送的方式发送邮件
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
		
		if( !"y".equals(SystemConstant.getValue("devMode")) ) {
			thread.start();
		}
	}
	
	@Override
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功!");
		try {
			if(id != null) {
				AdMeeting meeting = meetingDao.findById(id);
				meetingDao.deleteById(meeting.getId());
			} else {
				result =new CrudResultDTO(CrudResultDTO.FAILED, "没有ID为'" + id + "'的对象！");
			}
		} catch (Exception e) {
			result =new CrudResultDTO(CrudResultDTO.FAILED, "删除失败"+e.getMessage());
			throw new RuntimeException(e.getMessage());
		}
		return result;
	}
}