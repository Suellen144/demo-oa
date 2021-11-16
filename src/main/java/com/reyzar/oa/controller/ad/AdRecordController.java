package com.reyzar.oa.controller.ad;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.reyzar.oa.common.constant.deptUtilsConstant;
import com.reyzar.oa.domain.SysDept;
import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.fasterxml.jackson.core.JsonParseException;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.AdRecordDeptHistory;
import com.reyzar.oa.domain.AdRecordPositionHistory;
import com.reyzar.oa.domain.AdRecordSalaryHistory;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdPayAdjustmentService;
import com.reyzar.oa.service.ad.IAdRecordDeptHistoryService;
import com.reyzar.oa.service.ad.IAdRecordPositionHistoryService;
import com.reyzar.oa.service.ad.IAdRecordSalaryHistoryService;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysRoleService;
import com.reyzar.oa.service.sys.ISysUserService;

/**
 * 
* @Description: 个人档案
* @author zhouShaoFeng
* @date 2016年7月5日 上午9:33:27 
*
 */
@Controller
@RequestMapping("/manage/ad/record")
public class AdRecordController  extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdRecordController.class);
	
	@Autowired
	private IAdRecordService recordService;
	@Autowired
	private ISysUserService userService;
	
	@Autowired
	private IAdPayAdjustmentService payAdjustmentService;
	
	@Autowired
	private IAdRecordDeptHistoryService  recordDeptHistoryService;
	
	@Autowired
	private IAdRecordPositionHistoryService positionHistoryService;
	@Autowired
	private ISysRoleService roleServie;
	@Autowired
	private ISysDeptService deptService;

	@RequestMapping("/findPostAppointmentDeptByDeptId")
	@ResponseBody
	public List<SysDept> findPostAppointmentDeptByDeptId(String deptId) {
		return deptService.findByParentid2(Integer.valueOf(deptId));
	}

	@RequestMapping("/findProjectTeamByDeptId")
    @ResponseBody
    public List<SysDept> findProjectTeamByDeptId(String deptValue) {
		return deptService.findByParentid(Integer.valueOf(deptValue));
    }

    @RequestMapping("/judgeEmail")
	@ResponseBody
	public String judgeEmail(String email) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "");
		if(email != null) {
			if(recordService.findByEmail(email.trim()) != null) {
				result = new CrudResultDTO(CrudResultDTO.FAILED, "");
			}
		}
		return JSON.toJSONString(result);
	}

	@RequestMapping("judgeEmail2")
	@ResponseBody
	public String judgeEmail2(String email){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"");
		Integer maxId=recordService.findByEmail2(email);
		if(maxId != 0 && maxId != null) {
			result.setResult(maxId -1);
		}else {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "");
		}
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/toList")
	public String toList(){
		return "manage/ad/record/list";
	}

	@RequestMapping("/getRecordList")
	@ResponseBody
	public String getRecordList(@RequestBody Map<String, Object> requestMap) throws JsonParseException {
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		paramsMap.put("userId", getUser().getId());
		Page<AdRecord> page = recordService.findByPage(paramsMap,
				Integer.valueOf(paramsMap.get("pageNum").toString()),  
				Integer.valueOf(paramsMap.get("pageSize").toString()),getUser());
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
	}
	
	@RequiresPermissions("ad:record:edit")
	@RequestMapping("/edit")
	public String edit(@RequestParam Integer userId, Model model){
		AdRecord record = new AdRecord();
		SysUser sysUser=new SysUser();
		SysUser user=getUser();
		List<SysRole> roleList=Lists.newArrayList();
		if (userId != null) {
			record = recordService.findOne(userId);
			sysUser=userService.findById(userId);
			record.setPayAdjustments(payAdjustmentService.findByRecordId(record.getId()));
			roleList = roleServie.findAll();
			model.addAttribute("roleList", roleList);
			model.addAttribute("record", record);
			model.addAttribute("sysUser", sysUser);
			model.addAttribute("loginUser", JSONObject.toJSONString(user));
			model.addAttribute("userJson", JSONObject.toJSONString(sysUser));
            model.addAttribute("companyId", deptUtilsConstant.getDeptId("companyId"));
		}
		return "manage/ad/record/edit";
	}

	@RequestMapping("/printById")
	public String printById(@RequestParam Integer id,Model model){
		AdRecord record = new AdRecord();
		if(id!=null){
			record = recordService.findById(id);
			record.setPayAdjustments(payAdjustmentService.findByRecordId(id));
			model.addAttribute("record",record);
		}
		return "manage/ad/record/print";
	}

	@RequestMapping("/pdf")
	public String pdf(@RequestParam Integer id,Model model){
		AdRecord record = new AdRecord();
		if(id!=null){
			record = recordService.findById(id);
			record.setPayAdjustments(payAdjustmentService.findByRecordId(id));
			model.addAttribute("record",record);
		}
		return "manage/ad/record/pdf";
	}

	@RequestMapping("/save")
	@ResponseBody
	public String save(AdRecord record) {
		record.setUserId(getUser().getId());
		CrudResultDTO result = recordService.save(record, getUser());
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/savedata")
	@ResponseBody
	public String savedata(@RequestBody JSONObject json) {
		CrudResultDTO result=new CrudResultDTO();
		AdRecord record=json.toJavaObject(AdRecord.class);
		SysUser sysUser=record.getSysUser();
		if(sysUser.getId()!=null && !"".equals(sysUser.getId())){
			result = userService.save(sysUser, sysUser.getPositionId(), sysUser.getRoleidList(), getUser());
		SysUser user=userService.findById(record.getUserId());
		if (user.getDeptId() != null) {
			String deptName = (String) deptService.findUpDept(user.getDeptId()).getResult();
			String company=(String) deptService.findCompany(user.getDeptId()).getResult();
			String[] strs=company.split(",");
			record.setCompany(strs[0]);
			record.setDept(deptName);
		}
		//获取职位，从公司到职位展示
		StringBuffer positionUpName = new StringBuffer();
			List<AdPosition> pIds = user.getPositionList();
			
			for (int i = 0; i < pIds.size(); i++) {
				String upDeptName = pIds.get(i).getName(); 
				
				if (i==pIds.size()-1) {
					positionUpName.append(upDeptName);
				}else {
					positionUpName.append(upDeptName+"\r\n,");
				}
			}
			//初始化职位历史表
			if (positionUpName != null && !positionUpName.toString().equals("")) {
				record.setPosition(positionUpName.toString());
			}	
		}
			result = recordService.save(record, getUser());
		if(record.getId()==null){
			//添加
			if(record.getPayAdjustments().size()>0){
				result=payAdjustmentService.insertAll(record, record.getPayAdjustments());
			}
		}else{
			//更新
			if(record.getPayAdjustments().size()>0){
			result=payAdjustmentService.batchUpdate(record.getPayAdjustments(), record);
			}
		}
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/addData")
	@ResponseBody
	public String addData(@RequestBody JSONObject json){
		CrudResultDTO result=new CrudResultDTO();
		AdRecord record=json.toJavaObject(AdRecord.class);
		SysUser sysUser=record.getSysUser();
		record.setEntrystatus(2);
		result = userService.save(sysUser, sysUser.getPositionId(), sysUser.getRoleidList(), getUser());
		SysUser user=userService.finNewUser();
		if (user.getDeptId() != null) {
			String deptName = (String) deptService.findUpDept(user.getDeptId()).getResult();
			String company=(String) deptService.findCompany(user.getDeptId()).getResult();
			String[] strs=company.split(",");
			record.setDeptId(user.getDeptId());
			record.setCompany(strs[0]);
			record.setDept(deptName);
		}
		//获取职位，从公司到职位展示
		StringBuffer positionUpName = new StringBuffer();
			List<AdPosition> pIds = user.getPositionList();
			
			for (int i = 0; i < pIds.size(); i++) {
				String upDeptName = pIds.get(i).getName(); 
				
				if (i==pIds.size()-1) {
					positionUpName.append(upDeptName);
				}else {
					positionUpName.append(upDeptName+"\r\n,");
				}
			}
			//初始化职位历史表
			if (positionUpName != null && !positionUpName.toString().equals("")) {
				record.setPosition(positionUpName.toString());
			}	
		record.setUserId(user.getId());
		result = recordService.save(record, getUser());
		//添加
		if(record.getPayAdjustments().size()>0){
			result=payAdjustmentService.insertAll(record, record.getPayAdjustments());
		}
		return JSON.toJSONString(result);
	}
	
	
	@RequestMapping("/getUserList")
	@ResponseBody
	public String getUserList(){
		Page<SysUser> userList = userService.findByPage(null, 1, 10000);
		return JSON.toJSONString(userList);
	}
	
	/**
	 * 保存修改个人信息的数据
	 * */
	@RequestMapping("/saveForUser")
	@ResponseBody
	public String saveForUser(AdRecord record) {
		CrudResultDTO result = recordService.saveForUser(record);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/exportExcel")
	public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
		Map<String, Object> paramMap = parseRequestMap(request);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
		String fileName = "员工列表-"+sdf.format(new Date())+".xls";
		String agent = request.getHeader("USER-AGENT").toLowerCase();
		if (agent.contains("firefox")) {
			response.setCharacterEncoding("UTF-8");
			fileName = new String(fileName.getBytes(), "ISO8859-1");
		} else {
			fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
		}
		
		response.setContentType("application/vnd.ms-excel; charset=utf-8");  
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
        
        recordService.exportExcel(response.getOutputStream(), paramMap);
	}
	
	
	@RequestMapping("/addDeptHistory")
	public String addDeptHistory(Integer userId,Model model){
		List<AdRecordDeptHistory> deptHistories = recordDeptHistoryService.findByUserId(userId);
		if (deptHistories != null && deptHistories.size() >0) {
			model.addAttribute("isEdit", true);
			model.addAttribute("deptHistories", deptHistories);
		}else {
			model.addAttribute("isEdit", false);
		}
		model.addAttribute("userId", userId);
		return "manage/ad/record/addDeptHistory";
	}
	
	@RequestMapping("/saveBatchDeptHistory")
	@ResponseBody
	public String saveBatchDeptHistory(@RequestBody JSONObject jsonObject){
		return JSON.toJSONString(recordDeptHistoryService.saveBatchDeptHistory(jsonObject));
	}
	
	@RequestMapping("/showDeptHistory")
	@ResponseBody
	public String showDeptHistory(Integer userId){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功");
		List<AdRecordDeptHistory> deptHistories = recordDeptHistoryService.findByUserId(userId);
		result.setResult(deptHistories);
		return JSON.toJSONString(result);
	}
	
	
	@RequestMapping("/addPositionHistory")
	public String addPositionHistory(Integer userId,Model model){
		List<AdRecordPositionHistory> positionHistories = positionHistoryService.findByUserId(userId);
		if (positionHistories != null && positionHistories.size() >0) {
			model.addAttribute("isEdit", true);
			model.addAttribute("positionHistories", positionHistories);
		}else {
			model.addAttribute("isEdit", false);
		}
		model.addAttribute("userId", userId);
		return "manage/ad/record/addPositionHistory";
	}
	
	
	@RequestMapping("/saveBatchPositionHistory")
	@ResponseBody
	public String saveBatchPositionHistory(@RequestBody JSONObject jsonObject){
		return JSON.toJSONString(positionHistoryService.saveBatchPositionHistory(jsonObject));
	}
	
	
	@RequestMapping("/showPositionHistory")
	@ResponseBody
	public String showPositionHistory(Integer userId){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功");
		List<AdRecordPositionHistory> positionHistories = positionHistoryService.findByUserId(userId);
		result.setResult(positionHistories);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/toAdd")
	public String toAdd(HttpServletRequest request, Model model) {
		/*String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		if (ismobile){
			return "manage/ad/chkatt/leave/mobileadd";
		}else {
			return "manage/ad/chkatt/leave/add";
		}*/
		List<SysRole> roleList = roleServie.findAll();
		model.addAttribute("roleList", roleList);
		model.addAttribute("companyId", deptUtilsConstant.getDeptId("companyId"));
		return "manage/ad/record/add";
	}

	@RequestMapping("/findDeptList")
	@ResponseBody
	public  List<SysDept> findDeptList(String parentId) {
		return deptService.findByParentidAndIsCompanyTwo(parentId);
	}
	
	@RequestMapping("findMaxId")
	@ResponseBody
	public String findMaxId(){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"操作成功");
		Integer maxId=recordService.findMaxId();
		result.setResult(maxId);
		return JSON.toJSONString(result);
	}
	
	@RequestMapping("/del")
	@ResponseBody
	public String deldata(@RequestBody JSONObject json) {
		CrudResultDTO result=new CrudResultDTO();
		AdRecord record=json.toJavaObject(AdRecord.class);
		result = recordService.save(record, getUser());
		result =  userService.delete(record.getUserId());
		if(record.getId()==null){
			//添加
			if(record.getPayAdjustments().size()>0){
				result=payAdjustmentService.insertAll(record, record.getPayAdjustments());
			}
		}else{
			//更新
			if(record.getPayAdjustments().size()>0){
			result=payAdjustmentService.batchUpdate(record.getPayAdjustments(), record);
			}
		}
		return JSON.toJSONString(result);
	}
	
}
