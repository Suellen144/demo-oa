package com.reyzar.oa.service.finance.impl;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.mail.Message;
import com.reyzar.oa.common.util.*;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.IFinCollectionDao;
import com.reyzar.oa.dao.IFinPayAttachDao;
import com.reyzar.oa.dao.IFinPayDao;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinPay;
import com.reyzar.oa.domain.FinPayAttach;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.service.finance.FinPayService;

/** 
* @ClassName: FinInvestServiceImpl 
* @Description: 费用归属
* @author Lin 
* @date 2016年10月26日 上午10:40:07 
*  
*/
@Service
@Transactional
public class FinPayServiceImpl implements FinPayService {
	
	private final static Logger logger = Logger.getLogger(FinPayServiceImpl.class);
	
	@Autowired
	private IFinPayDao finPayDao;
	
	@Autowired
	private IFinPayAttachDao payAttachDao;
	
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdRecordDao iAdRecordDao;
	
	@Autowired
	private ISaleBarginManageDao barginManageDao;
	
	@Autowired
	private ISaleProjectManageDao projectManageDao;
	
	@Autowired
	private IFinCollectionDao collectionDao;
	
	@Autowired
	private IUserPositionDao userPositionDao;
	
	@Autowired
	private ISysUserDao iSysUserDao;
	
	@Override
	public Page<FinPay> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.PAY);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		Page<FinPay> page = null;
		if (user.getId().equals(36) || user.getId().equals(50)){
			 page = finPayDao.findByOne(params);
		}
		else {
			 page = finPayDao.findByPage(params);
		}
		return page;
	}

	@Override
	public Page<FinPay> findByPage2(Map<String, Object> params, Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.PAY);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		Page<FinPay> page = null;
		if (user.getId().equals(36) || user.getId().equals(50)){
			page = finPayDao.findByOne2(params);
		}
		else {
			page = finPayDao.findByPage2(params);
		}
		return page;
	}
	
	@Override
	public Page<FinPay> findByPageNew(Map<String, Object> params, Integer pageNum, Integer pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.PAY);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, 1000);
		Page<FinPay> page = null;
			 page = finPayDao.findByPageNew(params);
		return page;
	}
	
	@Override
	public CrudResultDTO saveInfo(JSONObject json) {		
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		
		FinPay finPay = json.toJavaObject(FinPay.class);
		
		SysUser user = UserUtils.getCurrUser();
		try {
			if (finPay.getId() == null) {
				finPay.setCreateBy(user.getAccount());
				finPay.setCreateDate(new Date());
				finPay.setUserId(user.getId());
				finPay.setDeptId(user.getDeptId());
				finPay.setStatus(null);
				if (!finPay.getInvoiceCollect().equals("1")) {
					finPay.setInvoiceMoney(0.00);
				}
				finPayDao.save(finPay);
			}else {				
				FinPay originFinPay = finPayDao.findById(finPay.getId());
				
				if (!finPay.getInvoiceCollect().equals("1")) {
					finPay.setInvoiceMoney(0.00);
				}
				finPay.setUpdateBy(UserUtils.getCurrUser().getAccount());
				finPay.setUpdateDate(new Date());
				if(StringUtils.equals(originFinPay.getStatus(),"7")
						|| StringUtils.equals(originFinPay.getStatus(),"8")
						|| StringUtils.equals(originFinPay.getStatus(),"9")){
					//重新提交时，修改appleTime
					finPay.setApplyTime(new Date());
				}else {
					finPay.setApplyTime(originFinPay.getApplyTime());
				}
				BeanUtils.copyProperties(finPay, originFinPay);
				finPayDao.update(originFinPay);
				if(finPay.getPayAttachList() != null) {
					/*	此处更新付款录入数据*/
					//判断是否有pay附表
					if (finPay.getPayAttachList().size() > 0) {
						//从数据库查找出当前payAttach附表
						List<FinPayAttach> orginPayAttachList = payAttachDao.findByPayId(finPay.getId());
						//从finPay集合中查出payAttach附表
						List<FinPayAttach> payAttachList = finPay.getPayAttachList();

						List<FinPayAttach> saveList = Lists.newArrayList();
						List<FinPayAttach> updateList = Lists.newArrayList();
						List<Integer> delList = Lists.newArrayList();

						Map<Integer, FinPayAttach> orginFinPayMap = Maps.newHashMap();

						for (FinPayAttach payAttach : orginPayAttachList) {
							orginFinPayMap.put(payAttach.getId(), payAttach);
						}
						//判断哪些是新增的附表
						for (FinPayAttach attach : payAttachList) {
							FinPayAttach orgin = orginFinPayMap.get(attach.getId());
							if (orgin != null) {
								//更新的附表
								BeanUtils.copyProperties(attach, orgin);
								updateList.add(orgin);
								orginFinPayMap.remove(orgin.getId());
							} else {
								//新增的附表
								attach.setPayId(finPay.getId());
								attach.setCreateBy(user.getAccount());
								attach.setCreateDate(new Date());
								attach.setUpdateBy(user.getAccount());
								attach.setUpdateDate(new Date());
								saveList.add(attach);
							}
						}
						delList.addAll(orginFinPayMap.keySet());

						if (saveList.size() > 0) {
							payAttachDao.insertAll(saveList);
						}
						if (updateList.size() > 0) {
							payAttachDao.batchUpdate(updateList);
						}
						if (delList.size() > 0) {
							payAttachDao.deleteByIdList(delList);
						}
					}
				}				
			}
			updateBargin(finPay);
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public FinPay findById(Integer id) {		
		return finPayDao.findById(id);
	}

	@Override
	public CrudResultDTO submit(JSONObject json) {		
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		
		FinPay finPay = json.toJavaObject(FinPay.class);
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;
		
		try {
			SaleProjectManage project = projectManageDao.findById(finPay.getProjectManageId());
			SysUserPosition userPosition = new SysUserPosition();
			if(project != null && project.getDutyDeptId() != null) {
				userPosition = userPositionDao.findByDeptAndLevel(project.getDutyDeptId());
			}else if(project.getUserId()!=null) {
				SysUser sysUser=iSysUserDao.findById(project.getUserId());
					userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
			}
		
			
			if (finPay.getId() == null) {
				finPay.setCreateBy(user.getAccount());
				finPay.setCreateDate(new Date());
				finPay.setApplyTime(new Date());
				finPay.setUserId(user.getId());
				finPay.setDeptId(user.getDeptId());
				finPay.setStatus(null);
				finPayDao.save(finPay);
				
				// 启动收款流程
				Map<String, Object> variables = Maps.newHashMap();
				Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
				businessParams.put("class", this.getClass().getName()); // 要反射的类全名
				businessParams.put("method", "findById"); // 调用方法
				businessParams.put("paramValue", new Object[] { finPay.getId() }); // 方法参数的值集合
			
				variables.put("businessParams", businessParams);
				variables.put("approved", true);
				//判断负责人是否为null，如不为空则需要负责人审批
				if(project.getUserId()!=null) {
					variables.put("userId", project.getUserId());
					variables.put("userId2", userPosition.getUserId());
					variables.put("toHead1",true);
					variables.put("isNewPay", true);
				}else {
					SysUser sysUser=iSysUserDao.findById(user.getId());
    				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
    				variables.put("userId", user.getId());
    				variables.put("userId2", userPosition.getUserId());
					variables.put("toHead1",true);
					variables.put("isNewPay", true);
				}
				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.PAY, user.getId().toString(), finPay.getId().toString(), variables);
				
				// 跳过初始时的提交申请节点
				List<Map<String, Object>> commentList = Lists.newArrayList(); 
				Map<String, Object> commentMap = Maps.newHashMap();
				commentMap.put("node", "提交申请");
				commentMap.put("approver", user.getName());
				commentMap.put("comment", "");
				commentMap.put("approveResult", "提交成功");
				commentMap.put("approveDate", new Date());
				commentList.add(commentMap);
				variables.put("commentList", commentList); // 初始化提交申请节点的备注列表
				
				List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
				for(Task task : taskList) {
					if(task.getName().equals("提交申请")) {
						activitiUtils.completeTask(task.getId(), variables);
						break ;
					}
				}
				
				//如果下一位执行者还是当前提交人，则直接执行处理下一步流程
				String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
				// 设置业务表与Activiti表双向关联
				finPay.setProcessInstanceId(processInstance.getId());
				finPay.setStatus(status);
				finPayDao.update(finPay);
			}else {				
				FinPay originFinPay = finPayDao.findById(finPay.getId());
				
				finPay.setUpdateBy(UserUtils.getCurrUser().getAccount());
				finPay.setUpdateDate(new Date());
				finPay.setApplyTime(new Date());
				
				BeanUtils.copyProperties(finPay, originFinPay);
				finPayDao.update(originFinPay);
				
				// 启动收款流程
				Map<String, Object> variables = Maps.newHashMap();
				Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
				businessParams.put("class", this.getClass().getName()); // 要反射的类全名
				businessParams.put("method", "findById"); // 调用方法
				businessParams.put("paramValue", new Object[] { finPay.getId() }); // 方法参数的值集合
			
				variables.put("businessParams", businessParams);
				variables.put("approved", true);
				//判断负责人是否为null，如不为空则需要负责人审批
				if(project.getUserId()!=null) {
					variables.put("userId", project.getUserId());
					variables.put("userId2", userPosition.getUserId());
					variables.put("toHead1",true);
					variables.put("isNewPay", true);
				}else {
					SysUser sysUser=iSysUserDao.findById(user.getId());
    				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
    				variables.put("userId", user.getId());
    				variables.put("userId2", userPosition.getUserId());
					variables.put("toHead1",true);
					variables.put("isNewPay", true);
				}
				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.PAY, user.getId().toString(), finPay.getId().toString(), variables);
				
				// 跳过初始时的提交申请节点
				List<Map<String, Object>> commentList = Lists.newArrayList(); 
				Map<String, Object> commentMap = Maps.newHashMap();
				commentMap.put("node", "提交申请");
				commentMap.put("approver", user.getName());
				commentMap.put("comment", "");
				commentMap.put("approveResult", "提交成功");
				commentMap.put("approveDate", new Date());
				commentList.add(commentMap);
				variables.put("commentList", commentList); // 初始化提交申请节点的备注列表
				
				List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
				for(Task task : taskList) {
					if(task.getName().equals("提交申请")) {
						activitiUtils.completeTask(task.getId(), variables);
						break ;
					}
				}
				// 如果下一位执行者还是当前提交人，则直接执行处理下一步流程
				String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
				// 设置业务表与Activiti表双向关联
				finPay.setProcessInstanceId(processInstance.getId());
				finPay.setStatus(status);
				finPayDao.update(finPay);				
			}
			updateBargin(finPay);			
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}
		
	public void updateBargin(FinPay finPay){
		if(finPay.getBarginManageId() != null && !"".equals(finPay.getBarginManageId())){
			SaleBarginManage saleBarginManage = barginManageDao.findById(finPay.getBarginManageId());
			if(!finPay.getProjectManageId().equals(saleBarginManage.getProjectManageId())){
				//更新合同表中对应的项目id
				saleBarginManage.setProjectManageId(finPay.getProjectManageId());
				barginManageDao.update(saleBarginManage);
				
				//更新收款表中对应的项目id
				List<FinCollection> collectionList = Lists.newArrayList();
				collectionList = collectionDao.findByBarginId(finPay.getBarginManageId());
				if(collectionList.size() > 0){
					for (FinCollection finCollection : collectionList) {
						finCollection.setProjectId(finPay.getProjectManageId());
					}
					collectionDao.batchUpdate(collectionList);
				}				
				//更新付款表中对应的项目id
				List<FinPay> payList = Lists.newArrayList();
				payList = finPayDao.findByBarginId(finPay.getBarginManageId());
				if(payList.size() > 0){
					for (FinPay pay : payList) {
						pay.setProjectManageId(finPay.getProjectManageId());
					}
					finPayDao.batchUpdate(payList);
				}
			}	
		}
	}
	
	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			FinPay finPay = finPayDao.findById(id);
			if(finPay != null) {
				
				finPay.setStatus(status);
				finPayDao.update(finPay);
				
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

	@Override
	public CrudResultDTO delete(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功!");
		
		try {
			FinPay finPay =json.toJavaObject(FinPay.class);
			String attachments = finPay.getAttachments();			
			//直接删除
			finPayDao.deleteById(finPay.getId());
			
			if (attachments != null && !attachments.equals("")) {
				FileUtil.forceDelete(attachments);
			}			
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO deleteAttach(String path, Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		FinPay finPay = finPayDao.findById(id);
		if (finPay.getAttachments() != null) {
			try {
				FileUtil.forceDelete(path);
				finPay.setAttachName("");
				finPay.setAttachments("");
				finPayDao.update(finPay);
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("删除成功！");
			} catch (IOException e) {
				e.printStackTrace();
			}		
		}
		else{
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("附件不存在！");
		}
		return result;
	}
	
	@Override
	public CrudResultDTO findPayInfo(Integer barginManageId ,String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {			
			List<FinPay> finPayList = finPayDao.findPayInfo(barginManageId ,status);
			if (finPayList != null && !finPayList.equals("") && finPayList.size() > 0) {
				
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult(finPayList);
			}				
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public void sendMailToApple(Integer id, String contents) {
		
		FinPay finPay = finPayDao.findById(id);
		if(finPay != null){
			sendMail(finPay, contents);
		}
	}
	
	/**
	 * 发送邮件
	 */
	public void sendMail(FinPay finPay,String contents) {
		StringBuffer contentBuffer=new StringBuffer();
		List<String> recipientsList=new ArrayList<String>();
		List<Integer> userIdListOfPorcess=new ArrayList<Integer>();
		userIdListOfPorcess.add(finPay.getUserId());
		recipientsList=iAdRecordDao.findEmailsByUserIdList(userIdListOfPorcess);
		String subject = "OA付款退回提示";
		String content = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 构造邮件
		contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">");
		contentBuffer.append("<br>你于&nbsp;");
		contentBuffer.append(sdf.format(finPay.getApplyTime())+"&nbsp;");
		contentBuffer.append("申请的付款申请单被退回。<br>相关批注:");
		contentBuffer.append(contents+"<br>");
		contentBuffer.append("<br>请尽快登陆OA进行处理!</br></span>\r\n");
		content=contentBuffer.toString();
		// 以线程方式发送邮件，避免邮件发送时间过长，造成前端等待过久
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
		logger.info("["+UserUtils.getCurrUser().getName()+"]" + "发送了一封收款邮件！报销ID：" + finPay.getId());
		for (String email:recipientsList) {
			logger.info("邮箱地址 向"+email+"发送了一封收款邮件！");
		}
	}
	
	@Override
	public CrudResultDTO getTaskNext(String taskId) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			SysUser user = UserUtils.getCurrUser();
			String processInstanceId = activitiUtils.getProcessImgById(taskId);
			List<Task> taskList  = activitiUtils.getTaskByProcessInstanceIdWithAssignee(processInstanceId, "user_"+user.getId());
			if(taskList == null || taskList.size() <= 0) {
				List<AdPosition> positionList = user.getPositionList();
				if(positionList != null) {
					for(AdPosition position : positionList) {
						taskList = activitiUtils.getTaskByProcessInstanceIdWithAssignee(processInstanceId, "position_"+position.getId());
						if(taskList != null && taskList.size() > 0) {
							break ;
						}
					}
				}
			}
			if(taskList != null && taskList.size() > 0) {
				Map<String, String> map = new HashMap<>();
				map.put("id", taskList.get(0).getId());
				map.put("name", taskList.get(0).getName());
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult(map);
			}
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public FinPay findPayMoneyNew(Integer barginManageId) {
		return finPayDao.findPayMoneyNew(barginManageId);
	}
	
}