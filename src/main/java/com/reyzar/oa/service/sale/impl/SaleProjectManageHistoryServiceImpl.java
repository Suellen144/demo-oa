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
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");		
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
					//??????????????????,??????id?????? ?????? or ?????? or ??????
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



				
				//?????????
				delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
				if (saveListInvoiceProjectMembers.size() > 0) {
					projectMemberHistoryDao.insertAll(saveListInvoiceProjectMembers);
				}
				//?????????
				if (updateListInvoiceProjectMembers.size() > 0) {
					projectMemberHistoryDao.batchUpdate(updateListInvoiceProjectMembers);
				}
				//?????????
				if (delListInvoiceProjectMembers.size() > 0) {
					//??????????????????????????????????????????
					for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
						SaleProjectMemberHistory sinInvoiceProjectMembersisD=projectMemberHistoryDao.findById(delListInvoiceProjectMembers.get(i));
						sinInvoiceProjectMembersisD.setIsDeleted("1");
						projectMemberHistoryDao.update(sinInvoiceProjectMembersisD);
					}
					//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
				}*/
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}		
		return result;
	}
	
	@Override
	public CrudResultDTO submit(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
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
				
			// ??????????????????????????????
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
			businessParams.put("class", this.getClass().getName()); // ?????????????????????
			businessParams.put("method", "findById"); // ????????????
			businessParams.put("paramValue", new Object[] { projectHistory.getId() }); // ????????????????????????
			
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
			variables.put("userId", projectHistory.getUserId());
			variables.put("userId2", userPosition.getUserId());
				
			processInstance = activitiUtils.startProcessInstance(
					ActivitiUtils.PROJECT_MODIFY_KEY, user.getId().toString(), projectHistory.getId().toString(), variables);
				
			// ????????????????????????????????????
			List<Map<String, Object>> commentList = Lists.newArrayList(); 
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "????????????");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "????????????");
			commentMap.put("approveDate", new Date());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // ??????????????????????????????????????????
				
			List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
			for(Task task : taskList) {
				if(task.getName().equals("????????????")) {
					activitiUtils.completeTask(task.getId(), variables);
					break ;
				}
			}
				
			//????????????????????????????????????????????????????????????????????????????????????
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			// ??????????????????Activiti???????????????
			projectHistory.setProcessInstanceId(processInstance.getId());
			projectHistory.setStatusNew(Integer.parseInt(status));
			projectManageHistoryDao.update(projectHistory);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????");
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
					/*// ??????????????????????????????
					List<SaleProjectMember> memberList = projectMemberDao.findByProjectId(projectManageHistory.getProjectId());

					// ??????????????????
					//projectMemberDao.deleteByProjectId(projectManageHistory.getProjectId());

					// ??????????????????????????????
					List<SaleProjectMemberHistory> MemberHistoryList = projectMemberHistoryDao.findByProjectId(projectManageHistory.getId());

					Map<Integer, SaleProjectMember> orginFinPayMap = Maps.newHashMap();

					for (SaleProjectMember saleProjectMember : memberList) {
						orginFinPayMap.put(saleProjectMember.getUserId(), saleProjectMember);
					}
					
					for (SaleProjectMemberHistory saleProjectMemberHistory : MemberHistoryList) {
						SaleProjectMember orgin = orginFinPayMap.get(saleProjectMemberHistory.getUserId());
						if (orgin != null) {
							//?????????????????????
							orgin.setUserId(saleProjectMemberHistory.getUserId());
							orgin.setResultsProportion(saleProjectMemberHistory.getResultsProportion());
							orgin.setCommissionProportion(saleProjectMemberHistory.getCommissionProportion());
							projectMemberDao.update(orgin);
							orginFinPayMap.remove(orgin.getUserId());
						} else {
							//?????????????????????
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
					// ?????????????????????
					List<Integer> delList = Lists.newArrayList();
					delList.addAll(orginFinPayMap.keySet());
					for (Integer integer : delList) {
						SaleProjectMember orgin = orginFinPayMap.get(integer);
						orgin.setIsDeleted("1");
						projectMemberDao.update(orgin);
					}*/
					
					//????????????????????????
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
					
					//????????????????????????????????????????????????????????????
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
				result.setResult("????????????!");
			} else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("??????ID??????" + id + " ????????????");
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
        //??????????????????????????????
        String userEmail = iAdRecordDao.findByUserid(userId).getEmail();
        //???????????????Email
        List<String> recipientsList = new ArrayList<>();
        recipientsList.add(userEmail);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            //????????????
            String subject = "OA??????????????????";
            StringBuffer contentBuffer = new StringBuffer();
            contentBuffer.append("<h3>");
            contentBuffer.append("<span style=\\\"font-family:????????????, Microsoft YaHei\\\">??????????????????!");
            contentBuffer.append("</h3><br>?????????");
            contentBuffer.append(sdf.format(saleProjectManage.getSubmitDate()) + "&nbsp;");
            contentBuffer.append("???????????????????????????????????????<br>???????????????:");
            contentBuffer.append(saleProjectManage.getName()+"&nbsp;");
            contentBuffer.append("<br>???????????????:");
            contentBuffer.append(comment + "<br>");
            contentBuffer.append("<br>???????????????OA??????????????????????????????!</br></span>\r\n");
            String content = contentBuffer.toString();
            //???????????????????????????????????????????????????????????????????????????????????????
            Thread thread = new Thread() {
                private List<String> recipientsList;
                private String subject;
                private String content;
                private Message.RecipientType recipientType;

                @Override
                public void run() {
                    // ????????????
                    MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType); // ??????????????????????????????
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
            logger.info("????????????????????????????????????ID???" + saleProjectManage.getId());
            for (String email : recipientsList) {
                logger.info("???" + email + "??????????????????????????????");
            }
            result.setCode(CrudResultDTO.SUCCESS);
            result.setResult("???????????????");
        } catch (Exception e) {
            e.printStackTrace();
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("???????????????");
        }
        return result;
    }
	
	
}