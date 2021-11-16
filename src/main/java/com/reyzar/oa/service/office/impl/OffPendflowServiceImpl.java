package com.reyzar.oa.service.office.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.act.dao.IActivitiDao;
import com.reyzar.oa.act.service.ActivitiService;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IFinReimburseDao;
import com.reyzar.oa.dao.IFinTravelreimburseDao;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.domain.FinReimburse;
import com.reyzar.oa.domain.FinTravelreimburse;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.ValidationJump;
import com.reyzar.oa.service.office.IOffPendflowService;
import com.reyzar.oa.service.sys.ISysUserService;

@Service
@Transactional
public class OffPendflowServiceImpl implements IOffPendflowService {
	
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private ISysUserService userService;
	@Autowired
	private IActivitiDao activitiDao;
	@Autowired
	private ActivitiService activitiService;
	@Autowired
	private IFinReimburseDao reimburseDao;
	@Autowired
	private IFinTravelreimburseDao travelreimburseDao;
	@Autowired
	private ISaleBarginManageDao iSaleBarginManageDao;

	@Override
	public List<Map<String, Object>> findTaskByAssignee(String assignee) {
		List<Map<String, Object>> result = Lists.newArrayList();
		List<Task> taskList = activitiUtils.findTaskByAssignee(assignee); 
		if(taskList != null) {
			for(Task task : taskList) {
				Map<String, Object> variables = activitiUtils.getVariablesByTaskid(task.getId());
				ProcessDefinition pd = activitiUtils.getProcessDefinitionByTaskid(task.getId());
				SysUser initiator = userService.findAllById(Integer.valueOf(variables.get("initiator").toString()));
				Object  business = activitiService.getBusinessObject(variables.get("businessParams"));
				Map<String, Object> taskMap = Maps.newHashMap();
				Map<String, Object> taskObj = Maps.newHashMap();
				taskObj.put("id", task.getId());
				taskObj.put("name", task.getName());
				taskObj.put("assignee", task.getAssignee());
				taskObj.put("createTime", task.getCreateTime());

				taskMap.put("task", taskObj);
				taskMap.put("processInstanceId", task.getProcessInstanceId());
				taskMap.put("processName", pd.getName());
				taskMap.put("processKey", pd.getKey());
				taskMap.put("initiator", initiator);
				taskMap.put("business", JSON.toJSON(business));
				
				//根据流程id,去各个表查询数据，返回结果取 is_new_project，如果是1 则代表项目管理模块创建
				//代办列表则跳转至新审批页面
				if(task.getProcessInstanceId()!=null) {
					List<ValidationJump> validationJump= iSaleBarginManageDao.findByValidationJump(task.getProcessInstanceId());
					if(validationJump!=null && validationJump.size()>0) {
						taskMap.put("validationJump", validationJump);
					}else {
						taskMap.put("validationJump", new ArrayList<ValidationJump>());
					}
				}else {
					taskMap.put("validationJump", new ArrayList<ValidationJump>());
				}
				result.add(taskMap);
			}
		}
		return result; 
	}

	@Override
	public CrudResultDTO getOrderNo(JSONArray jsonArray) {
		List<Map<String, Object>> resultList = Lists.newArrayList();
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, resultList);
		
		int size = jsonArray.size();
		for(int index=0; index < size; index++) {
			try {
				JSONObject json = jsonArray.getJSONObject(index);
				String tableName = json.getString("tableName");
				String column = json.getString("column");
				Object[] dataList = json.getJSONArray("dataList").toArray();
				
				resultList.addAll(activitiDao.findInAssignColumn(tableName, column, Lists.newArrayList(dataList)));
			} catch(Exception e) {}
		}
		
		return result;
	}
	
	
	@Override
	public CrudResultDTO completeTask(String processId){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功");
				try {
					List<Task> taskList = activitiUtils.getActivityTask(processId);
					for (Task task : taskList) {
						Map<String, Object> variables = activitiUtils.getVariablesByTaskid(task.getId());
						@SuppressWarnings("unchecked")
						List<Map<String, Object>> commentList = (List<Map<String, Object>>)variables.get("commentList");
						Map<String, Object> commentMap = Maps.newHashMap();
						commentMap.put("node", "出纳");
						commentMap.put("approver",UserUtils.getCurrUser().getName());
						commentMap.put("comment", " ");
						commentMap.put("approveResult", "通过");
						commentMap.put("approveDate", new Date());
						commentList.add(commentMap);
						variables.put("commentList", commentList); 
						activitiUtils.completeTask(task.getId(), variables);
					}
					
					FinReimburse reimburse = reimburseDao.findByProcessId(processId);
					FinTravelreimburse travelreimburse = travelreimburseDao.findByProcessId(processId);
					if (reimburse != null) {
						reimburse.setStatus("6");
						reimburse.setUpdateBy(UserUtils.getCurrUser().getAccount());
						reimburse.setUpdateDate(new Date());
						reimburseDao.update(reimburse);
					}
					if (travelreimburse != null) {
						travelreimburse.setStatus("6");
						travelreimburse.setUpdateBy(UserUtils.getCurrUser().getAccount());
						travelreimburse.setUpdateDate(new Date());
						travelreimburseDao.update(travelreimburse);
					}
				} catch (Exception e) {
					result = new CrudResultDTO(CrudResultDTO.FAILED, "操作失败！");
					e.printStackTrace();
				}
		return result; 
		
	}


	
}
