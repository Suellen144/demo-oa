package com.reyzar.oa.controller.office;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.OffNotice;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.service.office.IOffNoticeService;
import com.reyzar.oa.service.sys.ISysDeptService;

/**
 * 
* @Description: 公司公告
* @author zhouShaoFeng
* @date 2016年7月15日 下午3:28:33 
*
 */
@Controller
@RequestMapping(value="/manage/office/noitce")
public class OffNoticeController extends BaseController {
	
	@Autowired
	private IOffNoticeService noticeService;
	@Autowired
	private ISysDeptService deptService;
	
	@RequestMapping("/getTop5Notice")
	@ResponseBody
	public List<OffNotice> getTop5Notice() {
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("off:notice:seeall")) {
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
		paramsMap.put("userId", getUser().getId());
		
		List<OffNotice> list = noticeService.getTop5Notice(paramsMap);
		return list;
	}
	
	@ResponseBody
	@RequestMapping("/getNoticeCount")
	public String getNoticeCount() {
		Map<String, Object> paramsMap = Maps.newHashMap();
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("off:notice:seeall")) {
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
		paramsMap.put("userId", getUser().getId());
		int noticeCount = noticeService.getNoticeCount(paramsMap);
		return String.valueOf(noticeCount);
	}
	
	@ResponseBody
	@RequestMapping("/getUnreadCount")
	public String getUnreadCount(String type) {
		Map<String, Object> paramsMap = Maps.newHashMap();
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("off:notice:seeall")) {
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
		paramsMap.put("userId", getUser().getId());
		paramsMap.put("type", type);
		int unreadCount = noticeService.getUnreadCount(paramsMap);
		return String.valueOf(unreadCount);
	}
	
	@RequestMapping("/toList")
	public String toList(Model model, String isRead){
		// 从导航条点击且有未读消息则isRead=0(查看未读公告)，其他地方为null
		model.addAttribute("isRead", isRead != null ? isRead : "");
		model.addAttribute("deptList", JSON.toJSONString(deptService.findAll()));
		return "manage/office/notice/list";
	}
	
	@RequestMapping("/findNoticeToList")
	public String findNoticeToList(Model model, String isRead,HttpServletRequest request){
		// 从导航条点击且有未读消息则isRead=0(查看未读公告)，其他地方为null
		model.addAttribute("isRead", isRead != null ? isRead : "");
		model.addAttribute("deptList", JSON.toJSONString(deptService.findAll()));
		/*return "manage/office/notice/noticeList";*/
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		if (ismobile) {
			return "mobile/office/notice/noticeList";
		}else{
			return "manage/office/notice/noticeList";
		}
	}
	
	@RequestMapping("/findPointToList")
	public String findPointToList(Model model, String isRead){
		// 从导航条点击且有未读消息则isRead=0(查看未读公告)，其他地方为null
		model.addAttribute("isRead", isRead != null ? isRead : "");
		model.addAttribute("deptList", JSON.toJSONString(deptService.findAll()));
		return "manage/office/notice/pointList";
	}
	
	
	@RequestMapping("/findDocumentToList")
	public String findDocumentToList(Model model, String isRead){
		// 从导航条点击且有未读消息则isRead=0(查看未读公告)，其他地方为null
		model.addAttribute("isRead", isRead != null ? isRead : "");
		model.addAttribute("deptList", JSON.toJSONString(deptService.findAll()));
		return "manage/office/notice/documentList";
	}
	
	
	@RequestMapping("/getNoticeList")
	@ResponseBody
	public Map<String, Object> getNoticeList(@RequestBody Map<String, Object> requestMap, HttpServletRequest request) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("off:notice:seeall")) {
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
		paramsMap.put("userId", getUser().getId());
		
		Page<OffNotice> page = noticeService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return jsonMap;
	}
	
	
	@RequestMapping("/getPointList")
	@ResponseBody
	public Map<String, Object> findPointList(@RequestBody Map<String, Object> requestMap, HttpServletRequest request) {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Subject subject = SecurityUtils.getSubject();
		if(subject.isPermitted("off:notice:seeall")) {
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
		paramsMap.put("userId", getUser().getId());
		
		Page<OffNotice> page = noticeService.findPointByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return jsonMap;
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(Model model, @RequestParam(required=false)Integer id) {
		OffNotice notice = new OffNotice();
		if(id != null) {
			notice = noticeService.findById(id);
		}
		model.addAttribute("notice", notice);
		model.addAttribute("deptList", JSON.toJSONString(deptService.findAll()));
		return "manage/office/notice/addOrEdit";
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public String save(OffNotice notice) {
		CrudResultDTO result = noticeService.save(notice, getUser());
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/update")
	@ResponseBody
	public String update(OffNotice notice) {
		CrudResultDTO result = noticeService.update(notice);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/getNotice")
	@ResponseBody
	public OffNotice getNotice(Integer id) {
		return noticeService.findById(id);
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public String delete(Integer id) {
		return JSON.toJSONString(noticeService.deleteById(id));
	}

	@RequestMapping("/setReadStatus")
	@ResponseBody
	public String setReadStatus(Integer noticeId) {
		return JSON.toJSONString(noticeService.setReadStatus(noticeId));
	}
	
	@RequestMapping("/setApproveStatus")
	@ResponseBody
	public String setApproveStatus(Integer id, String approveStatus) {
		return JSON.toJSONString(noticeService.setApproveStatus(id, approveStatus));
	}
	
	@RequestMapping("/getNoticeById")
	@ResponseBody
	public String getNoticeById(Model model, @RequestParam(required=false)Integer id) {
		OffNotice notice = noticeService.findById(id);
		model.addAttribute("notice", notice);
		return "manage/common/main";
	}
	
}
