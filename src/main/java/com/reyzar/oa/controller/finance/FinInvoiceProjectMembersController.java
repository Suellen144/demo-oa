package com.reyzar.oa.controller.finance;


import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.FinInvoiceProjectMembers;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SaleProjectMember;
import com.reyzar.oa.service.finance.IFinInvoiceProjectMembersService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;
import com.reyzar.oa.service.sale.ISaleProjectMemberService;

@Controller
@RequestMapping(value="/manage/finance/invoiceProjectMembers")
public class FinInvoiceProjectMembersController extends BaseController {

	private final Logger logger = Logger.getLogger(FinCollectionController.class);
	
	@Autowired
	private IFinInvoiceProjectMembersService iFinInvoiceProjectMembersService;
	@Autowired
	private ISaleProjectManageService projectManageService;
	@Autowired
	private ISaleProjectMemberService saleProjectMemberService;
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(Integer finInvoicedId,Integer barginManageId) 
			throws JsonProcessingException {
		List<SaleProjectManage>  saleProjectManage=null;
		if(barginManageId!=null) {
			saleProjectManage=projectManageService.findProjectManageByBarginId(barginManageId);
		}	
		List<FinInvoiceProjectMembers> finInvoiceProjectMemberss =null;
		if(finInvoicedId!=null ) {
			finInvoiceProjectMemberss=iFinInvoiceProjectMembersService.findByFinInvoicedId(finInvoicedId);
		}
		if(finInvoiceProjectMemberss==null || finInvoiceProjectMemberss.size()<=0) {
			//如果是新增发票，则去项目成员表获取 项目成员信息到申请开票列表
			finInvoiceProjectMemberss=new ArrayList<FinInvoiceProjectMembers>();
			if(saleProjectManage!=null && saleProjectManage.size()>0) {
				//根据项目id获取项目成员集合
				List<SaleProjectMember> saleProjectMember=saleProjectMemberService.findByProjectId(saleProjectManage.get(0).getId());
				for (int i = 0; i < saleProjectMember.size(); i++) {
					FinInvoiceProjectMembers finInvoiceProjectMembers=new FinInvoiceProjectMembers();
					finInvoiceProjectMembers.setSysUser(saleProjectMember.get(i).getPrincipal());
					finInvoiceProjectMembers.setCommissionProportion(saleProjectMember.get(i).getCommissionProportion());
					finInvoiceProjectMembers.setResultsProportion(saleProjectMember.get(i).getResultsProportion());
					finInvoiceProjectMemberss.add(finInvoiceProjectMembers);
				}
			}
		}
		return JSONObject.toJSONString(finInvoiceProjectMemberss);
	}
}
