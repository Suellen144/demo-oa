package com.reyzar.oa.controller.ad;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
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
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdWorkReport;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdWorkReportService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

/**
 * @author Lin
 * @ClassName: AdWorkReportController
 * @Description: 工作汇报
 * @date 2016年11月9日 上午9:46:14
 */
@Controller
@RequestMapping("/manage/ad/workReport")
public class AdWorkReportController extends BaseController {

    private final Logger logger = Logger.getLogger(AdWorkReportController.class);

    @Autowired
    private IAdWorkReportService workReportService;
    @Autowired
    private ISysDeptService deptService;
    @Autowired
    private ISysUserService userService;

    @RequestMapping("/toList")
    public String toList(Model model) {
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.WORK_REPORT);
        SysUser user = getUser();
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        List<Integer> deptIdList = Lists.newArrayList(deptIdSet);
        List<SysUser> userList = userService.findByDeptIds(deptIdList);

        model.addAttribute("havePermission", deptIdSet.size() > 0);
        model.addAttribute("userList", JSON.toJSONString(userList));
        return "manage/ad/workReport/list";
    }

    @RequestMapping("/getWorkReportList")
    @ResponseBody
    public String getProjectList(@RequestBody Map<String, Object> requestMap) {
        Map<String, Object> paramsMap = parsePageMap(requestMap);
        SysUser user = getUser();

        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.WORK_REPORT);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        Set<Integer> userSet = UserUtils.getPrincipalIdList(user);

        if (paramsMap.get("userId") == null || "".equals(paramsMap.get("userId"))) {
            paramsMap.put("userId", user.getId());
            paramsMap.put("deptIdSet", deptIdSet);
            paramsMap.put("userSet",userSet);
        }

        Page<AdWorkReport> page = workReportService.findByPage(paramsMap,
                Integer.valueOf(paramsMap.get("pageNum").toString()),
                Integer.valueOf(paramsMap.get("pageSize").toString()));

        Map<String, Object> jsonMap = buildTableData(paramsMap, page);
        return JSON.toJSONString(jsonMap, SerializerFeature.WriteMapNullValue);
    }

    @RequestMapping("/getWorkReport")
    @ResponseBody
    public AdWorkReport getWorkReport(Integer id) {
        return workReportService.findById(id);
    }

    @RequestMapping("/toAddOrEdit")
    public String toAddOrEdit(Integer id, Model model) {
        AdWorkReport workReport = new AdWorkReport();
        if (id != null) {
            workReport = workReportService.findById(id);
        }

        model.addAttribute("workReport", workReport);
        return "manage/ad/workReport/addOrEdit";
    }

    @RequestMapping(value = "/saveOrUpdate", method = RequestMethod.POST)
    @ResponseBody
    public String save(@RequestBody JSONObject json) {
        return JSON.toJSONString(workReportService.saveOrUpdate(json));
    }

    @RequestMapping(value = "/checkStatus")
    @ResponseBody
    public String checkStatus(Integer id) {
        return JSON.toJSONString(workReportService.checkStatus(id));
    }

    @RequestMapping(value = "/delete")
    @ResponseBody
    public String delete(Integer id) {
        return JSON.toJSONString(workReportService.delete(id));
    }

    @RequestMapping("/toWorkReportCharts")
    public String toWorkReportCharts(Model model) {
        SysUser user = getUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.WORK_REPORT);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);

        List<SysDept> deptList = null;
        if (deptIdSet.size() > 0) {
            List<Integer> idList = Lists.newArrayList(deptIdSet);
            deptList = deptService.findByIds(idList);
        }

        model.addAttribute("deptList", deptList);
        return "manage/ad/workReport/workReportCharts";
    }

    @RequestMapping(value = "/getWorkReportChartsData")
    @ResponseBody
    public String getWorkReportChartsData(@RequestBody Map<String, String> requestMap) {
        return JSON.toJSONString(workReportService.getWorkReportChartsData(requestMap));
    }

    /**
     * @param userId 用户ID
     * @param month  月份
     * @param number 周数
     * @return String
     * @Title: checkNumber
     * @Description: 检查当年当月的周数是否重复
     */
    @RequestMapping(value = "/checkNumber")
    @ResponseBody
    public String checkNumber(@RequestParam("id") Integer id,
                              @RequestParam("userId") Integer userId,
                              @RequestParam("month") Integer month,
                              @RequestParam("number") Integer number,
                              @RequestParam("workDate") String workDate) {
        return JSON.toJSONString(workReportService.checkNumber(id, userId, month, number,workDate));
    }

    @RequestMapping("/exportExcel")
    public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
        Map<String, Object> paramMap = parseRequestMap(request);
        String fileName = paramMap.get("year").toString() + "年" + paramMap.get("month") + "月工时统计.xls";
        String agent = request.getHeader("USER-AGENT").toLowerCase();
        if (agent.contains("firefox")) {
            response.setCharacterEncoding("UTF-8");
//			response.setHeader("content-disposition", "attachment;filename=" + new String(fileName.getBytes(), "ISO8859-1") + ".xls");
            fileName = new String(fileName.getBytes(), "ISO8859-1");
        } else {
            fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
        }

        response.setContentType("application/vnd.ms-excel; charset=utf-8");
        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);

        workReportService.exportExcel(response.getOutputStream(), paramMap);
    }

}