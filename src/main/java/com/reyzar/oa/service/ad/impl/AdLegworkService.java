package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdLegworkDao;
import com.reyzar.oa.dao.IOffNoticeDao;
import com.reyzar.oa.domain.AdLegwork;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdLegworkService;

@Service
@Transactional
public class AdLegworkService implements IAdLegworkService{
	
	private final Logger logger = Logger.getLogger(AdLegworkService.class);
	@Autowired
	private IAdLegworkDao legworkDao;
	@Override
	public Page<AdLegwork> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize,SysUser user) {
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.LEGWORK);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		Set<Integer> userSet = UserUtils.getPrincipalIdList(user);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		params.put("userSet",userSet);
		PageHelper.startPage(pageNum, pageSize);
		PageHelper.orderBy("id desc");
		Page<AdLegwork> page = legworkDao.findByPage(params);
		return page;
	}

	@Override
	public CrudResultDTO save(JSONObject json, SysUser user) {
		List<AdLegwork> lwList=Lists.newArrayList();
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		String uuid = UUID.randomUUID().toString().trim().replaceAll("-", "");
		String[] stList= json.getJSONArray("startTime").toArray(new String[]{});
		String[] etList= json.getJSONArray("endTime").toArray(new String[]{});
		String[] placeList= json.getJSONArray("place").toArray(new String[]{});
		String[] reasonList= json.getJSONArray("reason").toArray(new String[]{});
		try {
			int length=stList.length;
			for (int index = 0; index <length; index++) {
				if (stList[index]!="" && etList[index]!="" && placeList[index] != "" && reasonList[index] !="") {
					AdLegwork legwork =new AdLegwork();
					legwork.setCategorize(uuid);
					legwork.setUserId(user.getId());
					legwork.setApplyPeople(json.getString("applyPeople"));
					legwork.setStartTime(!StringUtils.isBlank(stList[index])?DateUtils.parseDate(stList[index], "yyyy-MM-dd HH:mm") : null);
					legwork.setEndTime(!StringUtils.isBlank(etList[index])?DateUtils.parseDate(etList[index], "yyyy-MM-dd HH:mm") : null);
					legwork.setPlace(!StringUtils.isBlank(placeList[index])?String.valueOf(placeList[index]) : null);
					legwork.setReason(!StringUtils.isBlank(reasonList[index])?String.valueOf(reasonList[index]) : null);
					legwork.setCreateBy(user.getName());
					legwork.setCreateDate(new Date());
					lwList.add(legwork);
				}
				
			}
			
			legworkDao.insertAll(lwList);
		} 
		catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败" + e.getMessage());
			e.printStackTrace();
			logger.error(result);
			
		}		
		return result;
	}

	@Override
	public AdLegwork findById(Integer id) {
		return legworkDao.findById(id);
	}

	
	@Override
	public List<AdLegwork> findByCategorize(String categorize) {
		return legworkDao.findByCategorize(categorize);
	}

	@Override
	public CrudResultDTO deleteBycategorize(String categorize) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功!");
		try {
			if (categorize != null) {
				List<AdLegwork> legworks = legworkDao.findByCategorize(categorize);
				SysUser user = UserUtils.getCurrUser();
				for (AdLegwork legwork : legworks) {
					legwork.setDeleted(1);
					legwork.setUpdateBy(user.getAccount());
					legwork.setUpdateDate(new Date());
					legworkDao.update(legwork);
				}
			}
			else {
				result =new CrudResultDTO(CrudResultDTO.FAILED, "没有ID为'" + categorize + "'的对象！");
			}
		} catch (Exception e) {
			result =new CrudResultDTO(CrudResultDTO.FAILED, "删除失败"+e.getMessage());
			throw new RuntimeException(e.getMessage());
		}
		return result;
	}
	

}
