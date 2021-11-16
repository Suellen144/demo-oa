package com.reyzar.oa.controller.ad;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdDirectoryManage;
import com.reyzar.oa.domain.AdFileManage;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdFileManageService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Controller
@RequestMapping("/manage/ad/filemanage")
public class AdFileManageController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdFileManageController.class);
	
	@Autowired
	private IAdFileManageService fileManageService;
	@Autowired
	private ISysDeptService deptService;
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/ad/filemanage/list";
	}
	
	@RequestMapping("/getFileList")
	@ResponseBody
	public String getFileList(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("ad:filemanage:seeall")) {
			paramsMap.put("seeall", true);
		} else {
			paramsMap.put("seeall", false);
			List<SysDept> deptList = deptService.getDeptLink(getUser().getDeptId());
			List<Integer> idList = Lists.newArrayList();
			
			for(SysDept dept : deptList) {
				idList.add(dept.getId());
			}
			
			StringBuffer sb = new StringBuffer();
			if(idList.size() > 1) {
				for(Integer id : idList) {
					sb.append(id).append(",");
				}
				sb.delete(sb.length()-1, sb.length());
			} else {
				sb.append(idList.get(0));
			}
			
			paramsMap.put("deptIdList", sb.toString());
		}
		
		Page<AdFileManage> page = fileManageService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(@RequestParam Integer id, Model model) {
		
		AdFileManage file = new AdFileManage();
		List<SysDept> deptList = Lists.newArrayList();
		if(id != null) {
			file = fileManageService.findById(id);
			
			if(file.getDeptIds() != null && !"".equals(file.getDeptIds().trim())) {
				List<Integer> idList = Lists.newArrayList();
				String[] deptIds = file.getDeptIds().trim().split(",");
				List<String> tempDeptIds = new ArrayList<String>();
				tempDeptIds.addAll(Arrays.asList(deptIds));
				for(String deptId : tempDeptIds) {
					idList.add(Integer.valueOf(deptId));
				}
				
				deptList = deptService.findByIds(idList);
				if(deptList != null && deptList.size() > 0) {
					for(SysDept dept : deptList) {
						dept.setChildren(null);
					}
				}
			}
		}
		
		model.addAttribute("file", file);
		model.addAttribute("deptList", JSON.toJSONString(deptList));
		return "manage/ad/filemanage/addOrEdit";
	}
	
	@RequestMapping("/getDirWithFileInList")
	@ResponseBody
	public String getDirWithFileInList(HttpServletRequest request) {
		SysUser user=getUser();
		Map<String, Object> paramsMap = Maps.newHashMap();
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("ad:filemanage:seeall")) {
			paramsMap.put("seeall", true);
		} else {
			paramsMap.put("seeall", false);
			List<SysDept> deptList = deptService.getDeptLink(getUser().getDeptId());
			List<Integer> idList = Lists.newArrayList();
			
			for(SysDept dept : deptList) {
				idList.add(dept.getId());
			}
			
			StringBuffer sb = new StringBuffer();
			if(idList.size() > 1) {
				for(Integer id : idList) {
					sb.append(id).append(",");
				}
				sb.delete(sb.length()-1, sb.length());
			} else {
				sb.append(idList.get(0));
			}
			
			paramsMap.put("deptIdList", sb.toString());
		}
		Page<AdFileManage> page = fileManageService.findAll(paramsMap);
		return JSON.toJSONString(fileManageService.getDirWithFileInList(user.getDeptId(),page,request.getContextPath()));
	} 
	
	@RequestMapping(value="ajaxDepts", method=RequestMethod.POST)
	@ResponseBody
	public String ajaxDepts(String parentDeptIds, String currDeptIds) {
		
		CrudResultDTO result = fileManageService.ajaxDepts(parentDeptIds,currDeptIds);
		return JSON.toJSONString(result);
		
	}
	
	@RequestMapping(value="ajaxCurrDept", method=RequestMethod.POST)
	@ResponseBody
	public String ajaxCurrDept(String deptIds) {
		CrudResultDTO result = fileManageService.ajaxCurrDept(deptIds);
		return JSON.toJSONString(result);
		
	}
	
	@RequestMapping(value="dirSaveOrUpdate", method=RequestMethod.POST)
	@ResponseBody
	public CrudResultDTO dirSaveOrUpdate(AdDirectoryManage directoryManage) {
		return fileManageService.dirSaveOrUpdate(directoryManage);
	}
	
	@RequestMapping(value="fileSaveOrUpdate", method=RequestMethod.POST)
	@ResponseBody
	public CrudResultDTO fileSaveOrUpdate(AdFileManage fileManage) {
		return fileManageService.fileSaveOrUpdate(fileManage);
	}
	
	@RequestMapping(value="dirDelete")
	@ResponseBody
	public CrudResultDTO dirDelete(Integer id) {
		return fileManageService.dirDelete(id);
	}
	
	@RequestMapping(value="checkDir",method=RequestMethod.POST)
	@ResponseBody
	public CrudResultDTO checkDir(Integer id) {
		return fileManageService.checkDir(id);
	}
	
	@RequestMapping(value="fileDelete")
	@ResponseBody
	public CrudResultDTO fileDelete(Integer id) {
		return fileManageService.fileDelete(id);
	}
	
	@RequestMapping(value="dirExists")
	@ResponseBody
	public CrudResultDTO dirExists(Integer parentId, String dirName) {
		
		return fileManageService.exists(parentId, null, dirName, 0);
	}
	
	@RequestMapping(value="fileExists")
	@ResponseBody
	public String fileExists(Integer parentId, Integer id, String fileName) {
		
		return JSON.toJSONString(fileManageService.existsAdFileManage(parentId, id, fileName));
	}
	
	@RequestMapping(value="",method=RequestMethod.POST)
	@ResponseBody
	public String lookFileDirInList(HttpServletRequest request){
		
		return JSON.toJSONString("");
	}
	
	
}