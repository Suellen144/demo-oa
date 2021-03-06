package com.reyzar.oa.service.finance.impl; 

import java.io.IOException;
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
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.IFinTravelReimbursHistoryDao;
import com.reyzar.oa.dao.IFinTravelreimburseAttachDao;
import com.reyzar.oa.dao.IFinTravelreimburseDao;
import com.reyzar.oa.domain.FinReimburseAttach;
import com.reyzar.oa.domain.FinTravelReimbursHistory;
import com.reyzar.oa.domain.FinTravelreimburse;
import com.reyzar.oa.domain.FinTravelreimburseAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.finance.IFinTravelReimbursService;
import com.reyzar.oa.service.sys.IEncryptService;
import com.reyzar.oa.service.sys.ISysDeptService;
import com.reyzar.oa.service.sys.ISysUserService;

/**
 * 
 * @Description: 
 * @author Lairongfa
 * @date 2016???9???22??? ??????2:56:12 
 *
 */
@Service
@Transactional
public class FinTravelReimbursServiceImpl implements IFinTravelReimbursService, IEncryptService {
	
	private final static Logger logger = Logger.getLogger(FinTravelReimbursServiceImpl.class);

	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IFinTravelreimburseDao travelreimburseDao;
	@Autowired
	private IFinTravelreimburseAttachDao travelreimburseAttachDao; 
	@Autowired
	private IFinTravelReimbursHistoryDao travelReimbursHistoryDao;
	@Autowired
	private ISysUserService userService;
	@Autowired
	private IAdRecordDao iAdRecordDao;
	@Autowired
	private ISysDeptService deptService;
	
	@Override
	public Page<FinTravelreimburse> findByPage(Map<String, Object> params,int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.TRAVEL_REIMBURSE);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
	
		PageHelper.startPage(pageNum, pageSize);
		Page<FinTravelreimburse> page = travelreimburseDao.findByPage(params);
		return page;
	}
	
	@Override
	public FinTravelreimburse findById(Integer id) {
		 FinTravelreimburse finTravelreimburse = travelreimburseDao.findById(id);
		 SimpleDateFormat formatter = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss");
		 String  createDate = formatter.format(finTravelreimburse.getCreateDate());
		 finTravelreimburse.setCreateDateStr(createDate);
		 SysUser user = UserUtils.getCurrUser();
			if((user.getDeptId() == 3 || user.getDept().getParentId() == 3) && user.getDeptId() != 46 ) {
				finTravelreimburse.setIsOk("true");
			}else {
				finTravelreimburse.setIsOk("false");
			}
		 return finTravelreimburse;
	}
	
	/*??????????????????*/
	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SysUser user = UserUtils.getCurrUser();
		Date currDate = new Date();
		String orderNo = "";
			
		String maxOrderNo = travelreimburseDao.getMaxOrderNo();
		String orderNoBase = new SimpleDateFormat("yyyyMM").format(currDate); 
			
		// ?????????????????????????????????????????????????????????????????????
		if(maxOrderNo == null || "".equals(maxOrderNo) || maxOrderNo.indexOf(orderNoBase) <= -1) {
			orderNo = orderNoBase + "0001";
		} else {
			orderNo = (Long.valueOf(maxOrderNo) + 1) + "";
		}
		json.put("actReimburse", 0);
		FinTravelreimburse travelReimburse = json.toJavaObject(FinTravelreimburse.class);
		travelReimburse.setUserId(user.getId());
		travelReimburse.setOrderNo(orderNo);
		travelReimburse.setApplyTime(currDate);
		travelReimburse.setCreateBy(user.getAccount());
		travelReimburse.setCreateDate(currDate); 
		travelReimburse.setKind(1);
		travelReimburse.setStatus(null);
		travelreimburseDao.save(travelReimburse);
			
		for(FinTravelreimburseAttach travelreimburseAttach : travelReimburse.getTravelreimburseAttachList()) {
			travelreimburseAttach.setTravelreimburseId(travelReimburse.getId());
			travelreimburseAttach.setCreateBy(user.getAccount());
			travelreimburseAttach.setCreateDate(currDate);
				
			if(travelreimburseAttach.getActReimburse() == null) {
				travelreimburseAttach.setActReimburse(travelreimburseAttach.getCost());
			}
		}
		travelreimburseAttachDao.insertAll(travelReimburse.getTravelreimburseAttachList());
		return result;		
	}
	
	@Override
	public CrudResultDTO submitinfo(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		ProcessInstance processInstance = null;
		SysUser user = UserUtils.getCurrUser();
		SysDept sysDept=deptService.findById(user.getDept().getId());
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
			json.put("actReimburse", 0);
			FinTravelreimburse travelReimburse = json.toJavaObject(FinTravelreimburse.class);
			String old = travelReimburse.getOrderNo();
			if (travelReimburse.getId() != null) {
				travelreimburseDao.deleteById(travelReimburse.getId());
				travelreimburseAttachDao.deleteBytravelreimburseId(travelReimburse.getId());
			}
			travelReimburse.setUserId(user.getId());
			if (old == null) {
				travelReimburse.setOrderNo(orderNo);
			}
			else {
				String temp = old.substring(0, old.length()-4);
				String date = new SimpleDateFormat("yyyyMM").format(new Date()); 
				if (temp.equals(date)) {
					travelReimburse.setOrderNo(old);
				}
				else {
					travelReimburse.setOrderNo(orderNo);
				}
				
			}
			travelReimburse.setKind(1);
			travelReimburse.setIsSend(0);
			travelReimburse.setInitMoney(travelReimburse.getTotal());
			travelReimburse.setApplyTime(currDate);
			travelReimburse.setCreateBy(user.getAccount());
			travelReimburse.setCreateDate(currDate);
			travelreimburseDao.save(travelReimburse);
			
			for(FinTravelreimburseAttach travelreimburseAttach : travelReimburse.getTravelreimburseAttachList()) {
				travelreimburseAttach.setTravelreimburseId(travelReimburse.getId());
				travelreimburseAttach.setCreateBy(user.getAccount());
				travelreimburseAttach.setCreateDate(currDate);
				
				if(travelreimburseAttach.getActReimburse() == null) {
					travelreimburseAttach.setActReimburse(travelreimburseAttach.getCost());
				}
			}
			travelreimburseAttachDao.insertAll(travelReimburse.getTravelreimburseAttachList());
			
			// ????????????????????????
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
			businessParams.put("class", this.getClass().getName()); // ?????????????????????
			businessParams.put("method", "findById"); // ????????????
			businessParams.put("paramValue", new Object[] { travelReimburse.getId() }); // ????????????????????????
		
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
			variables.put("isOk", (user.getDeptId() == 3 || sysDept.getParentId() == 3) && user.getDeptId() != 46 ? true : false); // ???????????????
			processInstance = activitiUtils.startProcessInstance(
					ActivitiUtils.TRAVEL_REIMBURSE_KEY, user.getId().toString(), travelReimburse.getId().toString(), variables);			
			
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
			travelReimburse.setProcessInstanceId(processInstance.getId());
			travelReimburse.setStatus(status);
			travelreimburseDao.update(travelReimburse);
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
		FinTravelreimburse travelReimburse = travelreimburseDao.findById(id);
		if(travelReimburse != null) {
			//?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
			if(status.equals("8") || status.equals("9") || status.equals("10") || status.equals("12")){
				travelReimburse.setAssistantStatus("");
			}
			travelReimburse.setStatus(status);
			travelreimburseDao.update(travelReimburse);
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult("????????????!");
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("??????id??????" + id + " ????????????");
		}
		return result;
	}
	
	@Override
	public CrudResultDTO deleteAttach(String path, Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		FinTravelreimburse travelReimburse = travelreimburseDao.findById(id);
		if (travelReimburse.getAttachments() != null) {
			try {
				FileUtil.forceDelete(path);
				travelReimburse.setAttachName("");
				travelReimburse.setAttachments("");
				travelreimburseDao.update(travelReimburse);
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
	public void saveBankInfo(Integer userId, String payee, String bankAccount, String bankAddress) {
		SysUser user = UserUtils.getCurrUser();
		if(userId == null) {
			userId = user.getId();
		} else {
			user = userService.findById(userId);
		}
		String account = user.getAccount();
		
		if(payee != null && !"".equals(payee.trim())) {
			saveBankInfoToDb(userId, account, "0", payee.trim());
		}
		if(bankAddress != null && !"".equals(bankAddress.trim())) {
			saveBankInfoToDb(userId, account, "1", bankAddress.trim());
		}
		if(bankAccount != null && !"".equals(bankAccount.trim())) {
			saveBankInfoToDb(userId, account, "2", bankAccount.trim());
		}		
	}
	
	private void saveBankInfoToDb(Integer userId, String account, String type, String value) {
		Map<String, Object> paramsMap = Maps.newHashMap();
		paramsMap.put("userId", userId);
		paramsMap.put("type", type);
		paramsMap.put("value", value);
		
		List<FinTravelReimbursHistory> tempList = travelReimbursHistoryDao.findByCondition(paramsMap);
		if(tempList == null || tempList.size() <= 0) {
			FinTravelReimbursHistory travelReimbursHistory = new FinTravelReimbursHistory();
			travelReimbursHistory.setUserId(userId);
			travelReimbursHistory.setType(type);
			travelReimbursHistory.setValue(value);
			travelReimbursHistory.setCreateBy(account);
			travelReimbursHistory.setCreateDate(new Date());
			travelReimbursHistory.setUpdateDate(new Date());
			travelReimbursHistory.setUpdateBy(account);
			travelReimbursHistoryDao.save(travelReimbursHistory);
		}
		else {
			FinTravelReimbursHistory travelReimbursHistory = travelReimbursHistoryDao.findById(tempList.get(0).getId());
			travelReimbursHistory.setUpdateBy(account);
			travelReimbursHistory.setUpdateDate(new Date());
			travelReimbursHistory.setCreateDate(new Date());
			travelReimbursHistoryDao.update(travelReimbursHistory);
		}
	}

	@Override
	public List<FinTravelReimbursHistory> getBankInfoByUserId(Integer userId) {
		return travelReimbursHistoryDao.findByUserId(userId);
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SysUser user = UserUtils.getCurrUser();
		Date currDate = new Date();
		String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
		if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("?????????????????????????????????????????????");
		}
		boolean hasEncryptionKey = encryptionKey != null && ModuleEncryptUtils.validEncryptionKey(encryptionKey) ? true : false;
		
		json.put("actReimburse", 0);
		FinTravelreimburse travelReimburse = json.toJavaObject(FinTravelreimburse.class);
		FinTravelreimburse originTravelReimburse = travelreimburseDao.findById(travelReimburse.getId());
		if (originTravelReimburse.getStatus() != null &&(originTravelReimburse.getStatus()!=null &&(originTravelReimburse.getStatus().equals("8") || originTravelReimburse.getStatus().equals("9") || originTravelReimburse.getStatus().equals("10") || originTravelReimburse.getStatus().equals("12")))) {
		//	travelReimburse.setApplyTime(new Date());
		}
		travelReimburse.setUpdateBy(user.getAccount());
		travelReimburse.setUpdateDate(currDate);
		BeanUtils.copyProperties(travelReimburse, originTravelReimburse);
		List<FinTravelreimburseAttach> originTravelreimburseAttachList = travelreimburseAttachDao.findByTravelreimburseId(travelReimburse.getId());
		List<FinTravelreimburseAttach> reimburseAttachList = travelReimburse.getTravelreimburseAttachList();
		
		List<FinTravelreimburseAttach> saveList = Lists.newArrayList();
		List<FinTravelreimburseAttach> updateList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, FinTravelreimburseAttach> originTravelReimburseAttachMap = Maps.newHashMap();
		for(FinTravelreimburseAttach travelreimburseAttach : originTravelreimburseAttachList) {
			originTravelReimburseAttachMap.put(travelreimburseAttach.getId(), travelreimburseAttach);
		}
		
		for(FinTravelreimburseAttach travelreimburseAttach : reimburseAttachList) {
			if(travelreimburseAttach.getId() != null) {
				travelreimburseAttach.setUpdateBy(user.getAccount());
				travelreimburseAttach.setUpdateDate(currDate);
				
				if(travelreimburseAttach.getActReimburse() == null) {
					travelreimburseAttach.setActReimburse(travelreimburseAttach.getCost());
				}
				
				FinTravelreimburseAttach origin = originTravelReimburseAttachMap.get(travelreimburseAttach.getId());
				if(origin != null) {
					// ?????????????????????????????????????????????????????????????????????????????????
					if( "y".equals(originTravelReimburse.getEncrypted()) && !hasEncryptionKey ) {
						travelreimburseAttach.setReason(origin.getReason());
						travelreimburseAttach.setDetail(origin.getDetail());
					}
					BeanUtils.copyProperties(travelreimburseAttach, origin);
					if(travelreimburseAttach.getAttachInvestId() ==null ) {
						origin.setAttachInvestId(null);
					}
					if(travelreimburseAttach.getAttachInvestIdStr() ==null || "".equals(travelreimburseAttach.getAttachInvestIdStr())) {
						origin.setAttachInvestIdStr(null);
					}
					updateList.add(origin);
					originTravelReimburseAttachMap.remove(origin.getId());
				}
			} else {
				travelreimburseAttach.setTravelreimburseId(travelReimburse.getId());
				travelreimburseAttach.setCreateBy(user.getAccount());
				travelreimburseAttach.setCreateDate(currDate);
				saveList.add(travelreimburseAttach);
			}
		}
		delList.addAll(originTravelReimburseAttachMap.keySet());
		
		travelreimburseDao.update(originTravelReimburse);
		if(saveList.size() > 0) {
			if( "y".equals(originTravelReimburse.getEncrypted()) && hasEncryptionKey ) {
				encryptData(saveList, encryptionKey);
			}
			travelreimburseAttachDao.insertAll(saveList);
		}
		if(updateList.size() > 0) {
			if( "y".equals(originTravelReimburse.getEncrypted()) && hasEncryptionKey ) {
				decryptData(updateList, encryptionKey); // ??????????????????????????????????????????????????????????????????????????????????????????
				encryptData(updateList, encryptionKey);
			}
			travelreimburseAttachDao.batchUpdate(updateList);
		}
		if(delList.size() > 0) {
			travelreimburseAttachDao.deleteByIdList(delList);
		}		
		return result;
	}

	@Override
	public List<FinTravelReimbursHistory> getMainBankInfo(Integer userId,Integer type) {
		return travelReimbursHistoryDao.findByUserIdAndType(userId, type);
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
					FinTravelreimburse travelReimburse = travelreimburseDao.findById(id);
					
					if( !"y".equals(travelReimburse.getEncrypted()) ) {
						Set<Integer> idSet = Sets.newHashSet();
						Map<Integer, FinTravelreimburseAttach> travelreimbursAttachMap = Maps.newHashMap();
						JSONArray travelreimburseAttachList = json.getJSONArray("travelreimburseAttachList");
						
						for(int i=0; i < travelreimburseAttachList.size(); i++) {
							FinTravelreimburseAttach attach = travelreimburseAttachList.getObject(i, FinTravelreimburseAttach.class);
							if( attach.getReason() != null ) {
								attach.setReason(AesUtils.encryptECB(attach.getReason(), encryptionKey));
							}
							if( attach.getDetail() != null ) {
								attach.setDetail(AesUtils.encryptECB(attach.getDetail(), encryptionKey));
							}
							
							FinTravelreimburseAttach temp = travelreimbursAttachMap.get(attach.getId());
							if( temp != null ) {
								BeanUtils.copyProperties(attach, temp);
							} else {
								travelreimbursAttachMap.put(attach.getId(), attach);
							}
							idSet.add(attach.getId());
						}
						
						List<FinTravelreimburseAttach> oldList = travelreimburseAttachDao.findByIds(idSet);
						for( FinTravelreimburseAttach oldAttach : oldList ) {
							FinTravelreimburseAttach attach = travelreimbursAttachMap.get(oldAttach.getId());
							BeanUtils.copyProperties(attach, oldAttach);
						}
						
						travelReimburse.setEncrypted("y");
						travelreimburseDao.update(travelReimburse);
						travelreimburseAttachDao.batchUpdate(oldList);
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
		List<FinTravelreimburse> travelreimburseList = travelreimburseDao.findByEncrypted("y");
		List<FinTravelreimburseAttach> travelreimburseAttachList = Lists.newArrayList();
		for(FinTravelreimburse travelreimburse : travelreimburseList) {
			List<FinTravelreimburseAttach> tempAttachList = travelreimburse.getTravelreimburseAttachList();
			List<FinTravelreimburseAttach> tempAttachList2 = Lists.newArrayList();
			
			Map<Integer, FinTravelreimburseAttach> attachMap = Maps.newHashMap();
			for(FinTravelreimburseAttach attach : tempAttachList) {
				FinTravelreimburseAttach temp = new FinTravelreimburseAttach();
				temp.setId(attach.getId());
				temp.setReason(attach.getReason() == null ? "" : attach.getReason());
				temp.setDetail(attach.getDetail() == null ? "" : attach.getDetail());
				
				attachMap.put(attach.getId(), temp);
			}
			
			decryptData(tempAttachList, oldEncryptionKey);
			
			for(FinTravelreimburseAttach attach : tempAttachList) {
				FinTravelreimburseAttach temp = attachMap.get(attach.getId());
				if( !temp.getReason().equals(attach.getReason() == null ? "" : attach.getReason())
						&& !temp.getDetail().equals(attach.getDetail() == null ? "" : attach.getDetail()) ) {
					tempAttachList2.add(attach);
				}
			}
			
			encryptData(tempAttachList2, newEncryptionKey);
			
			travelreimburseAttachList.addAll(tempAttachList2);
		}
		
		if(travelreimburseAttachList.size() > 0) {
			travelreimburseAttachDao.batchUpdate(travelreimburseAttachList);
		}
	}
	
	@Override
	public <T> void decryptData(List<T> list, String oldEncryptionKey) {
		for( T temp : list ) {
			FinTravelreimburseAttach travelreimburseAttach = (FinTravelreimburseAttach) temp;
			if( StringUtils.isNotEmpty(travelreimburseAttach.getReason()) ) {
				String reason = ModuleEncryptUtils.decryptText(travelreimburseAttach.getReason(), oldEncryptionKey);
				if( StringUtils.isNotEmpty(reason) ) {
					travelreimburseAttach.setReason(reason);
				}
			}
			
			if( StringUtils.isNotEmpty(travelreimburseAttach.getDetail()) ) {
				String detail = ModuleEncryptUtils.decryptText(travelreimburseAttach.getDetail(), oldEncryptionKey);
				if( StringUtils.isNotEmpty(detail) ) {
					travelreimburseAttach.setDetail(detail);
				}
			}
		}
	}

	@Override
	public <T> void encryptData(List<T> list, String newEncryptionKey) {
		for( T temp : list ) {
			FinTravelreimburseAttach travelreimburseAttach = (FinTravelreimburseAttach) temp;
			if( StringUtils.isNotEmpty(travelreimburseAttach.getReason()) ) {
				String reason = ModuleEncryptUtils.encryptText(travelreimburseAttach.getReason(), newEncryptionKey);
				if( StringUtils.isNotEmpty(reason) ) {
					travelreimburseAttach.setReason(reason);
				}
			}
			
			if( StringUtils.isNotEmpty(travelreimburseAttach.getDetail()) ) {
				String detail = ModuleEncryptUtils.encryptText(travelreimburseAttach.getDetail(), newEncryptionKey);
				if( StringUtils.isNotEmpty(detail) ) {
					travelreimburseAttach.setDetail(detail);
				}
			}
		}
	}
	/******* ????????????????????? End *******/

	@Override
	public List<FinTravelreimburseAttach> findByProjectId(Integer id) {
		
		return travelreimburseAttachDao.findByProjectId(id);
	}

	@Override
	public Page<FinReimburseAttach> findPageByProjectId(Map<String, Object> paramsMap, Integer pageNum,
			Integer pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		Page<FinReimburseAttach> page = travelreimburseAttachDao.findPageByProjectId(paramsMap);
		return page;
	}

	@Override
	public CrudResultDTO unbound(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????????????????????????????");
		try {
			json.put("actReimburse", 0);
			FinTravelreimburse finTravelreimburse =  json.toJavaObject(FinTravelreimburse.class);
			 List<FinTravelreimburseAttach> attach= finTravelreimburse.getTravelreimburseAttachList();
			travelreimburseAttachDao.unbound(attach);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("????????????????????????????????????????????????????????????");
			throw new BusinessException(e);
		}
		return result;
	}

	@Override
	public CrudResultDTO remove(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "????????????????????????");
		try {
			FinTravelreimburse travelReimburse = travelreimburseDao.findById(id);
			String attachments = travelReimburse.getAttachments();
			
			List<FinTravelreimburseAttach>  finTravelreimburseList = travelReimburse.getTravelreimburseAttachList();
			List<Integer> idList = new ArrayList<>();
			
			if(finTravelreimburseList != null && !finTravelreimburseList.equals("") && finTravelreimburseList.size()>0){
				for (FinTravelreimburseAttach finTravelreimburseAttach : finTravelreimburseList) {
					idList.add(finTravelreimburseAttach.getId());
				}				
			}
			travelreimburseAttachDao.deleteByIdList(idList);
			travelreimburseDao.deleteById(id);
			
			if (attachments != null && !attachments.equals("")) {
				FileUtil.forceDelete(attachments);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("????????????????????????");
			throw new BusinessException(e);
		}
		return result;
	}

	@Override
	public CrudResultDTO setAssistantAffirm(Integer id, String assistantStatus) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		travelreimburseDao.setAssistantAffirm(id,assistantStatus);
		return result;
	}
		
	//??????????????????????????????
	@Override
	public void sendMailToApple(Integer id,String contents){
		FinTravelreimburse travelReimburse = travelreimburseDao.findById(id);
		if(travelReimburse != null) {
			/*travelReimburse.setIsSend(1);
			travelreimburseDao.update(travelReimburse);*/
			sendMail(travelReimburse,contents);
		}
	}
	
	/**
	* ????????????
	*/
	public void sendMail(FinTravelreimburse finTravelreimburse,String contents) {
		StringBuffer contentBuffer=new StringBuffer();
		List<String> recipientsList=new ArrayList<String>();
		String subject = "OA??????????????????";
		String content="";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// ????????????
		contentBuffer.append("<br>??????&nbsp;");
		contentBuffer.append(sdf.format(finTravelreimburse.getApplyTime())+"&nbsp;");
		contentBuffer.append("???????????????&nbsp;");
		contentBuffer.append(finTravelreimburse.getOrderNo()+"&nbsp;");
		contentBuffer.append("??????????????????????????????<br>????????????:");
		contentBuffer.append(contents+"<br>");
		List<Integer> userIdListOfPorcess=new ArrayList<Integer>();
		userIdListOfPorcess.add(finTravelreimburse.getUserId());
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
		logger.info("["+UserUtils.getCurrUser().getName()+"]" + "????????????????????????????????????ID???" + finTravelreimburse.getId());
		for (String email:recipientsList) {
			logger.info("???????????? ???"+email+"??????????????????????????????");
		}
	}

	@Override
	public Double findByIdAndUser(Integer id, Integer userId,String startDate,String endDate) {
		return travelreimburseDao.findByIdAndUser(id,userId,startDate,endDate);
	}
	
}
 