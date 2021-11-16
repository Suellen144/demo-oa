package com.reyzar.oa.service.office.impl;

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.dao.IOffForumDao;
import com.reyzar.oa.domain.OffForum;
import com.reyzar.oa.service.office.IOffForumService;

@Service
@Transactional
public class OffFroumServiceImpl implements IOffForumService{
	private final Logger logger = Logger.getLogger(OffNoticeServiceImpl.class);
	
	@Autowired 
	private IOffForumDao forumDao;
	
	
	@Override
	public Page<OffForum> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<OffForum> page =forumDao.findByPage(params);
		return page;
	}

	@Override
	public List<OffForum> findAll() {
		
		return forumDao.findAll();
	}

	@Override
	public OffForum findById(Integer id) {
		
		return forumDao.findById(id);
	}

	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		OffForum forum=json.toJavaObject(OffForum.class);
		try {
			
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
		
	}

	@Override
	public CrudResultDTO update(JSONObject json) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		OffForum forum=json.toJavaObject(OffForum.class);
		try {
			
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		try {
				forumDao.deleteById(id);
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}

}
