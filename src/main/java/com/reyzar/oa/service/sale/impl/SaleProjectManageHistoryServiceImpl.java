package com.reyzar.oa.service.sale.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.mail.Message;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.aspectj.weaver.ast.Var;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISaleProjectManageHistoryDao;
import com.reyzar.oa.dao.ISaleProjectMemberDao;
import com.reyzar.oa.dao.ISaleProjectMemberHistoryDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.FinInvoiceProjectMembers;
import com.reyzar.oa.domain.FinPayAttach;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SaleProjectManageHistory;
import com.reyzar.oa.domain.SaleProjectMember;
import com.reyzar.oa.domain.SaleProjectMemberHistory;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.service.sale.ISaleProjectManageHistoryService;

@Service
@Transactional
public class SaleProjectManageHistoryServiceImpl implements ISaleProjectManageHistoryService {
	
	@Autowired
	private ISaleProjectManageDao projectManageDao;
	
	@Autowired
	private ISaleProjectManageHistoryDao projectManageHistoryDao;
	
	@Autowired
	private ISaleProjectMemberDao projectMemberDao;
	
	@Autowired
	private ISaleProjectMemberHistoryDao projectMemberHistoryDao;
	
	@Autowired
	private IUserPositionDao userPositionDao;
	
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdRecordDao iAdRecordDao;

    private final static Logger logger = Logger.getLogger(String.valueOf(SaleProjectManageHistoryServiceImpl.class));
    
	@Override
	public SaleProjectManageHistory findById(Integer id) {
		SaleProjectManageHistory projectHistory = projectManageHistoryDao.findById(id);
		return projectHistory;
	}
	
	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");		
		SaleProjectManageHistory projectHistory = json.toJavaObject(SaleProjectManageHistory.class);
		SysUser user = UserUtils.getCurrUser();
		try {
			if(projectHistory.getId() == null) {
				projectHistory.setCreateBy(user.getAccount());
				projectHistory.setCreateDate(new Date());
				projectManageHistoryDao.save(projectHistory);
				
				for (SaleProjectMemberHistory member : projectHistory.getProjectMemberHistoryList()) {
					SaleProjectMemberHistory member1 = new SaleProjectMemberHistory();
					member1.setUserId(member.getUserId());
					member1.setProjectManageId(projectHistory.getProjectId());
					member1.setResultsProportion(member.getResultsProportion());
					member1.setCommissionProportion(member.getCommissionProportion());
					member1.setCreateBy(user.getAccount());
					member1.setCreateDate(new Date());
					projectMemberHistoryDao.save(member1);
				}
			} else {
				SaleProjectManageHistory old = projectManageHistoryDao.findById(projectHistory.getId());
				BeanUtils.copyProperties(projectHistory, old);
				old.setUserId(projectHistory.getUserId());
				old.setUpdateBy(user.getAccount());
				old.setUpdateDate(new Date());

				projectManageHistoryDao.update(old);

				if (Integer.valueOf((String) json.get("currStatus")) == 4) {
					//更新成员数据,根据id筛选 删除 or 添加 or 更新
					List<SaleProjectMember> saleProjectMemberList = projectMemberDao.findByProjectId(Integer.valueOf((String) json.get("projectId")));
					List<SaleProjectMember> saleProjectMemberList2 = projectMemberDao.findByProjectId(Integer.valueOf((String) json.get("projectId")));
					List<SaleProjectMemberHistory> saleProjectMemberHistory = projectHistory.getProjectMemberHistoryList();
					List<SaleProjectMemberHistory> saleProjectMemberHistory2 = projectHistory.getProjectMemberHistoryList();
					if (saleProjectMemberList != null && saleProjectMemberList.size() > 0) {
						for (int a = 0; a < saleProjectMemberList.size(); a++) {
							if (saleProjectMemberHistory != null && saleProjectMemberHistory.size() > 0) {
								for (int b = 0; b < saleProjectMemberHistory.size(); b++) {
									if (saleProjectMemberList.get(a).getUserId().equals(saleProjectMemberHistory.get(b).getUserId())) {
										saleProjectMemberList.get(a).setProjectHistoryId(projectHistory.getId());
										saleProjectMemberList.get(a).setIsDeleted("0");
										projectMemberHistoryDao.update2(saleProjectMemberList.get(a));
										saleProjectMemberList.get(a).setCommissionProportion(saleProjectMemberHistory.get(b).getCommissionProportion());
										saleProjectMemberList.get(a).setResultsProportion(saleProjectMemberHistory.get(b).getResultsProportion());
										projectMemberDao.update(saleProjectMemberList.get(a));
										saleProjectMemberHistory2.remove(b);
										saleProjectMemberList2.remove(a);
										break;
									} else {
										saleProjectMemberList.get(a).setIsDeleted("1");
										projectMemberDao.update(saleProjectMemberList.get(a));
									}
								}
							}
						}
					}

					if(saleProjectMemberList2 != null && saleProjectMemberList2.size()>0) {
						for(int a = 0; a<saleProjectMemberList2.size();a++) {
							saleProjectMemberList2.get(a).setProjectManageId(projectHistory.getId());
							saleProjectMemberList2.get(a).setCreateBy(user.getAccount());
						}
						projectMemberHistoryDao.insertAll2(saleProjectMemberList2);
						for(int i = 0; i<saleProjectMemberList2.size();i++) {
							saleProjectMemberList2.get(i).setIsDeleted("1");
							projectMemberDao.update(saleProjectMemberList2.get(i));
						}
					}

					if (saleProjectMemberHistory2 != null && saleProjectMemberHistory2.size() > 0) {
						for(int a = 0; a<saleProjectMemberHistory2.size();a++) {
							saleProjectMemberHistory2.get(a).setProjectManageId(Integer.valueOf((String) json.get("projectId")));
							saleProjectMemberHistory2.get(a).setCreateBy(user.getAccount());
						}
						projectMemberDao.insertAll2(saleProjectMemberHistory2);
						for(int i = 0; i<saleProjectMemberHistory2.size();i++) {
							projectMemberHistoryDao.delete(saleProjectMemberHistory2.get(i).getId());
						}
					}

					projectMemberHistoryDao.updateIsDelete();
				}

				/*List<SaleProjectMemberHistory> orginsaleProjectMemberHistory = projectMemberHistoryDao.findByProjectId(old.getId());
				List<SaleProjectMemberHistory> saleProjectMemberHistory= projectHistory.getProjectMemberHistoryList();
				List<SaleProjectMember>  saleProjectMemberList = projectMemberDao.findByProjectId(Integer.valueOf((String)json.get("projectId")));

				List<SaleProjectMemberHistory> saveListInvoiceProjectMembers = Lists.newArrayList();
				List<SaleProjectMemberHistory> updateListInvoiceProjectMembers = Lists.newArrayList();
				List<Integer> delListInvoiceProjectMembers = Lists.newArrayList();
				Map<Integer, SaleProjectMemberHistory> orgininvoicedMapInvoiceProjectMembers = Maps.newHashMap();
				if(orginsaleProjectMemberHistory!=null && orginsaleProjectMemberHistory.size()>0) {
					for (SaleProjectMemberHistory attach : orginsaleProjectMemberHistory) {
						if(saleProjectMemberList!=null && saleProjectMemberList.size()>0 ) {
							for (SaleProjectMember saleProjectMember : saleProjectMemberList) {
								if(attach.getUserId().equals(saleProjectMember.getUserId())) {
									attach.setResultsProportion(saleProjectMember.getResultsProportion());
									attach.setCommissionProportion(saleProjectMember.getCommissionProportion());
								}
							}
						}
						orgininvoicedMapInvoiceProjectMembers.put(attach.getId(), attach);
					}
				}
				if(saleProjectMemberHistory!=null && saleProjectMemberHistory.size()>0) {
					for(SaleProjectMemberHistory attach: saleProjectMemberHistory) {
						if (attach.getId() != null) {
							attach.setUpdateBy(user.getAccount());
							attach.setUpdateDate(new Date());
							SaleProjectMemberHistory orgin = orgininvoicedMapInvoiceProjectMembers.get(attach.getId());
							if (orgin != null) {
								BeanUtils.copyProperties(attach, orgin);
								updateListInvoiceProjectMembers.add(orgin);
								orgininvoicedMapInvoiceProjectMembers.remove(orgin.getId());
							}
						} else {
							attach.setProjectManageId(old.getId());
							attach.setCreateBy(user.getAccount());
							attach.setCreateDate(new Date());
							saveListInvoiceProjectMembers.add(attach);
						}
					}
				}



				
				//添加集
				delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
				if (saveListInvoiceProjectMembers.size() > 0) {
					projectMemberHistoryDao.insertAll(saveListInvoiceProjectMembers);
				}
				//更新集
				if (updateListInvoiceProjectMembers.size() > 0) {
					projectMemberHistoryDao.batchUpdate(updateListInvoiceProjectMembers);
				}
				//删除集
				if (delListInvoiceProjectMembers.size() > 0) {
					//目前数据不删除，更改删除状态
					for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
						SaleProjectMemberHistory sinInvoiceProjectMembersisD=projectMemberHistoryDao.findById(delListInvoiceProjectMembers.get(i));
						sinInvoiceProjectMembersisD.setIsDeleted("1");
						projectMemberHistoryDao.update(sinInvoiceProjectMembersisD);
					}
					//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
				}*/
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}		
		return result;
	}
	
	@Override
	public CrudResultDTO submit(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SaleProjectManageHistory projectHistory = json.toJavaObject(SaleProjectManageHistory.class);
		
		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;
		
		Integer deptId = Integer.valueOf(String.valueOf(json.get("dutyDeptId")));
		SysUserPosition userPosition =  userPositionDao.findByDeptAndLevel(deptId);
		
		try {	
			projectHistory.setProjectId(Integer.valueOf((String)json.get("projectId")));
			projectHistory.setCreateBy(user.getAccount());
			projectHistory.setCreateDate(new Date());
			projectManageHistoryDao.save(projectHistory);
				
			for (SaleProjectMemberHistory member : projectHistory.getProjectMemberHistoryList()) {
				SaleProjectMemberHistory memberHistory = new SaleProjectMemberHistory();
				memberHistory.setUserId(member.getUserId());
				memberHistory.setProjectManageId(projectHistory.getId());
				memberHistory.setResultsProportion(member.getResultsProportion());
				memberHistory.setCommissionProportion(member.getCommissionProportion());
				memberHistory.setCreateBy(user.getAccount());
				memberHistory.setCreateDate(new Date());
				projectMemberHistoryDao.save(memberHistory);
			}
				
			// 启动项目变更申请流程
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			businessParams.put("paramValue", new Object[] { projectHistory.getId() }); // 方法参数的值集合
			
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
			variables.put("userId", projectHistory.getUserId());
			variables.put("userId2", userPosition.getUserId());
				
			processInstance = activitiUtils.startProcessInstance(
					ActivitiUtils.PROJECT_MODIFY_KEY, user.getId().toString(), projectHistory.getId().toString(), variables);
				
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
			projectHistory.setProcessInstanceId(processInstance.getId());
			projectHistory.setStatusNew(Integer.parseInt(status));
			projectManageHistoryDao.update(projectHistory);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}		
		return result;
	}

	@Override
	public CrudResultDTO setStatusNew(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			SaleProjectManageHistory projectManageHistory = projectManageHistoryDao.findById(id);
			if(projectManageHistory != null) {
				projectManageHistory.setStatusNew(Integer.valueOf(status));
				projectManageHistoryDao.update(projectManageHistory);
				
				if("5".equals(status)) {
					SaleProjectManage project = projectManageDao.findById(projectManageHistory.getProjectId());
					//SaleProjectManage project2 = projectManageDao.findById(projectManageHistory.getProjectId());
					String name=project.getName();
					Integer userId=project.getUserId();
					Double size=project.getSize();
					Date projectEndDate=project.getProjectEndDate();
					String status1=project.getStatus();
					Date projectDate=project.getProjectDate();
					Integer dutyDeptId=project.getDutyDeptId();
					
					project.setName(projectManageHistory.getName());
					project.setUserId(projectManageHistory.getUserId());
					project.setSize(projectManageHistory.getSize());
					project.setProjectEndDate(projectManageHistory.getProjectEndDate());
					project.setStatus(projectManageHistory.getStatus());
					project.setProjectDate(projectManageHistory.getProjectDate());
					project.setDutyDeptId(projectManageHistory.getDutyDeptId());
					projectManageDao.update(project); 
					
					projectManageHistory.setName(name);
					projectManageHistory.setUserId(userId);
					projectManageHistory.setSize(size);
					projectManageHistory.setProjectEndDate(projectEndDate);
					projectManageHistory.setStatus(status1);
					projectManageHistory.setDutyDeptId(dutyDeptId);
					projectManageHistory.setProjectDate(projectDate);
					projectManageHistoryDao.update(projectManageHistory);
					/*// 获取变更前的项目成员
					List<SaleProjectMember> memberList = projectMemberDao.findByProjectId(projectManageHistory.getProjectId());

					// 删除原有成员
					//projectMemberDao.deleteByProjectId(projectManageHistory.getProjectId());

					// 获取变更后的项目成员
					List<SaleProjectMemberHistory> MemberHistoryList = projectMemberHistoryDao.findByProjectId(projectManageHistory.getId());

					Map<Integer, SaleProjectMember> orginFinPayMap = Maps.newHashMap();

					for (SaleProjectMember saleProjectMember : memberList) {
						orginFinPayMap.put(saleProjectMember.getUserId(), saleProjectMember);
					}
					
					for (SaleProjectMemberHistory saleProjectMemberHistory : MemberHistoryList) {
						SaleProjectMember orgin = orginFinPayMap.get(saleProjectMemberHistory.getUserId());
						if (orgin != null) {
							//更新的项目成员
							orgin.setUserId(saleProjectMemberHistory.getUserId());
							orgin.setResultsProportion(saleProjectMemberHistory.getResultsProportion());
							orgin.setCommissionProportion(saleProjectMemberHistory.getCommissionProportion());
							projectMemberDao.update(orgin);
							orginFinPayMap.remove(orgin.getUserId());
						} else {
							//新增的项目成员
							SaleProjectMember member = new SaleProjectMember();
							member.setResultsProportion(saleProjectMemberHistory.getResultsProportion());
							member.setCommissionProportion(saleProjectMemberHistory.getCommissionProportion());
							member.setCreateBy(saleProjectMemberHistory.getCreateBy());
							member.setCreateDate(saleProjectMemberHistory.getCreateDate());
							member.setProjectManageId(project.getId());
							member.setUserId(saleProjectMemberHistory.getUserId());
							member.setSorting(saleProjectMemberHistory.getSorting());
							projectMemberDao.save(member);
						}
					}
					// 删除的项目成员
					List<Integer> delList = Lists.newArrayList();
					delList.addAll(orginFinPayMap.keySet());
					for (Integer integer : delList) {
						SaleProjectMember orgin = orginFinPayMap.get(integer);
						orgin.setIsDeleted("1");
						projectMemberDao.update(orgin);
					}*/
					
					//插入新的项目成员
					/*for (SaleProjectMemberHistory saleProjectMemberHistory : MemberHistoryList) {
						SaleProjectMember member = new SaleProjectMember();
						member.setUserId(saleProjectMemberHistory.getUserId());
						member.setProjectManageId(saleProjectMemberHistory.getProjectManageId());
						member.setResultsProportion(saleProjectMemberHistory.getResultsProportion());
						member.setCommissionProportion(saleProjectMemberHistory.getCommissionProportion());
						member.setCreateBy(saleProjectMemberHistory.getCreateBy());
						member.setCreateDate(saleProjectMemberHistory.getCreateDate());
						projectMemberDao.save(member);
					}*/
					
					//删除最新项目成员数据并将历史成员数据插入
					/*projectMemberHistoryDao.deleteByProjectId(projectManageHistory.getId());
					for (SaleProjectMember saleProjectMember : memberList) {
						SaleProjectMemberHistory memberHistory = new SaleProjectMemberHistory();
						memberHistory.setUserId(saleProjectMember.getUserId());
						memberHistory.setProjectManageId(projectManageHistory.getId());
						memberHistory.setResultsProportion(saleProjectMember.getResultsProportion());
						memberHistory.setCommissionProportion(saleProjectMember.getCommissionProportion());
						memberHistory.setCreateBy(saleProjectMember.getCreateBy());
						memberHistory.setCreateDate(saleProjectMember.getCreateDate());
						memberHistory.setSorting(saleProjectMember.getSorting());
						projectMemberHistoryDao.save(memberHistory);
					}	*/
				}
				
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
	public List<SaleProjectManageHistory> findByProjectId(Integer id) {
		List<SaleProjectManageHistory> projectHistory = projectManageHistoryDao.findByProjectId(id);
		return projectHistory;
	}

	@Override
	public CrudResultDTO sendMail(Integer id, String comment) {
        CrudResultDTO result = new CrudResultDTO();
        SaleProjectManageHistory saleProjectManage = projectManageHistoryDao.findById(id);
        Integer userId = saleProjectManage.getApplicant();
        //获取提交人的邮箱地址
        String userEmail = iAdRecordDao.findByUserid(userId).getEmail();
        //存提交人的Email
        List<String> recipientsList = new ArrayList<>();
        recipientsList.add(userEmail);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            //构造邮件
            String subject = "OA项目变更提示";
            StringBuffer contentBuffer = new StringBuffer();
            contentBuffer.append("<h3>");
            contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">项目变更通知!");
            contentBuffer.append("</h3><br>您于：");
            contentBuffer.append(sdf.format(saleProjectManage.getSubmitDate()) + "&nbsp;");
            contentBuffer.append("提交的项目变更申请被退回。<br>项目名称为:");
            contentBuffer.append(saleProjectManage.getName()+"&nbsp;");
            contentBuffer.append("<br>流程备注为:");
            contentBuffer.append(comment + "<br>");
            contentBuffer.append("<br>详情请登陆OA项目管理模块进行查看!</br></span>\r\n");
            String content = contentBuffer.toString();
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
            logger.info("发送了一封项目邮件！项目ID：" + saleProjectManage.getId());
            for (String email : recipientsList) {
                logger.info("向" + email + "发送了一封项目邮件！");
            }
            result.setCode(CrudResultDTO.SUCCESS);
            result.setResult("发送成功！");
        } catch (Exception e) {
            e.printStackTrace();
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("发送失败！");
        }
        return result;
    }
	
	
}