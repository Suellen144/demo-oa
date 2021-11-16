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
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
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
				project.setStatus("1");//  1：活动     0：注销       -1：关闭
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

				//更新成员数据,根据id筛选 删除 or 添加 or 更新
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

				//添加集
				delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
				if (saveListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.insertAll(saveListInvoiceProjectMembers);
				}
				//更新集
				if (updateListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.batchUpdate(updateListInvoiceProjectMembers);
				}
				//删除集
				if (delListInvoiceProjectMembers.size() > 0) {
					//目前数据不删除，更改删除状态
					for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
						SaleProjectMember sinInvoiceProjectMembersisD=projectMemberDao.findById(delListInvoiceProjectMembers.get(i));
						sinInvoiceProjectMembersisD.setIsDeleted("1");
						projectMemberDao.update(sinInvoiceProjectMembersisD);
					}
					//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
				}
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO setStatus(Integer id,String status) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			SaleProjectManage project = new SaleProjectManage();
			project.setId(id);
			project.setStatus(status);
			project.setUpdateBy(UserUtils.getCurrUser().getAccount());
			project.setUpdateDate(new Date());
			projectManageDao.setStatus(project);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "操作失败！");
			e.printStackTrace();
		}

		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			projectManageDao.delete(id);

			List<SaleBarginManage> attachs = SaleBarginManageDao.findByProjectManageId(id);
			List<Integer> ids = new ArrayList<>();
			for (SaleBarginManage attach : attachs) {
				ids.add(attach.getId());
			}
			SaleBarginManageDao.deleteByIdList(ids);

		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "删除项目失败！");
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
				   result = new CrudResultDTO(CrudResultDTO.SUCCESS,"项目名称已存在，请重新填写！");
			   }else{
				   result = new CrudResultDTO(CrudResultDTO.FAILED,"");
			   }
		} catch (Exception e) {
			 result = new CrudResultDTO(CrudResultDTO.SUCCESS,"项目名称校验出现异常！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	//项目详情的的导出
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
					projectDTO.setLocation("公司");
				}else{
					projectDTO.setLocation("其他");
				}
			}
			Context context = new Context();
			context.putVar("title", "项目详情");
			context.putVar("dataList", dataList);
			ExcelUtil.export("projectManager.xls", out, context);
		} catch (Exception e) {
			e.printStackTrace();
			throw  new BusinessException();
		}

	}
	/**
	 * 导出项目列表 -- 项目管理模块
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
	                DecimalFormat df=new DecimalFormat(",###,##0.00"); //保留二位小数
	                vpd.put("sizes", String.valueOf(df.format(a)));
	                vpd.put("applicantName", mealOrder1.getApplicantName());
	                vpd.put("submitDates", mealOrder1.getSubmitDates());
	                vpd.put("applicationTypes", mealOrder1.getApplicationTypes());
	                vpd.put("statusNews", mealOrder1.getStatusNews());
	                varList.add(vpd);
	            }
	        }
			context.putVar("title", "项目申请列表");
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
				//如果审批状态为已归档并且立项时间为空
				if(status == "5" && projectManage.getProjectDate() == null) {
					projectManage.setProjectDate(new Date());
				}
				projectManage.setStatusNew(Integer.valueOf(status));
				projectManageDao.update(projectManage);

				result.setCode(CrudResultDTO.SUCCESS);
				result.setResult("操作成功!");
			} else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("没有ID为：" + id + " 的对象！");
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
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
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
				project.setStatus("1");//  1：活动     0：注销       -1：关闭
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

				// 启动项目立项流程
				Map<String, Object> variables = Maps.newHashMap();
				Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
				businessParams.put("class", this.getClass().getName()); // 要反射的类全名
				businessParams.put("method", "findById"); // 调用方法
				businessParams.put("paramValue", new Object[] { project.getId() }); // 方法参数的值集合

				variables.put("businessParams", businessParams);
				variables.put("approved", true);
				variables.put("userId", project.getUserId());
				variables.put("userId2", userPosition.getUserId());

				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.PROJECT_KEY, user.getId().toString(), project.getId().toString(), variables);

				// 跳过初始时的提交申请节点
				List<Map<String, Object>> commentList = Lists.newArrayList();
				Map<String, Object> commentMap = Maps.newHashMap();
				commentMap.put("node", "提交申请");
				commentMap.put("approver", user.getName());
				commentMap.put("comment", "");
				commentMap.put("approveResult", "提交成功");
				commentMap.put("approveDate", new Date());
				commentList.add(commentMap);
				variables.put("commentList", commentList); // 初始化提交申请节点的备注列表

				List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
				for(Task task : taskList) {
					if(task.getName().equals("提交申请")) {
						activitiUtils.completeTask(task.getId(), variables);
						break ;
					}
				}

				//如果下一位执行者还是当前提交人，则直接执行处理下一步流程
				String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
				// 设置业务表与Activiti表双向关联
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

				//更新成员数据,根据id筛选 删除 or 添加 or 更新
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

				//添加集
				delListInvoiceProjectMembers.addAll(orgininvoicedMapInvoiceProjectMembers.keySet());
				if (saveListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.insertAll(saveListInvoiceProjectMembers);
				}
				//更新集
				if (updateListInvoiceProjectMembers.size() > 0) {
					projectMemberDao.batchUpdate(updateListInvoiceProjectMembers);
				}
				//删除集
				if (delListInvoiceProjectMembers.size() > 0) {
					//目前数据不删除，更改删除状态
					for (int i = 0; i < delListInvoiceProjectMembers.size(); i++) {
						SaleProjectMember sinInvoiceProjectMembersisD=projectMemberDao.findById(delListInvoiceProjectMembers.get(i));
						sinInvoiceProjectMembersisD.setIsDeleted("1");
						projectMemberDao.update(sinInvoiceProjectMembersisD);
					}
					//iFinInvoiceProjectMembersDao.deleteByIdList(delListInvoiceProjectMembers);
				}

				// 启动项目立项流程
				Map<String, Object> variables = Maps.newHashMap();
				Map<String, Object> businessParams = Maps.newHashMap(); // businessParams 提供给 ActivitiService 来寻找业务对象
				businessParams.put("class", this.getClass().getName()); // 要反射的类全名
				businessParams.put("method", "findById"); // 调用方法
				businessParams.put("paramValue", new Object[] { old.getId() }); // 方法参数的值集合

				variables.put("businessParams", businessParams);
				variables.put("approved", true);
				variables.put("userId", old.getUserId());
				variables.put("userId2", userPosition.getUserId());

				processInstance = activitiUtils.startProcessInstance(
						ActivitiUtils.PROJECT_KEY, user.getId().toString(), old.getId().toString(), variables);

				// 跳过初始时的提交申请节点
				List<Map<String, Object>> commentList = Lists.newArrayList();
				Map<String, Object> commentMap = Maps.newHashMap();
				commentMap.put("node", "提交申请");
				commentMap.put("approver", user.getName());
				commentMap.put("comment", "");
				commentMap.put("approveResult", "提交成功");
				commentMap.put("approveDate", new Date());
				commentList.add(commentMap);
				variables.put("commentList", commentList); // 初始化提交申请节点的备注列表

				List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
				for(Task task : taskList) {
					if(task.getName().equals("提交申请")) {
						activitiUtils.completeTask(task.getId(), variables);
						break ;
					}
				}

				//如果下一位执行者还是当前提交人，则直接执行处理下一步流程
				String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
				// 设置业务表与Activiti表双向关联
				old.setProcessInstanceId(processInstance.getId());
				old.setStatusNew(Integer.parseInt(status));
				projectManageDao.update(old);
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public List<SaleProjectAchievement> findPerformanceContributionList(Map<String, Object> paramsMap) {
		Map<Integer,Object> map = new HashMap<>();
		List<SaleProjectManage> projectIds = collectionDao.findProjectId(paramsMap); //获得审批完结的项目
		List<SaleProjectAchievement> saleProjectAchievementlist = new ArrayList<SaleProjectAchievement>();
		if(projectIds != null && projectIds.size() > 0) {
			for (int i = 0; i < projectIds.size(); i++) {
				List<SaleBarginManage> Bargins = collectionDao.findBarginByProjectId(projectIds.get(i).getId());//获得每个项目的所有审批完结的销售合同
				if(Bargins != null && Bargins.size() > 0) {
					for (int b = 0; b < Bargins.size(); b++) {
						List<FinInvoiced> finInvoiceds = collectionDao.findInvoicedById(Bargins.get(b).getId());//根据合同Id获得审批完结的发票信息
						if (finInvoiceds != null && finInvoiceds.size()>0) {
							for (int f = 0; f < finInvoiceds.size(); f++) {
                                List<FinRevenueRecognition>  finRevenueRecognitions = collectionDao.findRevenueRecognition(finInvoiceds.get(f).getId());//获得收入确认信息
								List<FinInvoiceProjectMembers> InvoiceProjectMembersList = collectionDao.findInvoiceProjectMembersById(finInvoiceds.get(f).getId());//获得所有发票成员业绩比例
								if (InvoiceProjectMembersList != null && InvoiceProjectMembersList.size() > 0) {
									for (int c = 0; c < InvoiceProjectMembersList.size(); c++) {
										SysUser sysuser = collectionDao.findUserById(InvoiceProjectMembersList.get(c).getUserId());
										double resultsProportion = 0; //业绩比例格式转化
										String stringStr = InvoiceProjectMembersList.get(c).getResultsProportion();
										if (stringStr.substring(stringStr.length() - 1).equals("%")) {
											resultsProportion = Double.parseDouble(stringStr.replace("%", "")) * 0.01;
										} else {
											resultsProportion = Double.valueOf(stringStr) * 0.01;
										}
										if(finRevenueRecognitions != null && finRevenueRecognitions.size()>0) {
											DecimalFormat dt = new DecimalFormat("#.00");//保留两位小数
											if (finRevenueRecognitions.get(0).getConfirmWay().equals("1")) {//业绩确认方式为一次性
												double resultsContribution = finRevenueRecognitions.get(0).getResultsContribution();//项目一次性的业绩贡献
												String userRseultAmount = dt.format(resultsContribution * resultsProportion);//成员当前的业绩总额
												if (map.containsKey(sysuser.getId())) {
													map.put(sysuser.getId(), (double) map.get(sysuser.getId()) + Double.valueOf(userRseultAmount));
												} else {
													map.put(sysuser.getId(), Double.parseDouble(userRseultAmount));
												}
											} else {//业绩确认方式为分摊
												SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//时间格式化
												try {
													if (!df.parse(df.format(finRevenueRecognitions.get(0).getShareEndDate())).before(df.parse(df.format(new Date())))) {
														double resultsContribution = finRevenueRecognitions.get(0).getResultsContribution();//业绩贡献总额
														//分摊开始时间到结束时间的天数
														int days = daysBetween(finRevenueRecognitions.get(0).getShareStartDate(), finRevenueRecognitions.get(0).getShareEndDate());
														double resultsContributionByDay = resultsContribution / days; //每天的业绩贡献额
														//分摊开始时间到当前时间的天数
														int endDays = daysBetween(finRevenueRecognitions.get(0).getShareStartDate(),new Date());
														double resultsContributionByDayByDays = resultsContributionByDay * endDays; //分摊的业绩贡献总额
														String userRseultAmount = dt.format(resultsContributionByDayByDays * resultsProportion);//成员当前的业绩总额
														if (map.containsKey(sysuser.getId())) {
															map.put(sysuser.getId(), (double) map.get(sysuser.getId()) + Double.parseDouble(userRseultAmount));
														} else {
															map.put(sysuser.getId(), Double.parseDouble(userRseultAmount));
														}
													}else {//分摊结束时间在当前时间之前，就跳过天数，直接乘以比例
														double resultsContribution = finRevenueRecognitions.get(0).getResultsContribution();//业绩贡献总额
														String userRseultAmount = dt.format(resultsContribution * resultsProportion);//成员当前的业绩总额
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
		//把map数据存进实体类
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
			//按业绩额度降序
			Collections.sort(saleProjectAchievementlist, new Comparator<SaleProjectAchievement>() {
				@Override
				public int compare(SaleProjectAchievement s1, SaleProjectAchievement s2) {
					//降序
					return new Double(s2.getPerformanceContribution()).compareTo(new Double(s1.getPerformanceContribution()));
				}
			});
			//给业绩排名赋值
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
		List<SaleProjectManage> projectIds = collectionDao.findProjectId(paramsMap); //获得审批完结的项目
		List<SaleProjectAchievement> saleProjectAchievementlist = new ArrayList<SaleProjectAchievement>();
		if(projectIds != null && projectIds.size() > 0) {
			for (int i = 0; i < projectIds.size(); i++) {
				List<SaleBarginManage> Bargins = collectionDao.findBarginByProjectId(projectIds.get(i).getId());//获得每个项目的所有销售合同
				if(Bargins != null && Bargins.size() > 0) {
					for (int b = 0; b < Bargins.size(); b++) {
						//提成管理顺序--根据销售合同id找到所属的收款数据
						List<FinCollection>  finCollectionList = collectionDao.findCollectionInfo(Bargins.get(b).getId(),"5");//查询收款表
						if (finCollectionList != null && finCollectionList.size() >0) {
							//根据收款id查找收款成员
							for(int f=0;f<finCollectionList.size();f++) {
								List<FinCollectionMembers> FinCollectionMembers =iFinCollectionMembersDao.findByFinCollectionId(finCollectionList.get(f).getId());//根据收款id查询收款成员数据
								if(FinCollectionMembers != null && FinCollectionMembers.size()>0) {
									for (int c = 0; c < FinCollectionMembers.size(); c++) {
										SysUser sysuser = collectionDao.findUserById(FinCollectionMembers.get(c).getUserId());
										DecimalFormat dt = new DecimalFormat("#.00");//保留两位小数
										if (finCollectionList != null && finCollectionList.size() > 0) {
											String stringStr = FinCollectionMembers.get(c).getCommissionProportion();
											double commissionProportion = 0;
											if (stringStr.substring(stringStr.length() - 1).equals("%")) {
												commissionProportion = Double.parseDouble(stringStr.replace("%", "")) * 0.01;
											} else {
												commissionProportion = Double.valueOf(stringStr) * 0.01;
											}
											String userAllocations = dt.format(finCollectionList.get(0).getAllocations() * commissionProportion);//成员当前项目的提成总额
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
		//把map数据存进实体类
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
			//按业绩额度降序
			Collections.sort(saleProjectAchievementlist, new Comparator<SaleProjectAchievement>() {
				@Override
				public int compare(SaleProjectAchievement s1, SaleProjectAchievement s2) {
					//降序
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
                result = new CrudResultDTO(CrudResultDTO.SUCCESS, "项目名称已存在，请重新选择");
            } else {
                result = new CrudResultDTO(CrudResultDTO.FAILED, "项目名称不存在");
            }

        } catch (Exception e) {
            result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
            e.printStackTrace();
            throw new BusinessException(e.getMessage());
        }
        return result;
    }


	/**
	 * 导出excel --全部搜索字段
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
	 * 计算两个时间之间的天数
	 * smdate：起始时间
	 * bdate ：终止时间
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
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功!");
        try {
            if(id!=null) {
            	Map<String, Object> params =new HashMap<String, Object>();
            	params.put("projectManageId", id);
            	Page<FinTravelreimburse> finTravelreimburses=travelreimburseDao.findByPage1(params);
            	if(finTravelreimburses == null || finTravelreimburses.size()<=0) {
            		SaleProjectManage saleProjectManage=projectManageDao.findById(id);
            		if(saleProjectManage!=null) {
            			saleProjectManage.setIsDeleted("1");
            			//更改删除状态
            			projectManageDao.update(saleProjectManage);
            		}else {
            			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "网络错误，请稍后重试！");
            		}
            	}else {
            		result = new CrudResultDTO(CrudResultDTO.SUCCESS, "已发生报销，无法删除");
            	}
            }else {
            	result = new CrudResultDTO(CrudResultDTO.EXCEPTION, "网络错误，请稍后重试！");
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
                result.setResult("删除成功！");
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("附件不存在！");
        }
        return result;
    }

	@Override
	public CrudResultDTO sendMail(Integer id, String comment) {
        CrudResultDTO result = new CrudResultDTO();
        SaleProjectManage saleProjectManage = projectManageDao.findById(id);
        Integer userId = saleProjectManage.getApplicant();
        //获取提交人的邮箱地址
        String userEmail = iAdRecordDao.findByUserid(userId).getEmail();
        //存提交人的Email
        List<String> recipientsList = new ArrayList<>();
        recipientsList.add(userEmail);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            //构造邮件
            String subject = "OA项目立项提示";
            StringBuffer contentBuffer = new StringBuffer();
            contentBuffer.append("<h3>");
            contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">项目立项通知!");
            contentBuffer.append("</h3><br>您于：");
            contentBuffer.append(sdf.format(saleProjectManage.getSubmitDate()) + "&nbsp;");
            contentBuffer.append("提交的项目立项申请被退回。<br>项目名称为:");
            contentBuffer.append(saleProjectManage.getName()+"&nbsp;");
            contentBuffer.append("<br>流程备注为:");
            contentBuffer.append(comment + "<br>");
            contentBuffer.append("<br>详情请登陆OA项目管理模块进行查看!</br></span>\r\n");
            String content = contentBuffer.toString();
            //以线程方式发送邮件，避免邮件发送时间过长，造成前端等待过久
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
            logger.info("发送了一封项目邮件！项目ID：" + saleProjectManage.getId());
            for (String email : recipientsList) {
                logger.info("向" + email + "发送了一封项目邮件！");
            }
            result.setCode(CrudResultDTO.SUCCESS);
            result.setResult("发送成功！");
        } catch (Exception e) {
            e.printStackTrace();
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("发送失败！");
        }
        return result;
    }

	@Override
	public CrudResultDTO saveInfoOld(JSONObject json, SysUser user) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
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
				project.setStatus("1");//  1：活动     0：注销       -1：关闭
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
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败！");
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