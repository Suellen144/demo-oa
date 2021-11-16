package com.reyzar.oa.service.ad.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletOutputStream;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.RecordExcelDTO;
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdArbeitsvertragDao;
import com.reyzar.oa.dao.IAdCertificateDao;
import com.reyzar.oa.dao.IAdEducationDao;
import com.reyzar.oa.dao.IAdJobRecordDao;
import com.reyzar.oa.dao.IAdPostAppointmentDao;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.IAdRecordDeptHistoryDao;
import com.reyzar.oa.dao.IAdRecordPositionHistoryDao;
import com.reyzar.oa.dao.IAdRecordSalaryHistoryDao;
import com.reyzar.oa.domain.AdArbeitsvertrag;
import com.reyzar.oa.domain.AdCertificate;
import com.reyzar.oa.domain.AdEducation;
import com.reyzar.oa.domain.AdJobRecord;
import com.reyzar.oa.domain.AdPostAppointment;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.AdRecordDeptHistory;
import com.reyzar.oa.domain.AdRecordPositionHistory;
import com.reyzar.oa.domain.AdRecordSalaryHistory;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.sys.IEncryptService;

@Service
@Transactional
public class AdRecordServiceImpl implements IAdRecordService,IEncryptService{
	
	private final Logger logger = Logger.getLogger(AdRecordServiceImpl.class);
	
	@Autowired
	private IAdRecordDao recordDao;
	
	@Autowired
	private IAdArbeitsvertragDao arbeitsvertragDao;
	
	@Autowired
	private IAdCertificateDao certificateDao;
	
	@Autowired
	private IAdEducationDao educationDao;
	
	@Autowired
	private IAdJobRecordDao jobRecordDao;
	
	@Autowired
	private IAdPostAppointmentDao postAppointmentDao;

	@Autowired
	private IAdRecordDeptHistoryDao deptHistoryDao;
	
	@Autowired
	private IAdRecordPositionHistoryDao positionHistoryDao; 
	
	@Autowired
	private IAdRecordSalaryHistoryDao salaryHistoryDao;

	@Override
	public Integer findByEmail2(String email) {
		return recordDao.findByEmail2(email);
	}

	@Override
	public AdRecord findByEmail(String email) {
		return  recordDao.findByEmail(email);
	}
	
	@Override
	public Page<AdRecord> findByPage(Map<String, Object> params, int pageNum,int pageSize,SysUser user) {
			String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.RECORD);
			Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
			deptIdSet.add(31);
			params.put("userId", user.getId());
			params.put("deptIdSet", deptIdSet);
			PageHelper.startPage(pageNum, pageSize);
			return  recordDao.findByPage(params);
	}

	@Override
	public AdRecord findById(int id) {
		AdRecord adRecord = recordDao.findById(id);
		adRecord.setArbeitsvertrags(arbeitsvertragDao.findByRecordId(id));
		adRecord.setCertificates(certificateDao.findByRecordId(id));
		adRecord.setEducations(educationDao.findByRecordId(id));
		adRecord.setJobRecords(jobRecordDao.findByRecordId(id));
		adRecord.setPostAppointments(postAppointmentDao.findByRecordId(id));
		return adRecord;
	}
	
	@Override
	public AdRecord findByUserid(Integer userId) {
		AdRecord adRecord=recordDao.findByUserid(userId);
		if(adRecord !=null) {
			adRecord.setArbeitsvertrags(arbeitsvertragDao.findByRecordId(adRecord.getId()));
			adRecord.setCertificates(certificateDao.findByRecordId(adRecord.getId()));
			adRecord.setEducations(educationDao.findByRecordId(adRecord.getId()));
			adRecord.setJobRecords(jobRecordDao.findByRecordId(adRecord.getId()));
			adRecord.setPostAppointments(postAppointmentDao.findByRecordId(adRecord.getId()));
		}
		return adRecord;
	}

	@Override
	public CrudResultDTO save(AdRecord record, SysUser user) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		/*
		 * noticeFlag = add: 需要添加一条提醒消息 
		 * 				modify: 更改提醒消息 
		 */
		String noticeFlag = "";
		try {
			if(record.getId()==null){	
				if(record.getBecomeDate() != null) {
					record.getBecomeDate().setHours(23);
				}
				if(record.getBirthday() != null) {
					record.getBirthday().setHours(12);
				}
				record.setCreateBy(user.getAccount());
				record.setCreateDate(new Date());
				
				recordDao.save(record);
				
				List<AdArbeitsvertrag> adArbeitsvertrags=record.getArbeitsvertrags();
				if(adArbeitsvertrags.size()>0){
				for (AdArbeitsvertrag adArbeitsvertrag : adArbeitsvertrags) {
					adArbeitsvertrag.setRecordId(record.getId());
					adArbeitsvertrag.setCreateDate(new Date());
					adArbeitsvertrag.setCreateBy(user.getName());
					}
				arbeitsvertragDao.insertAll(adArbeitsvertrags);
				}
				
				List<AdCertificate> adCertificates=record.getCertificates();
				if(adCertificates.size()>0){
					for (AdCertificate adCertificate : adCertificates) {
						adCertificate.setRecordId(record.getId());
						adCertificate.setCreateDate(new Date());
						adCertificate.setCreateBy(user.getName());
					}	
					certificateDao.insertAll(adCertificates);
				}
				
				List<AdEducation> educations=record.getEducations();
				if(educations.size()>0){
				for (AdEducation adEducation : educations) {
					adEducation.setRecordId(record.getId());
					adEducation.setCreateDate(new Date());
					adEducation.setCreateBy(user.getName());
					}
				educationDao.insertAll(educations);
				}
				List<AdJobRecord> jobRecords=record.getJobRecords();
				if(jobRecords.size()>0){
				for (AdJobRecord jobRecord : jobRecords) {
					jobRecord.setRecordId(record.getId());
					jobRecord.setCreateDate(new Date());
					jobRecord.setCreateBy(user.getName());
					}
				jobRecordDao.insertAll(jobRecords);
				}
				
				List<AdPostAppointment> postAppointments=record.getPostAppointments();
				if(postAppointments.size()>0){
				for (AdPostAppointment postAppointment : postAppointments) {
					postAppointment.setRecordId(record.getId());
					postAppointment.setCreateDate(new Date());
					postAppointment.setCreateBy(user.getName());
					}
				postAppointmentDao.insertAll(postAppointments);
				}
				
				
				saveDeptHistory(record);
				savePositionHistory(record);
				
				//初始化薪酬历史表
				AdRecordSalaryHistory salaryHistory = new AdRecordSalaryHistory();
				salaryHistory.setUserId(user.getId());
				salaryHistory.setCreateBy(user.getAccount());
				salaryHistory.setCreateDate(new Date());
				salaryHistory.setStartTime(new Date());
				salaryHistoryDao.save(salaryHistory);
				
				noticeFlag = "add";
			}else{
				AdRecord old = recordDao.findById(record.getId());
				if(record.getSalary() != null && record.getSalary() != "" && !old.getSalary().equals(record.getSalary())){
					String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
					if( encryptionKey == null ) {
						result.setCode(2);
						result.setResult("更改薪酬，请导入密钥！");
					}else if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
						result.setCode(3);
						result.setResult("密钥已更改，请重新导入新密钥！");
					}else {
						record.setSalary(AesUtils.encryptECB(record.getSalary(), encryptionKey));
						record.setUpdateBy(user.getAccount());
						record.setUpdateDate(user.getUpdateDate());
						if(record.getBirthday() != null) {
							record.getBirthday().setHours(12);
						}
						
						if( record.getBecomeDate() != old.getBecomeDate() 
								|| record.getBeforeWarnDay() != old.getBeforeWarnDay() ) {
							noticeFlag = "modify";
						}
						/*saveSalaryHistory(record);*/
						BeanUtils.copyProperties(record, old);
						old.setIsencryption("y");
						recordDao.update(old);
					}
			
				}else{
					record.setUpdateBy(user.getAccount());
					record.setUpdateDate(user.getUpdateDate());
					if(record.getBirthday() != null) {
						record.getBirthday().setHours(12);
					}
					
					if( record.getBecomeDate() != old.getBecomeDate() 
							|| record.getBeforeWarnDay() != old.getBeforeWarnDay() ) {
						noticeFlag = "modify";
					}
					
					/*saveSalaryHistory(record);*/
					BeanUtils.copyProperties(record, old);
					recordDao.update(old);
				}
				//更新劳动合同
				updateArbeitsvertrag(record);
				//更新证书荣誉
				updateCertificate(record);
				//更新教育背景
				updateEducation(record);
				//更新以往工作经历
				updateJobRecord(record);
				//更新岗位任免记录
				updatePostAppointment(record);	
			}
			//更新部门职位历史表
			saveDeptHistory(record);
			savePositionHistory(record);
			
			if(record.getBecomeDate() == null 
					&& record.getBeforeWarnDay() == null) {
				noticeFlag = "";
			}
			// 设置转正消息提醒
			if(!"".equals(noticeFlag)) {
//				MessageSystemUtils.saveOrUpdate(buildMessageNoticeEntity(noticeFlag, record));
			}
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			logger.error(e);
		}
		return result;
	}

	private void updatePostAppointment(AdRecord record) {
		if(record.getPostAppointments().size()>0){
			List<AdPostAppointment> old=postAppointmentDao.findByRecordId(record.getId());
			List<AdPostAppointment> postAppointments=record.getPostAppointments();
			List<AdPostAppointment> saveList = Lists.newArrayList();
			List<AdPostAppointment> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, AdPostAppointment> orginAdPostAppointmentMap = Maps.newHashMap();
			
			for (AdPostAppointment postAppointment : old) {
				orginAdPostAppointmentMap.put(postAppointment.getId(), postAppointment);
			}
			for(AdPostAppointment postAppointment :postAppointments){
				AdPostAppointment adPostAppointment=orginAdPostAppointmentMap.get(postAppointment.getId());
				if(adPostAppointment!=null){
					BeanUtils.copyProperties(postAppointment, adPostAppointment);
					updateList.add(adPostAppointment);
					orginAdPostAppointmentMap.remove(adPostAppointment.getId());
				}else{
					postAppointment.setRecordId(record.getId());
					postAppointment.setCreateBy(record.getUpdateBy());
					postAppointment.setCreateDate(new Date());
					postAppointment.setUpdateBy(record.getUpdateBy());
					postAppointment.setUpdateDate(new Date());
					saveList.add(postAppointment);
				}
			}
			delList.addAll(orginAdPostAppointmentMap.keySet());

			if (saveList.size() > 0) {
				postAppointmentDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				postAppointmentDao.batchUpdate(updateList);
			}
			if (delList.size() > 0) {
				postAppointmentDao.deleteByIdList(delList);
			}
			
		}else{
			List<AdPostAppointment> old=postAppointmentDao.findByRecordId(record.getId());
			List<Integer> delList=Lists.newArrayList();
			if(old.size()>0){
				for (AdPostAppointment adPostAppointment : old) {
					delList.add(adPostAppointment.getId());
				}
				postAppointmentDao.deleteByIdList(delList);
			}
		}
	}

	private void updateJobRecord(AdRecord record) {
		if(record.getJobRecords().size()>0){
			List<AdJobRecord> old=jobRecordDao.findByRecordId(record.getId());
			List<AdJobRecord> jobRecords=record.getJobRecords();
			List<AdJobRecord> saveList = Lists.newArrayList();
			List<AdJobRecord> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, AdJobRecord> orginAdJobRecordMap = Maps.newHashMap();
			
			for (AdJobRecord jobRecord: old) {
				orginAdJobRecordMap.put(jobRecord.getId(), jobRecord);
			}
			for(AdJobRecord jobRecord :jobRecords){
				AdJobRecord adJobRecord=orginAdJobRecordMap.get(jobRecord.getId());
				if(adJobRecord!=null){
					BeanUtils.copyProperties(jobRecord, adJobRecord);
					updateList.add(adJobRecord);
					orginAdJobRecordMap.remove(adJobRecord.getId());
				}else{
					jobRecord.setRecordId(record.getId());
					jobRecord.setCreateBy(record.getUpdateBy());
					jobRecord.setCreateDate(new Date());
					jobRecord.setUpdateBy(record.getUpdateBy());
					jobRecord.setUpdateDate(new Date());
					saveList.add(jobRecord);
				}
			}
			delList.addAll(orginAdJobRecordMap.keySet());

			if (saveList.size() > 0) {
				jobRecordDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				jobRecordDao.batchUpdate(updateList);
			}
			if (delList.size() > 0) {
				jobRecordDao.deleteByIdList(delList);
			}
		}else{
			List<AdJobRecord> old=jobRecordDao.findByRecordId(record.getId());
			List<Integer> delList=Lists.newArrayList();
			if(old.size()>0){
				for (AdJobRecord adJobRecord : old) {
					delList.add(adJobRecord.getId());
				}
				jobRecordDao.deleteByIdList(delList);
			}
		}
		
	}

	private void updateEducation(AdRecord record) {
		if(record.getEducations().size()>0){
			List<AdEducation> old=educationDao.findByRecordId(record.getId());
			List<AdEducation> educations=record.getEducations();
			List<AdEducation> saveList = Lists.newArrayList();
			List<AdEducation> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, AdEducation> orginAdEducationMap = Maps.newHashMap();
			
			for (AdEducation education: old) {
				orginAdEducationMap.put(education.getId(), education);
			}
			for(AdEducation education :educations){
				AdEducation adEducation=orginAdEducationMap.get(education.getId());
				if(adEducation!=null){
					BeanUtils.copyProperties(education, adEducation);
					updateList.add(adEducation);
					orginAdEducationMap.remove(adEducation.getId());
				}else{
					education.setRecordId(record.getId());
					education.setCreateBy(record.getUpdateBy());
					education.setCreateDate(new Date());
					education.setUpdateBy(record.getUpdateBy());
					education.setUpdateDate(new Date());
					saveList.add(education);
				}
			}
			delList.addAll(orginAdEducationMap.keySet());

			if (saveList.size() > 0) {
				educationDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				educationDao.batchUpdate(updateList);
			}
			if (delList.size() > 0) {
				educationDao.deleteByIdList(delList);
			}
		}else{
			List<AdEducation> old=educationDao.findByRecordId(record.getId());
			List<Integer> delList=Lists.newArrayList();
			if(old.size()>0){
				for (AdEducation adEducation : old) {
					delList.add(adEducation.getId());
				}
				educationDao.deleteByIdList(delList);
			}
		}
		
	}

	private void updateCertificate(AdRecord record) {
		if(record.getCertificates().size()>0){
			List<AdCertificate> old=certificateDao.findByRecordId(record.getId());
			List<AdCertificate> certificates=record.getCertificates();
			List<AdCertificate> saveList = Lists.newArrayList();
			List<AdCertificate> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, AdCertificate> orginAdCertificateMap = Maps.newHashMap();
			
			for (AdCertificate certificate: old) {
				orginAdCertificateMap.put(certificate.getId(), certificate);
			}
			for(AdCertificate certificate :certificates){
				AdCertificate adCertificate=orginAdCertificateMap.get(certificate.getId());
				if(adCertificate!=null){
					BeanUtils.copyProperties(certificate, adCertificate);
					if(certificate.getValidity()==null){
						adCertificate.setValidity(certificate.getValidity());
					}
					updateList.add(adCertificate);
					orginAdCertificateMap.remove(adCertificate.getId());
				}else{
					certificate.setRecordId(record.getId());
					certificate.setCreateBy(record.getUpdateBy());
					certificate.setCreateDate(new Date());
					certificate.setUpdateBy(record.getUpdateBy());
					certificate.setUpdateDate(new Date());
					saveList.add(certificate);
				}
			}
			delList.addAll(orginAdCertificateMap.keySet());

			if (saveList.size() > 0) {
				certificateDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				certificateDao.batchUpdate(updateList);
			}
			if (delList.size() > 0) {
				certificateDao.deleteByIdList(delList);
			}
		}else{
			List<AdCertificate> old=certificateDao.findByRecordId(record.getId());
			List<Integer> delList=Lists.newArrayList();
			if(old.size()>0){
				for (AdCertificate adCertificate : old) {
					delList.add(adCertificate.getId());
				}
				certificateDao.deleteByIdList(delList);
			}
		}
	}

	private void updateArbeitsvertrag(AdRecord record) {
		if(record.getArbeitsvertrags().size()>0){
			List<AdArbeitsvertrag> old=arbeitsvertragDao.findByRecordId(record.getId());
			List<AdArbeitsvertrag> adArbeitsvertrags=record.getArbeitsvertrags();
			List<AdArbeitsvertrag> saveList = Lists.newArrayList();
			List<AdArbeitsvertrag> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, AdArbeitsvertrag> orginAdArbeitsvertragMap = Maps.newHashMap();
			
			for (AdArbeitsvertrag arbeitsvertrag: old) {
				orginAdArbeitsvertragMap.put(arbeitsvertrag.getId(), arbeitsvertrag);
			}
			for(AdArbeitsvertrag arbeitsvertrag :adArbeitsvertrags){
				AdArbeitsvertrag adArbeitsvertrag=orginAdArbeitsvertragMap.get(arbeitsvertrag.getId());
				if(adArbeitsvertrag!=null){
					BeanUtils.copyProperties(arbeitsvertrag, adArbeitsvertrag);
					updateList.add(adArbeitsvertrag);
					orginAdArbeitsvertragMap.remove(adArbeitsvertrag.getId());
				}else{
					arbeitsvertrag.setRecordId(record.getId());
					arbeitsvertrag.setCreateBy(record.getUpdateBy());
					arbeitsvertrag.setCreateDate(new Date());
					arbeitsvertrag.setUpdateBy(record.getUpdateBy());
					arbeitsvertrag.setUpdateDate(new Date());
					saveList.add(arbeitsvertrag);
				}
			}
			delList.addAll(orginAdArbeitsvertragMap.keySet());

			if (saveList.size() > 0) {
				arbeitsvertragDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				arbeitsvertragDao.batchUpdate(updateList);
			}
			if (delList.size() > 0) {
				arbeitsvertragDao.deleteByIdList(delList);
			}
		}else{
			List<AdArbeitsvertrag> old=arbeitsvertragDao.findByRecordId(record.getId());
			List<Integer> delList=Lists.newArrayList();
			if(old.size()>0){
				for (AdArbeitsvertrag arbeitsvertrag : old) {
					delList.add(arbeitsvertrag.getId());
				}
				arbeitsvertragDao.deleteByIdList(delList);
			}
		}
	}

	@Override
	public CrudResultDTO delete(int id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		
		try {
			recordDao.deleteById(id);
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败！");
			logger.error(e);
		}
		return result;
	}
	
	/**
	 * 构造一个消息提醒对象
	 * */
	/*private ConMessageNoticeEntity buildMessageNoticeEntity(String mode, AdRecord record) {
		ConMessageNoticeEntity entity = null;
		if("add".equals(mode)) {
			SysDept dept = deptService.findByCode(DeptConstant.ADMINISTRATION_OFFICE);
			entity = new ConMessageNoticeEntity();
			entity.setInitiator(dept.getUserId());
			entity.setPushTarget("0"); // 推送给指定用户
			entity.setUsers(dept.getUserId().toString()); // 推送给行政部管理员
			entity.setPushType("0");
			entity.setIsEnd("0");
			entity.setNoticeType("0");
			entity.setPushCount(3); // 推送三次就结束推送
			entity.setRelId("ad_record_"+record.getId()); // 设置消息对象与业务关联
			entity.setCreateBy(UserUtils.getCurrUser().getAccount());
			entity.setCreateDate(new Date());
		} else {
			entity = MessageSystemUtils.findByRelId("ad_record_"+record.getId());
			if(entity != null) {
				entity.setPushCount(3); // 推送三次就结束推送
				entity.setUpdateBy(UserUtils.getCurrUser().getAccount());
				entity.setUpdateDate(new Date());
			}
		}
		
		if(entity != null) {
			String text = record.getName() + " 于 "
					 		+ DateUtils.dateToStr(record.getBecomeDate(), "yyyy年MM月dd日") + " 转正！";
			entity.setTitle("转正提醒：" + text);
			entity.setContent("系统提醒：" + text + " <br/> 请提前做好员工转正准备工作！");
			
			entity.setStartTime(org.apache.commons.lang3.time.DateUtils.addDays(
					record.getBecomeDate(), -record.getBeforeWarnDay())); // 提前BeforeWarnDay天提醒
			entity.setEndTime(org.apache.commons.lang3.time.DateUtils.addHours(record.getBecomeDate(), 23));
		}
		
		return entity;
	}*/



	@Override
	public AdRecord findOne(Integer userId) {
		AdRecord adRecord=recordDao.findByUserid(userId);
		adRecord.setArbeitsvertrags(arbeitsvertragDao.findByRecordId(adRecord.getId()));
		adRecord.setCertificates(certificateDao.findByRecordId(adRecord.getId()));
		adRecord.setEducations(educationDao.findByRecordId(adRecord.getId()));
		adRecord.setJobRecords(jobRecordDao.findByRecordId(adRecord.getId()));
		adRecord.setPostAppointments(postAppointmentDao.findByRecordId(adRecord.getId()));
		return adRecord;
	}
	
	@Override
	public Page<AdRecord> showContacts(Map<String, Object> params, int pageNum,int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		return  recordDao.showContacts(params);
	}



	@Override
	public CrudResultDTO saveForUser(AdRecord record) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		
		AdRecord old = recordDao.findById(record.getId());
		old.setPhone(record.getPhone());
		old.setQq(record.getQq());
		old.setEmail(record.getEmail());
		old.setHome(record.getHome());
		old.setUpdateBy(UserUtils.getCurrUser().getAccount());
		old.setUpdateDate(new Date());
		old.setIsencryption(null);
		
		recordDao.update(old);
		
		return result;
	}

	@Override
	public AdRecord getByName(String name) {
		return recordDao.getByName(name);
	}


	@Override
	public void updateEncryptedData(String oldEncryptionKey,String newEncryptionKey) {
		List<AdRecord> RecordList = recordDao.findAll();
		decryptData(RecordList, oldEncryptionKey);
		encryptData(RecordList, newEncryptionKey);
	}

	
	@Override
	public <T> void decryptData(List<T> list, String oldEncryptionKey) {
		for( T temp : list ){
			AdRecord record = (AdRecord) temp;
			if (StringUtils.isNotEmpty(record.getSalary())) {
				String salary = ModuleEncryptUtils.decryptText(record.getSalary(),oldEncryptionKey);
				if (StringUtils.isNotEmpty(salary)) {
					record.setSalary(salary);
					recordDao.update(record);
				}
			}
		}
	}

	@Override
	public <T> void encryptData(List<T> list, String newEncryptionKey) {
		for( T temp : list ){
			AdRecord record = (AdRecord) temp;
			if (StringUtils.isNotEmpty(record.getSalary())) {
				String salary = ModuleEncryptUtils.encryptText(record.getSalary(),newEncryptionKey);
				if (StringUtils.isNotEmpty(salary)) {
					record.setSalary(salary);
					recordDao.update(record);
				}
			}
			
		}
	}

	@Override
	public List<AdRecord> findByDeptIds(List<Integer> deptList) {
		return recordDao.findByDeptIds(deptList);
	}

	@Override
	public void exportExcel(ServletOutputStream out, Map<String, Object> paramMap) {
		
		try {
			SysUser user =  UserUtils.getCurrUser();
			String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.RECORD);
			Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
			paramMap.put("userId", user.getId());
			paramMap.put("deptIdSet", deptIdSet);
			
			List<RecordExcelDTO> dataList = recordDao.getExcelData(paramMap);
			if (dataList != null && dataList.size()>0) {
				for (int i = 0; i < dataList.size(); i++) {
					RecordExcelDTO dto = dataList.get(i);
					dto.setSerialNumber(i+1);
					Integer status = dto.getEntrystatus();
					if (status != null && status == 1) {
						dto.setStatus("实习");
					}else if (status != null && status == 2) {
						dto.setStatus("试用");
					}else if (status != null && status == 3) {
						dto.setStatus("在职");
					}else if (status != null && status == 4) {
						dto.setStatus("离职");
					}else if (status != null && status == 5) {
						dto.setStatus("停职");
					}
					
					if (dto.getEntryTime() != null && !dto.getEntryTime().equals("")) {
						Date currentTime = dto.getEntryTime();
					    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
					    String dateString = formatter.format(currentTime);
					    dto.setTime(dateString);
					}
					if (dto.getLeaveTime() != null && !dto.getLeaveTime().equals("")) {
						Date currentTime = dto.getLeaveTime();
					    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
					    String dateString = formatter.format(currentTime);
					    dto.setLeaveTimes(dateString);
					}
				}
			}
			Calendar calendar =  Calendar.getInstance();
			Context context = new Context();
			context.putVar("year",calendar.get(Calendar.YEAR));
			context.putVar("month",calendar.get(Calendar.MONTH)+1 );
			context.putVar("day",calendar.get(Calendar.DAY_OF_MONTH) );
			context.putVar("company","睿哲科技股份有限公司");
			context.putVar("dataList", dataList);

			ExcelUtil.export("record.xls", out, context);
		} catch (Exception e) {
			e.printStackTrace();
			throw  new BusinessException();
		}
		
	}

	public void  savePositionHistory(AdRecord record){
		if (record.getPosition() != null && !record.getPosition().equals("") && record.getUserId() != null) {
			List<AdRecordPositionHistory> positionHistories = positionHistoryDao.findActivePosition(record.getUserId());
			String[] positions =  record.getPosition().split(",");
			
			for (String position : positions) {
				Integer count = 0;
				for (AdRecordPositionHistory positionHistorie : positionHistories) {
					String oldPosition =positionHistorie.getPosition().replace("\r", "").replace("\n", "").trim(); 
					position = position.replace("\r", "").replace("\n", "").trim();
					if (!oldPosition.equals(position)) {
						count = count +1;
					}
				}
				if (count.equals(positionHistories.size())) {
					AdRecordPositionHistory history = new AdRecordPositionHistory();
					history.setUserId(record.getUserId());
					history.setCreateDate(new Date());
					history.setStartTime(new Date());
					history.setPosition(position);
					positionHistoryDao.save(history);
				}
			}
		}
	}
	
	public void  saveDeptHistory(AdRecord record){
		if (record.getDept() != null && !record.getDept().equals("") && record.getUserId() != null) {
			List<AdRecordDeptHistory> deptHistories = deptHistoryDao.findActiveDept(record.getUserId());
			String[] depts =  record.getDept().split(",");
			
			for (String dept : depts) {
				Integer count = 0;
				for (AdRecordDeptHistory adRecordDeptHistory : deptHistories) {
					String oldDpet = adRecordDeptHistory.getDept().replace("\r", "").replace("\n", "").trim(); 
					dept = dept.replace("\r", "").replace("\n", "").trim(); 
					if (!oldDpet.equals(dept)) {
						count = count +1;
					}
				}
				if (count.equals(deptHistories.size())) {
					AdRecordDeptHistory history = new AdRecordDeptHistory();
					history.setUserId(record.getUserId());
					history.setCreateDate(new Date());
					history.setStartTime(new Date());
					history.setDept(dept);
					deptHistoryDao.save(history);
				}
			}
		}
	}

	@Override
	public Integer findMaxId() {
		
		return recordDao.findMaxId();
	}

	@Override
	public List<AdRecord> findByDeptIds2(Map<String, String> param) {
		return recordDao.findByDeptIds2(param);
	}
	
	/*public void  saveSalaryHistory(AdRecord record){
		
		try {
			String salary = record.getSalary();
			Integer userId = record.getUserId();
			if (salary != null && !salary.equals("") && userId != null && !userId.equals("")) {
				AdRecordSalaryHistory adRecordSalaryHistory =  salaryHistoryDao.findNewSalary(userId);
				
				if (adRecordSalaryHistory != null) {
					String  newSalary = adRecordSalaryHistory.getSalary();
					if (newSalary != null && !newSalary.equals("") && !newSalary.equals(salary)) {
						AdRecordSalaryHistory salaryHistory = new AdRecordSalaryHistory();
						salaryHistory.setUserId(userId);
						salaryHistory.setChangeDate(new Date());
						salaryHistory.setSalary(salary);
						salaryHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
						salaryHistory.setCreateDate(new Date());
						salaryHistoryDao.save(salaryHistory);
					}
				}else {
					AdRecordSalaryHistory salaryHistory = new AdRecordSalaryHistory();
					salaryHistory.setUserId(userId);
					salaryHistory.setChangeDate(new Date());
					salaryHistory.setSalary(salary);
					salaryHistory.setCreateBy(UserUtils.getCurrUser().getAccount());
					salaryHistory.setCreateDate(new Date());
					salaryHistoryDao.save(salaryHistory);
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new BusinessException();
		}
	}*/
}
