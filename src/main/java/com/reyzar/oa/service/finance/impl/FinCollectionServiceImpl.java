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
				//根据项目id，查出所有收款记录，攻关费只在第一次扣除，其他不扣除
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
	            if(result[a].contains("出纳") || result[a].contains("总经理") || result[a].contains("复核")) {
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
		double collectionBill=0.0; //金额
		double allocations=0.0;//提成额
		double channelCost=0.0;//渠到费用
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
        	finCollection.setPayCompany("累计");
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
		// 重构后的数据
		/*Page<FinCollection> collectionList = new Page<FinCollection>();
		double collectionBill2 = 0.0; //金额
		double allocations2 = 0.0; //提成额
		double channelCost2 = 0.0; //渠到费用
        if(page != null && page.size() > 0) {
        	for(int i = 0; i< page.size(); i++) {
        		double collectionBill = 0.0; //金额
        		double allocations = 0.0; //提成额
        		double channelCost = 0.0; //渠到费用
        		FinCollection finCollection = new FinCollection();
        		// 判断下标是否越界
        		if((i+1) < page.size()) {
        			//如果当前对象的项目Id与下一个对象项目Id不一致
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
                        finCollection.setPayCompany("累计");
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
        			//如果当前对象的项目Id与下一个对象项目Id一致
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
                        finCollection.setPayCompany("累计");
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
                        finCollection.setPayCompany("累计");
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
			if(result[a].contains("会计") || result[a].contains("财务")) {
				finCollection.setPosition("position");
			}
		}
       return finCollection;
	}

	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
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
				//如果是项目管理模块发起的收款申请
				if(finCollection.getIsNewProject()!=null && finCollection.getIsNewProject() == 1) {
					//根据合同id获取项目id
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
					//是否开具发票
					if (finCollection.getIsInvoiced() == 1) {
						FinInvoiced invoiced = json.toJavaObject(FinInvoiced.class);
						invoiced.setCreateBy(user.getAccount());
						invoiced.setCreateDate(new Date());
						invoicedDao.save(invoiced);
						//更新关联的发票ID
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
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "提交成功！");
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
					//更新成员数据,根据id筛选 删除 or 添加 or 更新
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
					
					//添加集
					delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
					if (saveListInvoiceProjectMembers.size() > 0) {
						iFinCollectionMembersDao.insertAll(saveListInvoiceProjectMembers);
					}
					//更新集
					if (updateListInvoiceProjectMembers.size() > 0) {
						iFinCollectionMembersDao.batchUpdate(updateListInvoiceProjectMembers);
					}
					//删除集
					if (delListInvoiceProjectMembers.size() > 0) {
						//目前数据不删除，更改删除状态
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
				//根据合同id获取项目id
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
				//是否开具发票
				if (collection.getIsInvoiced() == 1) {
					FinInvoiced invoiced = json.toJavaObject(FinInvoiced.class);
					invoiced.setCreateBy(user.getAccount());
					invoiced.setCreateDate(new Date());
					invoicedDao.save(invoiced);
					//更新关联的发票ID
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
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			businessParams.put("paramValue", new Object[]{collection.getId()}); // 方法参数的值集合
			variables.put("toCeo", toCeo);//如开具发票需经总经理审批。否则跳过此阶段
			variables.put("isOk", isOk);
			//判断是否项目管理模块新建，如果是则需要走项目负责人审批
            if(collection.getIsNewProject()!=null && collection.getIsNewProject() == 1) {
            	variables.put("toHead",true);
            	//如果项目负责人是null，则用发起人代替
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
			// 跳过初始时的提交申请节点
			List<Map<String, Object>> commentList = Lists.newArrayList();
			Map<String, Object> commentMap = Maps.newHashMap();
			commentMap.put("node", "提交申请");
			commentMap.put("approver", user.getName());
			commentMap.put("emailId", emailId);
			commentMap.put("comment", "");
			commentMap.put("approveResult", "提交成功");
			commentMap.put("approveDate", new Date());
			commentList.add(commentMap);
			variables.put("commentList", commentList); // 初始化提交申请节点的备注列表

			List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
			for (Task task : taskList) {
				if (task.getName().equals("提交申请")) {
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
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		//页面的全部信息
		FinCollection collection = json.toJavaObject(FinCollection.class);
		//fin_collection表
		FinCollection orginCollection = collectionDao.findById(collection.getId());
		//先从orginCollection 中取出 数据库中的emaiUid
		String[] emailUidString = orginCollection.getEmailUid().split(",");
		Set<String> emailUidSet = Sets.newHashSet();
		for (int i=0;i<emailUidString.length;i++){
			emailUidSet.add(emailUidString[i]);
		}
		collection.setUpdateBy(user.getAccount());
		collection.setUpdateDate(new Date());
		if(collection.getIsNewProject()!=null && collection.getIsNewProject() == 1) {
			//根据合同id获取项目id
			if(collection.getBarginId()!=null ) {
				List<SaleProjectManage> saleProjectManages=saleProjectManageDao.findProjectManageByBarginId(collection.getBarginId());
				if(saleProjectManages!=null && saleProjectManages.size()>0) {
					collection.setProjectId(saleProjectManages.get(0).getId());
				}
			}
		}
		BeanUtils.copyProperties(collection, orginCollection);
		//拼接emailUid字段
		//出纳状态为4,审批通过为5，不通过等状态都大于5
		if(orginCollection.getStatus() != null && !"".equals(orginCollection.getStatus())){
		if (Integer.parseInt(orginCollection.getStatus()) < 4) {
			emailUidSet.add(collection.getEmailUid());
		}
		if (Integer.parseInt(orginCollection.getStatus()) > 5) {
			orginCollection.setBill(null);
			orginCollection.setBillDate(null);
			//删除收款表附表，新流程不进此方法
			if(collection.getIsNewProcess() != 1) {
				collectionAttachDao.deleteByCollectionId(orginCollection.getId());
			}
		}
		orginCollection.setEmailUid(StringUtils.join(emailUidSet.toArray(),","));
		}
		//更新fin_collection表
		collectionDao.update(orginCollection);
		
		updateBargin(collection);
		
		/*	此处更新收款录入数据*/
		//判断是否有collection附表
		if (collection.getCollectionAttachList()!=null&&collection.getCollectionAttachList().size() > 0) {
			//从数据库查找出当前collectionAttach附表
			List<FinCollectionAttach> orginCollectionAttachList = collectionAttachDao.findByCollectionId(collection.getId());
			//从collection集合中查出collectionAttach附表
			List<FinCollectionAttach> collectionAttachList = collection.getCollectionAttachList();

			List<FinCollectionAttach> saveList = Lists.newArrayList();
			List<FinCollectionAttach> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();

			Map<Integer, FinCollectionAttach> orginFinCollectionMap = Maps.newHashMap();

			for (FinCollectionAttach collectionAttach : orginCollectionAttachList) {
				orginFinCollectionMap.put(collectionAttach.getId(), collectionAttach);
			}
			//判断哪些是新增的附表
			for (FinCollectionAttach attach : collectionAttachList) {
				FinCollectionAttach orgin = orginFinCollectionMap.get(attach.getId());
				if (orgin != null) {
					//更新的附表
					BeanUtils.copyProperties(attach, orgin);
					updateList.add(orgin);
					orginFinCollectionMap.remove(orgin.getId());
				} else {
					//新增的附表
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
				//新流程不发送邮件
				if(collection.getIsNewProcess() != 1) {
					//发送邮件
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
			//更新成员数据,根据id筛选 删除 or 添加 or 更新
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
			
			//添加集
			delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
			if (saveListInvoiceProjectMembers.size() > 0) {
				iFinCollectionMembersDao.insertAll(saveListInvoiceProjectMembers);
			}
			//更新集
			if (updateListInvoiceProjectMembers.size() > 0) {
				iFinCollectionMembersDao.batchUpdate(updateListInvoiceProjectMembers);
			}
			//删除集
			if (delListInvoiceProjectMembers.size() > 0) {
				//目前数据不删除，更改删除状态
				for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
					FinCollectionMembers sinInvoiceProjectMembersisD=iFinCollectionMembersDao.findById(delListInvoiceProjectMembers.get(i));
					sinInvoiceProjectMembersisD.setIsDeleted("1");
					iFinCollectionMembersDao.update(sinInvoiceProjectMembersisD);
				}
				//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
			}
		}else {
			/*此处更新发票表单数据*/
			if (collection.getIsInvoiced() != 0) {
				FinInvoiced invoiced = json.toJavaObject(FinInvoiced.class);
				FinInvoiced orgininInvoiced = invoicedDao.findById(orginCollection.getInvoicedId());
				//提交时未选择开具发票，再次提交选择开具发票，初始化发票数据
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
	 * 更新合同、收款、付款中所有项目
	 * */
	public void updateBargin(FinCollection collection){
		if(collection.getBarginId() != null && !"".equals(collection.getBarginId())){
			SaleBarginManage saleBarginManage = saleBarginManageDao.findById(collection.getBarginId());
			if(!saleBarginManage.getProjectManageId().equals(collection.getProjectId())){
				//更新合同表中对应的项目id
				saleBarginManage.setProjectManageId(collection.getProjectId());
				saleBarginManageDao.update(saleBarginManage);
				//更新收款表中对应的项目id
				List<FinCollection> collectionList = Lists.newArrayList();
				collectionList = collectionDao.findByBarginId(collection.getBarginId());
				if(collectionList.size() > 0){
					for (FinCollection finCollection : collectionList) {
						finCollection.setProjectId(collection.getProjectId());
					}
					collectionDao.batchUpdate(collectionList);
				}
			
				//更新付款表中对应的项目id
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
	 * 发送邮件
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
			logger.error("发送邮件 收款类型查找失败"+e);
		}

		String[] emailidArray = emailUid.split(",");
		//存流程中操作人的ID
		List<Integer> userIdListOfPorcess = new ArrayList<Integer>();
		//存流程中人的Email
		List<String> recipientsList = new ArrayList<String>();
		for (int i=0;i<emailidArray.length;i++){
			userIdListOfPorcess.add(Integer.valueOf(emailidArray[i]));	
		}
		recipientsList = iAdRecordDao.findEmailsByUserIdList(userIdListOfPorcess);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 构造邮件
		
		StringBuffer contentBuffer = new StringBuffer();
		String subject = "";
		if(flag == 1){
		subject = "OA收款提示";
		contentBuffer.append("<h3>");
		contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">出纳收款通知!");
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
			contentBuffer.append("</h3><br>于：");
			contentBuffer.append(collectionDate+"&nbsp;&nbsp;&nbsp;&nbsp;");
			contentBuffer.append("收取");
			contentBuffer.append(collection.getPayCompany());
			contentBuffer.append(sysDictData.getName() + "类型款项");
			contentBuffer.append(attach.getCollectionBill() + "&nbsp;元<br>");
			contentBuffer.append(projectManage.getName() + "项目&nbsp;&nbsp;&nbsp;&nbsp;");
			contentBuffer.append("累计已收款金额：" + ReceivedMoney + "&nbsp;元&nbsp;&nbsp;&nbsp;&nbsp;");
			contentBuffer.append("合同总金额：" + totalMoney + "&nbsp;元<br>");
		}
		contentBuffer.append("<br>详情请登陆OA收款管理模块进行查看!</br></span>\r\n");
		}else{
			subject = "OA收款退回提示";
			contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">");
			contentBuffer.append("<br>你于&nbsp;");
			contentBuffer.append(sdf.format(collection.getApplyTime())+"&nbsp;");
			contentBuffer.append("申请的收款申请单被退回。<br>相关批注:");
			contentBuffer.append(contents + "<br>");
			contentBuffer.append("<br>请尽快登陆OA进行处理!</br></span>\r\n");
		}
		String content = contentBuffer.toString();
		// 以线程方式发送邮件，避免邮件发送时间过长，造成前端等待过久
		Thread thread = new Thread() {
			private List<String> recipientsList;
			private String subject;
			private String content;
			private Message.RecipientType recipientType;

			@Override
			public void run() {
				// 发送邮件
				MailUtils.sendHtmlMail(recipientsList, subject, content, recipientType); // 以暗送的方式发送邮件
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
		logger.info("["+UserUtils.getCurrUser().getName()+"]" + "发送了一封收款邮件！收款ID：" + collection.getId());
		for (String email:recipientsList) {
			logger.info("邮箱地址 向"+email+"发送了一封收款邮件！");
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
			result.setResult("操作成功!");
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("没有id为：" + id + " 的对象！");
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
				result.setResult("操作成功!");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("附件不存在！");
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
				result.setResult("删除成功！");
			} catch (IOException e) {
				e.printStackTrace();
			}

		}
		else{
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("附件不存在！");
		}
		return result;
	}*/
}