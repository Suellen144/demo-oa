package com.reyzar.oa.service.sale;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleProjectMember;
import com.reyzar.oa.domain.SysUser;

public interface ISaleProjectMemberService {
	
	public SaleProjectMember findById(Integer id);
	
	public CrudResultDTO save(JSONObject json, SysUser user);

	public CrudResultDTO delete(Integer id);

	public List<SaleProjectMember> findByProjectId(Integer projectId);
}