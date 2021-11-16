package com.reyzar.oa.service.ad.impl;

import java.text.SimpleDateFormat;
import java.util.*;

import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.dao.IAdRecordDao;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdSealDao;
import com.reyzar.oa.domain.AdSeal;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdSealService;

import javax.mail.Message;

@Service
@Transactional
public class AdSealServiceImpl implements IAdSealService {

	private final static Logger logger = Logger.getLogger(AdSealServiceImpl.class);
	
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdSealDao sealDao;
	@Autowired
	private IAdRecordDao recordDao;
	
	@Override
	public Page<AdSeal> findByPage(Map<String, Object> params, int pageNum,int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.Seal);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		Page<AdSeal> page = sealDao.findByPage(params);
		return page;
	}
	

	@Override
	public AdSeal findById(Integer id) {
		return sealDao.findById(id);
	}

	@Override
	public CrudResultDTO save(AdSeal seal) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;
		try {
			seal.setStatus("0");
			seal.setApplyTime(new Date());
			seal.setCreateBy(user.getAccount());
			seal.setCreateDate(new Date());
			sealDao.save(seal);
			
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			
			businessParams.put("paramValue", new Object[] { seal.getId() }); // 方法参数的值集合
			
			variables.put("businessParams", businessParams);
			
			processInstance = 
					activitiUtils.startProcessInstance(ActivitiUtils.SEAL_KEY, user.getId().toString(), seal.getId().toString(), variables);
			
			// 跳过初始时的提交申请节点
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "提交申请");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "提交成功");
			commentMap.put("approveDate", seal.getCreateDate());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // 初始化提交申请节点的备注列表
			
			List<Task> taskList = activitiUtils.getActivityTask(processInstance
					.getId());
			for (Task task : taskList) {
				if (task.getName().equals("提交申请")) {
					activitiUtils.completeTask(task.getId(), variables);
					break;
				}
			}
			
			// 如果下一位执行者还是当前提交人，则直接执行处理下一步流程
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			// 设置业务表与Activiti表双向关联
			seal.setProcessInstanceId(processInstance.getId());
			seal.setStatus(status);
			sealDao.update(seal);
			
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
	public CrudResultDTO update(AdSeal seal) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		
		seal.setUpdateBy(user.getAccount());
		seal.setUpdateDate(new Date());
		
		AdSeal old = sealDao.findById(seal.getId());
		BeanUtils.copyProperties(seal, old);
		old.setReason(seal.getReason());
		old.setSealType(seal.getSealType());
		sealDao.update(old);
		
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			AdSeal seal = sealDao.findById(id);
			if (seal != null) {
				seal.setStatus(status);
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("操作成功！");
				sealDao.update(seal);
			}
		} catch (Exception e) {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult(e.getMessage());
			e.printStackTrace();
		}
		
		return result;
	}


	/**
	 * 发送邮件
	 */
	@Override
	public CrudResultDTO sendMail(Integer id,String comment){
		CrudResultDTO result = new CrudResultDTO();
		AdSeal adSeal = sealDao.findById(id);
		Integer userId = adSeal.getUserId();
		//获取提交人的邮箱地址
		String userEmail = recordDao.findByUserid(userId).getEmail();
		//存提交人的Email
		List<String> recipientsList=new ArrayList<>();
		recipientsList.add(userEmail);

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		try{
			//构造邮件
			String subject = "OA印章管理提示";
			StringBuffer contentBuffer=new StringBuffer();
			contentBuffer.append("<h3>");
			contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">印章管理通知!");
			contentBuffer.append("</h3><br>您于：");
			contentBuffer.append(sdf.format(adSeal.getApplyTime())+"&nbsp;");
			contentBuffer.append("<br>提交的用章申请被退回");
			contentBuffer.append("<br>流程备注为:");
			contentBuffer.append(comment+"<br>");
			contentBuffer.append("<br>详情请登陆OA用章管理模块进行查看!</br></span>\r\n");
			String content=contentBuffer.toString();
			//以线程方式发送邮件，避免邮件发送时间过长，造成前端等待过久
			Thread thread = new Thread() {
				private List<String> recipientsList;
				private String subject;
				private String content;
				private Message.RecipientType recipientType;

				@Override
				public void run() {
					// 发送邮件
					MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType); // 以暗送的方式发送邮件
				}

				public Thread setParams(List<String> recipientsList, String subject, String content, Message.RecipientType recipientType) {
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
			logger.info("发送了一封用章邮件！收款ID：" + adSeal.getId());
			for (String email:recipientsList) {
				logger.info("向"+email+"发送了一封用章邮件！");
			}
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult("发送成功！");
		}catch (Exception e){
			e.printStackTrace();
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("发送失败！");
		}
		return result;
	}

}