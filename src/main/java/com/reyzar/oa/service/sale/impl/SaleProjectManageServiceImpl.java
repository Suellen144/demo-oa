package com.reyzar.oa.service.sale.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;

import javax.mail.Message;
import javax.servlet.ServletOutputStream;

import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.dao.ISaleProjectMemberDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.dao.ISaleResearchRecordDao;
import com.reyzar.oa.dao.IFinCollectionDao;
import com.reyzar.oa.dao.IFinCollectionMembersDao;
import com.reyzar.oa.dao.IFinTravelreimburseDao;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.domain.*;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.ProjectDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.ActivitiUtils;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.MailUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.service.sale.ISaleProjectManageService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Service
@Transactional
public class SaleProjectManageServiceImpl implements ISaleProjectManageService {

	@Autowired
	private ISaleProjectManageDao projectManageDao;

	@Autowired
	private ISaleBarginManageDao SaleBarginManageDao;

	@Autowired
	private ISysDeptService deptService;

	@Autowired
	private ISaleProjectMemberDao projectMemberDao;

	@Autowired
	private IUserPositionDao userPositionDao;

	@Autowired
	private ActivitiUtils activitiUtils;

	@Autowired
	private ISysUserDao iSysUserDao;

	@Autowired
	private ISaleResearchRecordDao researchRecordDao;

	@Autowired
	private IFinCollectionDao collectionDao;

	@Autowired
	private IAdRecordDao iAdRecordDao;

	@Autowired
	private IFinCollectionMembersDao iFinCollectionMembersDao;

	@Autowired
	private IFinTravelreimburseDao travelreimburseDao;


    private final static Logger logger = Logger.getLogger(String.valueOf(SaleProjectManageServiceImpl.class));

	@Override
	public SysDept findDeptByDeptId(Integer id) {
		return projectManageDao.findDeptByDeptId(id);
	}

	@Override
	public Page<SaleProjectManage> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		try {
			PageHelper.startPage(pageNum, pageSize);
			return projectManageDao.findByPage(params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Page<SaleProjectManage> findByPage2(Map<String, Object> params, int pageNum, int pageSize) {
		try {
			PageHelper.startPage(pageNum, pageSize);
			return projectManageDao.findByPage2(params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Page<SaleProjectManage> findByPage3(Map<String, Object> params, int pageNum, int pageSize) {
		try {
			SysUser user =  UserUtils.getCurrUser();
			params=UserUtils.userByRole(user, params);
			PageHelper.startPage(pageNum, pageSize);
			return projectManageDao.findByPage3(params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Page<SaleProjectManage> findAll(Map<String, Object> params, int pageNum, int pageSize) {
		try {
			SysUser user =  UserUtils.getCurrUser();
			SysDept sysDept=deptService.findById(user.getDept().getId());
			params=UserUtils.userByRole(user, params);
			String status=params.get("status").toString();
			if("2".equals(status)) {
				params.put("statusNew", 1);
				params.put("status", 1);
			}else if("1".equals(status)) {
				params.put("statusNew", 2);
			}
			params.put("userId", user.getId());
			params.put("deptId", sysDept.getParentId());
			params.put("userDeptId", user.getDeptId());
			PageHelper.startPage(pageNum, pageSize);
			return projectManageDao.findList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public SaleProjectManage findById(Integer id) {
		SaleProjectManage project = projectManageDao.findById(id);
		 if(project!=null && project.getDeptD()==null) {
			 if(project.getPrincipal()!=null) {
				 SysDept sysDept=deptService.findById(project.getPrincipal().getDeptId());
				 if(sysDept!=null) {
					 project.setDeptD(sysDept);
					 project.setDutyDeptId(sysDept.getId());
				 }
			 }
		 }
		String deptIds = project.getDeptIds();
		if(StringUtils.isNotBlank(deptIds)) {
			List<Integer> idList = Lists.newArrayList();
			String[] deptIdList = deptIds.split(",");
			for(String deptId : deptIdList) {
				idList.add(Integer.valueOf(deptId));
			}
			if(idList.size() > 0) {
				project.setDeptList(deptService.findByIds(idList));
			}
		}
		return project;
	}

	@Override
	public CrudResultDTO save(JSONObject json, SysUser user) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SaleProjectManage project = json.toJavaObject(SaleProjectManage.class);

		try {
			if(project!=null && project.getUserId()!=null) {
				SysUser sysUser=iSysUserDao.findAllById(project.getUserId());
				if(sysUser!=null &&sysUser.getDeptId()!=null) {
					project.setDutyDeptId(sysUser.getDeptId());
				}
			}
			if(project.getId() == null) {
				if(project.getSize() * 0.02 >= 20000) {
					project.setResearchCostLines(20000.00);
				}else {
					project.setResearchCostLines(project.getSize() * 0.02);
				}
				project.setCreateBy(user.getAccount());
				project.setCreateDate(new Date());
				project.setStatus("1");//  1?????????     0?????????       -1?????????
				project.setProjectEndDate(null);
				projectManageDao.save(project);
				SaleResearchRecord record = new SaleResearchRecord();
				record.setUserId(user.getId());
				record.setProjectManageId(project.getId());
				record.setMtime(new Date());
				record.setCost(project.getResearchCostLines());
				record.setCreateBy(user.getAccount());
				record.setCreateDate(new Date());
				researchRecordDao.save(record);

				for (SaleProjectMember member : project.getProjectMemberList()) {
					SaleProjectMember member1 = new SaleProjectMember();
					member1.setUserId(member.getUserId());
					member1.setProjectManageId(project.getId());
					member1.setResultsProportion(member.getResultsProportion());
					member1.setCommissionProportion(member.getCommissionProportion());
					member1.setCreateBy(user.getAccount());
					member1.setCreateDate(new Date());
					projectMemberDao.save(member1);
				}
			} else {
				if(project.getSize()!=null&& project.getSize()!=0.0) {
					List<SaleResearchRecord> saleResearchRecordList = researchRecordDao.findByProjectId(project.getId());
					if(saleResearchRecordList.size() < 2) {
						if(project.getSize() * 0.02 >= 20000) {
							project.setResearchCostLines(20000.00);
						}else {
							project.setResearchCostLines(project.getSize() * 0.02);
						}
					}
				}
				SaleProjectManage old = projectManageDao.findById(project.getId());
				BeanUtils.copyProperties(project, old);
				old.setUserId(project.getUserId());
				old.setUpdateBy(user.getAccount());
				old.setUpdateDate(new Date());
				if("1".equals(project.getStatus())) {
					old.setProjectEndDate(null);
				}
				projectManageDao.update(old);

				//??????????????????,??????id?????? ?????? or ?????? or ??????
				List<SaleProjectMember> orginsaleProjectMember = projectMemberDao.findByProjectId(old.getId());
				List<SaleProjectMember> saleProjectMember= project.getProjectMemberList();
				List<SaleProjectMember> saveListInvoiceProjectMembers = Lists.newArrayList();
				List<SaleProjectMember> updateListInvoiceProjectMembers = Lists.newArrayList();
				List<Integer> delListInvoiceProjectMembers = Lists.newArrayList();
				Map<Integer, SaleProjectMember> orgininvoicedMapInvoiceProjectMembers = Maps.newHashMap();
				if(orginsaleProjectMember!=null && orginsaleProjectMember.size()>0) {
					for (SaleProjectMember attach : orginsaleProjectMember) {
						orgininvoicedMapInvoiceProjectMembers.put(attach.getId(), attach);
					}
				}
				if(saleProjectMember!=null && saleProjectMember.size()>0) {
					for(SaleProjectMember attach: saleProjectMember) {
						if (attach.getId() != null) {
							attach.setUpdateBy(user.getAccount());
							attach.setUpdateDate(new Date());
							SaleProjectMember orgin = orgininvoicedMapInvoiceProjectMembers.get(attach.getId());
							if (orgin != null) {
								BeanUtils.copyProperties(attach, orgin);
								updateListInvoiceProjectMembers.add(orgin);
								orgininvoicedMapInvoiceProjectMembers.remove(orgin.getId());
							}
						} else {
							attach.setProjectManageId(old.getId());
							attach.setCreateBy(user.getAccount());
							attach.setCreateDate(new Date());
							saveListInvoiceProjectMembers.add(attach);
						}
					}
				}

				//?????????
				delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
				if (saveListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.insertAll(saveListInvoiceProjectMembers);
				}
				//?????????
				if (updateListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.batchUpdate(updateListInvoiceProjectMembers);
				}
				//?????????
				if (delListInvoiceProjectMembers.size() > 0) {
					//??????????????????????????????????????????
					for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
						SaleProjectMember sinInvoiceProjectMembersisD=projectMemberDao.findById(delListInvoiceProjectMembers.get(i));
						sinInvoiceProjectMembersisD.setIsDeleted("1");
						projectMemberDao.update(sinInvoiceProjectMembersisD);
					}
					//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
				}
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id,String status) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		try {
			SaleProjectManage project = new SaleProjectManage();
			project.setId(id);
			project.setStatus(status);
			project.setUpdateBy(UserUtils.getCurrUser().getAccount());
			project.setUpdateDate(new Date());
			projectManageDao.setStatus(project);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????");
			e.printStackTrace();
		}

		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		try {
			projectManageDao.delete(id);

			List<SaleBarginManage> attachs = SaleBarginManageDao.findByProjectManageId(id);
			List<Integer> ids = new ArrayList<>();
			for (SaleBarginManage attach : attachs) {
				ids.add(attach.getId());
			}
			SaleBarginManageDao.deleteByIdList(ids);

		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "?????????????????????");
			throw new BusinessException(e.getMessage());
		}

		return result;
	}

	@Override
	public CrudResultDTO ajaxName(JSONObject json) {
		CrudResultDTO result =null;
		SaleProjectManage projectManage = json.toJavaObject(SaleProjectManage.class);
		try {
			   List<SaleProjectManage> manage   = projectManageDao.ajaxName(projectManage);
			   if(manage != null && !manage.equals("") && manage.size()>0){
				   result = new CrudResultDTO(CrudResultDTO.SUCCESS,"??????????????????????????????????????????");
			   }else{
				   result = new CrudResultDTO(CrudResultDTO.FAILED,"");
			   }
		} catch (Exception e) {
			 result = new CrudResultDTO(CrudResultDTO.SUCCESS,"?????????????????????????????????");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	//????????????????????????
	@Override
	public void exportExcel(ServletOutputStream out, Map<String, Object> paramMap) {

		try {
			List<ProjectDTO> dataList = projectManageDao.getExcelData(paramMap);
			List<SysDictData> typeList=projectManageDao.getProjectTyoe();
			for (ProjectDTO projectDTO : dataList) {
				for (SysDictData sysDictData : typeList) {
					if(projectDTO.getType().equals(sysDictData.getValue())){
						projectDTO.setType(sysDictData.getName());
					}
				}
				if("0".equals(projectDTO.getLocation())){
					projectDTO.setLocation("??????");
				}else{
					projectDTO.setLocation("??????");
				}
			}
			Context context = new Context();
			context.putVar("title", "????????????");
			context.putVar("dataList", dataList);
			ExcelUtil.export("projectManager.xls", out, context);
		} catch (Exception e) {
			e.printStackTrace();
			throw  new BusinessException();
		}

	}
	/**
	 * ?????????????????? -- ??????????????????
	 */
	@Override
	public void exportExcelList(ServletOutputStream out, Map<String, Object> paramMap) {
		try {
			Context context = new Context();
			List<SaleProjectManage> dataList = projectManageDao.getExcelDataList(paramMap);
			List<Map<String, String>> varList = new ArrayList<Map<String, String>>();
			for (SaleProjectManage mealOrder1 : dataList) {
	            if (mealOrder1 != null ) {
	                Map<String, String> vpd = new HashMap<String, String>();
	                vpd.put("name", mealOrder1.getName());
	                vpd.put("principalName", mealOrder1.getPrincipalName());
	                BigDecimal a=new BigDecimal(mealOrder1.getSize());
	                DecimalFormat df=new DecimalFormat(",###,##0.00"); //??????????????????
	                vpd.put("sizes", String.valueOf(df.format(a)));
	                vpd.put("applicantName", mealOrder1.getApplicantName());
	                vpd.put("submitDates", mealOrder1.getSubmitDates());
	                vpd.put("applicationTypes", mealOrder1.getApplicationTypes());
	                vpd.put("statusNews", mealOrder1.getStatusNews());
	                varList.add(vpd);
	            }
	        }
			context.putVar("title", "??????????????????");
			context.putVar("dataList", varList);
			ExcelUtil.export("projectManagerList.xls", out, context);
		} catch (Exception e) {
			e.printStackTrace();
			throw  new BusinessException();
		}

	}

	@Override
	public List<SaleProjectManage> findProjectManageByBarginId(Integer barginId) {
		return projectManageDao.findProjectManageByBarginId(barginId);
	}

	@Override
	public CrudResultDTO setStatusNew(Integer id, String status) {
		CrudResultDTO result = new CrudResultDTO();
		try {
			SaleProjectManage projectManage = projectManageDao.findById(id);
			if(projectManage != null) {
				//??????????????????????????????????????????????????????
				if(status == "5" && projectManage.getProjectDate() == null) {
					projectManage.setProjectDate(new Date());
				}
				projectManage.setStatusNew(Integer.valueOf(status));
				projectManageDao.update(projectManage);

				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("????????????!");
			} else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("??????ID??????" + id + " ????????????");
			}
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult(e.getMessage());
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO submit(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SaleProjectManage project = json.toJavaObject(SaleProjectManage.class);

		SysUser user = UserUtils.getCurrUser();
		ProcessInstance processInstance = null;

		try {
			SysUserPosition userPosition = new SysUserPosition();
			if(project!=null && project.getDutyDeptId()!=null) {
				userPosition=userPositionDao.findByDeptAndLevel(project.getDutyDeptId());
			}else if(project.getUserId()!=null) {
				SysUser sysUser=iSysUserDao.findById(project.getUserId());
				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
		}
			if(project!=null && project.getId() == null) {
				if(project.getSize() * 0.02 >= 20000) {
					project.setResearchCostLines(20000.00);
				}else {
					project.setResearchCostLines(project.getSize() * 0.02);
				}
				project.setCreateBy(user.getAccount());
				project.setCreateDate(new Date());
				project.setSubmitDate(new Date());
				project.setStatus("1");//  1?????????     0?????????       -1?????????
				projectManageDao.save(project);

				SaleResearchRecord record = new SaleResearchRecord();
				record.setUserId(user.getId());
				record.setProjectManageId(project.getId());
				record.setMtime(new Date());
				record.setCost(project.getResearchCostLines());
				record.setCreateBy(user.getAccount());
				record.setCreateDate(new Date());
				researchRecordDao.save(record);

				for (SaleProjectMember member : project.getProjectMemberList()) {
					SaleProjectMember member1 = new SaleProjectMember();
					member1.setUserId(member.getUserId());
					member1.setProjectManageId(project.getId());
					member1.setResultsProportion(member.getResultsProportion());
					member1.setCommissionProportion(member.getCommissionProportion());
					member1.setCreateBy(user.getAccount());
					member1.setCreateDate(new Date());
					projectMemberDao.save(member1);
				}

				// ????????????????????????
				Map<String, Object> variables = Maps.newHashMap();
				Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
				businessParams.put("class", this.getClass().getName()); // ?????????????????????
				businessParams.put("method", "findById"); // ????????????
				businessParams.put("paramValue", new Object[] { project.getId() }); // ????????????????????????

				variables.put("businessParams", businessParams);
				variables.put("approved", true);
				variables.put("userId", project.getUserId());
				variables.put("userId2", userPosition.getUserId());

				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.PROJECT_KEY, user.getId().toString(), project.getId().toString(), variables);

				// ????????????????????????????????????
				List<Map<String, Object>> commentList = Lists.newArrayList();
				Map<String, Object> commentMap = Maps.newHashMap();
				commentMap.put("node", "????????????");
				commentMap.put("approver", user.getName());
				commentMap.put("comment", "");
				commentMap.put("approveResult", "????????????");
				commentMap.put("approveDate", new Date());
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
				project.setProcessInstanceId(processInstance.getId());
				project.setStatusNew(Integer.parseInt(status));
				projectManageDao.update(project);
			} else {
				SaleProjectManage old = projectManageDao.findById(project.getId());
				BeanUtils.copyProperties(project, old);
				old.setUserId(project.getUserId());
				old.setUpdateBy(user.getAccount());
				old.setUpdateDate(new Date());
				old.setSubmitDate(new Date());

				projectManageDao.update(old);

				//??????????????????,??????id?????? ?????? or ?????? or ??????
				List<SaleProjectMember> orginsaleProjectMember = projectMemberDao.findByProjectId(old.getId());
				List<SaleProjectMember> saleProjectMember= project.getProjectMemberList();
				List<SaleProjectMember> saveListInvoiceProjectMembers = Lists.newArrayList();
				List<SaleProjectMember> updateListInvoiceProjectMembers = Lists.newArrayList();
				List<Integer> delListInvoiceProjectMembers = Lists.newArrayList();
				Map<Integer, SaleProjectMember> orgininvoicedMapInvoiceProjectMembers = Maps.newHashMap();
				if(orginsaleProjectMember!=null && orginsaleProjectMember.size()>0) {
					for (SaleProjectMember attach : orginsaleProjectMember) {
						orgininvoicedMapInvoiceProjectMembers.put(attach.getId(), attach);
					}
				}
				if(saleProjectMember!=null && saleProjectMember.size()>0) {
					for(SaleProjectMember attach: saleProjectMember) {
						if (attach.getId() != null) {
							attach.setUpdateBy(user.getAccount());
							attach.setUpdateDate(new Date());
							SaleProjectMember orgin = orgininvoicedMapInvoiceProjectMembers.get(attach.getId());
							if (orgin != null) {
								BeanUtils.copyProperties(attach, orgin);
								updateListInvoiceProjectMembers.add(orgin);
								orgininvoicedMapInvoiceProjectMembers.remove(orgin.getId());
							}
						} else {
							attach.setProjectManageId(old.getId());
							attach.setCreateBy(user.getAccount());
							attach.setCreateDate(new Date());
							saveListInvoiceProjectMembers.add(attach);
						}
					}
				}

				//?????????
				delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
				if (saveListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.insertAll(saveListInvoiceProjectMembers);
				}
				//?????????
				if (updateListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.batchUpdate(updateListInvoiceProjectMembers);
				}
				//?????????
				if (delListInvoiceProjectMembers.size() > 0) {
					//??????????????????????????????????????????
					for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
						SaleProjectMember sinInvoiceProjectMembersisD=projectMemberDao.findById(delListInvoiceProjectMembers.get(i));
						sinInvoiceProjectMembersisD.setIsDeleted("1");
						projectMemberDao.update(sinInvoiceProjectMembersisD);
					}
					//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
				}

				// ????????????????????????
				Map<String, Object> variables = Maps.newHashMap();
				Map<String, Object> businessParams = Maps.newHashMap(); // businessParams ????????? ActivitiService ?????????????????????
				businessParams.put("class", this.getClass().getName()); // ?????????????????????
				businessParams.put("method", "findById"); // ????????????
				businessParams.put("paramValue", new Object[] { old.getId() }); // ????????????????????????

				variables.put("businessParams", businessParams);
				variables.put("approved", true);
				variables.put("userId", old.getUserId());
				variables.put("userId2", userPosition.getUserId());

				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.PROJECT_KEY, user.getId().toString(), old.getId().toString(), variables);

				// ????????????????????????????????????
				List<Map<String, Object>> commentList = Lists.newArrayList();
				Map<String, Object> commentMap = Maps.newHashMap();
				commentMap.put("node", "????????????");
				commentMap.put("approver", user.getName());
				commentMap.put("comment", "");
				commentMap.put("approveResult", "????????????");
				commentMap.put("approveDate", new Date());
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
				old.setProcessInstanceId(processInstance.getId());
				old.setStatusNew(Integer.parseInt(status));
				projectManageDao.update(old);
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public List<SaleProjectAchievement> findPerformanceContributionList(Map<String, Object> paramsMap) {
		Map<Integer,Object> map = new HashMap<>();
		List<SaleProjectManage> projectIds = collectionDao.findProjectId(paramsMap); //???????????????????????????
		List<SaleProjectAchievement> saleProjectAchievementlist = new ArrayList<SaleProjectAchievement>();
		if(projectIds != null && projectIds.size() > 0) {
			for (int i = 0; i < projectIds.size(); i++) {
				List<SaleBarginManage> Bargins = collectionDao.findBarginByProjectId(projectIds.get(i).getId());//??????????????????????????????????????????????????????
				if(Bargins != null && Bargins.size() > 0) {
					for (int b = 0; b < Bargins.size(); b++) {
						List<FinInvoiced> finInvoiceds = collectionDao.findInvoicedById(Bargins.get(b).getId());//????????????Id?????????????????????????????????
						if (finInvoiceds != null && finInvoiceds.size()>0) {
							for (int f = 0; f < finInvoiceds.size(); f++) {
                                List<FinRevenueRecognition>  finRevenueRecognitions = collectionDao.findRevenueRecognition(finInvoiceds.get(f).getId());//????????????????????????
								List<FinInvoiceProjectMembers> InvoiceProjectMembersList = collectionDao.findInvoiceProjectMembersById(finInvoiceds.get(f).getId());//????????????????????????????????????
								if (InvoiceProjectMembersList != null && InvoiceProjectMembersList.size() > 0) {
									for (int c = 0; c < InvoiceProjectMembersList.size(); c++) {
										SysUser sysuser = collectionDao.findUserById(InvoiceProjectMembersList.get(c).getUserId());
										double resultsProportion = 0; //????????????????????????
										String stringStr = InvoiceProjectMembersList.get(c).getResultsProportion();
										if (stringStr.substring(stringStr.length() - 1).equals("%")) {
											resultsProportion = Double.parseDouble(stringStr.replace("%", "")) * 0.01;
										} else {
											resultsProportion = Double.valueOf(stringStr) * 0.01;
										}
										if(finRevenueRecognitions != null && finRevenueRecognitions.size()>0) {
											DecimalFormat dt = new DecimalFormat("#.00");//??????????????????
											if (finRevenueRecognitions.get(0).getConfirmWay().equals("1")) {//??????????????????????????????
												double resultsContribution = finRevenueRecognitions.get(0).getResultsContribution();//??????????????????????????????
												String userRseultAmount = dt.format(resultsContribution * resultsProportion);//???????????????????????????
												if (map.containsKey(sysuser.getId())) {
													map.put(sysuser.getId(), (double) map.get(sysuser.getId()) + Double.valueOf(userRseultAmount));
												} else {
													map.put(sysuser.getId(), Double.parseDouble(userRseultAmount));
												}
											} else {//???????????????????????????
												SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//???????????????
												try {
													if (!df.parse(df.format(finRevenueRecognitions.get(0).getShareEndDate())).before(df.parse(df.format(new Date())))) {
														double resultsContribution = finRevenueRecognitions.get(0).getResultsContribution();//??????????????????
														//??????????????????????????????????????????
														int days = daysBetween(finRevenueRecognitions.get(0).getShareStartDate(), finRevenueRecognitions.get(0).getShareEndDate());
														double resultsContributionByDay = resultsContribution / days; //????????????????????????
														//??????????????????????????????????????????
														int endDays = daysBetween(finRevenueRecognitions.get(0).getShareStartDate(),new Date());
														double resultsContributionByDayByDays = resultsContributionByDay * endDays; //???????????????????????????
														String userRseultAmount = dt.format(resultsContributionByDayByDays * resultsProportion);//???????????????????????????
														if (map.containsKey(sysuser.getId())) {
															map.put(sysuser.getId(), (double) map.get(sysuser.getId()) + Double.parseDouble(userRseultAmount));
														} else {
															map.put(sysuser.getId(), Double.parseDouble(userRseultAmount));
														}
													}else {//??????????????????????????????????????????????????????????????????????????????
														double resultsContribution = finRevenueRecognitions.get(0).getResultsContribution();//??????????????????
														String userRseultAmount = dt.format(resultsContribution * resultsProportion);//???????????????????????????
														if (map.containsKey(sysuser.getId())) {
															map.put(sysuser.getId(), (double) map.get(sysuser.getId()) + Double.parseDouble(userRseultAmount));
														} else {
															map.put(sysuser.getId(), Double.parseDouble(userRseultAmount));
														}
													}
												} catch (Exception e) {}
											}
										}
									}
								} else { continue; }
							}
						} else {continue;}
					}
				} else { continue; }
			}
		}
		//???map?????????????????????
		SaleProjectAchievement saleProjectAchievement = null;
		if(map != null) {
			for (Map.Entry<Integer, Object> entry : map.entrySet()) {
				saleProjectAchievement = new SaleProjectAchievement();
				SysUser sysuser = collectionDao.findUserById(entry.getKey());
				saleProjectAchievement.setPerformanceContribution(entry.getValue().toString());
				saleProjectAchievement.setUserName(sysuser.getName());
				saleProjectAchievement.setDeptId(sysuser.getDeptId());
				AdRecord record = iAdRecordDao.findByUserid(entry.getKey());
				saleProjectAchievement.setAdRecord(record);
				saleProjectAchievementlist.add(saleProjectAchievement);
			}
		}
		if(saleProjectAchievementlist != null && saleProjectAchievementlist.size() >0) {
			//?????????????????????
			Collections.sort(saleProjectAchievementlist, new Comparator<SaleProjectAchievement>() {
				@Override
				public int compare(SaleProjectAchievement s1, SaleProjectAchievement s2) {
					//??????
					return new Double(s2.getPerformanceContribution()).compareTo(new Double(s1.getPerformanceContribution()));
				}
			});
			//?????????????????????
			for (int s = 0; s < saleProjectAchievementlist.size(); s++) {
				SaleProjectAchievement sp = saleProjectAchievementlist.get(s);
				if(sp.getPerformanceRank() == null || sp.getPerformanceRank() == "") {
					if(s == 0) {
						sp.setPerformanceRank(String.valueOf(s + 1));
					} else {
						SaleProjectAchievement sp2 = saleProjectAchievementlist.get(s-1);
						sp.setPerformanceRank(String.valueOf(Integer.parseInt(sp2.getPerformanceRank())+1));
					}
				}
				for (int e = s+1; e < saleProjectAchievementlist.size(); e++) {
					SaleProjectAchievement sp2 = saleProjectAchievementlist.get(e);
					if(sp.getPerformanceContribution().equals(sp2.getPerformanceContribution())) {
						sp2.setPerformanceRank(sp.getPerformanceRank());
					}
					break;
				}
			}
		}

		return saleProjectAchievementlist;
	}


	@Override
	public List<SaleProjectAchievement> findProjectAchievementList(Map<String, Object> paramsMap) {
		Map<Integer,Object> map = new HashMap<>();
		List<SaleProjectManage> projectIds = collectionDao.findProjectId(paramsMap); //???????????????????????????
		List<SaleProjectAchievement> saleProjectAchievementlist = new ArrayList<SaleProjectAchievement>();
		if(projectIds != null && projectIds.size() > 0) {
			for (int i = 0; i < projectIds.size(); i++) {
				List<SaleBarginManage> Bargins = collectionDao.findBarginByProjectId(projectIds.get(i).getId());//???????????????????????????????????????
				if(Bargins != null && Bargins.size() > 0) {
					for (int b = 0; b < Bargins.size(); b++) {
						//??????????????????--??????????????????id???????????????????????????
						List<FinCollection>  finCollectionList = collectionDao.findCollectionInfo(Bargins.get(b).getId(),"5");//???????????????
						if (finCollectionList != null && finCollectionList.size() >0) {
							//????????????id??????????????????
							for(int f=0;f<finCollectionList.size();f++) {
								List<FinCollectionMembers> FinCollectionMembers =iFinCollectionMembersDao.findByFinCollectionId(finCollectionList.get(f).getId());//????????????id????????????????????????
								if(FinCollectionMembers != null && FinCollectionMembers.size()>0) {
									for (int c = 0; c < FinCollectionMembers.size(); c++) {
										SysUser sysuser = collectionDao.findUserById(FinCollectionMembers.get(c).getUserId());
										DecimalFormat dt = new DecimalFormat("#.00");//??????????????????
										if (finCollectionList != null && finCollectionList.size() > 0) {
											String stringStr = FinCollectionMembers.get(c).getCommissionProportion();
											double commissionProportion = 0;
											if (stringStr.substring(stringStr.length() - 1).equals("%")) {
												commissionProportion = Double.parseDouble(stringStr.replace("%", "")) * 0.01;
											} else {
												commissionProportion = Double.valueOf(stringStr) * 0.01;
											}
											String userAllocations = dt.format(finCollectionList.get(0).getAllocations() * commissionProportion);//?????????????????????????????????
											if (map.containsKey(sysuser.getId())) {
												map.put(sysuser.getId(), (double) map.get(sysuser.getId()) + Double.parseDouble(userAllocations));
											} else {
												map.put(sysuser.getId(), Double.parseDouble(userAllocations));
											}
										}
									}
								}else {continue;}
							}
						} else {continue;}
					}
				} else { continue; }
			}
		}
		//???map?????????????????????
		SaleProjectAchievement saleProjectAchievement = null;
		if(map != null) {
			for (Map.Entry<Integer, Object> entry : map.entrySet()) {
				saleProjectAchievement = new SaleProjectAchievement();
				SysUser sysuser = collectionDao.findUserById(entry.getKey());
				saleProjectAchievement.setAllocations(entry.getValue().toString());
				saleProjectAchievement.setUserName(sysuser.getName());
				saleProjectAchievement.setDeptId(sysuser.getDeptId());
				AdRecord record = iAdRecordDao.findByUserid(entry.getKey());
				saleProjectAchievement.setAdRecord(record);
				saleProjectAchievementlist.add(saleProjectAchievement);
			}
		}
		if(saleProjectAchievementlist != null && saleProjectAchievementlist.size() >0) {
			//?????????????????????
			Collections.sort(saleProjectAchievementlist, new Comparator<SaleProjectAchievement>() {
				@Override
				public int compare(SaleProjectAchievement s1, SaleProjectAchievement s2) {
					//??????
					return new Double(s2.getAllocations()).compareTo(new Double(s1.getAllocations()));
				}
			});
		}

		return saleProjectAchievementlist;
	}

	@Override
	public CrudResultDTO findByProjectName(JSONObject json) {
        CrudResultDTO result = null;
        SaleProjectManage saleProjectManage = json.toJavaObject(SaleProjectManage.class);

        try {
            List<SaleProjectManage> saleProjectManageAttach = projectManageDao.findByProjectName(saleProjectManage);

            if (saleProjectManageAttach != null && saleProjectManageAttach.size() > 0) {
                result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????????????????????????????");
            } else {
                result = new CrudResultDTO(CrudResultDTO.FAILED, "?????????????????????");
            }

        } catch (Exception e) {
            result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
            e.printStackTrace();
            throw new BusinessException(e.getMessage());
        }
        return result;
    }


	/**
	 * ??????excel --??????????????????
	 * @param out
	 * @param paramMap
	 */
	@Override
	public void exportExcelOne(ServletOutputStream out, Map<String, Object> paramMap){
		Context context = new Context();
		SaleProjectManage saleProjectManage = new SaleProjectManage();
		if(MapUtils.getString(paramMap,"status").equals("2")) {
			paramMap.put("statusNew", 1);
			paramMap.put("status", 1);
			List<SaleProjectManage> saleProjectManageList=projectManageDao.findList(paramMap);
			context.putVar("dataList", saleProjectManageList);
			ExcelUtil.export("projectManage.xls", out, context);
		}else {
			List<SaleProjectManage> saleProjectManageList=projectManageDao.findList(paramMap);
			context.putVar("dataList", saleProjectManageList);
			ExcelUtil.export("projectManage.xls", out, context);
		}
	}

	/**
	 * ?????????????????????????????????
	 * smdate???????????????
	 * bdate ???????????????
	 * */
	public static int daysBetween(Date smdate,Date bdate) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(smdate);
		long time1 = cal.getTimeInMillis();
		cal.setTime(bdate);
		long time2 = cal.getTimeInMillis();
		long between_days=(time2-time1)/(1000*3600*24);
		return Integer.parseInt(String.valueOf(between_days));
	}


	@Override
	public CrudResultDTO updateIsDeleted(Integer id) {
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "????????????!");
        try {
            if(id!=null) {
            	Map<String, Object> params =new HashMap<String, Object>();
            	params.put("projectManageId", id);
            	Page<FinTravelreimburse> finTravelreimburses=travelreimburseDao.findByPage1(params);
            	if(finTravelreimburses == null || finTravelreimburses.size()<=0) {
            		SaleProjectManage saleProjectManage=projectManageDao.findById(id);
            		if(saleProjectManage!=null) {
            			saleProjectManage.setIsDeleted("1");
            			//??????????????????
            			projectManageDao.update(saleProjectManage);
            		}else {
            			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "?????????????????????????????????");
            		}
            	}else {
            		result = new CrudResultDTO(CrudResultDTO.SUCCESS, "??????????????????????????????");
            	}
            }else {
            	result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "?????????????????????????????????");
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
        SaleProjectManage saleProjectManage = projectManageDao.findById(id);
        if (saleProjectManage.getAttachments() != null) {
            try {
                FileUtil.forceDelete(path);
                saleProjectManage.setAttachName("");
                saleProjectManage.setAttachments("");
                projectManageDao.update(saleProjectManage);
                result.setCode(CrudResultDTO.SUCCESS);
                result.setResult("???????????????");
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("??????????????????");
        }
        return result;
    }

	@Override
	public CrudResultDTO sendMail(Integer id, String comment) {
        CrudResultDTO result = new CrudResultDTO();
        SaleProjectManage saleProjectManage = projectManageDao.findById(id);
        Integer userId = saleProjectManage.getApplicant();
        //??????????????????????????????
        String userEmail = iAdRecordDao.findByUserid(userId).getEmail();
        //???????????????Email
        List<String> recipientsList = new ArrayList<>();
        recipientsList.add(userEmail);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            //????????????
            String subject = "OA??????????????????";
            StringBuffer contentBuffer = new StringBuffer();
            contentBuffer.append("<h3>");
            contentBuffer.append("<span style=\\\"font-family:????????????, Microsoft YaHei\\\">??????????????????!");
            contentBuffer.append("</h3><br>?????????");
            contentBuffer.append(sdf.format(saleProjectManage.getSubmitDate()) + "&nbsp;");
            contentBuffer.append("???????????????????????????????????????<br>???????????????:");
            contentBuffer.append(saleProjectManage.getName()+"&nbsp;");
            contentBuffer.append("<br>???????????????:");
            contentBuffer.append(comment + "<br>");
            contentBuffer.append("<br>???????????????OA??????????????????????????????!</br></span>\r\n");
            String content = contentBuffer.toString();
            //???????????????????????????????????????????????????????????????????????????????????????
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
            logger.info("????????????????????????????????????ID???" + saleProjectManage.getId());
            for (String email : recipientsList) {
                logger.info("???" + email + "??????????????????????????????");
            }
            result.setCode(CrudResultDTO.SUCCESS);
            result.setResult("???????????????");
        } catch (Exception e) {
            e.printStackTrace();
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("???????????????");
        }
        return result;
    }

	@Override
	public CrudResultDTO saveInfoOld(JSONObject json, SysUser user) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "???????????????");
		SaleProjectManage project = json.toJavaObject(SaleProjectManage.class);

		try {
			if(project!=null && project.getUserId()!=null) {
				SysUser sysUser=iSysUserDao.findAllById(project.getUserId());
				if(sysUser!=null &&sysUser.getDeptId()!=null) {
					project.setDutyDeptId(sysUser.getDeptId());
				}
			}
			if(project.getId() == null) {
				project.setCreateBy(user.getAccount());
				project.setCreateDate(new Date());
				project.setStatus("1");//  1?????????     0?????????       -1?????????
				project.setProjectEndDate(null);
				project.setStatusNew(5);
				project.setIsNewProject(1);
				projectManageDao.save(project);
			} else {
				SaleProjectManage old = projectManageDao.findById(project.getId());
				BeanUtils.copyProperties(project, old);
				old.setUserId(project.getUserId());
				old.setUpdateBy(user.getAccount());
				old.setUpdateDate(new Date());
				if("1".equals(project.getStatus())) {
					old.setProjectEndDate(null);
				}
				projectManageDao.update(old);
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "???????????????");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public SaleProjectManage findByIdByCreateDate(Integer id) {
		return projectManageDao.findByIdByCreateDate(id);
	}
}