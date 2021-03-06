package com.reyzar.oa.service.office.impl;

import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.mail.Message.RecipientType;

import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.IOffNoticeDao;
import com.reyzar.oa.dao.IOffNoticeReadDao;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.OffNotice;
import com.reyzar.oa.domain.OffNoticeRead;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.office.IOffNoticeService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.impl.SysUserServiceImpl;

@Service
@Transactional
public class OffNoticeServiceImpl implements IOffNoticeService {
	
	private final Logger logger = Logger.getLogger(OffNoticeServiceImpl.class);
	
	@Autowired
	private IOffNoticeDao noticeDao;
	@Autowired
	private IOffNoticeReadDao noticeReadDao;
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private IAdRecordDao recordDao;
	@Autowired
	private SysUserServiceImpl userService;
	@Autowired
	private ActivitiUtils activitiUtils;
	
	/**??????????????????*/
	@Override
	public int getUnreadCount(Map<String, Object> params) {
		return noticeDao.getUnreadCount(params);
	}
	
	@Override
	public List<OffNotice> findAll() {
		Map<String, Object> listMap=new HashMap<String, Object>();
		return noticeDao.findByPage(listMap);
	}

	@Override
	public Page<OffNotice> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<OffNotice> page = noticeDao.findByPage(params);
		
		// ??????????????????
		List<Integer> idList = Lists.newArrayList();
		for(OffNotice notice : page) {
			idList.add(notice.getId());
			notice.setIsRead(false); // ????????????
		}
		
		params.put("noticeIdList", idList);
		List<Map<String, Object>> readNoticeList = noticeReadDao.getReadNotice(params);
		
		// ??????????????????
		if(readNoticeList != null && readNoticeList.size() > 0) {
			Set<Object> ids = Sets.newHashSet(); 
			for(Map<String, Object> map : readNoticeList) {
				ids.addAll(map.values());
			}
			for(OffNotice notice : page) {
				if(ids.contains(notice.getId())) {
					notice.setIsRead(true);
				} else {
					notice.setIsRead(false);
				}
			}
		}
		
		return page;
	}

	@Override
	public Page<OffNotice> findPointByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<OffNotice> page = noticeDao.findPointByPage(params);
		
		// ??????????????????
		List<Integer> idList = Lists.newArrayList();
		for(OffNotice notice : page) {
			idList.add(notice.getId());
			notice.setIsRead(false); // ????????????
		}
		
		params.put("noticeIdList", idList);
		List<Map<String, Object>> readNoticeList = noticeReadDao.getReadNotice(params);
		
		// ??????????????????
		if(readNoticeList != null && readNoticeList.size() > 0) {
			Set<Object> ids = Sets.newHashSet(); 
			for(Map<String, Object> map : readNoticeList) {
				ids.addAll(map.values());
			}
			for(OffNotice notice : page) {
				if(ids.contains(notice.getId())) {
					notice.setIsRead(true);
				} else {
					notice.setIsRead(false);
				}
			}
		}
		
		return page;
	}
	@Override
	public CrudResultDTO save(OffNotice notice, SysUser user) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		ProcessInstance processInstance = null;
		String approveStatus = notice.getApproveStatus();
		try {
			if(notice.getId() != null) {
				OffNotice old = noticeDao.findById(notice.getId());
				if( !"1".equals(old.getApproveStatus()) ) { // ?????????????????????????????????????????????????????????????????????????????????????????????
					BeanUtils.copyProperties(notice, old);
					old.setUpdateBy(user.getAccount());
					old.setUpdateDate(new Date());
					if("2".equals(approveStatus)) { // ????????????????????????????????????????????????????????????????????????????????????????????????
						old.setApproveStatus("0");
					}
					
					noticeDao.update(old);
				}
				notice = old;
			} else {
				// ??????????????????
				if( "2".equals(notice.getType()) ) { // ??????????????????????????????
					notice.setApproveStatus("1");
				} else {
					notice.setApproveStatus("0");
				}
				notice.setIsDeleted("0");
				notice.setUserId(user.getId());
				notice.setCreateBy(user.getAccount());
				notice.setCreateDate(new Date());
				notice.setUpdateBy(user.getAccount());
				notice.setUpdateDate(new Date());
				
				noticeDao.save(notice);
				
				if( "2".equals(notice.getType()) ) { // ????????????????????????????????????????????????
					if( notice.getPublishTime() == null ) {
						notice.setActualPublishTime(new Date());
						sendMail(notice);
						notice.setIsPublished(1);
					} else {
						notice.setActualPublishTime(notice.getPublishTime());
					}
					noticeDao.update(notice);
				}
			}
			
			// ???????????????????????????????????????????????????????????????????????????
			if( (approveStatus == null || "".equals(approveStatus.trim()) || "2".equals(approveStatus)) && !"2".equals(notice.getType()) ) {
				Map<String, Object> variables = Maps.newHashMap();
				Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
				businessParams.put("class", this.getClass().getName()); // ?????????????????????
				businessParams.put("method", "findById"); // ????????????
				businessParams.put("paramValue", new Object[] { notice.getId() }); // ????????????????????????
				
				variables.put("businessParams", businessParams);
				processInstance = 
						activitiUtils.startProcessInstance(ActivitiUtils.NOTICE_KEY, user.getId().toString(), notice.getId().toString(), variables);
				
				notice.setProcessInstanceId(processInstance.getId());
				noticeDao.update(notice);
			}
			
		} catch(Exception e) {
			if(processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????" + e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}
	
	@Override
	public CrudResultDTO update(OffNotice notice) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		
		OffNotice old = noticeDao.findById(notice.getId());
		BeanUtils.copyProperties(notice, old);
		old.setUpdateBy(UserUtils.getCurrUser().getAccount());
		old.setUpdateDate(new Date());
		
		noticeDao.update(old);
		
		return result;
	}

	@Override
	public OffNotice findById(Integer id) {
		OffNotice notice = noticeDao.findById(id);
		
		String deptIds = notice.getDeptIds();
		if(StringUtils.isNotBlank(deptIds)) {
			List<Integer> idList = Lists.newArrayList();
			String[] deptIdList = deptIds.split(",");
			for(String deptId : deptIdList) {
				idList.add(Integer.valueOf(deptId));
			}
			if(idList.size() > 0) {
				notice.setDeptList(deptService.findByIds(idList));
			}
		}
		notice.setUser(userService.findById(notice.getUserId()));
		if( notice.getPublisherId() == null ) {
			notice.setPublisherId(notice.getUser().getDeptId());
		}
		notice.setPublishers(deptService.findById(notice.getPublisherId()));
		
		return notice;
	}

	//??????ID????????????
	@Override
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "????????????!");
		try {
			if(id != null) {
				OffNotice notice = noticeDao.findById(id);
				notice.setIsDeleted("1");
				noticeDao.update(notice);
			} else {
				result =new CrudResultDTO(CrudResultDTO.FAILED, "??????ID???'" + id + "'????????????");
			}
		} catch (Exception e) {
			result =new CrudResultDTO(CrudResultDTO.FAILED, "????????????"+e.getMessage());
			throw new RuntimeException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO setReadStatus(Integer noticeId) {
		int count = noticeReadDao.getCountByUserIdWithNoticeId(UserUtils.getCurrUser().getId(), noticeId);
		if( count <= 0 ) {
			OffNoticeRead noticeRead = new OffNoticeRead();
			noticeRead.setUserId(UserUtils.getCurrUser().getId());
			noticeRead.setNoticeId(noticeId);
			noticeRead.setReadTime(new Date());
			
			noticeReadDao.save(noticeRead);
		}
		
		return new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
	}

	@Override
	public CrudResultDTO setApproveStatus(Integer id, String approveStatus) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "????????????!");
		
		OffNotice notice = noticeDao.findById(id);
		notice.setApproveStatus(approveStatus);
		noticeDao.update(notice);
		
		return result;
	}
	
	@Override
	public void sendMail(OffNotice notice) {
		Set<Integer> deptIdSet = Sets.newHashSet();
		
		// ???????????????????????????????????????
		if( notice.getDeptIds() == null || "".equals(notice.getDeptIds().trim()) ) {
			List<SysDept> deptList = deptService.findAll();
			for(SysDept dept : deptList) {
				deptIdSet.add(dept.getId());
			}
		} else {
			String[] idStr = notice.getDeptIds().split(",");
			for(String id : idStr) {
				List<Integer> tempIdList = Lists.newArrayList();
				SysDept tempDept = deptService.findById(Integer.valueOf(id));
				deptService.getIds(tempDept, tempIdList);
				
				deptIdSet.addAll(tempIdList);
			}
		}
		
		// ??????????????????
		String deptName = "";
		if(notice.getPublisherId() == null) {
			SysUser user = userService.findById(notice.getUserId());
			notice.setPublisherId(user.getDept().getId());
			notice.setPublishers(user.getDept());
		} else {
			notice.setPublishers(deptService.findById(notice.getPublisherId()));
		}
		String[] nodeLinks = notice.getPublishers().getNodeLinks().split(",");
		if( nodeLinks.length <= 3 && nodeLinks[nodeLinks.length-1].equals(notice.getPublisherId().toString()) ) { // ???????????????????????????????????????????????????
			deptName = notice.getPublishers().getName();
		} else {
			SysDept dept = deptService.findById( Integer.valueOf(nodeLinks[2]) ); // nodelinks[0]=-1, nodelinks[1]=???????????????, nodelinks[2]=??????
			if( notice.getPublishers().getName().indexOf("?????????") > -1 
					|| notice.getPublishers().getName().indexOf("????????????") > -1 ) { // ?????????????????????????????????????????????????????????????????????
				deptName = dept.getName();
			} else {
				deptName = dept.getName() + " " + notice.getPublishers().getName();
			}
		}
		
		// ?????????????????????????????????????????????
		List<AdRecord> recordList = recordDao.findByDeptIds(Lists.newArrayList(deptIdSet));
		List<String> recipientsList = Lists.newArrayList();
		for(AdRecord record : recordList) {
			if(record.getEmail() != null && !"".equals(record.getEmail())) {
				recipientsList.add(record.getEmail());
			}
		}
		// ??????HTML?????????
		StringBuffer html = new StringBuffer();
		html.append("<table id=\"table1\" style=\"border:none;margin:5px 20px;\">")
			.append("<thead><tr><th colspan=\"8\" id=\"title\" style=\"padding:0.5em 0px;font-size:1.2em;\">{0}</th></tr></thead>")
			.append("<tbody>")
			.append("<tr><td colspan=\"8\"><div id=\"content\">{1}</div></td></tr>")
			.append("<tr><td><div style=\"padding: 0.5em 0;\"></div></td></tr>");
			if(notice.getAttachName() != null && !"".equals(notice.getAttachName().trim())) { // ?????????????????????
				html.append("<tr><td colspan=\"20\" style=\"padding:0px;\"><span>?????????{4}??????????????????????????????OA???????????????</span></td></tr>");
			}
		html.append("<tr><td style=\"width:80%; text-align:right;\"><span></span></td>")
			.append("<td colspan=\"20\"><div style=\"width:100%;height:100%;border:none;font-size:1em;text-align:center;\">{2}</div></td>")
			.append("</tr><tr><td style=\"width:80%; text-align:right;\"><span></span></td>")
			.append("<td colspan=\"20\"><div style=\"width:100%;height:100%;border:none;font-size:1em;text-align:center;\">{3}</div></td></tr>")
			.append("</tbody></table>");
		
		// ????????????
		String title = notice.getTitle();
		if(title.length() > 40) {
			title = title.substring(0, 40) + "......";
		}
		String subject = title;
		String content = "";
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if(notice.getAttachName() != null && !"".equals(notice.getAttachName().trim())) { // ?????????????????????
			content = MessageFormat.format(html.toString(), notice.getTitle(), notice.getContent(), 
					deptName, sdf.format(notice.getActualPublishTime()), notice.getAttachName()); 
		} else {
			content = MessageFormat.format(html.toString(), notice.getTitle(), notice.getContent(), 
					deptName, sdf.format(notice.getActualPublishTime()));
		}
		
		// ???????????????????????????????????????????????????????????????????????????????????????
		Thread thread = new Thread() {
			private List<String> recipientsList;
			private String subject;
			private String content;
			private RecipientType recipientType;
			
			@Override
			public void run() {
				// ????????????
				MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType); // ??????????????????????????????
			}
			
			public Thread setParams(List<String> recipientsList, String subject, String content, RecipientType recipientType) {
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
		
		if( UserUtils.getCurrUser() != null ) {
			logger.info("["+UserUtils.getCurrUser().getName()+"]" + "????????????????????????????????????ID???" + notice.getId());
		}
	}

	@Override
	public List<OffNotice> getUnpublishNotice() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String now = dateFormat.format(new Date());
		
		return noticeDao.getUnpublishNotice(now);
	}

	@Override
	public void batchUpdateIsPublished(List<OffNotice> noticeList) {
		noticeDao.batchUpdateIsPublished(noticeList);
	}

	@Override
	public List<OffNotice> getTop5Notice(Map<String, Object> params) {
		List<OffNotice> page = noticeDao.getTop5Notice(params);
		// ??????????????????
		List<Integer> idList = Lists.newArrayList();
		for(OffNotice notice : page) {
			idList.add(notice.getId());
			notice.setIsRead(false); // ????????????
		}
				
		params.put("noticeIdList", idList);
		List<Map<String, Object>> readNoticeList = noticeReadDao.getReadNotice(params);
				
		// ??????????????????
		if(readNoticeList != null && readNoticeList.size() > 0) {
			Set<Object> ids = Sets.newHashSet(); 
			for(Map<String, Object> map : readNoticeList) {
				ids.addAll(map.values());
			}
			for(OffNotice notice : page) {
				if(ids.contains(notice.getId())) {
					notice.setIsRead(true);
				} else {
					notice.setIsRead(false);
				}
			}
		}
		return page;
	}
		
	@Override
	public int getNoticeCount(Map<String, Object> params) {
		return noticeDao.getNoticeCount(params);
	}
	
}
