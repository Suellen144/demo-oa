package com.reyzar.oa.controller.sys;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.Map;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.activiti.bpmn.converter.BpmnXMLConverter;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.editor.constants.ModelDataJsonConstants;
import org.activiti.editor.language.json.converter.BpmnJsonConverter;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.Model;
import org.activiti.engine.repository.ProcessDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.controller.BaseController;

@Controller
@RequestMapping("/manage/sys/workflow/processDef")
public class SysProcessDefController extends BaseController {

	@Autowired
	private ActivitiUtils actUtils;
	@Autowired
    RepositoryService repositoryService;
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/sys/workflow/processDefinition/list";
	}
	
	@RequestMapping("/getProcessDefList")
	@ResponseBody
	public String getProcessDefList(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		
		Page<Map<String, Object>> page = actUtils.getProcessDefinitionByPage(
				paramsMap,
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteNullListAsEmpty);
	}
	
	@RequestMapping("/processDefinitionStatus")
	@ResponseBody
	public String getProcessDefList(String processDefinitionId, String status) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			if("active".equals(status)) {
				actUtils.setProcessDefinitionStatus(processDefinitionId, false);
			} else if("suspend".equals(status)){
				actUtils.setProcessDefinitionStatus(processDefinitionId, true);
			} else {
				result = new CrudResultDTO(CrudResultDTO.FAILED, "操作失败！");
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "操作失败:" + e.getMessage());
		}
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/deleteProcessDefinition")
	@ResponseBody
	public String deleteProcessDefinition(String processDefinitionId) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			actUtils.deleteDeployByProcessDefinitionId(processDefinitionId, true);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "操作失败:" + e.getMessage());
		}
		return JSON.toJSONString(result);
	}
	
	@RequestMapping(value = "/convertToModel/{processDefinitionId}")
    public String convertToModel(@PathVariable("processDefinitionId") String processDefinitionId)
            throws UnsupportedEncodingException, XMLStreamException {
        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery()
                .processDefinitionId(processDefinitionId).singleResult();
        InputStream bpmnStream = repositoryService.getResourceAsStream(processDefinition.getDeploymentId(),
                processDefinition.getResourceName());
        XMLInputFactory xif = XMLInputFactory.newInstance();
        InputStreamReader in = new InputStreamReader(bpmnStream, "UTF-8");
        XMLStreamReader xtr = xif.createXMLStreamReader(in);
        BpmnModel bpmnModel = new BpmnXMLConverter().convertToBpmnModel(xtr);

        BpmnJsonConverter converter = new BpmnJsonConverter();
        com.fasterxml.jackson.databind.node.ObjectNode modelNode = converter.convertToJson(bpmnModel);
        Model modelData = repositoryService.newModel();
        modelData.setKey(processDefinition.getKey());
        modelData.setName(processDefinition.getResourceName());
        modelData.setCategory(processDefinition.getDeploymentId());

        ObjectNode modelObjectNode = new ObjectMapper().createObjectNode();
        modelObjectNode.put(ModelDataJsonConstants.MODEL_NAME, processDefinition.getName());
        modelObjectNode.put(ModelDataJsonConstants.MODEL_REVISION, 1);
        modelObjectNode.put(ModelDataJsonConstants.MODEL_DESCRIPTION, processDefinition.getDescription());
        modelData.setMetaInfo(modelObjectNode.toString());

        repositoryService.saveModel(modelData);

        repositoryService.addModelEditorSource(modelData.getId(), modelNode.toString().getBytes("utf-8"));

        return "redirect:/manage/sys/workflow/model/toList";
    }
}
