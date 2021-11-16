package com.reyzar.oa.service.office.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IOffInReplyDao;
import com.reyzar.oa.dao.IOffPostDao;
import com.reyzar.oa.dao.IOffReplyDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.domain.OffInReply;
import com.reyzar.oa.domain.OffPost;
import com.reyzar.oa.domain.OffReply;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.office.IOffPostService;

@Service
@Transactional
public class OffOPostServiceImpl implements IOffPostService{
	
	private final Logger logger = Logger.getLogger(OffNoticeServiceImpl.class);
	
	@Autowired
	private IOffPostDao postDao;
	@Autowired
	private IOffReplyDao replyDao;
	@Autowired
	private IOffInReplyDao inReplyDao;
	@Autowired
	private ISysUserDao userDao;
	
	
	@Override
	public Page<OffPost> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		
		return null;
	}

	@Override
	public List<OffPost> findAll(Map<String, Object> params) {
		SysUser user=UserUtils.getCurrUser();
		params.put("userId", user.getId());
		return postDao.findAll(params);
	}

	@Override
	public OffPost findById(Integer id) {
		return postDao.findById(id);
	}

	@Override
	public CrudResultDTO save(OffPost offPost) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		try {
			if(!"y".equals(SystemConstant.getValue("isMark"))){
				offPost.setAudit(1);
			}else{
				offPost.setAudit(0);
			}
			postDao.save(offPost);
		} catch (Exception e) {
			result=new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO update(OffPost offPost) {
		
		return null;
	}

	@Override
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		List<OffReply> updateReply=Lists.newArrayList();
		List<OffInReply> updateInReply=Lists.newArrayList();
		OffPost post=postDao.findById(id);
		try {
			List<OffReply> replies=replyDao.findByPostId(id);
			for (OffReply offReply : replies) {
				offReply.setIsDeleted("1");
				updateReply.add(offReply);
				List<OffInReply> inReplies=inReplyDao.findByInReplyId(offReply.getId());
				for (OffInReply offInReply : inReplies) {
					offInReply.setIsDeleted("1");
					updateInReply.add(offInReply);
				}
			}
			if(updateReply.size()>0){
				replyDao.batchUpdate(updateReply);
				if(updateInReply.size()>0){
					inReplyDao.batchUpdate(updateInReply);
				}
			}
			post.setIsDeleted("1");
			postDao.update(post);
		} catch (Exception e) {
			result=new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}

	@Override
	public List<OffReply> findReplyById(Integer id) {
		
		return replyDao.findByPostId(id);
	}

	@Override
	public CrudResultDTO addReply(JSONObject json) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		OffReply reply=json.toJavaObject(OffReply.class);
		SysUser user=UserUtils.getCurrUser();
		try {
			OffPost offPost=postDao.findById(reply.getPostId());
			offPost.setLastReplyId(user.getId());
			offPost.setLastReplyName(user.getName());
			offPost.setLastReplyTime(new Date());
			offPost.setReplyCount(offPost.getReplyCount()+1);
			postDao.update(offPost);
			reply.setInReplyCount(0);
			reply.setReplyTime(new Date());
			replyDao.save(reply);
		} catch (Exception e) {
			result=new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO addInReply(JSONObject json) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		OffInReply inReply=json.toJavaObject(OffInReply.class);
		SysUser user=UserUtils.getCurrUser();
		try {
			OffReply  reply=replyDao.findById(inReply.getReplyId());
			reply.setInReplyCount(reply.getInReplyCount()+1);
			replyDao.update(reply);
			OffPost offPost=postDao.findById(reply.getPostId());
			offPost.setLastReplyId(user.getId());
			offPost.setLastReplyName(user.getName());
			offPost.setLastReplyTime(new Date());
			offPost.setReplyCount(offPost.getReplyCount()+1);
			postDao.update(offPost);
			inReply.setUnickName(user.getName());
			SysUser sysUser=userDao.findById(inReply.getRuserId());
			inReply.setRunickname(sysUser.getName());
			inReply.setReplyTime(new Date());
			inReplyDao.save(inReply);
		} catch (Exception e) {
			result=new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO updateAudit(Integer id, Integer audit) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		OffPost offPost=null;
		try {
			offPost=postDao.findById(id);
			offPost.setAudit(audit);
			postDao.updateAudit(offPost);
		} catch (Exception e) {
			result=new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO updateStatus(Integer id, Integer status) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		OffPost offPost=null;
		try {
			offPost=postDao.findById(id);
			offPost.setStatus(status);
			postDao.updateStatus(offPost);
		} catch (Exception e) {
			result=new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		return result;
	}
	
	
}
