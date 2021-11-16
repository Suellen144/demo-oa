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
import org.apache.commons.collections.MapUtils;
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
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.dao.IFinCollectionDao;
import com.reyzar.oa.dao.IFinInvoiceProjectMembersDao;
import com.reyzar.oa.dao.IFinInvoicedAttachDao;
import com.reyzar.oa.dao.IFinInvoicedDao;
import com.reyzar.oa.dao.IFinRevenueRecognitionDao;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinInvoiceProjectMembers;
import com.reyzar.oa.domain.FinInvoiced;
import com.reyzar.oa.domain.FinInvoicedAttach;
import com.reyzar.oa.domain.FinRevenueRecognition;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.service.finance.IFinInvoicedService;

@Service
@Transactional
public class FinInvoicedServiceImpl implements IFinInvoicedService {

	private final static Logger logger = Logger.getLogger(FinInvoicedServiceImpl.class);
	@Autowired
	private ActivitiUtils activitiUtils;
	@Autowired
	private IFinInvoicedDao invoiceDao;
	@Autowired
	private IFinInvoicedAttachDao invoiceAttachDao;
	@Autowired
	private IFinInvoiceProjectMembersDao iFinInvoiceProjectMembersDao;
	@Autowired
	private IAdRecordDao iAdRecordDao;
	@Autowired
	private ISaleProjectManageDao iSaleProjectManageDao;
	@Autowired
	private IFinRevenueRecognitionDao iFinRevenueRecognitionDao;
	@Autowired
	private ISysUserDao iSysUserDao;
	@Autowired
	private IUserPositionDao userPositionDao;
	@Autowired
	private ISysDeptDao iSysDeptDao;
	@Autowired
	private IFinCollectionDao iFinCollectionDao;

	@Override
	public List<FinInvoicedAttach> findAttachByInvoicedID(Integer invoicedId) {
		return invoiceAttachDao.findByInvoicedId(invoicedId);
	}

	@Override
	public List<FinInvoiced> findByBarginId(Integer barginId) {
		return invoiceDao.findByBarginId(barginId);
	}

	@Override
	public FinInvoiced findById(Integer id) {
		FinInvoiced finInvoiced=invoiceDao.findById(id);
		if(finInvoiced!=null&& finInvoiced.getBarginManageId()!=null) {
			List<SaleProjectManage> saleProjectManage=iSaleProjectManageDao.findProjectManageByBarginId(finInvoiced.getBarginManageId());
			if(saleProjectManage!=null && saleProjectManage.size()>0) {
				finInvoiced.setSaleProjectManage(saleProjectManage.get(0));
			}
			//获取收入确认数据
			List<FinRevenueRecognition> finRevenueRecognitions=iFinRevenueRecognitionDao.findByFinInvoicedId(finInvoiced.getId());
			if(finRevenueRecognitions!=null && finRevenueRecognitions.size()>0) {
				finInvoiced.setFinRevenueRecognition(finRevenueRecognitions.get(0));
			}
			double invoiceAmount=0.0;
			//获取 已开票金额
			List<FinCollection> finCollections=iFinCollectionDao.findByBarginIdAndCreateDate(finInvoiced.getBarginManageId(),finInvoiced.getCreateDate());
			for (int i = 0; i < finCollections.size(); i++) {
				if(finCollections.get(i).getBill()!=null) {
					invoiceAmount+=finCollections.get(i).getBill();
				}
			}
			List<FinInvoiced> finInvoiceds=invoiceDao.findByBarginIdAndCreateDate(finInvoiced.getBarginManageId(),finInvoiced.getCreateDate());
			for (int j = 0; j < finInvoiceds.size(); j++) {
				if(finInvoiceds.get(j).getInvoiceAmount()!=null ) {
					invoiceAmount+=finInvoiceds.get(j).getInvoiceAmount();
				}
			}
			finInvoiced.setInvoiceAmountTo(invoiceAmount);
		}
		if(finInvoiced!=null && finInvoiced.getApplyUser() !=null && finInvoiced.getApplyUser().getDeptId()!=null) {
			SysDept sysDept=iSysDeptDao.findById(finInvoiced.getApplyUser().getDeptId());
			if(sysDept!=null) {
				finInvoiced.getApplyUser().setDept(sysDept);
			}
		}
		return finInvoiced;
	}

	@Override
	public CrudResultDTO save(JSONObject json) {
		return null;
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		//处理收入确认与业绩贡献逻辑，成功则进行流程下一步
		 CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		 
		return result;
	}
	
    @Override
    public Page<FinInvoiced> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, 1000);
        Page<FinInvoiced> page = null;
        page = invoiceDao.findByPage(params);
        double invoiceAmount=0.0;
        if(page!=null && page.size()>0) {
        	FinInvoiced finInvoiced=new FinInvoiced();
        	for(int i=0;i<page.size();i++) {
        		if(page.get(i).getInvoiceAmount()!=null)
        		invoiceAmount+=page.get(i).getInvoiceAmount();
        		if(page.get(i).getApplyUser()!=null)
        		page.get(i).setApplyUserName(page.get(i).getApplyUser().getName());
        	}
        	finInvoiced.setInvoiceAmount(invoiceAmount);
        	finInvoiced.setCollectionCompany("累计");
        	page.add(finInvoiced);
        }
        return page;
    }
	
    @Override
    public Page<FinInvoiced> findByPageList(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);
        params=UserUtils.userByRole(user, params);
        PageHelper.startPage(pageNum, pageSize);
		if(MapUtils.getString(params,"status").equals("2")) {
			params.put("status","");
			params.put("status_a","1");
		}else {
			params.put("status_a","");
		}
        Page<FinInvoiced> page = invoiceDao.findByPage(params);
        return page;
    }
	@Override
	public CrudResultDTO saveInfo(JSONObject json) {
		 CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		 FinInvoiced finInvoiced=json.toJavaObject(FinInvoiced.class);
		 SysUser user = UserUtils.getCurrUser();
		 if (finInvoiced.getInvoiceAmount() == null || finInvoiced.getInvoiceAmount().equals("")) {
			 finInvoiced.setInvoiceAmount(0.00);
	        }
		 try {
			 Date currDate = new Date();
			 if(finInvoiced.getId() ==null ) {
				 finInvoiced.setCreateBy(user.getAccount());
				 finInvoiced.setCreateDate(currDate);
				 invoiceDao.save(finInvoiced);
				 List<FinInvoicedAttach> invoicedAttachList =finInvoiced.getInvoicedAttachList();
				 for (int i = 0; i < invoicedAttachList.size(); i++) {
					 FinInvoicedAttach finInvoicedAttach=invoicedAttachList.get(i);
					 finInvoicedAttach.setInvoicedId(finInvoiced.getId());
					 finInvoicedAttach.setCreateBy(user.getAccount());
					 finInvoicedAttach.setCreateDate(currDate);
					 invoiceAttachDao.save(finInvoicedAttach);
				}
				 List<FinInvoiceProjectMembers> finInvoiceProjectMembersList= finInvoiced.getFinInvoiceProjectMembersList();
				 for (int i = 0; i < finInvoiceProjectMembersList.size(); i++) {
					 FinInvoiceProjectMembers finInvoiceProjectMembers=finInvoiceProjectMembersList.get(i);
					 finInvoiceProjectMembers.setFinInvoicedId(finInvoiced.getId());
					 finInvoiceProjectMembers.setCreateBy(user.getAccount());
					 finInvoiceProjectMembers.setCreateDate(currDate);
					 iFinInvoiceProjectMembersDao.save(finInvoiceProjectMembers);
				}
			 }else {
				 FinInvoiced originFinInvoiced=invoiceDao.findById(finInvoiced.getId());
				 BeanUtils.copyProperties(finInvoiced, originFinInvoiced);
				 invoiceDao.update(originFinInvoiced);
				 //更新发票子表数据,根据id筛选 删除 or 添加 or 更新
				 List<FinInvoicedAttach> orginFinInvoicedAttachList = invoiceAttachDao.findByInvoicedId(originFinInvoiced.getId());
					List<FinInvoicedAttach> finInvoicedAttachList = finInvoiced.getInvoicedAttachList();
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
							attach.setInvoicedId(originFinInvoiced.getId());
							attach.setCreateBy(user.getAccount());
							attach.setCreateDate(new Date());
							saveList.add(attach);
						}
					}
					delList.addAll(orgininvoicedMap.keySet());
					if (saveList.size() > 0) {
						invoiceAttachDao.insertAll(saveList);
					}
					if (updateList.size() > 0) {
						invoiceAttachDao.batchUpdate(updateList);
					}
					if (delList.size() > 0) {
						invoiceAttachDao.deleteByIdList(delList);
					}
					//更新成员数据,根据id筛选 删除 or 添加 or 更新
					List<FinInvoiceProjectMembers> orginFinInvoiceProjectMembers = iFinInvoiceProjectMembersDao.findByFinInvoicedId(originFinInvoiced.getId());
					List<FinInvoiceProjectMembers> finInvoiceProjectMembersList= finInvoiced.getFinInvoiceProjectMembersList();
					if(finInvoiceProjectMembersList!=null && finInvoiceProjectMembersList.size()>0) {
					List<FinInvoiceProjectMembers> saveListInvoiceProjectMembers = Lists.newArrayList();
					List<FinInvoiceProjectMembers> updateListInvoiceProjectMembers = Lists.newArrayList();
					List<Integer> delListInvoiceProjectMembers = Lists.newArrayList();
					Map<Integer, FinInvoiceProjectMembers> orgininvoicedMapInvoiceProjectMembers = Maps.newHashMap();
					if(orginFinInvoiceProjectMembers!=null && orginFinInvoiceProjectMembers.size()>0) {
						for (FinInvoiceProjectMembers attach : orginFinInvoiceProjectMembers) {
							orgininvoicedMapInvoiceProjectMembers.put(attach.getId(), attach);
						}
					}
					if(finInvoiceProjectMembersList!=null && finInvoiceProjectMembersList.size()>0) {
						for(FinInvoiceProjectMembers attach: finInvoiceProjectMembersList) {
							if (attach.getId() != null) {
								attach.setUpdateBy(user.getAccount());
								attach.setUpdateDate(new Date());
								FinInvoiceProjectMembers orgin = orgininvoicedMapInvoiceProjectMembers.get(attach.getId());
								if (orgin != null) {
									BeanUtils.copyProperties(attach, orgin);
									updateListInvoiceProjectMembers.add(orgin);
									orgininvoicedMapInvoiceProjectMembers.remove(orgin.getId());
								}
							} else {
								attach.setFinInvoicedId(originFinInvoiced.getId());
								attach.setCreateBy(user.getAccount());
								attach.setCreateDate(new Date());
								saveListInvoiceProjectMembers.add(attach);
							}
						}
					}
					
					//添加集
					delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
					if (saveListInvoiceProjectMembers.size() > 0) {
						iFinInvoiceProjectMembersDao.insertAll(saveListInvoiceProjectMembers);
					}
					//更新集
					if (updateListInvoiceProjectMembers.size() > 0) {
						iFinInvoiceProjectMembersDao.batchUpdate(updateListInvoiceProjectMembers);
					}
					//删除集
					if (delListInvoiceProjectMembers.size() > 0) {
						//目前数据不删除，更改删除状态
						for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
							FinInvoiceProjectMembers sinInvoiceProjectMembersisD=iFinInvoiceProjectMembersDao.findById(delListInvoiceProjectMembers.get(i));
							sinInvoiceProjectMembersisD.setIsDeleted("1");
							iFinInvoiceProjectMembersDao.update(sinInvoiceProjectMembersisD);
						}
						//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
					}
					}
					//插入或更新 收入确认
					FinRevenueRecognition finRevenueRecognition=finInvoiced.getFinRevenueRecognition();
					if(finRevenueRecognition!=null &&finRevenueRecognition.getConfirmAmount() !=null) {
							finRevenueRecognition.setConfirmDate(new Date());
							if(("1").equals(finRevenueRecognition.getConfirmWay())) {
								finRevenueRecognition.setIsBeenConfirmed("1");
								//如果选择一次性确认，则设置分摊日期为null
								finRevenueRecognition.setShareStartDate(null);
								finRevenueRecognition.setShareEndDate(null);
								
							}else {
								finRevenueRecognition.setIsBeenConfirmed("0");
								finRevenueRecognition.setIsJob(0);
							}
							finRevenueRecognition.setSaleBarginManageId(originFinInvoiced.getBarginManageId());
							finRevenueRecognition.setFinInvoicedId(originFinInvoiced.getId());
							finRevenueRecognition.setConfirmPeople(user.getName());
						if(finRevenueRecognition.getId()== null) {
							finRevenueRecognition.setCreateBy(user.getAccount());
							finRevenueRecognition.setCreateDate(new Date());
							iFinRevenueRecognitionDao.save(finRevenueRecognition);
						}else {
							finRevenueRecognition.setUpdateBy(user.getAccount());
							finRevenueRecognition.setUpdateDate(new Date());
							iFinRevenueRecognitionDao.update(finRevenueRecognition);
						}
					}
				
			 }
		} catch (Exception e) {
			 result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
             e.printStackTrace();
             throw new BusinessException(e.getMessage());
		}
		return result;
	}
	@Override
	public CrudResultDTO deleteAttach(String path, Integer id) {
		CrudResultDTO result = new CrudResultDTO();
		FinInvoiced finInvoiced = invoiceDao.findById(id);
		System.out.println(path);
		if(finInvoiced.getAttachments()!=null){
			try {
				FileUtil.forceDelete(path);
				finInvoiced.setAttachments("");
				finInvoiced.setAttachName("");
				invoiceDao.update(finInvoiced);
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
	public CrudResultDTO submitinfo(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "提交成功！");
		ProcessInstance processInstance = null;
		SysUser user = UserUtils.getCurrUser();
		try {
			FinInvoiced finInvoiced=json.toJavaObject(FinInvoiced.class);
			SysUserPosition userPosition =new SysUserPosition();
			List<SaleProjectManage> saleProjectManage=iSaleProjectManageDao.findProjectManageByBarginId(finInvoiced.getBarginManageId());
			if(saleProjectManage!=null && saleProjectManage.size()>0) {
				finInvoiced.setSaleProjectManage(saleProjectManage.get(0));
				Integer userId=finInvoiced.getSaleProjectManage().getUserId();
				if(userId!=null &&!"".equals(userId)) {
					SysUser sysUser=iSysUserDao.findAllById(userId);
					userPosition =  userPositionDao.findByDeptAndLevel(sysUser.getDeptId());
				}
				if (finInvoiced.getInvoiceAmount() == null || finInvoiced.getInvoiceAmount().equals("")) {
					finInvoiced.setInvoiceAmount(0.00);
				}
			}

			 Date currDate = new Date();
			 if(finInvoiced.getId() ==null ) {
				 finInvoiced.setCreateBy(user.getAccount());
				 finInvoiced.setCreateDate(currDate);
				 invoiceDao.save(finInvoiced);
				 List<FinInvoicedAttach> invoicedAttachList =finInvoiced.getInvoicedAttachList();
				 for (int i = 0; i < invoicedAttachList.size(); i++) {
					 FinInvoicedAttach finInvoicedAttach=invoicedAttachList.get(i);
					 finInvoicedAttach.setInvoicedId(finInvoiced.getId());
					 finInvoicedAttach.setCreateBy(user.getAccount());
					 finInvoicedAttach.setCreateDate(currDate);
					 invoiceAttachDao.save(finInvoicedAttach);
				}
				 List<FinInvoiceProjectMembers> finInvoiceProjectMembersList= finInvoiced.getFinInvoiceProjectMembersList();
				 for (int i = 0; i < finInvoiceProjectMembersList.size(); i++) {
					 FinInvoiceProjectMembers finInvoiceProjectMembers=finInvoiceProjectMembersList.get(i);
					 finInvoiceProjectMembers.setFinInvoicedId(finInvoiced.getId());
					 finInvoiceProjectMembers.setCreateBy(user.getAccount());
					 finInvoiceProjectMembers.setCreateDate(currDate);
					 iFinInvoiceProjectMembersDao.save(finInvoiceProjectMembers);
				}
			 }else {
				 FinInvoiced originFinInvoiced=invoiceDao.findById(finInvoiced.getId());
				 BeanUtils.copyProperties(finInvoiced, originFinInvoiced);
				 invoiceDao.update(originFinInvoiced);
				 //更新发票子表数据,根据id筛选 删除 or 添加 or 更新
				 List<FinInvoicedAttach> orginFinInvoicedAttachList = invoiceAttachDao.findByInvoicedId(originFinInvoiced.getId());
					List<FinInvoicedAttach> finInvoicedAttachList = finInvoiced.getInvoicedAttachList();
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
							attach.setInvoicedId(originFinInvoiced.getId());
							attach.setCreateBy(user.getAccount());
							attach.setCreateDate(new Date());
							saveList.add(attach);
						}
					}
					delList.addAll(orgininvoicedMap.keySet());
					if (saveList.size() > 0) {
						invoiceAttachDao.insertAll(saveList);
					}
					if (updateList.size() > 0) {
						invoiceAttachDao.batchUpdate(updateList);
					}
					if (delList.size() > 0) {
						invoiceAttachDao.deleteByIdList(delList);
					}
					//更新成员数据,根据id筛选 删除 or 添加 or 更新
					List<FinInvoiceProjectMembers> orginFinInvoiceProjectMembers = iFinInvoiceProjectMembersDao.findByFinInvoicedId(originFinInvoiced.getId());
					List<FinInvoiceProjectMembers> finInvoiceProjectMembersList= finInvoiced.getFinInvoiceProjectMembersList();
					List<FinInvoiceProjectMembers> saveListInvoiceProjectMembers = Lists.newArrayList();
					List<FinInvoiceProjectMembers> updateListInvoiceProjectMembers = Lists.newArrayList();
					List<Integer> delListInvoiceProjectMembers = Lists.newArrayList();
					Map<Integer, FinInvoiceProjectMembers> orgininvoicedMapInvoiceProjectMembers = Maps.newHashMap();
					for (FinInvoiceProjectMembers attach : orginFinInvoiceProjectMembers) {
						orgininvoicedMapInvoiceProjectMembers.put(attach.getId(), attach);
					}
					for(FinInvoiceProjectMembers attach: finInvoiceProjectMembersList) {
						if (attach.getId() != null) {
							attach.setUpdateBy(user.getAccount());
							attach.setUpdateDate(new Date());
							FinInvoiceProjectMembers orgin = orgininvoicedMapInvoiceProjectMembers.get(attach.getId());
							if (orgin != null) {
								BeanUtils.copyProperties(attach, orgin);
								updateListInvoiceProjectMembers.add(orgin);
								orgininvoicedMapInvoiceProjectMembers.remove(orgin.getId());
							}
						} else {
							attach.setFinInvoicedId(originFinInvoiced.getId());
							attach.setCreateBy(user.getAccount());
							attach.setCreateDate(new Date());
							saveListInvoiceProjectMembers.add(attach);
						}
					}
					//添加集
					delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
					if (saveListInvoiceProjectMembers.size() > 0) {
						iFinInvoiceProjectMembersDao.insertAll(saveListInvoiceProjectMembers);
					}
					//更新集
					if (updateListInvoiceProjectMembers.size() > 0) {
						iFinInvoiceProjectMembersDao.batchUpdate(updateListInvoiceProjectMembers);
					}
					//删除集
					if (delListInvoiceProjectMembers.size() > 0) {
						//目前数据不删除，更改删除状态
						for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
							FinInvoiceProjectMembers sinInvoiceProjectMembersisD=iFinInvoiceProjectMembersDao.findById(delListInvoiceProjectMembers.get(i));
							sinInvoiceProjectMembersisD.setIsDeleted("1");
							iFinInvoiceProjectMembersDao.update(sinInvoiceProjectMembersisD);
						}
						//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
					}
					finInvoiced.setUpdateBy(user.getAccount());
					finInvoiced.setUpdateDate(currDate);
			 }
			//发起流程审批
			Map<String, Object> variables = Maps.newHashMap();
			Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
			businessParams.put("class", this.getClass().getName()); // 要反射的类全名
			businessParams.put("method", "findById"); // 调用方法
			businessParams.put("paramValue", new Object[]{finInvoiced.getId()}); // 方法参数的值集合
			//variables.put("toCeo", toCeo);//如开具发票需经总经理审批。否则跳过此阶段
			variables.put("businessParams", businessParams);
			variables.put("approved", true);
			if(finInvoiced.getSaleProjectManage().getUserId() == null) {
        		SysUser sysUser=iSysUserDao.findById(user.getId());
				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
				variables.put("userId", user.getId());
        	}else {
        		variables.put("userId", finInvoiced.getSaleProjectManage().getUserId());
        	}
			variables.put("userId2", userPosition.getUserId());
			
				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.Invoiced_KEY, user.getId().toString(), finInvoiced.getId().toString(), variables);
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
			finInvoiced.setProcessInstanceId(processInstance.getId());
			finInvoiced.setStatus(status);
			invoiceDao.update(finInvoiced);
		} catch (Exception e) {
			if (processInstance != null) {
				activitiUtils.deleteProcessInstance(processInstance.getId());
			}
			throw new BusinessException(e.getMessage());
		
		}
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		FinInvoiced finInvoiced = invoiceDao.findById(id);
		if(finInvoiced != null) {
			finInvoiced.setStatus(status);
			invoiceDao.update(finInvoiced);
			
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult("操作成功!");
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("没有id为：" + id + " 的对象！");
		}
		return result;
	}

	@Override
	public void sendMailToApple(Integer id, String contents) {
		FinInvoiced finInvoiced=invoiceDao.findById(id);
		sendMail(finInvoiced, finInvoiced.getApplyUserId()+",", 2, contents);
	}
	
	/**
	 * 发送邮件
	 */
	public void sendMail(FinInvoiced finInvoiced,String emailUid,Integer flag,String contents) {
		String[] emailidArray = emailUid.split(",");
		//存流程中操作人的ID
		List<Integer> userIdListOfPorcess = new ArrayList<Integer>();
		//存流程中人的Email
		List<String> recipientsList = new ArrayList<String>();
		for (int i=0;i<emailidArray.length;i++){
			userIdListOfPorcess.add(Integer.valueOf(emailidArray[i]));	
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		recipientsList = iAdRecordDao.findEmailsByUserIdList(userIdListOfPorcess);
		// 构造邮件
		StringBuffer contentBuffer = new StringBuffer();
		String subject = "";
		if(flag == 1){
			
		}else{
			subject = "OA发票退回提示";
			contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">");
			contentBuffer.append("<br>你于&nbsp;");
			contentBuffer.append(sdf.format(finInvoiced.getCreateDate())+"&nbsp;");
			contentBuffer.append("申请的发票申请单被退回。<br>相关批注:");
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
		logger.info("["+UserUtils.getCurrUser().getName()+"]" + "发送了一封发票邮件！发票ID：" + finInvoiced.getId());
		for (String email:recipientsList) {
			logger.info("邮箱地址 向"+email+"发送了一封发票邮件！");
		}
	}

	@Override
	public List<FinInvoiced> findByBarginIdAndCreateDate(Integer barginId, Date createDate) {
		return invoiceDao.findByBarginIdAndCreateDate(barginId, createDate);
	}
}