package com.reyzar.oa.controller.organization;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.reyzar.oa.common.util.ExportTextUtil;
import com.reyzar.oa.common.util.StringUtils;
import com.reyzar.oa.domain.Responsibility;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysRole;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.institution.IResponsibilityService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysRoleService;
import com.reyzar.oa.service.sys.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.common.util.WebUtil;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.Organization;
import com.reyzar.oa.service.organization.IOrganizationService;

/** 
* @ClassName: OrganizationController
* @Description: 组织关系控制器
* @author LWY
* @date 2018年6月27日
*  
*/
@Controller
@RequestMapping("/manage/organization")
public class OrganizationController extends BaseController {
	private final static String ROOT_DEPT = "-1"; // 根部门ID
    private final static String ROOT_DEPT2 = "55"; // 根部门ID
	@Autowired
	private IOrganizationService organizationService;
    @Autowired
    private ISysUserService userService;
    @Autowired
    private ISysDeptService sysDeptService;
	@Autowired
	private IResponsibilityService responsibilityService;
	@Autowired
	private ISysRoleService sysRoleService;


	//恢复
	@RequestMapping("/recoveryOrganizationById")
	@ResponseBody
	public String recoveryOrganizationById(String id ,String sign) {
		organizationService.recoveryOrganizationById(id,sign);
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"恢复成功！");
		return JSON.toJSONString(result);
	}

	@RequestMapping("/findByparentIdAndDelete")
	@ResponseBody
	public String findByparentIdAndDelete(String id,String sign) {
		CrudResultDTO res =new CrudResultDTO();
		if(sign.equals("1")) {
			List<SysUser> userList = userService.findByDeptid(Integer.valueOf(id));
			List<SysDept> SysDeptList = sysDeptService.findByParentid(Integer.valueOf(id));
			if((userList != null && userList.size()>0)
					||(SysDeptList != null && SysDeptList.size()>0)) {
				res.setCode(CrudResultDTO.SUCCESS);
			}else {
				res.setCode(CrudResultDTO.EXCEPTION);
			}
		}else {
			List<Organization> deptList=organizationService.findByparentIdAndDelete(id);
			List<SysUser> userList = userService.findByDeptid(Integer.valueOf(id));
			List<SysDept> SysDeptList = sysDeptService.findByParentidAndCompany(Integer.valueOf(id));
			if((deptList !=null && deptList.size()>0)
					|| userList != null && userList.size()>0
					|| SysDeptList != null && SysDeptList.size()>0) {
				res.setCode(CrudResultDTO.SUCCESS);
			}else {
				res.setCode(CrudResultDTO.EXCEPTION);
			}
		}
		return JSON.toJSONString(res);
	}

	@RequestMapping("/findDeptByNameAndId")
	@ResponseBody
	public String findDeptByNameAndId(String name,String id) {
		CrudResultDTO res =new CrudResultDTO();
		List<SysDept> deptList=sysDeptService.findDeptByNameAndId(name,id);
		if(deptList !=null && deptList.size()>0) {
			res.setCode(CrudResultDTO.SUCCESS);
		}else {
			res.setCode(CrudResultDTO.EXCEPTION);
		}
		return JSON.toJSONString(res);
	}

	@RequestMapping("/findByNameAndId")
	@ResponseBody
	public String findByNameAndId(String name,String id) {
		CrudResultDTO res =new CrudResultDTO();
		List<Organization> deptList=organizationService.findByNameAndId(name,id);
		if(deptList !=null && deptList.size()>0) {
			res.setCode(CrudResultDTO.SUCCESS);
		}else {
			res.setCode(CrudResultDTO.EXCEPTION);
		}
		return JSON.toJSONString(res);
	}
	
	@RequestMapping("/toList")
	public String toList(HttpServletRequest request) {
		return "manage/organization/list";
		
	}
	/**==============================================树菜单开始=====================================================*/
	@RequestMapping("/getDeptList")
	@ResponseBody
	public void getDeptList(HttpServletRequest request,HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		param.put("parentId", ROOT_DEPT2);
		Organization deptList = null;
		if(param.get("sign").equals("1")) {
			 deptList = organizationService.findByParentid(param);
		} else {
			deptList = organizationService.findByParentid2(param);
		}
		if(deptList!=null) {
			deptList.setOrganization(deptList.getChildren().get(0));	
			deptList.getChildren().remove(0);
		}
		renderJSONString(response, deptList);
	}

	@RequestMapping("/getDeptWithPositionInList")
	@ResponseBody
	public String getDeptWithPositionInList(HttpServletRequest request) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		param.put("root", request.getContextPath());
		return JSON.toJSONString(organizationService.getDeptWithPositionInList(param));
	} 
	/**==============================================树菜单结束=====================================================*/
	
	//===============================================业务操作开始====================================================
	
	//根据id查询公司基本信息
	@RequestMapping("/queryOrganizationById")
	@ResponseBody
	public Map<String,Object> queryOrganizationById(HttpServletRequest request, HttpServletResponse response, Model model) {
		Map<String, Object> retus =new HashMap<String, Object>();
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		Organization ogn=organizationService.queryOrganizationById(param);
		retus.put("ogn", ogn);
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		retus.put("ismobile", ismobile);
		return retus;
	}

	//根据id查询部门基本信息
	@RequestMapping("/findDeptDataById")
	@ResponseBody
	public Map<String,Object> findDeptDataById(HttpServletRequest request, HttpServletResponse response, Model model) {
		Map<String, Object> retus =new HashMap<String, Object>();
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		SysDept sysDept = sysDeptService.findById(Integer.parseInt(param.get("id")));
		Responsibility responsibility = responsibilityService.findByDeptId2(Integer.parseInt(param.get("id")));
		retus.put("sysDept", sysDept);
		retus.put("responsibility", responsibility);
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		retus.put("ismobile", ismobile);
		return retus;
	}
	
	//新增保存
	@RequestMapping("/saveOrganization")
	@ResponseBody
	public void toSave(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		organizationService.saveOrUpdateOrganization(param);
	}

	//保存或者编辑部门
	@RequestMapping("/saveOrUpdateDeptData")
	@ResponseBody
	public String saveOrUpdateDeptData(HttpServletRequest request, HttpServletResponse response, Model model) {
		CrudResultDTO res =new CrudResultDTO();
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		if(StringUtils.isNotBlank(param.get("id"))) {
			sysDeptService.updateDept(param);
		}else {
			sysDeptService.saveDept(param);
		}
		return JSON.toJSONString(res);
	}
	
	//撤销
	@RequestMapping("/revokeOrganizationById")
	@ResponseBody
	public String revokeOrganizationById(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		if(param.get("sign").equals("1")) {
			sysDeptService.updateByDeteleId(Integer.parseInt(param.get("id")));
		}else {
			organizationService.revokeOrganizationById(param);
		}
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"撤销成功！");
		return JSON.toJSONString(result);
	}

	//删除
	@RequestMapping("/delOrganizationById")
	@ResponseBody
	public String delOrganizationById(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		if(param.get("sign").equals("1")) {
			sysDeptService.delByDeteleId(Integer.parseInt(param.get("id")));
		}else {
			organizationService.delOrganizationById(param);
		}
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"删除成功！");
		return JSON.toJSONString(result);
	}
	
	
	@RequestMapping("/selectOgnList")
	@ResponseBody
	public List<Organization> selectOgnList(HttpServletRequest request, HttpServletResponse response, Model model) {
		List<Organization> ognList=organizationService.selectOgnList();
		return ognList;
	}
	@RequestMapping("/queryOrganizationChangeInfoListByOgnId")
	@ResponseBody
	public List<Organization> queryOrganizationChangeInfoListByOgnId(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		List<Organization> organizationChangeInfoList=organizationService.queryOrganizationChangeInfoListByOgnId(param);
		return organizationChangeInfoList;
	}
	
	
	@RequestMapping("/toPDF")
	public String toPDF(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		Organization ogn = organizationService.queryOrganizationById(param);
		model.addAttribute("ogn", ogn);
		return "manage/organization/pdf";
	}
	
	@RequestMapping("/toPDF2")
	public String toPDF2(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		Organization ogn = organizationService.queryOrganizationById(param);
		model.addAttribute("ogn", ogn);
		return "manage/organization/pdf2";
	}
	
	@RequestMapping("/organizationChangeBGXMSelect")
	@ResponseBody
	public List<Organization> organizationChangeBGXMSelect(HttpServletRequest request, HttpServletResponse response, Model model) {
		List<Organization> ognList=organizationService.organizationChangeBGXMSelect();
		return ognList;
	}
	
	@RequestMapping("/delChangeInfoById")
	@ResponseBody
	public String delChangeInfoById(HttpServletRequest request, HttpServletResponse response, Model model) {
		@SuppressWarnings("unchecked")
		Map<String, String> param = WebUtil.paramsToMap(request.getParameterMap());
		organizationService.delChangeInfoById(param);
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"删除成功！");
		return JSON.toJSONString(result);
	}
	
	/********************************************************/
	@RequestMapping("/saveChangeInfo")
	@ResponseBody
	public String saveChangeInfo(@RequestBody JSONObject json) {
		organizationService.updateChangeInfoByJson(json);
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		return JSON.toJSONString(result);
	}
	/**
	     * 导出文件文件
	     * 用于UCC配置，将有效的数转换成JSON字符串，然后导出文本文件
     *
     * @return
     * @throws Exception
     */
    @RequestMapping("/toText")
    public void toText(HttpServletResponse response,Integer id){
        //将集合转换成字符串
        String jsonString = "";
        Organization organization=organizationService.findById(id.toString());
        if(organization!=null) {
        	if(organization.getName()!=null && !"".equals(organization.getName())) {
        		jsonString+="公司名称："+organization.getName()+"\r\n";
        	}
        	if(organization.getShxydm()!=null && !"".equals(organization.getShxydm())) {
        		jsonString+="社会信用代码："+organization.getShxydm()+"\r\n";
        	}
        	if(organization.getClrq()!=null && !"".equals(organization.getClrq())) {
        		jsonString+="成立日期："+organization.getClrq()+"\r\n";
        	}
        	if(organization.getZczb()!=null && !"".equals(organization.getZczb())) {
        		jsonString+="注册资本(万元)："+organization.getZczb()+"\r\n";
        	}
        	if(organization.getFrdb()!=null && !"".equals(organization.getFrdb())) {
        		jsonString+="法人代表："+organization.getFrdb()+"\r\n";
        	}
        	if(organization.getDszzxds()!=null && !"".equals(organization.getDszzxds())) {
        		jsonString+="董事长/执行董事："+organization.getDszzxds()+"\r\n";
        	}
        	if(organization.getZjl()!=null && !"".equals(organization.getZjl())) {
        		jsonString+="总经理："+organization.getZjl()+"\r\n";
        	}
        	if(organization.getCwzj()!=null && !"".equals(organization.getCwzj())) {
        		jsonString+="财务总监："+organization.getCwzj()+"\r\n";
        	}
        	if(organization.getJshzxjs()!=null && !"".equals(organization.getJshzxjs())) {
        		jsonString+="监事会主席/监事："+organization.getJshzxjs()+"\r\n";
        	}
        	if(organization.getGswz()!=null && !"".equals(organization.getGswz())) {
        		jsonString+="公司网站："+organization.getGswz()+"\r\n";
        	}
        	if(organization.getLxdh()!=null && !"".equals(organization.getLxdh())) {
        		jsonString+="联系电话："+organization.getLxdh()+"\r\n";
        	}
        	if(organization.getGsdz()!=null && !"".equals(organization.getGsdz())) {
        		jsonString+="公司地址："+organization.getGsdz()+"\r\n";
        	}
        	if(organization.getGszh()!=null && !"".equals(organization.getGszh())) {
        		jsonString+="公司账号："+organization.getGszh()+"\r\n";
        	}
        	if(organization.getZhmc()!=null && !"".equals(organization.getZhmc())) {
        		jsonString+="账户名称："+organization.getZhmc()+"\r\n";
        	}
        	if(organization.getKhyh()!=null && !"".equals(organization.getKhyh())) {
        		jsonString+="开户银行："+organization.getKhyh()+"\r\n";
        	}
        	if(organization.getKhhdz()!=null && !"".equals(organization.getKhhdz())) {
        		jsonString+="开户行地址："+organization.getKhhdz()+"\r\n";
        	}
        	if(organization.getZxrq()!=null && !"".equals(organization.getZxrq())) {
        		jsonString+="注销日期："+organization.getZxrq()+"\r\n";
        	}
        	if(organization.getScrq()!=null && !"".equals(organization.getScrq())) {
        		jsonString+="售出日期："+organization.getScrq()+"\r\n";
        	}
        	if(organization.getJyfw()!=null && !"".equals(organization.getJyfw())) {
        		jsonString+="经营范围："+organization.getJyfw()+"\r\n";
        	}
        }
        ExportTextUtil.writeToTxt(response,jsonString,organization.getName()+"信息");
    }
}