package com.reyzar.oa.act.listener;

import java.util.List;
import java.util.Map;

import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.apache.log4j.Logger;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.PositionConstant;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.SpringContextUtils;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysProcessTodo;
import com.reyzar.oa.domain.SysProcessTodoNode;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdPositionService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysProcessTodoService;
import com.reyzar.oa.service.sys.ISysUserService;

@SuppressWarnings("serial")
public class CommonTaskListener implements TaskListener {
	
	private final static Logger logger = Logger.getLogger(CommonTaskListener.class);
	
	private final static Integer POSITION_LEVEL_OF_MANAGER = 3; // 部门经理职位等级
	private final static Integer POSITION_LEVEL_OF_DEPUTY_MANAGER = 4; // 部门副经理职位等级

	ISysUserService userService = SpringContextUtils.getBean(ISysUserService.class);
	ISysDeptService deptService = SpringContextUtils.getBean(ISysDeptService.class);
	IAdPositionService positionService = SpringContextUtils.getBean(IAdPositionService.class);
	ISysProcessTodoService processTodoService = SpringContextUtils.getBean(ISysProcessTodoService.class);
	ActivitiUtils activitiUtils = SpringContextUtils.getBean(ActivitiUtils.class);
	
	// processtodo 指定的节点名称与流程图节点名称对应关系，如果有新的流程节点需要从页面上指定办理人，则在此需要添加
	private static Map<String, String> nodeMap = Maps.newHashMap();
	static {
		nodeMap.put("HR", "hr");
//		nodeMap.put("部门经理", "deptManager");
		nodeMap.put("经办", "handler");
		nodeMap.put("复核", "checker");
		nodeMap.put("出纳", "teller");
		nodeMap.put("总经理", "ceo");
		nodeMap.put("财务", "finance");
	}
	
	
	/**
	 * 有三种指定办理人方式
	 * 1、根据 “组织机构” 里的部门负责人来指定
	 * 2、根据 “职位管理” 的职位来指定
	 * 3、根据页面指定流程任务环节办理人来指定
	 * */
	@SuppressWarnings("unchecked")
	@Override
	public void notify(DelegateTask delegateTask) {
		
		List<String> assigneeList = Lists.newArrayList();
		List<SysUser> userList = Lists.newArrayList();
		List<AdPosition> positionList = Lists.newArrayList();
		
		String taskName = delegateTask.getName();
		Integer userId = Integer.valueOf(delegateTask.getVariable("initiator").toString());
		SysUser initiator = userService.findAllById(userId);
		
		if(taskName.equals("调整申请") || taskName.equals("提交申请") || taskName.equals("销假") || taskName.equals("发起人确认")) {
			userList.add(initiator);
		} else {
			SysUser assignee = getAssigneeByNode(delegateTask, initiator);
			if( assignee == null ) { // 没有指定办理人，则使用默认模式获取办理人

				if(taskName.equals("部门经理审批") || taskName.equals("部门经理")) { // 根据部门负责人获取
					Map<String, Object> map = getAssigneeByDept(initiator);
					if(map.get("positionList") != null) {
						positionList = (List<AdPosition>) map.get("positionList");
					} else {
						userList.add((SysUser) map.get("assignee")); 
					}
				} else { // 根据职位获取
					positionList = getAssigneeByPosition(delegateTask, initiator);
				}
			} else {
				userList.add(assignee);
			}
		}
		
		for(SysUser temp : userList) {
			if(temp != null) {
				assigneeList.add("user_" + temp.getId());
			}
		}
		for(AdPosition position : positionList) {
			if(position != null) {
				assigneeList.add("position_" + position.getId());
			}
		}

		if(assigneeList.size() > 0) {
			delegateTask.addCandidateUsers(assigneeList);
		}
	}
	
	/**
	 * @Title: getAssigneeByNode
	 * @Description: 获取任务环节指定办理人
	 * @param delegateTask
	 * @param initiator 流程发起人
	 * @return SysUser 
	 * 			有指定则返回 assignee
	 * 			无指定则返回 null
	 * */
	private SysUser getAssigneeByNode(DelegateTask delegateTask, SysUser initiator) {
		SysUser assignee = null;
		
		try {
			if(delegateTask.getVariable("userId") != null && delegateTask.getName().equals("项目负责人")) {
				Integer userId = Integer.valueOf(String.valueOf(delegateTask.getVariable("userId")));
				assignee = userService.findAllById(userId);
			}else if(delegateTask.getVariable("userId3") != null && delegateTask.getName().equals("项目经理")){
				Integer userId = Integer.valueOf(String.valueOf(delegateTask.getVariable("userId3")));
				assignee = userService.findAllById(userId);
			}else if(delegateTask.getVariable("userId2") != null && (delegateTask.getName().equals("部门主管") || delegateTask.getName().equals("部门经理"))) {
				Integer userId = Integer.valueOf(String.valueOf(delegateTask.getVariable("userId2")));
				assignee = userService.findAllById(userId);
			}else {
				String process = delegateTask.getProcessDefinitionId().split(":")[0]; // 获取流程名称，如leave
				SysDept deptOfUser = deptService.findById(initiator.getDeptId());
				String companyId = deptOfUser.getNodeLinks().split(",")[2]; // 发起人所在公司
				
				SysProcessTodo processTodo = processTodoService.findByCompanyIdAndProcess(Integer.valueOf(companyId), process);
				if( processTodo != null && processTodo.getNodeList() != null ) {
					String taskName = delegateTask.getName();
					String nodeName = nodeMap.get(taskName);
					if( nodeName != null && !"".equals(nodeName) ) {
						List<SysProcessTodoNode> nodeList = processTodo.getNodeList();
						for( SysProcessTodoNode node : nodeList ) {
							if( nodeName.equals(node.getNode()) ) {
								assignee = node.getHandler();
								break ;
							}
						}
					}
				}
			}
		} catch(Exception e) {
			logger.error("获取指定流程办理人异常。异常信息：" + e.getMessage());
		}
		
		return assignee;
	}

	/**
	* @Title: getAssigneeByDept
	* @Description: 获取部门(副)经理职位或部门(副)负责人，有职位的情况获取职位，没有就获取负责人
	* @param initiator
	* @return Map
	 */
	private Map<String, Object> getAssigneeByDept(SysUser initiator) {
		Map<String, Object> result = Maps.newHashMap();
		try {
			List<AdPosition> positionList = positionService.findPositionOfManagerByDeptIdAndLevel(initiator.getDeptId(), POSITION_LEVEL_OF_MANAGER); // 查询当前部门的部门经理职位
			if(positionList == null || positionList.size() <= 0) {
				positionList = positionService.findPositionOfManagerByDeptIdAndLevel(initiator.getDeptId(), POSITION_LEVEL_OF_DEPUTY_MANAGER); // 查询当前部门的部门副经理职位
			}
			if(positionList != null && positionList.size() > 0) {
				result.put("positionList", positionList);
			} else {
				SysDept dept = deptService.findById(initiator.getDeptId());
				SysUser assignee = userService.findById(dept.getUserId()); // 获取部门经理
				if( assignee == null ) {
					assignee = userService.findById(dept.getAssistantId()); // 获取部门副经理
				}
				
				result.put("assignee", assignee);
			}
		} catch(Exception e) {
			logger.error("根据部门获取流程办理人异常。异常信息：" + e.getMessage());
		}
		return result;
	}
	
	/**
	* @Title: getAssigneeByPosition
	* @Description: 获取处理任务环节需要的职位
	  @param delegateTask
	  @param initiator
	* @return List<AdPosition>
	 */
	private List<AdPosition> getAssigneeByPosition(DelegateTask delegateTask, SysUser initiator) {
		List<AdPosition> positionList = Lists.newArrayList();
		
		try {
			List<AdPosition> tempList = PositionConstant.getPositionList(delegateTask.getName());
			if( tempList != null && tempList.size() > 0 ) {
				SysDept deptOfUser = deptService.findById(initiator.getDeptId());
				String company = deptOfUser.getNodeLinks().split(",")[2]; // 发起人所在公司
				
				for(AdPosition position : tempList) {
					SysDept tempDept = deptService.findById(position.getDeptId());
					if(tempDept != null) {
						String tempCompany = tempDept.getNodeLinks().split(",")[2];
						if( company.equals(tempCompany) ) { // 职位所属公司跟发起人处于同一公司才加入到任务处理
							positionList.add(position);
						}
					}
				}
			}
		} catch(Exception e) {
			logger.error("根据职位获取流程办理人异常。异常信息：" + e.getMessage());
		}
		
		return positionList;
	}
}
