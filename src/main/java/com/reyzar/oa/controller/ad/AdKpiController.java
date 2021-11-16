package com.reyzar.oa.controller.ad;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.deptUtilsConstant;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.service.ad.IAdRecordService;
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
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdKpi;
import com.reyzar.oa.domain.AdKpiAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdKpiService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;
import com.reyzar.oa.service.sys.impl.SysDeptServiceImpl;


@Controller
@RequestMapping("/manage/ad/kpi")
public class AdKpiController extends BaseController {
	
	private final Logger logger = Logger.getLogger(AdKpiController.class);
	
	@Autowired
	private IAdKpiService kpiService;
	@Autowired
	private ISysUserService userService;
	@Autowired
	private ISysDeptService iSysDeptService;
    @Autowired
    private IAdRecordService recordService;

    @RequestMapping("/findDataByDeptId")
    @ResponseBody
    public  List<SysDept> findDataByDeptId(Integer deptId) throws JsonProcessingException{
        return iSysDeptService.findByParentid2(deptId);
    }

    @RequestMapping("/findDataByDeptId2")
    @ResponseBody
    public   List<AdKpiAttach> findDataByDeptId2(Integer deptId ,Date time,Date date) throws JsonProcessingException{
        Set<Integer> deptIdSet = Sets.newHashSet();
        deptIdSet.add(deptId);
        List<SysDept> sysDepts=iSysDeptService.findByParentid(deptId);
        for (int i = 0; i < sysDepts.size(); i++) {
            deptIdSet.add(sysDepts.get(i).getId());
        }
        Map<String,Object> params = new HashMap<String,Object>();
        Map<String,Object> params2 = new HashMap<String,Object>();
        params.put("date",date);
        params.put("deptIdSet",deptIdSet);
        params2.put("date",time);
        params2.put("deptIdSet",deptIdSet);
        List<AdKpiAttach> kpiAttachs = kpiService.findAllByDpetIdAndDate2(params);
        if (kpiAttachs.size() == 0) {
            kpiAttachs = kpiService.findAllByDpetIdAndDate2(params2);
        }
        return kpiAttachs;

    }

    @RequestMapping("/toList")
	public String toList(Model model){
		SysUser user = UserUtils.getCurrUser();
		Date date = new Date();
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, -1);
		Date time = c.getTime();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		Subject subject = SecurityUtils.getSubject();
        AdRecord record = recordService.findByUserid(user.getId());
        String [] result = record.getPosition().split(",");
        for(int a = 0;a<result.length;a++) {
            if(result[a].contains("\r\n")) {
                result[a] = result[a].replaceAll("(\r\n)", "").trim();
            }
        }
		//总经理审批
		if (Arrays.asList(result).contains("总经理")) {
            model.addAttribute("date", date);
            model.addAttribute("time", time);
			model.addAttribute("ceo", "ceo");
			model.addAttribute("companyId", deptUtilsConstant.getDeptId("companyId"));
			AdKpi kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(new Date()));
			if(kpi == null){
				kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(time));
			}
			model.addAttribute("kpi", kpi);
			return "manage/ad/kpi/approve";
		}
		//各部门经理审批
		if (subject.isPermitted("ad:kpi:approve")) {
			AdKpi kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(new Date()));
				if(kpi == null){
					kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(time));
				}
				 if (kpi != null) {
					 //根据用户部门，查一下是否有下级部门，如果有，则查询出来
					 List<SysDept> sysDepts=iSysDeptService.findByParentid(user.getDeptId());
					 List<AdKpiAttach> kpiAttachs =new ArrayList<AdKpiAttach>();
					 kpiAttachs.addAll(kpi.getKpiAttachsList());
					 for (SysDept sysDept : sysDepts) {
						 List<AdKpiAttach> kpiAttachs1=kpiService.findAllByDpetIdAndDate(sysDept.getId(),date);
						 if (kpiAttachs1.size() == 0) {
							 kpiAttachs1 = kpiService.findAllByDpetIdAndDate(sysDept.getId(), time);
						 }
						 kpiAttachs.addAll(kpiAttachs1);
					 }
					 List<SysUser> userList = userService.findByDeptid(user.getDeptId());
					 for (AdKpiAttach kpiAttach : kpiAttachs) {
						 for (SysUser temp : userList) {
							 if (kpiAttach.getUserId().equals(temp.getId())) {
								 model.addAttribute("user", temp);
								 model.addAttribute("kpiAttachs", kpiAttachs);
							}
							if (kpiAttach.getUserId().equals(user.getId())) {
								 model.addAttribute("flag",user.getId());
							}
						}
					}
					 model.addAttribute("kpi", kpi);
					 model.addAttribute("userList", userList);
					 
				}
				 return "manage/ad/kpi/manager";
		}else {
		AdKpi kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(new Date()));
		if (kpi == null) {
			kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(time));
			if (user.getDeptId()  == 20) {
				kpi = kpiService.findBydeptIdAndDate(3, sdf.format(new Date()));
				if (kpi == null) {
					kpi = kpiService.findBydeptIdAndDate(3, sdf.format(time));
				}
			}
		}	
		
		if (kpi != null) {
			if (user.getDeptId()  == 20) {
				kpi = kpiService.findBydeptIdAndDate(3, sdf.format(new Date()));
				if (kpi == null) {
					kpi = kpiService.findBydeptIdAndDate(3, sdf.format(time));
				}
			}
			List<AdKpiAttach> kpiAttachs = kpi.getKpiAttachsList();
			for (AdKpiAttach kpiAttach : kpiAttachs) {
				if (kpiAttach.getUserName().equals(user.getName())) {
					model.addAttribute("kpiAttach", kpiAttach);
					model.addAttribute("kpi", kpi);
					return "manage/ad/kpi/show";
				}
			}
			model.addAttribute("kpi", kpi);
			return "manage/ad/kpi/add";
		}else {
			kpi = new AdKpi();
			model.addAttribute("kpi", kpi);
			return "manage/ad/kpi/add";
		}
		}
	}
	
	
	//用于查询历史纪录
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(@RequestBody Map<String, Object> requestMap) throws JsonProcessingException{
		Map<String, Object> paramsMap = parsePageMap(requestMap);
		Page<AdKpiAttach> page = kpiService.findByPage(paramsMap, 
				Integer.valueOf(paramsMap.get("pageNum").toString()), 
				Integer.valueOf(paramsMap.get("pageSize").toString()));	
		
		Map<String, Object> jsonMap = buildTableData(paramsMap, page);
		return JSONObject.toJSONString(jsonMap);
		
	}
	
	
	@RequestMapping("/getStatus")
	@ResponseBody
	public Integer getStatus(Integer deptId, String time) {
		return kpiService.getStatus(deptId, time);
	}
	
	
	
	@RequestMapping("/toShow")
	public String toShow(){
		return "manage/ad/kpi/list";
	}

	@RequestMapping("/showAll")
	public String showAll(Model model){
		SysUser user = UserUtils.getCurrUser();
		Date date = new Date();
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, -1);
		Date time = c.getTime();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		model.addAttribute("date", date);
		model.addAttribute("time", time);
		model.addAttribute("companyId", deptUtilsConstant.getDeptId("companyId"));
		AdKpi kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(new Date()));
		if(kpi == null){
			kpi = kpiService.findBydeptIdAndDate(user.getDeptId(), sdf.format(time));
		}
		model.addAttribute("kpi", kpi);
		return "manage/ad/kpi/showAll";
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	@ResponseBody
	public String save(@RequestBody JSONObject json){
		return JSON.toJSONString(kpiService.save(json));
	}
	
	
	//用于更新审批
	@RequestMapping(value="/update", method=RequestMethod.POST)
	@ResponseBody
	public String update(@RequestBody JSONObject json) throws ParseException{
		return JSON.toJSONString(kpiService.saveOrUpdate(json));
	}
	
	//用于更新审批
	@RequestMapping(value="/saveone", method=RequestMethod.POST)
	@ResponseBody
	public String saveone(@RequestBody JSONObject json) throws ParseException{

		return JSON.toJSONString(kpiService.saveone(json));
	}
	
	@RequestMapping(value="/approve", method=RequestMethod.POST)
	@ResponseBody
	public String approve(@RequestBody JSONObject json) throws ParseException{
		return JSON.toJSONString(kpiService.approve(json));
	}
	
	
	@RequestMapping(value="/saveall", method=RequestMethod.POST)
	@ResponseBody
	public String saveall(@RequestBody JSONObject json) throws ParseException{
		return JSON.toJSONString(kpiService.saveall(json));
	}
	
}