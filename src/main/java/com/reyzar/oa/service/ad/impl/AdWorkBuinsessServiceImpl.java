package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.naming.spi.DirStateFactory.Result;

import org.activiti.engine.impl.cmd.SaveAttachmentCmd;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.druid.sql.visitor.functions.Bin;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.databind.util.BeanUtil;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.WorkManageDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdWorkBuinsessAttachDao;
import com.reyzar.oa.dao.IAdWorkBuinsessBackDao;
import com.reyzar.oa.dao.IAdWorkBuinsessDao;
import com.reyzar.oa.domain.AdWorkBuinsess;
import com.reyzar.oa.domain.AdWorkBuinsessAttach;
import com.reyzar.oa.domain.AdWorkBuinsessBack;
import com.reyzar.oa.domain.AdWorkReportAttach;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdWorkBuinsessService;

@Service
@Transactional
public class AdWorkBuinsessServiceImpl implements IAdWorkBuinsessService {
	@Autowired
	private IAdWorkBuinsessDao businessDao;
	@Autowired
	private IAdWorkBuinsessAttachDao buinessAttachDao;
	@Autowired
	private IAdWorkBuinsessBackDao buinsessBackDao;

	private final Logger logger = Logger.getLogger(AdWorkBuinsessServiceImpl.class);
	@Override
	public AdWorkBuinsess findById(Integer id) {
		return businessDao.findById(id);
	}
	
	
	@Override
	public Page<WorkManageDTO> findAllByPage(Map<String, Object> params,int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.MARKET);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		Page<WorkManageDTO> page = businessDao.findAllByPage(params);
		return page;
	}

	/**
	 * 驳回
	 * @param id
	 * @return
	 */
	@Override
	public CrudResultDTO rejectProcess(Integer id) {
		CrudResultDTO result=null;
		try{
			AdWorkBuinsess adWorkBuinsess=businessDao.findById(id);
			//将状态设置为空，表示未提交状态
			adWorkBuinsess.setStatus(" ");
			businessDao.setSstatus(adWorkBuinsess);
			result = new CrudResultDTO(CrudResultDTO.SUCCESS,"修改状态成功");
		}catch (Exception e){
			logger.info("退回工作汇报商务失败"+e);
		}
		return result;
	}


	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		CrudResultDTO result = null;
		AdWorkBuinsess buinsess = json.toJavaObject(AdWorkBuinsess.class);
		if (buinsess.getId() == null) {
			if(buinsess.getStatus() != ""){
				businessDao.setSstatus(buinsess);
				result = submit(buinsess);
			}else {
				result = save(buinsess);
			}
		}
		else {
			if(buinsess.getStatus() != "" && !"3".equals(buinsess.getStatus())){
				result = updatesbumit(buinsess);
			}else {
				result = update(buinsess);
			}
	
		}
		return result;
	}
	
	
	
	public CrudResultDTO save(AdWorkBuinsess business){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功");
		SysUser user = UserUtils.getCurrUser();
		business.setUserId(user.getId());
		business.setDeptId(user.getDeptId());
		business.setApplyTime(new Date());
		business.setCreateBy(user.getAccount());
		business.setCreateDate(new Date());
		business.setType("1");
		businessDao.save(business);
		
		List<AdWorkBuinsessAttach> businessAttachList = business.getBuinsessAttachsList();
		for (AdWorkBuinsessAttach attach : businessAttachList) {
			attach.setWorkBusinessId(business.getId());
			attach.setCreateBy(user.getAccount());
			attach.setCreateDate(new Date());
			attach.setUpdateBy(user.getAccount());
			attach.setUpdateDate(new Date());
		}
		
		buinessAttachDao.insertAll(businessAttachList);
		return result;
	}
	
	
	public CrudResultDTO submit(AdWorkBuinsess business){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功");
		SysUser user = UserUtils.getCurrUser();
		business.setUserId(user.getId());
		business.setDeptId(user.getDeptId());
		business.setApplyTime(new Date());
		business.setCreateBy(user.getAccount());
		business.setCreateDate(new Date());
		business.setType("1");
		business.setStatus("1");
		
		businessDao.save(business);
		
		List<AdWorkBuinsessAttach> businessAttachList = business.getBuinsessAttachsList();
		for (AdWorkBuinsessAttach attach : businessAttachList) {
			attach.setWorkBusinessId(business.getId());
			attach.setCreateBy(user.getAccount());
			attach.setCreateDate(new Date());
			attach.setUpdateBy(user.getAccount());
			attach.setUpdateDate(new Date());
		}
		
		buinessAttachDao.insertAll(businessAttachList);
		return result;
	}
	
	public CrudResultDTO update(AdWorkBuinsess business) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		business.setUpdateBy(user.getAccount());
		business.setUpdateDate(new Date());
		business.setApplyTime(new Date());
		AdWorkBuinsess orginbuiness = businessDao.findById(business.getId());
		List<AdWorkBuinsessAttach> orginWorkBuinsessAttachList = orginbuiness.getBuinsessAttachsList();
		BeanUtils.copyProperties(business, orginbuiness);
		
		List<AdWorkBuinsessAttach> saveList = Lists.newArrayList();
		List<AdWorkBuinsessAttach> updeteList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, AdWorkBuinsessAttach> originWorkBuinsessAttachMap = Maps.newHashMap();
		
		for (AdWorkBuinsessAttach buinsessAttach : orginWorkBuinsessAttachList) {
			originWorkBuinsessAttachMap.put(buinsessAttach.getId(), buinsessAttach);
		}
		List<AdWorkBuinsessAttach> buinsessAttachList = business.getBuinsessAttachsList();
		for (AdWorkBuinsessAttach buinsessAttach : buinsessAttachList) {
			AdWorkBuinsessAttach orgin = originWorkBuinsessAttachMap.get(buinsessAttach.getId());
			if (orgin != null) {
				BeanUtils.copyProperties(buinsessAttach, orgin);
				updeteList.add(orgin);
				originWorkBuinsessAttachMap.remove(orgin.getId());
			}
			else {
				buinsessAttach.setWorkBusinessId(business.getId());
				buinsessAttach.setCreateBy(user.getAccount());
				buinsessAttach.setCreateDate(new Date());
				buinsessAttach.setUpdateBy(user.getAccount());
				buinsessAttach.setUpdateDate(new Date());
				saveList.add(buinsessAttach);
			}
		}
		delList.addAll(originWorkBuinsessAttachMap.keySet());
		if (saveList.size()>0) {
			buinessAttachDao.insertAll(saveList);
		}
		if (updeteList.size() >0) {
			buinessAttachDao.batchUpdate(updeteList);
		}
		if (delList.size()>0) {
			buinessAttachDao.deleteByIdList(delList);
		}
		return result;
	}


		public CrudResultDTO updatesbumit(AdWorkBuinsess business) {
			CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
			SysUser user = UserUtils.getCurrUser();
			AdWorkBuinsess buinsess=businessDao.findById(business.getId());
			business.setUpdateBy(user.getAccount());
			business.setUpdateDate(new Date());
			if("3".equals(buinsess.getStatus())){
				business.setStatus("1");
				business.setApplyTime(buinsess.getApplyTime());
				/*businessDao.setSstatus(business);*/
			}else{
				business.setApplyTime(new Date());
			}
		AdWorkBuinsess orginbuiness = businessDao.findById(business.getId());
		List<AdWorkBuinsessAttach> orginWorkBuinsessAttachList = orginbuiness.getBuinsessAttachsList();
		BeanUtils.copyProperties(business, orginbuiness);
		businessDao.update(orginbuiness);
		List<AdWorkBuinsessAttach> saveList = Lists.newArrayList();
		List<AdWorkBuinsessAttach> updeteList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, AdWorkBuinsessAttach> originWorkBuinsessAttachMap = Maps.newHashMap();
		
		for (AdWorkBuinsessAttach buinsessAttach : orginWorkBuinsessAttachList) {
			originWorkBuinsessAttachMap.put(buinsessAttach.getId(), buinsessAttach);
		}
		List<AdWorkBuinsessAttach> buinsessAttachList = business.getBuinsessAttachsList();
		for (AdWorkBuinsessAttach buinsessAttach : buinsessAttachList) {
			AdWorkBuinsessAttach orgin = originWorkBuinsessAttachMap.get(buinsessAttach.getId());
			if (orgin != null) {
				BeanUtils.copyProperties(buinsessAttach, orgin);
				updeteList.add(orgin);
				originWorkBuinsessAttachMap.remove(orgin.getId());
			}
			else {
				buinsessAttach.setWorkBusinessId(business.getId());
				buinsessAttach.setCreateBy(user.getAccount());
				buinsessAttach.setCreateDate(new Date());
				buinsessAttach.setUpdateBy(user.getAccount());
				buinsessAttach.setUpdateDate(new Date());
				saveList.add(buinsessAttach);
			}
		}
		delList.addAll(originWorkBuinsessAttachMap.keySet());
		if (saveList.size()>0) {
			buinessAttachDao.insertAll(saveList);
		}
		if (updeteList.size() >0) {
			buinessAttachDao.batchUpdate(updeteList);
		}
		if (delList.size()>0) {
			buinessAttachDao.deleteByIdList(delList);
		}
		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		return null;
	}

/**
 * 驳回
 * */
	@Override
	public CrudResultDTO rejectProcess(Integer id, String contents) {
		CrudResultDTO result=null;
		try{
			AdWorkBuinsess adWorkBuinsess=businessDao.findById(id);
			AdWorkBuinsessBack adWorkBuinsessBack=new AdWorkBuinsessBack();
			adWorkBuinsessBack.setWorkBusinessId(id);
			adWorkBuinsessBack.setCreateDate(new Date());
			adWorkBuinsessBack.setUserId(UserUtils.getCurrUser().getId());
			adWorkBuinsessBack.setContent(contents);
			buinsessBackDao.save(adWorkBuinsessBack);
			//将状态设置为空，表示未提交状态
			adWorkBuinsess.setStatus("3");
			businessDao.setSstatus(adWorkBuinsess);
			result = new CrudResultDTO(CrudResultDTO.SUCCESS,"修改状态成功");
		}catch (Exception e){
			logger.info("退回工作汇报商务失败"+e);
		}
		return result;
	}
}