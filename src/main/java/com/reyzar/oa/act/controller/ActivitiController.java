package com.reyzar.oa.act.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.act.service.ActivitiService;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.controller.BaseController;

/** 
* @ClassName: ActivitiController 
* @Description: 流程公共功能
* @author Lin 
* @date 2016年7月18日 下午6:17:20 
*  
*/
@Controller
@RequestMapping("/activiti")
public class ActivitiController extends BaseController {

	@Autowired
	private ActivitiUtils actUtils;
	@Autowired
	private ActivitiService activitiService;
	
	/**
	* @Title: toProcess
	* @Description: 跳转到任务处理页面
	* @param paramMap
	* @param  model
	* @return String
	* @throws
	 */
	@RequestMapping("/process")
	public String toProcess(@RequestParam Map<String, String> paramMap, Model model) {
		Map<String, Object> map = activitiService.getBusinessWithProcess(paramMap);
		model.addAttribute("map", map);
		return paramMap.get("page");
	}
	
	/**
	* @Title: toProcess
	* @Description: 跳转到任务处理页面
	* @param paramMap
	* @param  model
	* @return String
	* @throws
	 */
	@RequestMapping("/process2")
	public String toProcess2(@RequestParam Map<String, String> paramMap, Model model) {
		Map<String, Object> map = activitiService.getBusinessWithProcess(paramMap);
		String type = map.get("business").toString();
		if(type.contains("Travelreimburse")) {
			paramMap.put("page", "manage/finance/travelReimburs/process");
		}else if(type.contains("Reimburse")) {
			paramMap.put("page", "manage/finance/reimburs/process");
		}else if(type.contains("Pay")) {
			paramMap.put("page", "manage/finance/pay/process");
		}else{
			FinCollection finCollection=(FinCollection) map.get("business");
			if(finCollection.getIsOldData()==1) {
				paramMap.put("page", "manage/finance/collection/processNew");
			}else {
				paramMap.put("page", "manage/finance/collection/process");
			}
		}
		model.addAttribute("map", map);
		return paramMap.get("page");
	}
	
	/**
	* @Title: complete
	* @Description: 完成一次任务
	* @param taskId
	* @param variables 存放到流程实例的变量集合
	* @return CrudResultDTO
	* @throws
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/completeTask")
	@ResponseBody
	public CrudResultDTO completeTask(@RequestBody(required=true) Map<String, Object> param) {
		String taskId = param.get("taskId").toString();
		Map<String, Object> variables = (Map<String, Object>)param.get("variables");
		return activitiService.completeTask(taskId, variables);
	}
	
	/***
	* @Title: deleteProcessInstance
	* @Description: 删除流程实例
	* @param processInstanceId
	* @return String
	* @throws
	 */
	@RequestMapping("/deleteProcessInstance")
	@ResponseBody
	public CrudResultDTO deleteProcessInstance(String processInstanceId) {
		return activitiService.deleteProcessInstance(processInstanceId);
	}
	
	/***
	* @Title: endProcessInstance
	* @Description: 中止流程实例
	* @param taskId
	* @return String
	* @throws
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/endProcessInstance")
	@ResponseBody
	public CrudResultDTO endProcessInstance(@RequestBody JSONObject json) {
		CrudResultDTO result = null;
		try {
			String taskId = json.getString("taskId");
			Map<String, Object> variables = json.getObject("variables", Map.class);
			result = activitiService.endProcessInstance(taskId, variables);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}
	
	/***
	* @Title: endProcessByProcessInstanceId
	* @Description: 中止流程实例（有并行任务的流程）
	* @param processInstanceId
	* @return String
	* @throws
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/endProcessOfParallel")
	@ResponseBody
	public CrudResultDTO endProcessOfParallel(@RequestBody JSONObject json) {
		CrudResultDTO result = null;
		try {
			String processInstanceId = json.getString("processInstanceId");
			Map<String, Object> variables = json.getObject("variables", Map.class);
			result = activitiService.endProcessByProcessInstanceId(processInstanceId, variables);
			
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/backProcessForParallel")
	@ResponseBody
	public CrudResultDTO backProcessForParallel(@RequestBody JSONObject json) {
		CrudResultDTO result = null;
		try {
			String taskId = json.getString("taskId");
			String applyTask = json.getString("applyTask"); // 重新申请节点的名称
			Map<String, Object> variables = json.getObject("variables", Map.class);
			result = activitiService.backProcessForParallel(taskId, applyTask, variables);
			
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}
	
	@RequestMapping("/getImgByProcessInstancdId")
	public void getImgByProcessInstancdId(String processInstanceId, HttpServletResponse response) throws IOException {
		InputStream is = actUtils.getProcessImgByProcessInstanceId(processInstanceId);
		outToClient(is, response);
	}
	
	@RequestMapping("/getImgByTaskId")
	public void getImgByTaskId(String taskId, HttpServletResponse response) throws IOException {
		InputStream is = actUtils.getProcessImgByTaskId(taskId);
		outToClient(is, response);
	}
	
	private void outToClient(InputStream is, HttpServletResponse response) throws IOException {
		OutputStream out = response.getOutputStream();
		BufferedOutputStream bufferOut = new BufferedOutputStream(out);
		BufferedInputStream bufferIn = new BufferedInputStream(is);
		 
		byte[] buffer = new byte[2048];
		int size = bufferIn.read(buffer);
		while(size != -1){
		    bufferOut.write(buffer, 0, size);
		    size = bufferIn.read(buffer);
		}
		bufferIn.close();
		bufferOut.close();
	}
	
	@RequestMapping("/getTaskList")
	@ResponseBody
	public String getTaskList(@RequestParam(value="userId",required=false) Integer userId,
			@RequestParam(value="processInstanceId",required=false) String processInstanceId) {
		return JSON.toJSONString(activitiService.getTaskList(userId, processInstanceId));
	}
	
	@RequestMapping("/setTaskVariables")
	@ResponseBody
	public String setTaskVariables(@RequestBody Map<String, Object> variables) {
		String taskId = variables.get("taskId").toString();
		variables.remove("taskId");
		return JSON.toJSONString(activitiService.setTaskVariables(taskId, variables));
	}
	
	@RequestMapping("/getBusinessIdList")
	@ResponseBody
	public List<Integer> getBusinessIdList(String processDefinitionKey) {
		return activitiService.getBusinessIdList(processDefinitionKey);
	}
	
	@RequestMapping("/getTask")
	@ResponseBody
	public String getTask(@RequestBody Map<String, Object> processInstanceId) {
		String id = processInstanceId.get("processInstanceId").toString();
		return JSON.toJSONString(activitiService.getTask(id));
	}
	
	@RequestMapping("/processState")
	@ResponseBody
	public String processState(@RequestBody Map<String, Object> processInstanceId) {
		String id = processInstanceId.get("processInstanceId").toString();
		return JSON.toJSONString(activitiService.getTask(id));
	}
	
	@RequestMapping("/getTaskNext")
	@ResponseBody
	public String getTaskNext(@RequestBody JSONObject json) {
		String taskId = json.getString("taskId");
		return JSON.toJSONString(activitiService.getTaskNext(taskId));
	}
}
