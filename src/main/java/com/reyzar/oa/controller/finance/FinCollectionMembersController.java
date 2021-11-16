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
import com.reyzar.oa.domain.FinCollectionMembers;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SaleProjectMember;
import com.reyzar.oa.service.finance.IFinCollectionMembersService;
import com.reyzar.oa.service.sale.ISaleProjectManageService;
import com.reyzar.oa.service.sale.ISaleProjectMemberService;

@Controller
@RequestMapping(value="/manage/finance/collectionMembers")
public class FinCollectionMembersController extends BaseController {

	private final Logger logger = Logger.getLogger(FinCollectionController.class);
	
	@Autowired
	private IFinCollectionMembersService iFinCollectionMembersService;
	@Autowired
	private ISaleProjectManageService projectManageService;
	@Autowired
	private ISaleProjectMemberService saleProjectMemberService;
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList(Integer finCollectionId,Integer barginManageId) 
			throws JsonProcessingException {
		List<SaleProjectManage>  saleProjectManage=null;
		if(barginManageId!=null) {
			saleProjectManage=projectManageService.findProjectManageByBarginId(barginManageId);
		}	
		List<FinCollectionMembers> FinCollectionMembers =null;
		if(finCollectionId!=null ) {
			FinCollectionMembers=iFinCollectionMembersService.findByFinCollectionId(finCollectionId);
		}
		if(FinCollectionMembers==null || FinCollectionMembers.size()<=0) {
			//如果是新增收款，则去项目成员表获取 项目成员信息到收款申请表
			FinCollectionMembers=new ArrayList<FinCollectionMembers>();
			if(saleProjectManage!=null && saleProjectManage.size()>0) {
				//根据项目id获取项目成员集合
				List<SaleProjectMember> saleProjectMember=saleProjectMemberService.findByProjectId(saleProjectManage.get(0).getId());
				for (int i = 0; i < saleProjectMember.size(); i++) {
					FinCollectionMembers finCollectionMembers1=new FinCollectionMembers();
					finCollectionMembers1.setSysUser(saleProjectMember.get(i).getPrincipal());
					finCollectionMembers1.setCommissionProportion(saleProjectMember.get(i).getCommissionProportion());
					FinCollectionMembers.add(finCollectionMembers1);
				}
			}
		}
		return JSONObject.toJSONString(FinCollectionMembers);
	}
}
