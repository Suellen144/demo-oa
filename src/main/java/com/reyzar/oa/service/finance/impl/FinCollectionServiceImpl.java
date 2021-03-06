package com.reyzar.oa.service.finance.impl;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Date;
import java.util.HashMap;
import java.util.ArrayList;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.StringUtils;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.dao.IFinCollectionDao;
import com.reyzar.oa.dao.IFinCollectionAttachDao;
import com.reyzar.oa.dao.IFinInvoicedDao;
import com.reyzar.oa.dao.IFinInvoicedAttachDao;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.ISysDictDataDao;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.dao.IFinPayDao;
import com.reyzar.oa.dao.IFinCollectionMembersDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinCollectionMembers;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.domain.FinCollectionAttach;
import com.reyzar.oa.domain.FinInvoiced;
import com.reyzar.oa.domain.FinInvoicedAttach;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.domain.FinPay;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.service.ad.IAdRecordService;
import com.reyzar.oa.service.finance.IFinCollectionService;

import javax.mail.Message;

@Service
@Transactional
public class FinCollectionServiceImpl implements IFinCollectionService {

	@Autowired
	private ActivitiUtils activitiUtils;

	@Autowired
	private IFinCollectionDao collectionDao;

	@Autowired
	private IFinCollectionAttachDao collectionAttachDao;

	@Autowired
	private IFinInvoicedDao invoicedDao;

	@Autowired
	private IFinInvoicedAttachDao invoicedAttachDao;

	@Autowired
	private IAdRecordDao iAdRecordDao;

	@Autowired
	private ISysDictDataDao iSysDictDataDao;
	
	@Autowired
	private ISaleProjectManageDao saleProjectManageDao;
	
	@Autowired
	private ISaleBarginManageDao saleBarginManageDao;
	
	@Autowired
	private IFinPayDao payDao;
	
	@Autowired
	private IFinCollectionMembersDao iFinCollectionMembersDao;
	
	@Autowired
	private ISaleProjectManageDao projectManageDao;
	
	@Autowired
	private IUserPositionDao userPositionDao;

	@Autowired
	private ISysUserDao iSysUserDao;
	@Autowired
	private IFinCollectionDao iFinCollectionDao;
    @Autowired
    private IAdRecordService recordService;

	private final static Logger logger = Logger.getLogger(FinCollectionServiceImpl.class);

	@Override
	public Map<String,Object> findTaxesAndRelationshipByProjectId(Integer projectId,Integer barginId,Integer id) {
		Map<String ,Object> map = new HashMap<String,Object>();
		double exciseMoneyS = 0.00;
		if(projectId != null) {
			List<FinCollection> finCollections=collectionDao.findCommissionByProjectId(projectId);
			FinCollection finCollection= collectionDao.statisticsRelationship(projectId);
			if(finCollection != null && finCollection.getRelationship() != null) {
				//????????????id??????????????????????????????????????????????????????????????????????????????
				if(finCollections!=null && finCollections.get(0).getId()==id) {
					map.put("relationship",finCollection.getRelationship());
				}else {
					map.put("relationship",0.00);
				}
			}else{
				map.put("relationship",0.00);
			}
			List<FinInvoiced> finInvoicedList = new ArrayList<>();
			if(barginId!=null) {
				SaleBarginManage saleBarginManageList = saleBarginManageDao.findById(barginId);
				if(saleBarginManageList != null) {
						 finInvoicedList = invoicedDao.findByBarginId(saleBarginManageList.getId());
				}
			}else {
				List<SaleBarginManage> saleBarginManageList = saleBarginManageDao.findByProjectIdAndType(projectId);
				if(saleBarginManageList != null && saleBarginManageList.size() >0) {
					for(int i = 0;i<saleBarginManageList.size();i++){
						finInvoicedList = invoicedDao.findByBarginId(saleBarginManageList.get(i).getId());
					}
				}
			}
			if(finInvoicedList != null && finInvoicedList.size() > 0) {
				for(int a = 0;a<finInvoicedList.size();a++){
					List<FinInvoicedAttach> finInvoicedAttachList = invoicedAttachDao.findByInvoicedId(finInvoicedList.get(a).getId());
					if(finInvoicedAttachList != null && finInvoicedAttachList.size() >0) {
						for(int b = 0;b<finInvoicedAttachList.size();b++){
							exciseMoneyS +=finInvoicedAttachList.get(b).getExciseMoney();
						}
					}
				}
			}
			map.put("taxes",exciseMoneyS);
		}
		return map;
	}

	@Override
	public FinCollection statisticsRelationship(Integer projectId) {
		return collectionDao.statisticsRelationship(projectId);
	}

	@Override
	public int changeData(Integer id ,double purchase , double taxes,double relationship,double other,double commissionBase) {
		return collectionDao.changeData(id,purchase,taxes,relationship,other,commissionBase);
	}
	
	@Override
	public Map<String, Object> findUser() {
		Map<String,Object> map = new HashMap<String,Object>();
		SysUser user = UserUtils.getCurrUser();
		 AdRecord record = recordService.findByUserid(user.getId());
	        String [] result = record.getPosition().split(",");
	        for(int a = 0;a<result.length;a++){
	            if(result[a].contains("??????") || result[a].contains("?????????") || result[a].contains("??????")) {
	            	map.put("position", "position1");
	            }
	        }
		return map;
	}
	
	@Override
	public Page<FinCollection> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.COLLECTION);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, pageSize);
		Page<FinCollection> page = collectionDao.findByPage(params);
		return page;
	}

	@Override
	public Page<FinCollection> findByPageNew(Map<String, Object> params, int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.COLLECTION);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		PageHelper.startPage(pageNum, 1000);
		Page<FinCollection> page = collectionDao.findByPageNew(params);
		double collectionBill=0.0; //??????
		double allocations=0.0;//?????????
		double channelCost=0.0;//????????????
        if(page!=null && page.size()>0) {
        	FinCollection finCollection=new FinCollection();
        	for(int i=0;i<page.size();i++) {
        		if(page.get(i).getApplyPay()!=null && page.get(i).getApplyPay() != "")
        		collectionBill+=Double.parseDouble(page.get(i).getApplyPay());
        		if(page.get(i).getAllocations()!=null)
        		allocations+=page.get(i).getAllocations();
        		if(page.get(i).getChannelCost()!=null)
        		channelCost+=page.get(i).getChannelCost();
        	}
        	finCollection.setApplyPay(collectionBill+"");
        	finCollection.setAllocations(allocations);
        	finCollection.setChannelCost(channelCost);
        	finCollection.setPayCompany("??????");
        	page.add(finCollection);
        }
		return page;
	}
	
	@Override
	public Page<FinCollection> findListByPage(Map<String, Object> params, int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.COLLECTION);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		params=UserUtils.userByRole(user, params);
		PageHelper.startPage(pageNum, pageSize);
		Page<FinCollection> page = collectionDao.findListByPage(params);
		// ??????????????????
		/*Page<FinCollection> collectionList = new Page<FinCollection>();
		double collectionBill2 = 0.0; //??????
		double allocations2 = 0.0; //?????????
		double channelCost2 = 0.0; //????????????
        if(page != null && page.size() > 0) {
        	for(int i = 0; i< page.size(); i++) {
        		double collectionBill = 0.0; //??????
        		double allocations = 0.0; //?????????
        		double channelCost = 0.0; //????????????
        		FinCollection finCollection = new FinCollection();
        		// ????????????????????????
        		if((i+1) < page.size()) {
        			//???????????????????????????Id????????????????????????Id?????????
        			if(!page.get(i+1).getProjectId().equals(page.get(i).getProjectId())) {
            			collectionList.add(page.get(i));
            			if(page.get(i).getApplyPay() != null) {
            				collectionBill += (Double.parseDouble(page.get(i).getApplyPay()) + collectionBill2);
            			}else {
            				collectionBill += collectionBill2;
            			}
                    	if(page.get(i).getAllocations() != null) {
                    		allocations += (page.get(i).getAllocations() + allocations2);
                    	}else {
                    		allocations += allocations2;
                    	}
                    	if(page.get(i).getChannelCost() != null) {
                    		channelCost += (page.get(i).getChannelCost() + channelCost2);
                    	}else {
                    		channelCost += channelCost2;
                    	}
                    	finCollection.setApplyPay(collectionBill+"");
                        finCollection.setAllocations(allocations);
                        finCollection.setChannelCost(channelCost);
                        finCollection.setPayCompany("??????");
                        collectionList.add(finCollection);
            		}else {
            			collectionList.add(page.get(i));
            			if(page.get(i).getApplyPay() != null)
                    		collectionBill2 += Double.parseDouble(page.get(i).getApplyPay());
                    	if(page.get(i).getAllocations() != null)
                    		allocations2 += (page.get(i).getAllocations());
                    	if(page.get(i).getChannelCost() != null)
                    		channelCost2 += (page.get(i).getChannelCost());
            		}
        		}else {
        			collectionList.add(page.get(i));
        			//???????????????????????????Id????????????????????????Id??????
        			if(page.get(i).getProjectId().equals(page.get(i-1).getProjectId())) {
        				if(page.get(i).getApplyPay() != null)
                    		collectionBill += Double.parseDouble(page.get(i).getApplyPay() + page.get(i-1).getApplyPay());
                    	if(page.get(i).getAllocations() != null)
                    		allocations += (page.get(i).getAllocations() + page.get(i-1).getAllocations());
                    	if(page.get(i).getChannelCost() != null)
                    		channelCost += (page.get(i).getChannelCost() + page.get(i-1).getChannelCost());
                    	finCollection.setApplyPay(collectionBill+"");
                        finCollection.setAllocations(allocations);
                        finCollection.setChannelCost(channelCost);
                        finCollection.setPayCompany("??????");
                        collectionList.add(finCollection);
        			}else {
        				if(page.get(i).getApplyPay() != null)
                    		collectionBill += Double.parseDouble(page.get(i).getApplyPay());
                    	if(page.get(i).getAllocations() != null)
                    		allocations += (page.get(i).getAllocations());
                    	if(page.get(i).getChannelCost() != null)
                    		channelCost += (page.get(i).getChannelCost());
                    	finCollection.setApplyPay(collectionBill+"");
                        finCollection.setAllocations(allocations);
                        finCollection.setChannelCost(channelCost);
                        finCollection.setPayCompany("??????");
                        collectionList.add(finCollection);
        			}
        		}
        	}
        }*/
		return page;
	}
	
	@Override
	public FinCollection findById(Integer id) {
       FinCollection  finCollection = collectionDao.findById(id);
       SaleProjectManage saleProjectmanage =projectManageDao.findById(finCollection.getProjectId());
		if(saleProjectmanage != null && saleProjectmanage.getUserId() != null) {
			finCollection.setIsOk("true");
		}else {
			finCollection.setIsOk("false");
		}
       if(finCollection != null && finCollection.getChannelCost() ==null) {
           finCollection.setChannelCost(0.00);
       }
		SysUser user = UserUtils.getCurrUser();
		AdRecord record = recordService.findByUserid(user.getId());
		String [] result = record.getPosition().split(",");
		for(int a = 0;a<result.length;a++){
			if(result[a].contains("??????") || result[a].contains("??????")) {
				finCollection.setPosition("position");
			}
		}
       return finCollection;
	}

	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"???????????????");
		FinCollection finCollection = json.toJavaObject(FinCollection.class);
		SysUser user = UserUtils.getCurrUser();
		try {
			if(finCollection.getId() == null){
				finCollection.setUserId(user.getId());
				finCollection.setDeptId(user.getDeptId());
				/*finCollection.setApplyTime(new Date());*/
				finCollection.setStatus(null);
				finCollection.setCreateBy(user.getAccount());
				finCollection.setCreateDate(new Date());
				finCollection.setEmailUid(String.valueOf(user.getId()));
				//????????????????????????????????????????????????
				if(finCollection.getIsNewProject()!=null && finCollection.getIsNewProject() == 1) {
					//????????????id????????????id
					if(finCollection.getBarginId()!=null ) {
						List<SaleProjectManage> saleProjectManages=saleProjectManageDao.findProjectManageByBarginId(finCollection.getBarginId());
						if(saleProjectManages!=null && saleProjectManages.size()>0) {
							finCollection.setProjectId(saleProjectManages.get(0).getId());
						}
					}
				}
				collectionDao.save(finCollection);
				if(finCollection.getIsNewProject()!=null && finCollection.getIsNewProject() == 1) {
					for(int i=0;i< finCollection.getFinCollectionMembers().size();i++) {
						FinCollectionMembers finCollectionMembers=finCollection.getFinCollectionMembers().get(i);
						finCollectionMembers.setCreateBy(user.getAccount());
						finCollectionMembers.setCreateDate(new Date());
						finCollectionMembers.setFinCollectionId(finCollection.getId());
						iFinCollectionMembersDao.save(finCollectionMembers);
					}
				}
					//??????????????????
					if (finCollection.getIsInvoiced() == 1) {
						FinInvoiced invoiced = json.toJavaObject(FinInvoiced.class);
						invoiced.setCreateBy(user.getAccount());
						invoiced.setCreateDate(new Date());
						invoicedDao.save(invoiced);
						//?????????????????????ID
						finCollection.setInvoicedId(invoiced.getId());
						collectionDao.update(finCollection);
						List<FinInvoicedAttach > invoicedAttachs = invoiced.getInvoicedAttachList();
						if (invoicedAttachs != null) {
							for (FinInvoicedAttach attach : invoicedAttachs) {
								attach.setInvoicedId(invoiced.getId());
								attach.setCreateBy(user.getAccount());
								attach.setCreateDate(new Date());
							}
							invoicedAttachDao.insertAll(invoicedAttachs);
						}
					}
				
				updateBargin(finCollection);
			}else{
				saveOrUpdate(json);
			}
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO submitinfo(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		ProcessInstance processInstance = null;
		SysUser user = UserUtils.getCurrUser();
		try {
			FinCollection collection = json.toJavaObject(FinCollection.class);
			collection.setUserId(user.getId());
			collection.setDeptId(user.getDeptId());
			/*collection.setApplyTime(new Date());*/
			collection.setStatus(null);
			collection.setCreateBy(user.getAccount());
			collection.setCreateDate(new Date());
			collection.setEmailUid(String.valueOf(user.getId()));
			if (collection.getId() == null){
				collectionDao.save(collection);
				
				if(collection.getIsNewProject()!=null && collection.getIsNewProject() == 1) {
					if(collection.getFinCollectionMembers()!=null && collection.getFinCollectionMembers().size()>0) {
						for(int i=0;i< collection.getFinCollectionMembers().size();i++) {
							FinCollectionMembers finCollectionMembers=collection.getFinCollectionMembers().get(i);
							finCollectionMembers.setCreateBy(user.getAccount());
							finCollectionMembers.setCreateDate(new Date());
							finCollectionMembers.setFinCollectionId(collection.getId());
							iFinCollectionMembersDao.save(finCollectionMembers);
						}
					}
				}
				
				if(collection.getIsNewProcess() != null && collection.getIsNewProcess() == 1) {
					List<FinCollectionAttach> saveList = Lists.newArrayList();
					FinCollectionAttach collectionAttach = new FinCollectionAttach();
					collectionAttach.setCollectionId(collection.getId());
					collectionAttach.setCreateBy(user.getAccount());
					collectionAttach.setCreateDate(new Date());
					collectionAttach.setUpdateBy(user.getAccount());
					collectionAttach.setUpdateDate(new Date());
					collectionAttach.setCollectionBill(Double.parseDouble(collection.getApplyPay()));
					collectionAttach.setCollectionDate(collection.getApplyTime());
					saveList.add(collectionAttach);
					collectionAttachDao.insertAll(saveList);
				}
			}else{
				FinCollection outcollection=collectionDao.findById(collection.getId());
				BeanUtils.copyProperties(collection, outcollection);
				collectionDao.update(collection);
				
				if(collection.getIsNewProject()!=null && collection.getIsNewProject() == 1) {
					//??????????????????,??????id?????? ?????? or ?????? or ??????
					List<FinCollectionMembers> orginfinCollectionMembers = iFinCollectionMembersDao.findByFinCollectionId(collection.getId());
					List<FinCollectionMembers> finCollectionMembers= collection.getFinCollectionMembers();
					List<FinCollectionMembers> saveListInvoiceProjectMembers = Lists.newArrayList();
					List<FinCollectionMembers> updateListInvoiceProjectMembers = Lists.newArrayList();
					List<Integer> delListInvoiceProjectMembers = Lists.newArrayList();
					Map<Integer, FinCollectionMembers> orgininvoicedMapInvoiceProjectMembers = Maps.newHashMap();
					if(orginfinCollectionMembers!=null && orginfinCollectionMembers.size()>0) {
						for (FinCollectionMembers attach : orginfinCollectionMembers) {
							orgininvoicedMapInvoiceProjectMembers.put(attach.getId(), attach);
						}
					}
					if(finCollectionMembers!=null && finCollectionMembers.size()>0) {
						for(FinCollectionMembers attach: finCollectionMembers) {
							if (attach.getId() != null) {
								attach.setUpdateBy(user.getAccount());
								attach.setUpdateDate(new Date());
								FinCollectionMembers orgin = orgininvoicedMapInvoiceProjectMembers.get(attach.getId());
								if (orgin != null) {
									BeanUtils.copyProperties(attach, orgin);
									updateListInvoiceProjectMembers.add(orgin);
									orgininvoicedMapInvoiceProjectMembers.remove(orgin.getId());
								}
							} else {
								attach.setFinCollectionId(collection.getId());
								attach.setCreateBy(user.getAccount());
								attach.setCreateDate(new Date());
								saveListInvoiceProjectMembers.add(attach);
							}
						}
					}
					
					//?????????
					delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
					if (saveListInvoiceProjectMembers.size() > 0) {
						iFinCollectionMembersDao.insertAll(saveListInvoiceProjectMembers);
					}
					//?????????
					if (updateListInvoiceProjectMembers.size() > 0) {
						iFinCollectionMembersDao.batchUpdate(updateListInvoiceProjectMembers);
					}
					//?????????
					if (delListInvoiceProjectMembers.size() > 0) {
						//??????????????????????????????????????????
						for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
							FinCollectionMembers sinInvoiceProjectMembersisD=iFinCollectionMembersDao.findById(delListInvoiceProjectMembers.get(i));
							sinInvoiceProjectMembersisD.setIsDeleted("1");
							iFinCollectionMembersDao.update(sinInvoiceProjectMembersisD);
						}
						//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
					}
				}
				if(collection.getIsNewProcess() != null && collection.getIsNewProcess() == 1) {
					List<FinCollectionAttach> saveList = Lists.newArrayList();
					FinCollectionAttach collectionAttach = new FinCollectionAttach();
					collectionAttach.setCollectionId(collection.getId());
					collectionAttach.setCreateBy(user.getAccount());
					collectionAttach.setCreateDate(new Date());
					collectionAttach.setUpdateBy(user.getAccount());
					collectionAttach.setUpdateDate(new Date());
					collectionAttach.setCollectionBill(Double.parseDouble(collection.getApplyPay()));
					collectionAttach.setCollectionDate(collection.getApplyTime());
					saveList.add(collectionAttach);
					collectionAttachDao.insertAll(saveList);
				}
			}
			if(collection.getIsNewProject()!=null && collection.getIsNewProject() == 1) {
				//????????????id????????????id
				if(collection.getBarginId()!=null ) {
					List<SaleProjectManage> saleProjectManages=saleProjectManageDao.findProjectManageByBarginId(collection.getBarginId());
					if(saleProjectManages!=null && saleProjectManages.size()>0) {
						collection.setProjectId(saleProjectManages.get(0).getId());
					}
				}
			}
			SaleProjectManage saleProjectManage=new SaleProjectManage();
			if(collection.getProjectId()!=null) {
				saleProjectManage=projectManageDao.findById(collection.getProjectId());
			}
			SysUserPosition userPosition = new SysUserPosition();
			if(saleProjectManage!=null && saleProjectManage.getDutyDeptId()!=null) {
				userPosition=userPositionDao.findByDeptAndLevel(saleProjectManage.getDutyDeptId());
			}
				//??????????????????
				if (collection.getIsInvoiced() == 1) {
					FinInvoiced invoiced = json.toJavaObject(FinInvoiced.class);
					invoiced.setCreateBy(user.getAccount());
					invoiced.setCreateDate(new Date());
					invoicedDao.save(invoiced);
					//?????????????????????ID
					collection.setInvoicedId(invoiced.getId());
					collectionDao.update(collection);
					List<FinInvoicedAttach > invoicedAttachs = invoiced.getInvoicedAttachList();
					if (invoicedAttachs != null) {
						for (FinInvoicedAttach attach : invoicedAttachs) {
							attach.setInvoicedId(invoiced.getId());
							attach.setCreateBy(user.getAccount());
							attach.setCreateDate(new Date());
						}
						invoicedAttachDao.insertAll(invoicedAttachs);
					}
				}
			boolean toCeo = (collection.getIsInvoiced() == 1) ? true : false;
			SaleProjectManage saleProjectmanage =projectManageDao.findById(collection.getProjectId());
			boolean isOk = (saleProjectmanage != null && saleProjectmanage.getPrincipal() != null)? true : false;
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
			businessParams.put("class", this.getClass().getName()); // ?????????????????????
			businessParams.put("method", "findById"); // ????????????
			businessParams.put("paramValue", new Object[]{collection.getId()}); // ????????????????????????
			variables.put("toCeo", toCeo);//????????????????????????????????????????????????????????????
			variables.put("isOk", isOk);
			//?????????????????????????????????????????????????????????????????????????????????
            if(collection.getIsNewProject()!=null && collection.getIsNewProject() == 1) {
            	variables.put("toHead",true);
            	//????????????????????????null????????????????????????
            	if(saleProjectManage.getUserId() == null) {
            		SysUser sysUser=iSysUserDao.findById(user.getId());
    				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
    				variables.put("userId", user.getId());
            	}else {
            		variables.put("userId", saleProjectManage.getUserId());
            	}
    			variables.put("userId2", userPosition.getUserId());
            }else {
            	variables.put("toHead",false);
            }
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.COLLECT_KEY, user.getId().toString(), collection.getId().toString(), variables);
			String emailId = String.valueOf(user.getId());
			// ????????????????????????????????????
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "????????????");
			commentMap.put("approver", user.getName());
			commentMap.put("emailId", emailId);
			commentMap.put("comment", "");
			commentMap.put("approveResult", "????????????");
			commentMap.put("approveDate", new Date());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // ??????????????????????????????????????????

			List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
			for (Task task : taskList) {
				if (task.getName().equals("????????????")) {
					activitiUtils.completeTask(task.getId(), variables);
					break;
				}
			}
			
			String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
			collection.setProcessInstanceId(processInstance.getId());
			collection.setStatus(status);
			collectionDao.update(collection);
			updateBargin(collection);
		} catch (Exception e) {
			if (processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SysUser user = UserUtils.getCurrUser();
		//?????????????????????
		FinCollection collection = json.toJavaObject(FinCollection.class);
		//fin_collection???
		FinCollection orginCollection = collectionDao.findById(collection.getId());
		//??????orginCollection ????????? ???????????????emaiUid
		String[] emailUidString = orginCollection.getEmailUid().split(",");
		Set<String> emailUidSet = Sets.newHashSet();
		for (int i=0;i<emailUidString.length;i++){
			emailUidSet.add(emailUidString[i]);
		}
		collection.setUpdateBy(user.getAccount());
		collection.setUpdateDate(new Date());
		if(collection.getIsNewProject()!=null && collection.getIsNewProject() == 1) {
			//????????????id????????????id
			if(collection.getBarginId()!=null ) {
				List<SaleProjectManage> saleProjectManages=saleProjectManageDao.findProjectManageByBarginId(collection.getBarginId());
				if(saleProjectManages!=null && saleProjectManages.size()>0) {
					collection.setProjectId(saleProjectManages.get(0).getId());
				}
			}
		}
		BeanUtils.copyProperties(collection, orginCollection);
		//??????emailUid??????
		//???????????????4,???????????????5??????????????????????????????5
		if(orginCollection.getStatus() != null && !"".equals(orginCollection.getStatus())){
		if (Integer.parseInt(orginCollection.getStatus()) < 4) {
			emailUidSet.add(collection.getEmailUid());
		}
		if (Integer.parseInt(orginCollection.getStatus()) > 5) {
			orginCollection.setBill(null);
			orginCollection.setBillDate(null);
			//????????????????????????????????????????????????
			if(collection.getIsNewProcess() != 1) {
				collectionAttachDao.deleteByCollectionId(orginCollection.getId());
			}
		}
		orginCollection.setEmailUid(StringUtils.join(emailUidSet.toArray(),","));
		}
		//??????fin_collection???
		collectionDao.update(orginCollection);
		
		updateBargin(collection);
		
		/*	??????????????????????????????*/
		//???????????????collection??????
		if (collection.getCollectionAttachList()!=null&&collection.getCollectionAttachList().size() > 0) {
			//???????????????????????????collectionAttach??????
			List<FinCollectionAttach> orginCollectionAttachList = collectionAttachDao.findByCollectionId(collection.getId());
			//???collection???????????????collectionAttach??????
			List<FinCollectionAttach> collectionAttachList = collection.getCollectionAttachList();

			List<FinCollectionAttach> saveList = Lists.newArrayList();
			List<FinCollectionAttach> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, FinCollectionAttach> orginFinCollectionMap = Maps.newHashMap();

			for (FinCollectionAttach collectionAttach : orginCollectionAttachList) {
				orginFinCollectionMap.put(collectionAttach.getId(), collectionAttach);
			}
			//??????????????????????????????
			for (FinCollectionAttach attach : collectionAttachList) {
				FinCollectionAttach orgin = orginFinCollectionMap.get(attach.getId());
				if (orgin != null) {
					//???????????????
					BeanUtils.copyProperties(attach, orgin);
					updateList.add(orgin);
					orginFinCollectionMap.remove(orgin.getId());
				} else {
					//???????????????
					attach.setCollectionId(collection.getId());
					attach.setCreateBy(user.getAccount());
					attach.setCreateDate(new Date());
					attach.setUpdateBy(user.getAccount());
					attach.setUpdateDate(new Date());
					saveList.add(attach);
				}
			}
			delList.addAll(orginFinCollectionMap.keySet());

			if (saveList.size() > 0) {
				if(!emailUidSet.contains("3")){
					emailUidSet.add("3");
				}
				//????????????????????????
				if(collection.getIsNewProcess() != 1) {
					//????????????
					if(Integer.parseInt(orginCollection.getStatus()) < 5) {

						sendMail(collection, saveList,StringUtils.join(emailUidSet.toArray(),","),1,"");
					}
				}
				collectionAttachDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				/*sendMail(collection, saveList,StringUtils.join(emailUidSet.toArray(),","));*/
				collectionAttachDao.batchUpdate(updateList);
			}
			if (delList.size() > 0) {
				collectionAttachDao.deleteByIdList(delList);
			}
		}
		if(orginCollection.getIsOldData()!=null && orginCollection.getIsOldData() == 1) {
			/*if(collection.getFinCollectionMembers() !=null && collection.getFinCollectionMembers().size()>0) {
				List<FinCollectionMembers> finCollectionMemberss=iFinCollectionMembersDao.findByFinCollectionId(collection.getId());
				for (int i = 0; i < finCollectionMemberss.size(); i++) {
					finCollectionMemberss.get(i).setIsDeleted("1");
					iFinCollectionMembersDao.update(finCollectionMemberss.get(i));
				}
				for(int i=0;i< collection.getFinCollectionMembers().size();i++) {
					FinCollectionMembers finCollectionMembers=collection.getFinCollectionMembers().get(i);
					finCollectionMembers.setCreateBy(user.getAccount());
					finCollectionMembers.setCreateDate(new Date());
					finCollectionMembers.setFinCollectionId(collection.getId());
					iFinCollectionMembersDao.save(finCollectionMembers);
				}
			}*/
			//??????????????????,??????id?????? ?????? or ?????? or ??????
			List<FinCollectionMembers> orginfinCollectionMembers = iFinCollectionMembersDao.findByFinCollectionId(collection.getId());
			List<FinCollectionMembers> finCollectionMembers= collection.getFinCollectionMembers();
			List<FinCollectionMembers> saveListInvoiceProjectMembers = Lists.newArrayList();
			List<FinCollectionMembers> updateListInvoiceProjectMembers = Lists.newArrayList();
			List<Integer> delListInvoiceProjectMembers = Lists.newArrayList();
			Map<Integer, FinCollectionMembers> orgininvoicedMapInvoiceProjectMembers = Maps.newHashMap();
			if(orginfinCollectionMembers!=null && orginfinCollectionMembers.size()>0) {
				for (FinCollectionMembers attach : orginfinCollectionMembers) {
					orgininvoicedMapInvoiceProjectMembers.put(attach.getId(), attach);
				}
			}
			if(finCollectionMembers!=null && finCollectionMembers.size()>0) {
				for(FinCollectionMembers attach: finCollectionMembers) {
					if (attach.getId() != null) {
						attach.setUpdateBy(user.getAccount());
						attach.setUpdateDate(new Date());
						FinCollectionMembers orgin = orgininvoicedMapInvoiceProjectMembers.get(attach.getId());
						if (orgin != null) {
							BeanUtils.copyProperties(attach, orgin);
							updateListInvoiceProjectMembers.add(orgin);
							orgininvoicedMapInvoiceProjectMembers.remove(orgin.getId());
						}
					} else {
						attach.setFinCollectionId(collection.getId());
						attach.setCreateBy(user.getAccount());
						attach.setCreateDate(new Date());
						saveListInvoiceProjectMembers.add(attach);
					}
				}
			}
			
			//?????????
			delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
			if (saveListInvoiceProjectMembers.size() > 0) {
				iFinCollectionMembersDao.insertAll(saveListInvoiceProjectMembers);
			}
			//?????????
			if (updateListInvoiceProjectMembers.size() > 0) {
				iFinCollectionMembersDao.batchUpdate(updateListInvoiceProjectMembers);
			}
			//?????????
			if (delListInvoiceProjectMembers.size() > 0) {
				//??????????????????????????????????????????
				for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
					FinCollectionMembers sinInvoiceProjectMembersisD=iFinCollectionMembersDao.findById(delListInvoiceProjectMembers.get(i));
					sinInvoiceProjectMembersisD.setIsDeleted("1");
					iFinCollectionMembersDao.update(sinInvoiceProjectMembersisD);
				}
				//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
			}
		}else {
			/*??????????????????????????????*/
			if (collection.getIsInvoiced() != 0) {
				FinInvoiced invoiced = json.toJavaObject(FinInvoiced.class);
				FinInvoiced orgininInvoiced = invoicedDao.findById(orginCollection.getInvoicedId());
				//???????????????????????????????????????????????????????????????????????????????????????
				if (orgininInvoiced == null) {
					FinInvoiced finInvoiced = new FinInvoiced();
					finInvoiced.setCreateBy(user.getAccount());
					finInvoiced.setCreateDate(new Date());
					invoicedDao.save(finInvoiced);
					orginCollection.setInvoicedId(finInvoiced.getId());
					collectionDao.update(orginCollection);
					orgininInvoiced = invoicedDao.findById(orginCollection.getInvoicedId());
					BeanUtils.copyProperties(invoiced, orgininInvoiced);
					orgininInvoiced.setId(orginCollection.getInvoicedId());
					invoicedDao.update(orgininInvoiced);
				} else {
					invoiced.setUpdateBy(user.getAccount());
					invoiced.setUpdateDate(new Date());
					BeanUtils.copyProperties(invoiced, orgininInvoiced);
					orgininInvoiced.setId(orginCollection.getInvoicedId());
					invoicedDao.update(orgininInvoiced);
				}
				List<FinInvoicedAttach> orginFinInvoicedAttachList = invoicedAttachDao.findByInvoicedId(collection.getInvoicedId());
				List<FinInvoicedAttach> finInvoicedAttachList = invoiced.getInvoicedAttachList();
				List<FinInvoicedAttach> saveList = Lists.newArrayList();
				List<FinInvoicedAttach> updateList = Lists.newArrayList();
				List<Integer> delList = Lists.newArrayList();
				
				Map<Integer, FinInvoicedAttach> orgininvoicedMap = Maps.newHashMap();
				for (FinInvoicedAttach attach : orginFinInvoicedAttachList) {
					orgininvoicedMap.put(attach.getId(), attach);
				}
				
				for (FinInvoicedAttach attach : finInvoicedAttachList) {
					if (attach.getId() != null) {
						attach.setUpdateBy(user.getAccount());
						attach.setUpdateDate(new Date());
						FinInvoicedAttach orgin = orgininvoicedMap.get(attach.getId());
						if (orgin != null) {
							BeanUtils.copyProperties(attach, orgin);
							updateList.add(orgin);
							orgininvoicedMap.remove(orgin.getId());
						}
					} else {
						attach.setInvoicedId(orgininInvoiced.getId());
						attach.setCreateBy(user.getAccount());
						attach.setCreateDate(new Date());
						saveList.add(attach);
					}
				}
				delList.addAll(orgininvoicedMap.keySet());
				if (saveList.size() > 0) {
					invoicedAttachDao.insertAll(saveList);
				}
				if (updateList.size() > 0) {
					invoicedAttachDao.batchUpdate(updateList);
				}
				if (delList.size() > 0) {
					invoicedAttachDao.deleteByIdList(delList);
				}
			}
		}
		return result;
	}
	
	/**
	 * ?????????????????????????????????????????????
	 * */
	public void updateBargin(FinCollection collection){
		if(collection.getBarginId() != null && !"".equals(collection.getBarginId())){
			SaleBarginManage saleBarginManage = saleBarginManageDao.findById(collection.getBarginId());
			if(!saleBarginManage.getProjectManageId().equals(collection.getProjectId())){
				//?????????????????????????????????id
				saleBarginManage.setProjectManageId(collection.getProjectId());
				saleBarginManageDao.update(saleBarginManage);
				//?????????????????????????????????id
				List<FinCollection> collectionList = Lists.newArrayList();
				collectionList = collectionDao.findByBarginId(collection.getBarginId());
				if(collectionList.size() > 0){
					for (FinCollection finCollection : collectionList) {
						finCollection.setProjectId(collection.getProjectId());
					}
					collectionDao.batchUpdate(collectionList);
				}
			
				//?????????????????????????????????id
				List<FinPay> payList = Lists.newArrayList();
				payList = payDao.findByBarginId(collection.getBarginId());
				if(payList.size() > 0){
					for (FinPay finPay : payList) {
						finPay.setProjectManageId(collection.getProjectId());
					}
					payDao.batchUpdate(payList);
				}
			}
		}
	}
	
	/**
	 * ????????????
	 */
	public void sendMail(FinCollection collection, List<FinCollectionAttach> saveList,String emailUid,Integer flag,String contents) {
		SaleProjectManage projectManage = saleProjectManageDao.findById(collection.getProjectId());
		SaleBarginManage barginManage = saleBarginManageDao.findById(collection.getBarginId());
		double totalMoney=0.0;
		List<FinCollection> coll =new ArrayList<FinCollection>();
		if(barginManage!=null && barginManage.getCollectionList()!=null ){
			coll=barginManage.getCollectionList();
			if((barginManage.getTotalMoney() == 0 || barginManage.getTotalMoney() == null) && collection != null && StringUtils.isNotBlank(collection.getTotalPay())) {
				totalMoney=Double.parseDouble(collection.getTotalPay());
			}else {
				totalMoney=barginManage.getTotalMoney();
			}
		}else {
			coll=iFinCollectionDao.findCollectionByProjectId(collection.getProjectId());
		}
		SysDictData sysDictData = new SysDictData();
		try{
			sysDictData = iSysDictDataDao.findByValueAndTypeidNotDelet(Integer.valueOf(collection.getCollectionType()), 72);
		}catch (Exception e){
			logger.error("???????????? ????????????????????????"+e);
		}

		String[] emailidArray = emailUid.split(",");
		//????????????????????????ID
		List<Integer> userIdListOfPorcess = new ArrayList<Integer>();
		//??????????????????Email
		List<String> recipientsList = new ArrayList<String>();
		for (int i=0;i<emailidArray.length;i++){
			userIdListOfPorcess.add(Integer.valueOf(emailidArray[i]));	
		}
		recipientsList = iAdRecordDao.findEmailsByUserIdList(userIdListOfPorcess);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// ????????????
		
		StringBuffer contentBuffer = new StringBuffer();
		String subject = "";
		if(flag == 1){
		subject = "OA????????????";
		contentBuffer.append("<h3>");
		contentBuffer.append("<span style=\\\"font-family:????????????, Microsoft YaHei\\\">??????????????????!");
		for (FinCollectionAttach attach:saveList) {
			double money = 0;
			double ReceivedMoney = 0;
			double collectionBill = 0;
			String collectionDate = "";
			if(attach.getCollectionBill() != null) {
                 collectionBill = attach.getCollectionBill();
            }
            if(attach.getCollectionDate() != null) {
                collectionDate= sdf.format(attach.getCollectionDate());
            }
			for (FinCollection finCollection : coll) {
				money += Double.parseDouble(finCollection.getApplyPay());
			}
			ReceivedMoney = money + collectionBill;
			contentBuffer.append("</h3><br>??????");
			contentBuffer.append(collectionDate+"&nbsp;&nbsp;&nbsp;&nbsp;");
			contentBuffer.append("??????");
			contentBuffer.append(collection.getPayCompany());
			contentBuffer.append(sysDictData.getName() + "????????????");
			contentBuffer.append(attach.getCollectionBill() + "&nbsp;???<br>");
			contentBuffer.append(projectManage.getName() + "??????&nbsp;&nbsp;&nbsp;&nbsp;");
			contentBuffer.append("????????????????????????" + ReceivedMoney + "&nbsp;???&nbsp;&nbsp;&nbsp;&nbsp;");
			contentBuffer.append("??????????????????" + totalMoney + "&nbsp;???<br>");
		}
		contentBuffer.append("<br>???????????????OA??????????????????????????????!</br></span>\r\n");
		}else{
			subject = "OA??????????????????";
			contentBuffer.append("<span style=\\\"font-family:????????????, Microsoft YaHei\\\">");
			contentBuffer.append("<br>??????&nbsp;");
			contentBuffer.append(sdf.format(collection.getApplyTime())+"&nbsp;");
			contentBuffer.append("????????????????????????????????????<br>????????????:");
			contentBuffer.append(contents + "<br>");
			contentBuffer.append("<br>???????????????OA????????????!</br></span>\r\n");
		}
		String content = contentBuffer.toString();
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
		logger.info("["+UserUtils.getCurrUser().getName()+"]" + "????????????????????????????????????ID???" + collection.getId());
		for (String email:recipientsList) {
			logger.info("???????????? ???"+email+"??????????????????????????????");
		}
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		FinCollection collection = collectionDao.findById(id);
		if(collection != null) {
			collection.setStatus(status);
			collectionDao.update(collection);
			
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
		FinCollection finCollection = collectionDao.findById(id);
		System.out.println(path);
		if(finCollection.getAttachments()!=null){
			try {
				FileUtil.forceDelete(path);
				finCollection.setAttachments("");
				finCollection.setAttachName("");
				collectionDao.update(finCollection);
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("????????????!");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("??????????????????");
		}
		return result;
	}

	@Override
	public CrudResultDTO findCollectionInfo(Integer barginId, String status) {
		CrudResultDTO result  = new CrudResultDTO();
		try{
			List<FinCollection> finCollectionList = collectionDao.findCollectionInfo(barginId,status);
			if(finCollectionList != null && !finCollectionList.equals("") && finCollectionList.size() > 0){
				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult(finCollectionList);
			}
		}catch (Exception e){
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public void sendMailToApple(Integer id, String contents) {
		FinCollection collection=collectionDao.findById(id);
		sendMail(collection, collection.getCollectionAttachList(), collection.getUserId()+",", 2, contents);
	}

	@Override
	public List<FinCollection> findByBarginId(Integer barginId) {
		return collectionDao.findByBarginId(barginId);
	}

	@Override
	public List<FinCollection> findByBarginIdAndCreateDate(Integer barginId, Date createDate) {
		return collectionDao.findByBarginIdAndCreateDate(barginId, createDate);
	}


/*	@Override
	public CrudResultDTO deleteAttach(String path, Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		FinCollection finCollection = collectionDao.findById(id);
		if (finCollection.getAttachments() != null) {
			try {
				FileUtil.forceDelete(path);
				finCollection.setAttachName("");
				finCollection.setAttachments("");
				collectionDao.update(finCollection);
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
	}*/
}