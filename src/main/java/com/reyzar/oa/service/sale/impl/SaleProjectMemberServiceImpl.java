package com.reyzar.oa.service.sale.impl;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;

import org.apache.commons.lang3.StringUtils;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.ProjectDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISaleProjectMemberDao;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SaleProjectMember;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleProjectManageService;
import com.reyzar.oa.service.sale.ISaleProjectMemberService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Service
@Transactional
public class SaleProjectMemberServiceImpl implements ISaleProjectMemberService {

	@Autowired
	private ISaleProjectMemberDao projectMemberDao;

	@Override
	public CrudResultDTO save(JSONObject json, SysUser user) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SaleProjectMember member = json.toJavaObject(SaleProjectMember.class);
		
		try {
			if(member.getId() == null) {
				member.setCreateBy(user.getAccount());
				member.setCreateDate(new Date());
				projectMemberDao.save(member);
			} else {	
				SaleProjectMember old = projectMemberDao.findById(member.getId());
				BeanUtils.copyProperties(member, old);
				old.setUserId(member.getUserId());
				old.setUpdateBy(user.getAccount());
				old.setUpdateDate(new Date());
				
				projectMemberDao.update(old);
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public SaleProjectMember findById(Integer id) {
		SaleProjectMember member = projectMemberDao.findById(id);
		return member;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<SaleProjectMember> findByProjectId(Integer projectId) {
		// TODO Auto-generated method stub
		return projectMemberDao.findByProjectId(projectId);
	}

}