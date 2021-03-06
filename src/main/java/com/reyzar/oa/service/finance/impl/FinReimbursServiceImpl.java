package com.reyzar.oa.service.finance.impl; 

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.mail.Message;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.ReimburseDTO;
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.IFinReimburseAttachDao;
import com.reyzar.oa.dao.IFinReimburseDao;
import com.reyzar.oa.dao.IFinTravelreimburseDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.domain.FinReimburse;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelreimburse;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.finance.IFinReimbursService;
import com.reyzar.oa.service.sys.IEncryptService;
import com.reyzar.oa.service.sys.ISysDeptService;

/**
 * 
 * @Description: 
 * @author Lairongfa
 * @date 2016???9???21??? ??????2:56:12 
 *
 */
@Service
@Transactional
public class FinReimbursServiceImpl implements IFinReimbursService, IEncryptService {
	
	private final static Logger logger = Logger.getLogger(FinReimbursServiceImpl.class);

	@Autowired
	private IFinReimburseDao reimburseDao;
	@Autowired
	private IFinReimburseAttachDao reimburseAttachDao;
	@Autowired
	private IFinTravelreimburseDao travelreimburseDao;
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IAdRecordDao iAdRecordDao;
	@Autowired
	private ISysUserDao iSysUserDao;
	@Autowired
	private ISysDeptService deptService;
	
	@Override
	public Page<FinReimburse> findByPage(Map<String, Object> params,int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.REIMBURSE);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		
		PageHelper.startPage(pageNum, pageSize);
		Page<FinReimburse> page = reimburseDao.findByPage(params);
		return page;
	}
	
	@Override
	public Page<FinTravelreimburse> findByPage1(Map<String, Object> params,int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, 1000);
		Page<FinTravelreimburse> page = travelreimburseDao.findByPage1(params);
		return page;
	}
	
	/*??????????????????????????????*/
	@Override
	public Page<ReimburseDTO> findMeByPage(Map<String, Object> params,int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		params.put("userId", user.getId());
		PageHelper.startPage(pageNum, pageSize);
		Page<ReimburseDTO> page = reimburseDao.findMeByPage(params);
		return page;
	}
	
	@Override
	public Integer showSize() {
		SysUser user = UserUtils.getCurrUser();
		Integer count = reimburseDao.showSize(user.getId());
		if (count ==null || count<1) {
			count = 0;
		}
		return count;
	}
	
	/*??????????????????????????????*/
	@Override
	public Page<ReimburseDTO> findAllByPage(Map<String, Object> params,int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.MANAGER);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		
		PageHelper.startPage(pageNum, pageSize);
		Page<ReimburseDTO> page = reimburseDao.findAllByPage(params);
		return page;
	}
	
	
	
	@Override
	public FinReimburse findById(Integer id) {
		FinReimburse finReimburse = reimburseDao.findById(id);
		 SimpleDateFormat formatter = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss");
		 String  createDate = formatter.format(finReimburse.getCreateDate());
		 finReimburse.setCreateDateStr(createDate);
		 SysUser user = UserUtils.getCurrUser();
			if((user.getDeptId() == 3 || user.getDept().getParentId() == 3) && user.getDeptId() != 46) {
				finReimburse.setIsOk("true");
			}else {
				finReimburse.setIsOk("false");
			}
		return finReimburse;
	}
	
	

	/*??????????????????*/
	@Override
	public CrudResultDTO save(JSONObject json) {
		SysUser user = UserUtils.getCurrUser();
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
			Date currDate = new Date();
			String orderNo = "";
			
			String maxOrderNo = travelreimburseDao.getMaxOrderNo();
			String orderNoBase = new SimpleDateFormat("yyyyMM").format(currDate); 
			
			// ?????????????????????????????????????????????????????????????????????
			if(maxOrderNo == null || "".equals(maxOrderNo)
					|| maxOrderNo.indexOf(orderNoBase) <= -1) {
				orderNo = orderNoBase + "0001";
			} else {
				orderNo = (Long.valueOf(maxOrderNo) + 1) + "";
			}
			
			FinReimburse reimburse = json.toJavaObject(FinReimburse.class);
			reimburse.setOrderNo(orderNo);
			reimburse.setApplyTime(currDate);
			reimburse.setCreateBy(user.getAccount());
			reimburse.setCreateDate(currDate);
			reimburse.setKind(2);
			reimburse.setStatus(null);
			reimburseDao.save(reimburse);
			
			if(reimburse.getReimburseAttachList() != null) {
				for(FinReimburseAttach reimburseAttach : reimburse.getReimburseAttachList()) {
					reimburseAttach.setReimburseId(reimburse.getId());
					reimburseAttach.setCreateBy(reimburse.getCreateBy());
					reimburseAttach.setCreateDate(currDate);
					
					if(reimburseAttach.getActReimburse() == null) {
						reimburseAttach.setActReimburse(reimburseAttach.getMoney());
					}
				}
				reimburseAttachDao.insertAll(reimburse.getReimburseAttachList());
			}
			
			return result;
	}
	
	/*????????????*/
	@Override
	public CrudResultDTO submitinfo(JSONObject json) {
		ProcessInstance processInstance = null;
		SysUser user = UserUtils.getCurrUser();
		SysDept sysDept=deptService.findById(user.getDept().getId());
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		try {
			Date currDate = new Date();
			String orderNo = "";
			
			String maxOrderNo = travelreimburseDao.getMaxOrderNo();
			String orderNoBase = new SimpleDateFormat("yyyyMM").format(currDate); 
			
			// ?????????????????????????????????????????????????????????????????????
			if(maxOrderNo == null || "".equals(maxOrderNo)
					|| maxOrderNo.indexOf(orderNoBase) <= -1) {
				orderNo = orderNoBase + "0001";
			} else {
				orderNo = (Long.valueOf(maxOrderNo) + 1) + "";
			}
			
			FinReimburse reimburse = json.toJavaObject(FinReimburse.class);
			String old = reimburse.getOrderNo();
			if (reimburse.getId() != null) {
				reimburseDao.deleteById(reimburse.getId());
				reimburseAttachDao.deleteByreimburseId(reimburse.getId());
			}
			if (old == null) {
				reimburse.setOrderNo(orderNo);
			}
			else {
				String temp = old.substring(0, old.length()-4);
				String date = new SimpleDateFormat("yyyyMM").format(new Date()); 
				if (temp.equals(date)) {
					reimburse.setOrderNo(old);
				}
				else {
					reimburse.setOrderNo(orderNo);
				}
			}
			reimburse.setApplyTime(currDate);
			reimburse.setCreateBy(user.getAccount());
			reimburse.setCreateDate(currDate);
			reimburse.setKind(2);
			reimburse.setInitMoney(reimburse.getCost());
			reimburse.setIsSend(0);
			reimburseDao.save(reimburse);
			
			if(reimburse.getReimburseAttachList() != null) {
				for(FinReimburseAttach reimburseAttach : reimburse.getReimburseAttachList()) {
					reimburseAttach.setReimburseId(reimburse.getId());
					reimburseAttach.setCreateBy(reimburse.getCreateBy());
					reimburseAttach.setCreateDate(currDate);
					
					if(reimburseAttach.getActReimburse() == null) {
						reimburseAttach.setActReimburse(reimburseAttach.getMoney());
					}
				}
				reimburseAttachDao.insertAll(reimburse.getReimburseAttachList());
			}
			
			List<SysUser> sysUser=iSysUserDao.findByName(reimburse.getName());
			String userIds="";
			if(sysUser!=null && sysUser.size()>0) {
				userIds=sysUser.get(0).getId().toString();
			}else {
				userIds=user.getId().toString();
			}
			// ????????????????????????
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
			businessParams.put("class", this.getClass().getName()); // ?????????????????????
			businessParams.put("method", "findById"); // ????????????
			businessParams.put("paramValue", new Object[] { reimburse.getId() }); // ????????????????????????
			variables.put("isOk", user.getDeptId() == 3 || sysDept.getParentId() == 3 && user.getDeptId() != 46? true : false); // ???????????????
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
			
			processInstance = activitiUtils.startProcessInstance(
					ActivitiUtils.REIMBURSE_KEY, userIds, reimburse.getId().toString(), variables);
			
			// ????????????????????????????????????
			List<Map<String, Object>> commentList = Lists.newArrayList(); 
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "????????????");
			commentMap.put("approver", user.getName());
			commentMap.put("comment", "");
			commentMap.put("approveResult", "????????????");
			commentMap.put("approveDate", currDate);
			commentList.add(commentMap);
			variables.put("commentList", commentList); // ??????????????????????????????????????????
			
			List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
			for(Task task : taskList) {
				if(task.getName().equals("????????????")) {
					activitiUtils.completeTask(task.getId(), variables);
					break ;
				}
			}
			
			//????????????????????????????????????????????????????????????????????????????????????
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			// ??????????????????Activiti???????????????
			reimburse.setProcessInstanceId(processInstance.getId());
			reimburse.setStatus(status);
			reimburseDao.update(reimburse);
		} catch(Exception e) {
			if(processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}
	
	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		FinReimburse reimburse = reimburseDao.findById(id);
	
		if(reimburse != null) {
			reimburse.setStatus(status);
			reimburseDao.update(reimburse);
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult("????????????!");
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("??????id??????" + id + " ????????????");
		}
		return result;
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) throws ParseException {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SysUser user = UserUtils.getCurrUser();
		String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
		if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("?????????????????????????????????????????????");
		}
		boolean hasEncryptionKey = encryptionKey != null && ModuleEncryptUtils.validEncryptionKey(encryptionKey) ? true : false;
		
		FinReimburse reimburse = json.toJavaObject(FinReimburse.class);
		FinReimburse originReimburse = reimburseDao.findById(reimburse.getId());
		if (originReimburse.getStatus() != null &&(originReimburse.getStatus().equals("8") || originReimburse.getStatus().equals("9") || originReimburse.getStatus().equals("10") || originReimburse.getStatus().equals("12"))) {
		//	reimburse.setApplyTime(new Date());
		}
		reimburse.setUpdateBy(user.getAccount());
		reimburse.setUpdateDate(new Date());
		BeanUtils.copyProperties(reimburse, originReimburse);
		List<FinReimburseAttach> originReimburseAttachList = reimburseAttachDao.findByReimburseId(reimburse.getId());
		List<FinReimburseAttach> reimburseAttachList = reimburse.getReimburseAttachList();
		
		List<FinReimburseAttach> saveList = Lists.newArrayList();
		List<FinReimburseAttach> updateList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, FinReimburseAttach> originReimburseAttachMap = Maps.newHashMap();
		for(FinReimburseAttach reimburseAttach : originReimburseAttachList) {
			originReimburseAttachMap.put(reimburseAttach.getId(), reimburseAttach);
		}
		
		for(FinReimburseAttach reimburseAttach : reimburseAttachList) {
			if(reimburseAttach.getId() != null) {
				reimburseAttach.setUpdateBy(user.getAccount());
				reimburseAttach.setUpdateDate(new Date());
				
				if(reimburseAttach.getActReimburse() == null) {
					reimburseAttach.setActReimburse(reimburseAttach.getMoney());
				}
				
				FinReimburseAttach origin = originReimburseAttachMap.get(reimburseAttach.getId());
				if(origin != null) {
					// ?????????????????????????????????????????????????????????????????????????????????
					if( "y".equals(originReimburse.getEncrypted()) && !hasEncryptionKey ) {
						reimburseAttach.setReason(origin.getReason());
						reimburseAttach.setDetail(origin.getDetail());
					}
					BeanUtils.copyProperties(reimburseAttach, origin);
					if(reimburseAttach.getInvestId() == null ){
						origin.setInvestId(null);
					}
					if(reimburseAttach.getInvestIdStr() == null ){
						origin.setInvestIdStr(null);
					}
					updateList.add(origin);
					originReimburseAttachMap.remove(origin.getId());
				}
			} else {
				reimburseAttach.setReimburseId(reimburse.getId());
				reimburseAttach.setCreateBy(user.getAccount());
				reimburseAttach.setCreateDate(new Date());
				saveList.add(reimburseAttach);
			}
		}
		delList.addAll(originReimburseAttachMap.keySet());
		
		reimburseDao.update(originReimburse);
		if(saveList.size() > 0) {
			if( "y".equals(originReimburse.getEncrypted()) && hasEncryptionKey ) {
				encryptData(saveList, encryptionKey);
			}
			reimburseAttachDao.insertAll(saveList);
		}
		if(updateList.size() > 0) {
			if( "y".equals(originReimburse.getEncrypted()) && hasEncryptionKey ) {
				decryptData(updateList, encryptionKey); // ??????????????????????????????????????????????????????????????????????????????????????????
				encryptData(updateList, encryptionKey);
			}
			reimburseAttachDao.batchUpdate(updateList);
		}
		if(delList.size() > 0) {
			reimburseAttachDao.deleteByIdList(delList);
		}
		
		return result;
	}

	
	@Override
	public CrudResultDTO deleteAttach(String path, Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		FinReimburse reimburse = reimburseDao.findById(id);
		if (reimburse.getAttachments() != null) {
			try {
				FileUtil.forceDelete(path);
				reimburse.setAttachName("");
				reimburse.setAttachments("");
				reimburseDao.update(reimburse);
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("???????????????");
			} catch (IOException e) {
				e.printStackTrace();
			}
		
		}
		else{
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("??????????????????");
		}
		return result;
	}
	
	
	@Override
	public CrudResultDTO lock(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		try {
			if( json == null ) {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("???????????????????????????");
			} else {
				String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
				
				if( encryptionKey == null ) {
					result.setCode(CrudResultDTO.FAILED);
					result.setResult("??????????????????");
				} else if( !ModuleEncryptUtils.validEncryptionKey(encryptionKey) ) {
					result.setCode(CrudResultDTO.FAILED);
					result.setResult("????????????????????????????????????????????????");
				} else {
					Integer id = json.getInteger("id");
					FinReimburse reimburse = reimburseDao.findById(id);
					
					if( !"y".equals(reimburse.getEncrypted()) ) {
						Set<Integer> idSet = Sets.newHashSet();
						Map<Integer, FinReimburseAttach> reimbursAttachMap = Maps.newHashMap();
						JSONArray reimburseAttachList = json.getJSONArray("reimburseAttachList");
						
						for(int i=0; i < reimburseAttachList.size(); i++) {
							FinReimburseAttach attach = reimburseAttachList.getObject(i, FinReimburseAttach.class);
							if( attach.getReason() != null ) {
								attach.setReason(AesUtils.encryptECB(attach.getReason(), encryptionKey));
							}
							if( attach.getDetail() != null ) {
								attach.setDetail(AesUtils.encryptECB(attach.getDetail(), encryptionKey));
							}
							
							FinReimburseAttach temp = reimbursAttachMap.get(attach.getId());
							if( temp != null ) {
								BeanUtils.copyProperties(attach, temp);
							} else {
								reimbursAttachMap.put(attach.getId(), attach);
							}
							idSet.add(attach.getId());
						}
						
						List<FinReimburseAttach> oldList = reimburseAttachDao.findByIds(idSet);
						for( FinReimburseAttach oldAttach : oldList ) {
							FinReimburseAttach attach = reimbursAttachMap.get(oldAttach.getId());
							BeanUtils.copyProperties(attach, oldAttach);
						}
						
						reimburse.setEncrypted("y");
						reimburseDao.update(reimburse);
						reimburseAttachDao.batchUpdate(oldList);
					} else {
						result.setCode(CrudResultDTO.FAILED);
						result.setResult("?????????????????????????????????????????????");
					}
				}
			}
		} catch(Exception e) {
			logger.error("????????????????????????????????????" + e.getMessage());
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("??????????????????????????????????????????");
			throw new BusinessException(e);
		}
		
		return result;
	}

	/******* ????????????????????? Begin *******/
	@Override
	public void updateEncryptedData(String oldEncryptionKey, String newEncryptionKey) {
		List<FinReimburse> reimburseList = reimburseDao.findByEncrypted("y");
		List<FinReimburseAttach> reimburseAttachList = Lists.newArrayList();
		for(FinReimburse travelreimburse : reimburseList) {
			List<FinReimburseAttach> tempAttachList = travelreimburse.getReimburseAttachList();
			
			List<FinReimburseAttach> tempAttachList2 = Lists.newArrayList();
			
			Map<Integer, FinReimburseAttach> attachMap = Maps.newHashMap();
			for(FinReimburseAttach attach : tempAttachList) {
				FinReimburseAttach temp = new FinReimburseAttach();
				temp.setId(attach.getId());
				temp.setReason(attach.getReason() == null ? "" : attach.getReason());
				temp.setDetail(attach.getDetail() == null ? "" : attach.getDetail());
				
				attachMap.put(attach.getId(), temp);
			}
			
			decryptData(tempAttachList, oldEncryptionKey);
			
			for(FinReimburseAttach attach : tempAttachList) {
				FinReimburseAttach temp = attachMap.get(attach.getId());
				if( !temp.getReason().equals(attach.getReason() == null ? "" : attach.getReason())
						&& !temp.getDetail().equals(attach.getDetail() == null ? "" : attach.getDetail()) ) {
					tempAttachList2.add(attach);
				}
			}
			
			encryptData(tempAttachList2, newEncryptionKey);
			
			reimburseAttachList.addAll(tempAttachList2);
		}
		
		if(reimburseAttachList.size() > 0) {
			reimburseAttachDao.batchUpdate(reimburseAttachList);
		}
	}
	
	@Override
	public <T> void decryptData(List<T> list, String oldEncryptionKey) {
		for( T temp : list ) {
			FinReimburseAttach reimburseAttach = (FinReimburseAttach) temp;
			if( StringUtils.isNotEmpty(reimburseAttach.getReason()) ) {
				String reason = ModuleEncryptUtils.decryptText(reimburseAttach.getReason(), oldEncryptionKey);
				if( StringUtils.isNotEmpty(reason) ) {
					reimburseAttach.setReason(reason);
				}
			}
			
			if( StringUtils.isNotEmpty(reimburseAttach.getDetail()) ) {
				String detail = ModuleEncryptUtils.decryptText(reimburseAttach.getDetail(), oldEncryptionKey);
				if( StringUtils.isNotEmpty(detail) ) {
					reimburseAttach.setDetail(detail);
				}
			}
		}
	}

	@Override
	public <T> void encryptData(List<T> list, String newEncryptionKey) {
		for( T temp : list ) {
			FinReimburseAttach reimburseAttach = (FinReimburseAttach) temp;
			if( StringUtils.isNotEmpty(reimburseAttach.getReason()) ) {
				String reason = ModuleEncryptUtils.encryptText(reimburseAttach.getReason(), newEncryptionKey);
				if( StringUtils.isNotEmpty(reason) ) {
					reimburseAttach.setReason(reason);
				}
			}
			
			if( StringUtils.isNotEmpty(reimburseAttach.getDetail()) ) {
				String detail = ModuleEncryptUtils.encryptText(reimburseAttach.getDetail(), newEncryptionKey);
				if( StringUtils.isNotEmpty(detail) ) {
					reimburseAttach.setDetail(detail);
				}
			}
		}
	}
	/******* ????????????????????? End *******/


	@Override
	public List<FinReimburseAttach> findByProjectId(Integer id) {
		
		return reimburseAttachDao.findByProjectId(id);
	}


	@Override
	public Page<FinReimburseAttach> findPageByProjectId(Map<String, Object> params, Integer pageNum,
			Integer pageSize) {

		PageHelper.startPage(pageNum, pageSize);
		Page<FinReimburseAttach> page = reimburseAttachDao.findPageByProjectId(params);
		return page;
	}


	@Override
	public Page<ReimburseDTO> findAllByProjectId(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize) {
		
		PageHelper.startPage(pageNum, pageSize);
		Page<ReimburseDTO> page = reimburseDao.findAllByProjectId(paramsMap);
		return page;
	}


	@Override
	public CrudResultDTO unbound(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????????????????????????????");
		try {
			List<FinReimburseAttach> attach =  json.toJavaObject(FinReimburse.class).getReimburseAttachList();
			
			reimburseAttachDao.unbound(attach);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new BusinessException(e);
		}
		return result;
	}


	@Override
	public CrudResultDTO initFindAllByProjectId(Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		
		try{
			List<ReimburseDTO> dto = reimburseDao.findAllByProjectId(id);
			
			if(dto.size()>0){
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("????????????????????????????????????");
			}else{
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("?????????????????????");
			}
		}catch(Exception e){
			e.printStackTrace();
			throw new BusinessException(e);
		}
		return result;
	}


	@Override
	public CrudResultDTO remove(Integer id) {
		
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "?????????????????????");
		try {
			FinReimburse finReimburse = reimburseDao.findById(id);
			
			String attachments  = finReimburse.getAttachments();

			List<FinReimburseAttach> attachList = reimburseDao.findById(id).getReimburseAttachList();

			List<Integer> idList = new ArrayList<>();
			
			if(attachList != null && !attachList.equals("") && attachList.size()>0){
				for (int i = 0; i < attachList.size(); i++) {
					Integer id2 = attachList.get(i).getId();
					idList.add(id2);
				}
			}
			
			reimburseAttachDao.deleteByIdList(idList);
			reimburseDao.deleteById(id);
			
			if(attachments != null && !attachments.equals("")){
				FileUtil.forceDelete(finReimburse.getAttachments());
			}

		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "??????????????????????????????");
			e.printStackTrace();
			throw new BusinessException(e);
		}
		return result;
	}


	@Override
	public CrudResultDTO setAssistantAffirm(Integer id, String assistantStatus) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		reimburseDao.setAssistantAffirm(id, assistantStatus);
		return result;
	}
	
	//??????????????????????????????
	@Override
	public void sendMailToApple(Integer id,String contents){
		FinReimburse finReimburse = reimburseDao.findById(id);
		if(finReimburse != null) {
			/*finReimburse.setIsSend(1);
			reimburseDao.update(finReimburse);*/
			sendMail(finReimburse,contents);
		}
	}
	
		/**
		 * ????????????
		 */
		public void sendMail(FinReimburse finReimburse,String contents) {
			StringBuffer contentBuffer=new StringBuffer();
			List<String> recipientsList=new ArrayList<String>();
			String subject = "OA??????????????????";
			String content="";
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			// ????????????
			contentBuffer.append("<br>??????&nbsp;");
			contentBuffer.append(sdf.format(finReimburse.getApplyTime())+"&nbsp;");
			contentBuffer.append("???????????????&nbsp;");
			contentBuffer.append(finReimburse.getOrderNo()+"&nbsp;");
			contentBuffer.append("??????????????????????????????<br>????????????:");
			contentBuffer.append(contents+"<br>");
			/*if(flag==1){   //???????????????
				recipientsList.add("linjn@reyzar.com");
				recipientsList.add("zhangyz@reyzar.com");
				
			}else{//????????????????????????
				List<Integer> userIdListOfPorcess=new ArrayList<Integer>();
				userIdListOfPorcess.add(finReimburse.getUserId());
				recipientsList=iAdRecordDao.findEmailsByUserIdList(userIdListOfPorcess);
				contentBuffer.append("??????:");
				contentBuffer.append(contents+"&nbsp<br>");
			}*/
			List<Integer> userIdListOfPorcess=new ArrayList<Integer>();
			userIdListOfPorcess.add(finReimburse.getUserId());
			recipientsList=iAdRecordDao.findEmailsByUserIdList(userIdListOfPorcess);
			contentBuffer.append("<br>???????????????OA????????????!</br></span>\r\n");
			content=contentBuffer.toString();
			// ???????????????????????????????????????????????????????????????????????????????????????
			Thread thread = new Thread() {
				private List<String> recipientsList;
				private String subject;
				private String content;
				private Message.RecipientType recipientType;
				@Override
				public void run() {
					// ????????????
					MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType); // ??????????????????????????????
				}

				public Thread setParams(List<String> recipientsList, String subject, String content, Message.RecipientType recipientType) {
					this.recipientsList = recipientsList;
					this.subject = subject;
					this.content = content;
					this.recipientType = recipientType;

					return this;
				}
			}.setParams(recipientsList, subject, content, MailUtils.BCC);

			if (!"y".equals(SystemConstant.getValue("devMode"))) {
				thread.start();
			}
			logger.info("["+UserUtils.getCurrUser().getName()+"]" + "????????????????????????????????????ID???" + finReimburse.getId());
			for (String email:recipientsList) {
				logger.info("???????????? ???"+email+"??????????????????????????????");
			}
		}


		@Override
		public List<ReimburseDTO> findAllByProjectIdAndStatus(Integer id) {
			return reimburseDao.findAllByProjectIdAndStatus(id);
		}

		@Override
		public FinTravelreimburse findByExpenditure(Integer projectId) {
			return travelreimburseDao.findByExpenditure(projectId);
		}

		@Override
		public FinTravelreimburse findByClearanceBeen(Integer projectId) {
			return travelreimburseDao.findByClearanceBeen(projectId);
		}
		
		@Override
		public FinTravelreimburse findByClearanceBeenTo(Integer projectId,Integer reimbursid,Integer travelreimburseid) {
			return travelreimburseDao.findByClearanceBeenTo(projectId,reimbursid,travelreimburseid);
		}

		@Override
		public Double findByIdAndUser(Integer id, Integer userId,String startDate,String endDate) {
			return reimburseDao.findByIdAndUser(id,userId,startDate,endDate);
		}
}
 