package com.reyzar.oa.controller.office;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.reyzar.oa.common.util.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.office.IOffPendflowService;

/** 
* @ClassName: TaskController 
* @Description: 待办事项
* @author Lin 
* @date 2016年6月17日 下午12:20:44 
*  
*/
@Controller
@RequestMapping(value="/manage/office/pendflow")
public class OffPendflowController extends BaseController {
	
	@Autowired
	private IOffPendflowService taskService;
	
	@RequestMapping(value="/toList")
	public String toList(Model model, HttpServletRequest request) {
		if (getUser().getId() != null) {
			model.addAttribute("deptid", getUser().getDeptId());
			model.addAttribute("userid", getUser().getId());
		}
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		if (UserUtils.CheckMobile.check(userAgent)){
			return "manage/office/pending/pendflow/mobilelist";
		}else {
			return "manage/office/pending/pendflow/list";
		}

	}
	
	@RequestMapping(value="/getPendflowList")
	@ResponseBody
	public CrudResultDTO getPendflowList() {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, null); 
		
		SysUser user = getUser();
		List<Map<String, Object>> resultList = taskService.findTaskByAssignee("user_" + user.getId().toString());
		List<AdPosition> positionList = user.getPositionList();
		if(positionList != null && positionList.size()>0) {
			for(AdPosition position : positionList) {
				resultList.addAll(taskService.findTaskByAssignee("position_" + position.getId()));
			}
		}
		result.setResult(resultList);
		JSON.toJSONString(result, SerializerFeature.EMPTY);
		return result;
	}
	
	/**
	* @Title: getTodoList
	* @Description: 获取当前用户待办任务
	* @return List<Map<String,Object>>
	* @throws
	 */
	@RequestMapping(value="/getTodoList")
	@ResponseBody
	public void getTodoList(HttpServletResponse response) {
		SysUser user = getUser();
		List<Map<String, Object>> taskList =new ArrayList<Map<String, Object>>();
		if(!StringUtils.isEmpty(user)){
			taskList = taskService.findTaskByAssignee("user_" + user.getId().toString());
			List<AdPosition> positionList = user.getPositionList();
			if(positionList != null && positionList.size()>0) {
				for(AdPosition position : positionList) {
					taskList.addAll(taskService.findTaskByAssignee("position_" + position.getId()));
				}
			}
			if(taskList != null && taskList.size() > 0) {
				for(Map<String, Object> map : taskList) {
					map.remove("variables");
					map.remove("task");
				}
			}
		}
		renderJSONString(response, taskList);
	}
	
	@RequestMapping("/getOrderNo")
	@ResponseBody
	public CrudResultDTO getOrderNo(@RequestBody JSONArray jsonArray) {
		return taskService.getOrderNo(jsonArray);
	}
	
	@RequestMapping("/completeTask")
	@ResponseBody
	public CrudResultDTO completeTask(String processId) {
		return taskService.completeTask(processId);
	}
}
