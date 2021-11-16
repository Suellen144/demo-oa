package com.reyzar.oa.act.service;

import java.lang.reflect.Method;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.dozer.DozerBeanMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.act.dao.IActivitiDao;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.gen.util.ConvertUtil;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.SpringContextUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysUserService;

/** 
* @ClassName: ActivitiService 
* @Description: Activiti 业务处理 Service
* @author Lin 
* @date 2016年9月22日 下午4:22:02 
*  
*/
@Service
public class ActivitiService {

	@Autowired
	private IActivitiDao activitiDao;
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private ISysUserService userService;
	
	private DozerBeanMapper dozer = new DozerBeanMapper();
	
	private final static Logger logger = Logger.getLogger(ActivitiService.class);
	
	/**
	* @Title: getBusinessWithProcess
	* @Description: 获取任务节点的相关数据
	* @param  paramMap
	* @return Map<String,Object>
	* 			key: user 		value: 流程发起人
	* 			key: business 	value: 业务关联对象（比如请假流程的AdLeave对象）
	* 			key: task		value: 当前任务节点
	* 			key: pd			value: 流程定义对象
	* 			key: variables	value: 存放到流程实例的变量集合
	* @throws
	 */
	public Map<String, Object> getBusinessWithProcess(Map<String, String> paramMap) {
		Map<String, Object> result = Maps.newHashMap();
		Map<String, Object> variables = Maps.newHashMap();
		Object business = null; // 业务对象
		SysUser initiator = new SysUser(); // 流程发起人
		String processInstanceId = paramMap.get("processInstanceId");
		
		variables = activitiUtils.getHistoryVariablesByProcessInstanceId(processInstanceId);
		ProcessInstance processInstance = activitiUtils.getProcessInstanceByProcessInstanceId(processInstanceId);
		if(processInstance == null) { // 流程结束
			result.put("processEnd", true);
		} else { // 流程未结束，获取其他数据
			SysUser user = UserUtils.getCurrUser();
			List<Task> taskList = activitiUtils.getTaskByProcessInstanceIdWithAssignee(processInstanceId, "user_"+user.getId());
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
				result.put("task", taskList.get(0));
				result.put("taskList", taskList);
				result.put("isHandler", true); // 当前任务的办理人
			} else {
				taskList = activitiUtils.getTaskListByProcessInstanceId(processInstanceId);
				if(taskList != null && taskList.size() > 0) {
					result.put("task", taskList.get(0));
					result.put("taskList", taskList);
				}
				result.put("isHandler", false);
			}
			result.put("activityTaskList", activitiUtils.getActivityTask(processInstanceId)); // 活动的任务节点
			result.put("processEnd", false); // 流程是否结束
		}
		
		// 获取业务对象
		business = getBusinessObject(variables.get("businessParams"));
		
		// 获取流程发起人
		Integer userId = variables.get("initiator") != null ? Integer.valueOf(variables.get("initiator").toString()) : null;
		if(userId != null) {
			initiator = userService.findAllById(userId);
		}
		
		result.put("initiator", initiator);
		result.put("business", business);
		result.put("variables", variables);
		/**
		 * 提供两种版本的值
		 * 1、原生Java对象（上面的对象）
		 * 2、JSON格式对象（一般供JS使用，以下为将上面的对象转换为JSON） 
		 * */
		Map<String, Object> jsonMap = Maps.newHashMap();
		jsonMap.put("initiator", JSON.toJSON(initiator));
		jsonMap.put("business", JSON.toJSON(business));
		jsonMap.put("variables", JSON.toJSON(variables));
		
		result.put("jsonMap", jsonMap);
		return result;
	}
	
	/**
	 * 访问指定表、指定主键并将数据反射给予领域对象
	 * */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Object getBusinessObject(String tableName, Integer id, String entityClass) {
		Object result = null;
		
		try {
			List<Map<String, Object>> dataList = activitiDao.findOne(tableName, id);
			if(dataList != null && dataList.size() > 0) {
				Class clazz = Class.forName(entityClass);
				
				List<Map<String, Object>> newList = Lists.newArrayList();
				for(Map<String, Object> map : dataList) {
					Map<String, Object> newMap = Maps.newHashMap();
					Set<String> keys = map.keySet();
					for(String key : keys) {
						Object value = map.get(key);
						String newKey = ConvertUtil.underlineToUpper(key.toLowerCase());
						
						newMap.put(newKey, value);
					}
					newList.add(newMap);
				}
				
				if(newList.size() > 0) {
					result = dozer.map(newList.get(0), clazz);
				}
			}
		} catch(Exception e) {}
		
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes", "unused"})
	private Object getBusinessObject(String tableName, Map<String, Object> columnsMap, String entityClass) {
		List<Object> result = null;
		
		try {
			List<Map<String, Object>> dataList = activitiDao.findByColumn(tableName, columnsMap);
			if(dataList != null && dataList.size() > 0) {
				Class clazz = Class.forName(entityClass);
				
				List<Map<String, Object>> newList = Lists.newArrayList();
				for(Map<String, Object> map : dataList) {
					Map<String, Object> newMap = Maps.newHashMap();
					Set<String> keys = map.keySet();
					for(String key : keys) {
						Object value = map.get(key);
						String newKey = ConvertUtil.underlineToUpper(key.toLowerCase());
						
						newMap.put(newKey, value);
					}
					newList.add(newMap);
				}
				
				if(newList.size() > 0) {
					result = Lists.newArrayList();
					for(Map<String, Object> map : newList) {
						Object obj = dozer.map(map, clazz);
						result.add(obj);
					}
				}
			}
		} catch(Exception e) {}
		
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Object getBusinessObject(Object businessParam) {
		Object result = null;
		Map<String, Object> paramsMap = null;
		if(businessParam instanceof Map) {
			paramsMap = (Map<String, Object>)businessParam;
		} else {
			return result;
		}
		try {
			Class clazz = Class.forName(paramsMap.get("class").toString());
			Object service = SpringContextUtils.getBean(clazz);
			Object[] params = {}; 
			Object paramValue = paramsMap.get("paramValue");
			String methodName = paramsMap.get("method").toString();
			
			Method[] methods = service.getClass().getMethods();
			Method method = null;
			for(Method temp : methods) {
				if(temp.getName().equals(methodName)) {
					method = temp;
				}
			}
			if(paramValue instanceof Object[]) {
				params = (Object[])paramsMap.get("paramValue");
			} else if(paramValue instanceof Collection) {
				params = ((Collection)paramsMap.get("paramValue")).toArray(new Object[]{});
			}
			
			if(method != null) {
				result = method.invoke(service, params);
			}
		} catch(Exception e) {}
		
		return result;
	}
	
	/**
	 * 完成一次任务
	 * */
	public CrudResultDTO completeTask(String taskId, Map<String, Object> variables) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			activitiUtils.completeTask(taskId, variables);
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult("操作成功！");
		} catch(Exception e) {
			logger.info(e.getMessage());
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
		}
		return result;
	}
	
	/**
	 * 删除流程实例
	 * */
	public CrudResultDTO deleteProcessInstance(String processInstanceId) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			activitiUtils.deleteProcessInstance(processInstanceId);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "操作失败:" + e.getMessage());
			new BusinessException(e.getMessage());
		}
		return result;
	}
	
	/**
	 * 中止流程实例
	 */
	public CrudResultDTO endProcessInstance(String taskId, Map<String, Object> variables) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			activitiUtils.endProcess(taskId, variables);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "操作失败:" + e.getMessage());
			new BusinessException(e.getMessage());
		}
		return result;
	}
	
	/**
	 * 中止有并行任务的流程实例
	 */
	public CrudResultDTO endProcessByProcessInstanceId(String processInstanceId, Map<String, Object> variables) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			activitiUtils.endProcessByProcessInstanceId(processInstanceId, variables);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "操作失败:" + e.getMessage());
			new BusinessException(e.getMessage());
		}
		return result;
	}
	
	/**
	 * 驳回并行流程
	 * （并行流程不能用常规驳回，只能用此方法）
	 */
	public CrudResultDTO backProcessForParallel(String taskId, String applyTask, Map<String, Object> variables) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			activitiUtils.backProcessForParallel(taskId, applyTask, variables);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "操作失败:" + e.getMessage());
			new BusinessException(e.getMessage());
		}
		return result;
	}
	
	public CrudResultDTO getTaskList(Integer userId, String processInstanceId) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.FAILED, null);
		List<Map<String, Object>> resultList = Lists.newArrayList();
		SysUser user = userService.findById(userId);
		if(user != null) {
			resultList.addAll(findTaskList("user_" + user.getId().toString(), processInstanceId));
			List<AdPosition> positionList = user.getPositionList();
			if(positionList != null) {
				for(AdPosition position : positionList) {
					resultList.addAll(findTaskList("position_" + position.getId(), processInstanceId));
				}
				
				result = new CrudResultDTO(CrudResultDTO.SUCCESS, resultList);
			}
		}
		
		return result;
	}
	
	private List<Map<String, Object>> findTaskList(String assignee, String processInstanceId) {
		List<Map<String, Object>> result = Lists.newArrayList();
		List<Task> taskList = Lists.newArrayList();
		
		if(processInstanceId == null || "".equals(processInstanceId.trim())) {
			taskList = activitiUtils.findTaskByAssignee(assignee); 
		} else {
			taskList = activitiUtils.findTaskByAssigneeWithProcessInstanceId(assignee, processInstanceId);
		}
		
		if(taskList != null) {
			for(Task task : taskList) {
				Map<String, Object> map = Maps.newHashMap();
				ProcessInstance processInstance = activitiUtils.getProcessInstanceByTaskid(task.getId());
				Map<String, Object> taskMap = Maps.newHashMap();
				taskMap.put("id", task.getId());
				taskMap.put("name", task.getName());
				taskMap.put("assignee", task.getAssignee());
				taskMap.put("processInstanceId", task.getProcessInstanceId());
				taskMap.put("taskDefinitionKey", task.getTaskDefinitionKey());
				taskMap.put("executionId", task.getExecutionId());
				taskMap.put("processVariables", task.getProcessVariables());
				map.put("task", taskMap);
				map.put("businessKey", processInstance != null ? processInstance.getBusinessKey() : "");
				result.add(map);
			}
		}
		return result; 
	}
	
	public CrudResultDTO setTaskVariables(String taskId, Map<String, Object> variables) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "设置流程变量成功！");
		try {
			activitiUtils.setTaskVariables(taskId, variables);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}
	
	/**
	 * 获取当前用户指定流程待办的业务主键
	 * */
	public List<Integer> getBusinessIdList(String processDefinitionKey) {
		List<Integer> idList = Lists.newArrayList();
		List<Task> taskList = Lists.newArrayList();
		SysUser user = UserUtils.getCurrUser();
		
		taskList.addAll(activitiUtils.findTaskByAssigneeWithProcessDefinitionKey("user_" + user.getId().toString(), processDefinitionKey));
		List<AdPosition> positionList = user.getPositionList();
		if(positionList != null) {
			for(AdPosition position : positionList) {
				taskList.addAll(activitiUtils.findTaskByAssigneeWithProcessDefinitionKey("position_" + position.getId().toString(), processDefinitionKey));
			}
		}
		
		for(Task task : taskList) {
			ProcessInstance pi = activitiUtils.getProcessInstanceByTaskid(task.getId());
			if(pi != null && pi.getBusinessKey() != null && !"".equals(pi.getBusinessKey().trim())) {
				idList.add(Integer.valueOf(pi.getBusinessKey()));
			}
		}
		return idList;
	}
	
	public CrudResultDTO getTask(String processInstanceId) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.FAILED, null);
		List<Map<String, Object>> resultList = Lists.newArrayList();
		resultList.addAll(findTask(processInstanceId));
		result = new CrudResultDTO(CrudResultDTO.SUCCESS, resultList);
		return result;
	}
	
	/**
	 * 根据任务实例ID查询当前任务节点
	 * @param processInstanceId
	 * @return
	 */
	private List<Map<String, Object>> findTask(String processInstanceId) {
		List<Map<String, Object>> result = Lists.newArrayList();
		List<Task> taskList = Lists.newArrayList();
		if(processInstanceId != null || !"".equals(processInstanceId.trim())) {
			taskList = activitiUtils.findTask(processInstanceId);
		}
		if(taskList != null) {
			for(Task task : taskList) {
				Map<String, Object> map = Maps.newHashMap();
				ProcessInstance processInstance = activitiUtils.getProcessInstanceByTaskid(task.getId());
				Map<String, Object> taskMap = Maps.newHashMap();
				taskMap.put("id", task.getId());
				taskMap.put("name", task.getName());
				taskMap.put("assignee", task.getAssignee());
				taskMap.put("processInstanceId", task.getProcessInstanceId());
				taskMap.put("taskDefinitionKey", task.getTaskDefinitionKey());
				taskMap.put("executionId", task.getExecutionId());
				taskMap.put("processVariables", task.getProcessVariables());
				map.put("task", taskMap);
				map.put("businessKey", processInstance != null ? processInstance.getBusinessKey() : "");
				result.add(map);
			}
		}
		return result; 
	}
	
	public CrudResultDTO processState(String processInstanceId) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.FAILED, null);
		ProcessInstance pi = activitiUtils.processState(processInstanceId);
		result = new CrudResultDTO(CrudResultDTO.SUCCESS, pi);
		return result;
	}
	
	public CrudResultDTO getTaskNext(String taskId) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			SysUser user = UserUtils.getCurrUser();
			String processInstanceId = activitiUtils.getProcessImgById(taskId);
			List<Task> taskList = activitiUtils.getTaskByProcessInstanceIdWithAssignee(processInstanceId, "user_"+user.getId());
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
}
