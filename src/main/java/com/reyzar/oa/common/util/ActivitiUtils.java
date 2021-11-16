package com.reyzar.oa.common.util;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.activiti.bpmn.model.BpmnModel;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricVariableInstance;
import org.activiti.engine.impl.RepositoryServiceImpl;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.pvm.PvmTransition;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.impl.pvm.process.ProcessDefinitionImpl;
import org.activiti.engine.impl.pvm.process.TransitionImpl;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.IdentityLink;
import org.activiti.engine.task.IdentityLinkType;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.msgsys.WebClientUtils;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.SysMessage;
import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: ActUtils 
* @Description: Activiti 流程相关操作
* @author Lin 
* @date 2016年6月16日 上午10:36:54 
*  
*/
@Component
@Transactional
public class ActivitiUtils {
	
	@Autowired
	private ProcessEngine processEngine;
	@Autowired
	private ProcessEngineConfiguration processEngineConfiguration;
	@Autowired
	private RepositoryService repositoryService;
	@Autowired
	private RuntimeService runtimeService;
	@Autowired
	private TaskService taskService;
	@Autowired
	private HistoryService historyService;
	@Autowired
	private IdentityService identityService;

	// 流程Key
	public final static String LEVAE_KEY = "leave"; // 请假流程
	public final static String TRAVEL_KEY = "travel"; // 出差流程
	public final static String TRAVEL_REIMBURSE_KEY = "travelReimburse"; // 出差报销流程
	public final static String REIMBURSE_KEY = "reimburse"; // 通用报销流程
	public final static String NOTICE_KEY = "notice"; // 公司公告流程
	public final static String OVERTIME_KEY = "overtime"; // 加班流程
	public final static String SEAL_KEY = "seal"; //公章流程
	public final static String BARGIN_KEY = "bargin"; // 合同流程
	public final static String COLLECT_KEY = "collection"; // 收款流程
	public final static String PAY = "pay"; // 付款流程
	public final static String SALARY_KEY = "salary";//薪酬流程
	public final static String CAR_KEY ="usercar"; //用车流程
	public final static String PROJECT_KEY ="project"; //项目立项流程
	public final static String PROJECT_MODIFY_KEY ="projectModify"; //项目变更流程
	public final static String Invoiced_KEY ="invoiced"; //开票申请流程
	
	/**
	* @Title: deployProcess
	* @Description: 部署流程
	* @param processResourcePath 流程设计文件路径
	* @throws
	 */
	public void deployProcess(String processResourcePath) {
		repositoryService.createDeployment()
				.addClasspathResource(processResourcePath)
				.deploy();
	}
	
	/**
	* @Title: deleteProcessInstance
	* @Description: 删除流程实例
	* @param processInstanceId
	* @throws
	 */
	public void deleteProcessInstance(String processInstanceId) {
		runtimeService.deleteProcessInstance(processInstanceId, "");
	}
	
	/**
	* @Title: deleteProcessInstanceByTaskId
	* @Description: 通过taskId删除流程实例
	* @param taskId
	* @return void
	* @throws
	 */
	public void deleteProcessInstanceByTaskId(String taskId) {
		String processInstanceId = taskService.createTaskQuery()
				.taskId(taskId)
				.singleResult()
				.getProcessInstanceId();
		deleteProcessInstance(processInstanceId);
	}
		
	/**
	* @Title: endProcess
	* @Description: 中止流程
	* @param taskId
	* @param @throws Exception
	* @return void
	* @throws
	 */
    public void endProcess(String taskId, Map<String, Object> variables) throws Exception {    
        ActivityImpl endActivity = findActivitiImpl(taskId, "end");    
        commitProcess(taskId, variables, endActivity.getId());    
    } 
    
    public void endProcess(String taskId) throws Exception {    
        endProcess(taskId, null);    
    }
    
    /**
	* @Title: endProcessByProcessInstanceId
	* @Description: 中止流程（可结束并行流程）
	* @param processInstanceId
	* @param @throws Exception
	* @return void
	* @throws
	 */
    public void endProcessByProcessInstanceId(String processInstanceId, Map<String, Object> variables) throws Exception {    
    	List<Task> taskList = getActivityTask(processInstanceId);
		for(Task task : taskList) {
			endProcess(task.getId(), variables);
		}  
    }    
	
	/**
	* @Title: deleteDeploy
	* @Description: 删除部署
	* @param deploymentId
	* @param isCascade 是否级联删除下面的流程定义
	* @throws
	 */
	public void deleteDeploy(String deploymentId, boolean isCascade) {
		repositoryService.deleteDeployment(deploymentId, isCascade);
	}
	
	/**
	* @Title: deleteDeployByProcessDefinitionId
	* @Description: 通过流程定义ID删除部署
	* @param processDefinitionId
	* @param isCascade
	* @return void
	* @throws
	 */
	public void deleteDeployByProcessDefinitionId(String processDefinitionId, boolean isCascade) {
		repositoryService.deleteDeployment(repositoryService
				.createProcessDefinitionQuery()
				.processDefinitionId(processDefinitionId)
				.singleResult().getDeploymentId(), isCascade);
	}
	
	/**
	* @Title: getProcessDefinitionList
	* @Description: 获取流程定义列表
	* @return List<ProcessDefinition>
	* @throws
	 */
	public List<ProcessDefinition> getProcessDefinitionList() {
		return repositoryService.createProcessDefinitionQuery()
			.list();
	}
	
	/**
	* @Title: getProcessDefinitionByPage
	* @Description: 获取分页流程定义列表
	* @param pageNum
	* @param pageSize
	* @return Page<Map<String,Object>>
	* @throws
	 */
	public Page<Map<String, Object>> getProcessDefinitionByPage(Map<String, Object> paramsMap, int pageNum, int pageSize) {
		ProcessDefinitionQuery pdQuery = repositoryService.createProcessDefinitionQuery();
		if(paramsMap != null) {
			if(paramsMap.get("key") != null && !"".equals(paramsMap.get("key"))) {
				pdQuery.processDefinitionKeyLike("%"+paramsMap.get("key").toString()+"%");
			}
			if(paramsMap.get("name") != null && !"".equals(paramsMap.get("name"))) {
				pdQuery.processDefinitionNameLike("%"+paramsMap.get("name").toString()+"%");
			}
			if(paramsMap.get("version") != null && !"".equals(paramsMap.get("version"))) {
				pdQuery.processDefinitionVersion(Integer.valueOf(paramsMap.get("version").toString()));
			}
			if(paramsMap.get("status") != null && !"".equals(paramsMap.get("status"))) {
				if("1".equals(paramsMap.get("status").toString())) {
					pdQuery.active();
				} else if("0".equals(paramsMap.get("status").toString())) {
					pdQuery.suspended();
				}
			}
		}
		
		List<ProcessDefinition> pdList = pdQuery.listPage((pageSize * (pageNum-1)), pageSize);

		Page<Map<String, Object>> page = new Page<Map<String, Object>>();
		page.setPageNum(pageNum);
		page.setPageSize(pageSize);
		page.setTotal(pdQuery.count());
		
		for(ProcessDefinition pd : pdList) {
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", pd.getId());
			map.put("deploymentId", pd.getDeploymentId());
			map.put("name", pd.getName());
			map.put("key", pd.getKey());
			map.put("version", pd.getVersion());
			map.put("suspended", pd.isSuspended());
			map.put("resourceName", pd.getResourceName());
			map.put("diagramResourceName", pd.getDiagramResourceName());
			
			Deployment deploymenet = repositoryService.createDeploymentQuery()
					.deploymentId(pd.getDeploymentId())
					.singleResult();
			map.put("deploymentTime", deploymenet.getDeploymentTime());
			
			page.add(map);
		}	
		return page;
	}
	
	/**
	 * 
	* @Title: startProcessInstance
	* @Description: 启动流程
	* @param processKey 流程Key(必须要)
	* @param userId 流程发起人
	* @param businessKey 业务Key
	* @param variables 流程变量
	* @return ProcessInstance
	* @throws
	 */
	public ProcessInstance startProcessInstance(String processKey, String userId, String businessKey, Map<String, Object> variables) {
		ProcessInstance processInstance = null;
		identityService.setAuthenticatedUserId(userId);
		if(businessKey == null || "".equals(businessKey)) {
			processInstance = runtimeService.startProcessInstanceByKey(processKey, variables);
		} else {
			processInstance = runtimeService.startProcessInstanceByKey(processKey, businessKey, variables);
		}		
		return processInstance;
	}
	
	/**
	 * 
	* @Title: findTaskByAssignee
	* @Description: 获取任务列表
	* @param assignee
	* @return List<Task>
	* @throws
	 */
	public List<Task> findTaskByAssignee(String assignee) {
		return taskService.createTaskQuery()
				.taskCandidateUser(assignee)
//				.taskAssignee(assignee)
				.orderByTaskCreateTime()
				.desc()
				.list();
	}
	
	/**
	 * 
	* @Title: findTaskByAssigneeWithProcessDefinitionKey
	* @Description: 根据候选人与流程实例ID获取任务列表
	* @param assignee
	* @param processInstanceId
	* @return List<Task>
	* @throws
	 */
	public List<Task> findTaskByAssigneeWithProcessInstanceId(String assignee, String processInstanceId) {
		return taskService.createTaskQuery()
				.taskCandidateUser(assignee)
				.processInstanceId(processInstanceId)
				.orderByTaskCreateTime()
				.desc()
				.list();
	}
	
	/**
	 * 
	* @Title: findTaskByAssigneeWithProcessDefinitionKey
	* @Description: 根据候选人与流程定义Key获取任务列表
	* @param assignee
	* @param processDefinitionKey
	* @return List<Task>
	* @throws
	 */
	public List<Task> findTaskByAssigneeWithProcessDefinitionKey(String assignee, String processDefinitionKey) {
		return taskService.createTaskQuery()
				.taskCandidateUser(assignee)
				.processDefinitionKey(processDefinitionKey)
				.orderByTaskCreateTime()
				.desc()
				.list();
	}
	
	/**
	* @Title: getVariablesByTaskid
	* @Description: 获取任务变量
	* @param taskId
	* @return Map<String,Object>
	* @throws
	 */
	public Map<String, Object> getVariablesByTaskid(String taskId) {
		return taskService.getVariables(taskId);
	}
	
	/**
	* @Title: getVariablesByProcessInstanceId
	* @Description: 获取流程变量
	* @param processInstanceId
	* @return Map<String,Object>
	* @throws
	 */
	public Map<String, Object> getVariablesByProcessInstanceId(String processInstanceId) {
		Map<String, Object> result = Maps.newHashMap();
		List<Task> taskList = taskService.createTaskQuery().processInstanceId(processInstanceId)
								.orderByTaskCreateTime().desc().list();
		for(Task task : taskList) {
			result.putAll(getVariablesByTaskid(task.getId()));
		}
		return result;
	}
	
	/**
	* @Title: getHistoryVariablesByProcessInstanceId
	* @Description: 获取历史流程变量
	* @param processInstanceId
	* @return Map<String,Object>
	* @throws
	 */
	public Map<String, Object> getHistoryVariablesByProcessInstanceId(String processInstanceId) {
		Map<String, Object> result = Maps.newHashMap();
		List<HistoricVariableInstance> variableList = 
				historyService.createHistoricVariableInstanceQuery().processInstanceId(processInstanceId).list();
		for(HistoricVariableInstance variable : variableList) {
			result.put(variable.getVariableName(), variable.getValue());
		}		
		return result;
	}

	/**
	 * 
	* @Title: completeTask
	* @Description: 完成一次任务
	* @param taskId
	* @param variables
	* @return void
	* @throws
	 */
	public void completeTask(String taskId, Map<String, Object> variables) {
		taskService.complete(taskId, variables);
	}
	
	/**
	 * 
	* @Title: findBussinessKeyByTaskid
	* @Description: 根据任务ID获取业务表关联ID
	* @param taskId
	* @return String
	* @throws
	 */
	public String findBussinessKeyByTaskid(String taskId) {
		Task task = taskService.createTaskQuery()
				.taskId(taskId)
				.singleResult();
		
		ProcessInstance pi = runtimeService.createProcessInstanceQuery()
				.processInstanceId(task.getProcessInstanceId())
				.singleResult();
		
		return pi.getBusinessKey();
	}
	
	/**
	 * 
	* @Title: findBussinessKeyByProcessInstanceId
	* @Description: 根据流程实例ID获取业务表关联ID
	* @param processInstanceId
	* @return String
	* @throws
	 */
	public String findBussinessKeyByProcessInstanceId(String processInstanceId) {
		ProcessInstance pi = runtimeService.createProcessInstanceQuery()
				.processInstanceId(processInstanceId)
				.singleResult();
		if(pi != null) {
			return pi.getBusinessKey();
		} else {
			return null;
		}
	}
	
	/**
	 * 
	* @Title: findTaskByTaskid
	* @Description: 返回Task
	* @param taskId
	* @return Task
	* @throws
	 */
	public Task findTaskByTaskid(String taskId)	{
		return  taskService.createTaskQuery()
					.taskId(taskId)
					.singleResult();
	}
	
	/**
	 * 
	* @Title: findTaskByProcessInstanceId
	* @Description: 返回Task
	* @param processInstanceId
	* @return Task
	* @throws
	 */
	public Task findTaskByProcessInstanceId(String processInstanceId) {
		return taskService.createTaskQuery().processInstanceId(processInstanceId).singleResult();
	}
	
	/**
	 * 
	* @Title: findAllTask
	* @Description: 查询所有的Task
	* @return List<Task>
	* @throws
	 */
	public List<Task> findAllTask()	{
		return taskService.createTaskQuery().list();
	}
	
	public List<String> findAllTaskUser(String taskId) {
		List<String> users = new ArrayList<String>();
		List<IdentityLink> links = taskService.getIdentityLinksForTask(taskId);
		for (IdentityLink link : links) {
		    if (IdentityLinkType.CANDIDATE.equals(link.getType())) {
		        users.add(link.getUserId());
		    }
		}
		return users;
	}
	
	/**
	 * 
	* @Title: getProcessImgByProcessInstanceId
	* @Description: 获取流程实例图片
	* @param processInstanceId
	* @return InputStream
	* @throws
	 */
	public InputStream getProcessImgByProcessInstanceId(String processInstanceId) {
		
		ProcessInstance processInstance = runtimeService.createProcessInstanceQuery()
				.processInstanceId(processInstanceId)
				.singleResult();
		HistoricProcessInstance historicProcessInstance = historyService.createHistoricProcessInstanceQuery()
				.processInstanceId(processInstanceId)
				.singleResult();
		
		if (processInstance == null && historicProcessInstance == null) {
            return null;
        }
		
		ProcessDefinitionEntity processDefinition = (ProcessDefinitionEntity) 
				repositoryService.getProcessDefinition(processInstance == null ? 
						historicProcessInstance.getProcessDefinitionId() : processInstance.getProcessDefinitionId());
		
        BpmnModel bpmnModel = repositoryService.getBpmnModel(processDefinition.getId());
        //得到流程正在执行的环节
        List<String> activeActivityIds = Lists.newArrayList();
        if (processInstance != null) {
        	activeActivityIds = runtimeService.getActiveActivityIds(processInstance.getProcessInstanceId());
        } else {
        	List<HistoricActivityInstance> historicActivityInstanceList = 
        			historyService.createHistoricActivityInstanceQuery()
        			.processInstanceId(processInstanceId)
        			.activityType("endEvent")
                    .list();
        	for(HistoricActivityInstance historicActivityInstance : historicActivityInstanceList) {
        		activeActivityIds.add(historicActivityInstance.getActivityId());
        	}
        }
        //打印流程图
        InputStream in = processEngine.getProcessEngineConfiguration()
        		.getProcessDiagramGenerator()
        		.generateDiagram(bpmnModel, 
        						"PNG", 
        						activeActivityIds, 
        						Collections.<String>emptyList(),
        						processEngineConfiguration.getActivityFontName(), 
        						processEngineConfiguration.getLabelFontName(), 
        						processEngineConfiguration.getClassLoader(), 
        						1.0);
        
        return in;
	}
	
	/**
	* @Title: getProcessImgByTaskId
	* @Description: 通过Taskid获取流程实例图片
	* @param taskId
	* @return InputStream
	* @throws
	 */
	public InputStream getProcessImgByTaskId(String taskId) {
		String processInstanceId = taskService.createTaskQuery().taskId(taskId).singleResult().getProcessInstanceId();
		return getProcessImgByProcessInstanceId(processInstanceId);
	}
	
	/**
	* @Title: getProcessDefinitionByTaskid
	* @Description: 通过 taskId 获取流程定义
	* @param taskId
	* @return ProcessDefinition
	* @throws
	 */
	public ProcessDefinition getProcessDefinitionByTaskid(String taskId) {
		return repositoryService.createProcessDefinitionQuery()
		.processDefinitionId(taskService.createTaskQuery().taskId(taskId).singleResult().getProcessDefinitionId())
		.singleResult();
	}
	
	/**
	 * @Title: getProcessInstanceByProcessInstanceId
	 * @Description: 通过 processInstanceId 查询流程是否结束
	 * @param processInstanceId
	 * @return ProcessInstance
	 * @throws
	 */
	public ProcessInstance getProcessInstanceByProcessInstanceId(String processInstanceId) {
		return runtimeService.createProcessInstanceQuery()
				.processInstanceId(processInstanceId)
				.singleResult();
	}
	
	/**
	* @Title: getProcessDefinitionByTaskid
	* @Description: 通过 taskId 获取流程定义
	* @param taskId
	* @return ProcessDefinition
	* @throws
	 */
	public ProcessInstance getProcessInstanceByTaskid(String taskId) {
		Task task = taskService.createTaskQuery()
				.taskId(taskId)
				.singleResult();
		if(task != null) {
			return runtimeService.createProcessInstanceQuery()
					.processInstanceId(task.getProcessInstanceId())
					.singleResult();
		} else {
			return null;
		}
	}
	
	/**
	* @Title: setProcessDefinitionStatus
	* @Description: 设置流程实例挂起或激活
	* @param processDefinitionId
	* @param isSuspend
	* @return void
	* @throws
	 */
	public void setProcessDefinitionStatus(String processDefinitionId, boolean isSuspend) {
		if(isSuspend) {
			repositoryService.suspendProcessDefinitionById(processDefinitionId);
		} else {
			repositoryService.activateProcessDefinitionById(processDefinitionId);
		}
	}
	
	/**
	 * 
	* @Title: setTaskVariables
	* @Description: 设置流程变量
	* @param taskId
	* @param variables
	* @return void
	* @throws
	 */
	public void setTaskVariables(String taskId, Map<String, Object> variables) {
		taskService.setVariables(taskId, variables);
	}
	
	/**
	 * 
	* @Title: setTaskVariables
	* @Description: 设置指定流程变量
	* @param taskId
	* @param variableName
	* @param value
	* @return void
	* @throws
	 */
	public void setTaskVariables(String taskId, String variableName, Object value) {
		taskService.setVariableLocal(taskId, variableName, value);
	}
	
	/**
	 * @Title: getTaskListByProcessInstanceId
	 * @Description: 根据流程实例Id查询当前任务信息变量
	 * @param processInstanceId
	 * @return
	 * @throws
	 */
	public List<Task> getTaskListByProcessInstanceId(String processInstanceId){
		return taskService.createTaskQuery().processInstanceId(processInstanceId)
				.orderByTaskCreateTime().desc().list();
	}
	
	/**
	 * @Title: getTaskByProcessInstanceIdWithAssignee
	 * @Description: 根据流程实例Id和任务处理人查询当前任务信息
	 * @param processInstanceId
	 * @param assignee
	 * @return
	 */
	public List<Task> getTaskByProcessInstanceIdWithAssignee(String processInstanceId, String assignee){
		return taskService.createTaskQuery().processInstanceId(processInstanceId)
				.taskCandidateOrAssigned(assignee)
				.list();
	}
	
	/**
	 * 进行消息推送提醒，给下一个执行者
	 * @param processInstanceId
	 */
	public void sendWebSocketMessage(String processInstanceId,String taskUrl){
		//查询流程下一个位执行者
		String nextUserAccount = "";
		String taskId = "";
		List<Task> taskList = getTaskListByProcessInstanceId(processInstanceId);
		if(taskList!=null && taskList.size()>0){
			nextUserAccount = taskList.get(0).getAssignee();
			taskId = taskList.get(0).getId();
		}
		//准备推送webSocket通知
		if(!StringUtils.isEmpty(nextUserAccount)){
			SysMessage message = new SysMessage();
			message.setCode(1);
			message.setTitle("待办事项通知");
			message.setContent("您有一个未处理的待办事项，请处理。");
			message.setViewSrc(taskUrl+taskId);
			WebClientUtils.sendMessage(nextUserAccount, JSON.toJSONString(message));
		}
	}
		
	/**  
     * 根据任务ID和节点ID获取活动节点 <br>  
     *   
     * @param taskId  
     *            任务ID  
     * @param activityId  
     *            活动节点ID <br>  
     *            如果为null或""，则默认查询当前活动节点 <br>  
     *            如果为"end"，则查询结束节点 <br>  
     *   
     * @return  
     * @throws Exception  
     */    
	public ActivityImpl findActivitiImpl(String taskId, String activityId)    
            throws Exception {    
        // 取得流程定义    
        ProcessDefinitionEntity processDefinition = findProcessDefinitionEntityByTaskId(taskId);    
    
        // 获取当前活动节点ID    
        if (activityId == null || "".equals(activityId.trim())) {    
            activityId = findTaskByTaskid(taskId).getTaskDefinitionKey();    
        }    
    
        // 根据流程定义，获取该流程实例的结束节点    
        if (activityId.toUpperCase().equals("END")) {    
            for (ActivityImpl activityImpl : processDefinition.getActivities()) {    
                List<PvmTransition> pvmTransitionList = activityImpl    
                        .getOutgoingTransitions();    
                if (pvmTransitionList.isEmpty()) {    
                    return activityImpl;    
                }    
            }    
        }    
    
        // 根据节点ID，获取对应的活动节点    
        ActivityImpl activityImpl = ((ProcessDefinitionImpl) processDefinition)    
                .findActivity(activityId);    
    
        return activityImpl;    
    }
	
    /**  
     * 根据任务ID获取流程定义  
     *   
     * @param taskId  
     *            任务ID  
     * @return  
     */    
    public ProcessDefinitionEntity findProcessDefinitionEntityByTaskId(String taskId) {    
        // 取得流程定义    
        ProcessDefinitionEntity processDefinition = (ProcessDefinitionEntity) ((RepositoryServiceImpl) repositoryService)    
                .getDeployedProcessDefinition(findTaskByTaskid(taskId)    
                        .getProcessDefinitionId());    
    
        return processDefinition;    
    }  
    
    /**  
     * 完成任务或流程转向
     * @param taskId  
     *            当前任务ID  
     * @param variables  
     *            流程变量  
     * @param activityId  
     *            流程转向执行任务节点ID<br>  
     *            此参数为空，默认为提交操作  
     * @throws Exception  
     */    
    private void commitProcess(String taskId, Map<String, Object> variables,    
            String activityId) throws Exception {    
        if (variables == null) {    
            variables = Maps.newHashMap(); 
        }    
        // 跳转节点为空，默认提交操作    
        if (activityId == null || "".equals(activityId.trim())) {    
            taskService.complete(taskId, variables);    
        } else {// 流程转向操作    
            turnTransition(taskId, activityId, variables);    
        }    
    }    
    
    /**  
     * 清空指定活动节点流向  
     *   
     * @param activityImpl  
     *            活动节点  
     * @return 节点流向集合  
     */    
    private List<PvmTransition> clearTransition(ActivityImpl activityImpl) {    
        // 存储当前节点所有流向临时变量    
        List<PvmTransition> oriPvmTransitionList = Lists.newArrayList();  
        // 获取当前节点所有流向，存储到临时变量，然后清空    
        List<PvmTransition> pvmTransitionList = activityImpl    
                .getOutgoingTransitions();    
        for (PvmTransition pvmTransition : pvmTransitionList) {    
            oriPvmTransitionList.add(pvmTransition);    
        }    
        pvmTransitionList.clear();    
    
        return oriPvmTransitionList;    
    }    
    
    /**  
     * 还原指定活动节点流向  
     *   
     * @param activityImpl  
     *            活动节点  
     * @param oriPvmTransitionList  
     *            原有节点流向集合  
     */    
    private void restoreTransition(ActivityImpl activityImpl,    
            List<PvmTransition> oriPvmTransitionList) {    
        // 清空现有流向    
        List<PvmTransition> pvmTransitionList = activityImpl    
                .getOutgoingTransitions();    
        pvmTransitionList.clear();    
        // 还原以前流向    
        for (PvmTransition pvmTransition : oriPvmTransitionList) {    
            pvmTransitionList.add(pvmTransition);    
        }    
    }    
    
    /**  
     * 流程转向操作  
     *   
     * @param taskId  
     *            当前任务ID  
     * @param activityId  
     *            目标节点任务ID  
     * @param variables  
     *            流程变量  
     * @throws Exception  
     */    
    private void turnTransition(String taskId, String activityId,    
            Map<String, Object> variables) throws Exception {    
        // 当前节点    
        ActivityImpl currActivity = findActivitiImpl(taskId, null);    
        // 清空当前流向    
        List<PvmTransition> oriPvmTransitionList = clearTransition(currActivity);    
    
        // 创建新流向    
        TransitionImpl newTransition = currActivity.createOutgoingTransition();    
        // 目标节点    
        ActivityImpl pointActivity = findActivitiImpl(taskId, activityId);    
        // 设置新流向的目标节点    
        newTransition.setDestination(pointActivity);    
    
        // 执行转向任务    
        taskService.complete(taskId, variables);    
        // 删除目标节点新流入    
        pointActivity.getIncomingTransitions().remove(newTransition);    
    
        // 还原以前流向    
        restoreTransition(currActivity, oriPvmTransitionList);    
    }
    
    /**
     * 根据实例Id查询当前任务信息
     * 
     * @param processInstanceId
     * @return
     */
    public List<Task> getActivityTask(String processInstanceId) {
    	return taskService.createTaskQuery().processInstanceId(processInstanceId)
    			.active()
				.orderByTaskCreateTime().desc().list();
    }
    
    /** 
     * 驳回流程（适合并行流程） 
     *  
     * @param taskId 
     *            当前任务ID 
     * @param activityId 
     *            驳回节点ID 
     * @param variables 
     *            流程存储参数 
     * @throws Exception 
     */  
    public void backProcessForParallel(String taskId, String activityId, Map<String, Object> variables) throws Exception {  
        if (activityId == null || "".equals(activityId.trim())) {  
            throw new Exception("驳回目标节点ID为空！");  
        }  
        
        // 查找所有待办任务节点，同时驳回  
        List<Task> taskList = getActivityTask(getProcessInstanceByTaskid(  
                taskId).getId());
        if(taskList != null && taskList.size() > 0) {
        	for(Task task : taskList) {
        		if(task.getId().equals(taskId)) { // 当前任务驳回
        			commitProcess(task.getId(), variables, activityId);
        		} else { // 其他任务默认完成
        			commitProcess(task.getId(), null, null);
        		}
        	}
        }
    }  
    
    /** 
     * 根据流程实例ID和任务key值查询所有同级任务集合 
     *  
     * @param processInstanceId 
     * @param key 
     * @return 
     */  
    public List<Task> findTaskListByKey(String processInstanceId, String key) {  
        return taskService.createTaskQuery().processInstanceId(  
                processInstanceId).taskDefinitionKey(key).list();  
    }
    
    public List<Task> findTask(String processInstanceId) {
		return taskService.createTaskQuery().processInstanceId(processInstanceId).list();
	}
    
    /**
	 * 查询流程状态（正在执行 or 已经执行结束）
	 */
	public ProcessInstance processState(String processInstanceId){
		return runtimeService.createProcessInstanceQuery().processInstanceId(
				processInstanceId).singleResult();
	}
	
	/**
	 * 获取下一步流程执行人
	 * @param processInstanceId
	 * @return
	 */
	public String findTaskNextStep(String processInstanceId, String processDefinitionId, Map<String, Object> variables){
		String status = "1";
		SysUser user = UserUtils.getCurrUser();
		if(variables.get("toHead")!=null && (boolean)variables.get("toHead")) {
			status="14";
		}
		if(variables.get("toHead1")!=null && (boolean)variables.get("toHead1")) {
			status="11";
		}
		if(processDefinitionId.contains("leave")) {
			if((boolean)variables.get("isOk")) {
				status="11";
			}else {
				status="1";
			}
		}
		if(processDefinitionId.contains("overtime")) {
			if((boolean)variables.get("isOk")) {
				status="11";
			}else {
				status="1";
			}
		}
		if(processDefinitionId.contains("travelReimburse")) {
			status="1";
		}
		if(processDefinitionId.contains("reimburse")) {
			status="1";
		}
		if(processDefinitionId.contains("travel")) {
			status="1";
		}
		if(processDefinitionId.contains("collection")) {
			if((boolean)variables.get("isOk")) {
				status="1";
			}else {
				status="7";
			}
		}
		//如果下一位执行者还是当前提交人，则直接执行处理下一步流程
		List<Task> taskList  = getTaskByProcessInstanceIdWithAssignee(processInstanceId, "user_"+user.getId());
		if(taskList == null || taskList.size() <= 0) {
			List<AdPosition> positionList = user.getPositionList();
			if(positionList != null) {
				for(AdPosition position : positionList) {
					taskList = getTaskByProcessInstanceIdWithAssignee(processInstanceId, "position_"+position.getId());
					if(taskList != null && taskList.size() > 0) {
						break ;
					}
				}
			}
		}
		if(taskList != null && taskList.size() > 0) {
			//完成一次流程任务
			Map<String, Object> variables1 = Maps.newHashMap();
			Map<String, Object> commentMap1 = Maps.newHashMap();
			commentMap1.put("node", taskList.get(0).getName());
			commentMap1.put("approver", user.getName());
			commentMap1.put("comment", "系统自动审批");
			if(taskList.get(0).getName().equals("部门经理") || taskList.get(0).getName().equals("项目负责人") || taskList.get(0).getName().equals("项目经理")) {
				commentMap1.put("approveResult", "通过");
			}
			
			commentMap1.put("approveDate", new Date());
			List<Map<String, Object>> commentList = (List<Map<String, Object>>) variables.get("commentList");
			commentList.add(commentMap1);
			variables1.put("commentList", commentList);
			variables1.put("approved", true);
			completeTask(taskList.get(0).getId(), variables1);
			if(taskList.get(0).getName().equals("部门经理") || taskList.get(0).getName().equals("项目负责人") || taskList.get(0).getName().equals("项目经理")) {
				if(processDefinitionId.contains("bargin")) {
					if(taskList.get(0).getName().equals("项目负责人")) {
						status = "1";
					}else {
						if((boolean) variables.get("toCeo")) {
							status = "3";
						}else {
							status = "2";
						}
					}
				}else if(processDefinitionId.contains("pay")) {
						status = "1";
				}else if(processDefinitionId.contains("collection")) {
					status = "7";
				}else if(processDefinitionId.contains("leave")) {
					if(taskList.get(0).getName().equals("项目经理")) {
						status = "1";
					}else if(taskList.get(0).getName().equals("部门经理")) {
						status = "2";
					}
				}else if(processDefinitionId.contains("overtime")) {
					if(taskList.get(0).getName().equals("项目经理")) {
						status = "1";
					}else if(taskList.get(0).getName().equals("部门经理")) {
						status = "2";
					}
				}else if(processDefinitionId.contains("travelReimburse")) {
					if((boolean) variables.get("isOk")) {
						status = "13";
					}else {
						status = "2";
					}
				}else if(processDefinitionId.contains("reimburse")) {
					if((boolean) variables.get("isOk")) {
						status = "13";
					}else {
						status = "2";
					}
				}else if(processDefinitionId.contains("travel")) {
					status = "1";
				}else {
						status = "2";
					}
			}
			}
		return status;
	}
	
	/**
	* @Title: getProcessImgById
	* @Description: 通过Taskid获取流程实例ID
	* @param taskId
	* @return String
	* @throws
	 */
	public String getProcessImgById(String taskId) {
		String processInstanceId = historyService.createHistoricTaskInstanceQuery().taskId(taskId).singleResult().getProcessInstanceId();
		return processInstanceId;
	}
	
}
