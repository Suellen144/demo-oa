package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.reyzar.oa.controller.ad.AdWorkMarketController;
import net.sf.jsqlparser.statement.update.Update;

import org.activiti.engine.impl.cmd.SaveAttachmentCmd;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdWorkMarketAttachDao;
import com.reyzar.oa.dao.IAdWorkMarketBackDao;
import com.reyzar.oa.dao.IAdWorkMarketDao;
import com.reyzar.oa.domain.AdWorkBuinsess;
import com.reyzar.oa.domain.AdWorkBuinsessAttach;
import com.reyzar.oa.domain.AdWorkMarket;
import com.reyzar.oa.domain.AdWorkMarketAttach;
import com.reyzar.oa.domain.AdWorkMarketBack;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdWorkMarketService;

@Service
@Transactional
public class AdWorkMarketServiceImpl implements IAdWorkMarketService {
	@Autowired
	private IAdWorkMarketDao marketDao;
	@Autowired
	private IAdWorkMarketAttachDao marketAttachDao;
	@Autowired
	private IAdWorkMarketBackDao marketBackDao;
	
	private final Logger logger = Logger.getLogger(AdWorkMarketServiceImpl.class);
	
	@Override
	public AdWorkMarket findById(Integer id) {
		return marketDao.findById(id);
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		CrudResultDTO result = null;
		AdWorkMarket market = json.toJavaObject(AdWorkMarket.class);
		if (market.getId() == null) {
			if (market.getStatus() != "") {
				marketDao.setSstatus(market);
				result = sbumit(market);
			}
			else{
				result = save(market);
			}
		}
		else {
			if (market.getStatus() != "" && !"3".equals(market.getStatus())) {
				result = Updatesubmit(market);
			}
			else{
				result = Update(market);
			}
		}
		return result;
	}
	
	
	public CrudResultDTO save(AdWorkMarket market){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功");
		SysUser user = UserUtils.getCurrUser();
		market.setUserId(user.getId());
		market.setDeptId(user.getDeptId());
		market.setApplyTime(new Date());
		market.setCreateBy(user.getAccount());
		market.setCreateDate(new Date());
		market.setType("2");
		
		marketDao.save(market);
		
		List<AdWorkMarketAttach> marketAttachList = market.getMarketAttachsList();
		for (AdWorkMarketAttach attach : marketAttachList) {
			attach.setWorkMarketId(market.getId());
			attach.setCreateBy(user.getAccount());
			attach.setCreateDate(new Date());
			attach.setUpdateBy(user.getAccount());
			attach.setUpdateDate(new Date());
		}
		
		marketAttachDao.insertAll(marketAttachList);
		return result;
	}
	
	
	public CrudResultDTO sbumit(AdWorkMarket market){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功");
		SysUser user = UserUtils.getCurrUser();
		market.setUserId(user.getId());
		market.setDeptId(user.getDeptId());
		market.setApplyTime(new Date());
		market.setCreateBy(user.getAccount());
		market.setCreateDate(new Date());
		market.setType("2");
		
		marketDao.save(market);
		
		List<AdWorkMarketAttach> marketAttachList = market.getMarketAttachsList();
		for (AdWorkMarketAttach attach : marketAttachList) {
			attach.setWorkMarketId(market.getId());
			attach.setCreateBy(user.getAccount());
			attach.setCreateDate(new Date());
			attach.setUpdateBy(user.getAccount());
			attach.setUpdateDate(new Date());
		}
		
		marketAttachDao.insertAll(marketAttachList);
		return result;
	}
	
	public CrudResultDTO Update(AdWorkMarket market){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		market.setUpdateBy(user.getAccount());
		market.setUpdateDate(new Date());
		AdWorkMarket orginbuiness = marketDao.findById(market.getId());
		List<AdWorkMarketAttach> orginWorkBuinsessAttachList = orginbuiness.getMarketAttachsList();
		BeanUtils.copyProperties(market, orginbuiness);
		List<AdWorkMarketAttach> saveList = Lists.newArrayList();
		List<AdWorkMarketAttach> updeteList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, AdWorkMarketAttach> originWorkBuinsessAttachMap = Maps.newHashMap();
		
		for (AdWorkMarketAttach buinsessAttach : orginWorkBuinsessAttachList) {
			originWorkBuinsessAttachMap.put(buinsessAttach.getId(), buinsessAttach);
		}
		List<AdWorkMarketAttach> buinsessAttachList = market.getMarketAttachsList();
		for (AdWorkMarketAttach Attach : buinsessAttachList) {
			AdWorkMarketAttach orgin = originWorkBuinsessAttachMap.get(Attach.getId());
			if (orgin != null) {
				BeanUtils.copyProperties(Attach, orgin);
				updeteList.add(orgin);
				originWorkBuinsessAttachMap.remove(orgin.getId());
			}
			else {
				Attach.setWorkMarketId(market.getId());
				Attach.setCreateBy(user.getAccount());
				Attach.setCreateDate(new Date());
				saveList.add(Attach);
			}
		}
		delList.addAll(originWorkBuinsessAttachMap.keySet());
		if (saveList.size()>0) {
			marketAttachDao.insertAll(saveList);
		}
		if (updeteList.size() >0) {
			marketAttachDao.batchUpdate(updeteList);
		}
		if (delList.size()>0) {
			marketAttachDao.deleteByIdList(delList);
		}
		return result;
	}
	
	public CrudResultDTO Updatesubmit(AdWorkMarket market){
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		AdWorkMarket market2=marketDao.findById(market.getId());
		SysUser user = UserUtils.getCurrUser();
		market.setUpdateBy(user.getAccount());
		market.setUpdateDate(new Date());
		if("3".equals(market2.getStatus())){
			market.setStatus("1");
			market.setApplyTime(market2.getApplyTime());
		/*	marketDao.setSstatus(market);*/
		}else{
			market.setApplyTime(new Date());
		}
		AdWorkMarket orginbuiness = marketDao.findById(market.getId());
		List<AdWorkMarketAttach> orginWorkBuinsessAttachList = orginbuiness.getMarketAttachsList();
		BeanUtils.copyProperties(market, orginbuiness);
		marketDao.update(orginbuiness);
		List<AdWorkMarketAttach> saveList = Lists.newArrayList();
		List<AdWorkMarketAttach> updeteList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, AdWorkMarketAttach> originWorkBuinsessAttachMap = Maps.newHashMap();
		
		for (AdWorkMarketAttach buinsessAttach : orginWorkBuinsessAttachList) {
			originWorkBuinsessAttachMap.put(buinsessAttach.getId(), buinsessAttach);
		}
		List<AdWorkMarketAttach> buinsessAttachList = market.getMarketAttachsList();
		for (AdWorkMarketAttach Attach : buinsessAttachList) {
			AdWorkMarketAttach orgin = originWorkBuinsessAttachMap.get(Attach.getId());
			if (orgin != null) {
				BeanUtils.copyProperties(Attach, orgin);
				updeteList.add(orgin);
				originWorkBuinsessAttachMap.remove(orgin.getId());
			}
			else {
				Attach.setWorkMarketId(market.getId());
				Attach.setCreateBy(user.getAccount());
				Attach.setCreateDate(new Date());
				saveList.add(Attach);
			}
		}
		delList.addAll(originWorkBuinsessAttachMap.keySet());
		if (saveList.size()>0) {
			marketAttachDao.insertAll(saveList);
		}
		if (updeteList.size() >0) {
			marketAttachDao.batchUpdate(updeteList);
		}
		if (delList.size()>0) {
			marketAttachDao.deleteByIdList(delList);
		}
		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		return null;
	}

	/**
	 * 退回工作汇报
	 * @param id
	 * @return
	 */
	@Override
	public CrudResultDTO rejectProcess(Integer id) {
		CrudResultDTO result=null;
		try {
			AdWorkMarket adWorkMarket = marketDao.findById(id);
			adWorkMarket.setStatus(" ");
			marketDao.setSstatus(adWorkMarket);
			result = new CrudResultDTO(CrudResultDTO.SUCCESS, "修改状态成功！");
		}catch (Exception e){
			logger.info("退回工作汇报拜访失败"+e);
		}
		return result;
	}

	@Override
	public CrudResultDTO rejectProcess(Integer id, String contents) {
		CrudResultDTO result=null;
		try {
			AdWorkMarket adWorkMarket = marketDao.findById(id);
			AdWorkMarketBack adWorkMarketBack=new AdWorkMarketBack();
			adWorkMarketBack.setUserId(UserUtils.getCurrUser().getId());
			adWorkMarketBack.setCreateDate(new Date());
			adWorkMarketBack.setWorkMarketId(id);
			adWorkMarketBack.setContent(contents);
			marketBackDao.save(adWorkMarketBack);
			adWorkMarket.setStatus("3");
			marketDao.setSstatus(adWorkMarket);
			result = new CrudResultDTO(CrudResultDTO.SUCCESS, "修改状态成功！");
		}catch (Exception e){
			logger.info("退回工作汇报拜访失败"+e);
		}
		return result;
	}

}