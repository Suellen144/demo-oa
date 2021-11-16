package com.reyzar.oa.service.sale.impl;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;

import com.reyzar.oa.common.constant.SystemConstant;
import com.reyzar.oa.common.util.*;
import com.reyzar.oa.dao.IAdRecordDao;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.service.ad.IAdRecordService;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.domain.SysUserPosition;
import com.reyzar.oa.service.sale.ISaleBarginManageService;

import javax.mail.Message;

@Service
public class SaleBarginManageServiceImpl implements ISaleBarginManageService {

    @Autowired
    private ISaleBarginManageDao saleBarginManageDao;

    @Autowired
    private ActivitiUtils activitiUtils;
	@Autowired
	private ISaleProjectManageDao projectManageDao;
    @Autowired
    private IAdRecordDao recordDao;
	
	@Autowired
	private IUserPositionDao userPositionDao;
	@Autowired
	private ISysUserDao iSysUserDao;
    @Autowired
    private IAdRecordService recordService;
	

    private final static Logger logger = Logger.getLogger(String.valueOf(SaleBarginManageServiceImpl.class));

    @Override
    public Page<SaleBarginManage> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        AdRecord record = recordService.findByUserid(user.getId());
        String [] result = record.getPosition().split(",");
        for(int a = 0;a<result.length;a++){
            if(result[a].contains("前台") ||result[a].contains("行政主管")) {
                params.put("barginType","L");
            }
        }
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, pageSize);
        Page<SaleBarginManage> page = null;
        if (user.getId().equals(36) || user.getId().equals(50)) {
            page = saleBarginManageDao.findByOne(params);
        } else {
            page = saleBarginManageDao.findByPage(params);
        }
        return page;
    }
    
    @Override
    public Page<SaleBarginManage> findByPageNew(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
    	String status=params.get("status").toString();
        if("2".equals(status)) {
        	params.put("status_T1", 1);
            params.put("status","");
            params.put("userId", user.getId());
        }else if("1".equals(status)){
        	params.put("status", 5);
        	params.put("dateSearch", new Date());
        }
        params=UserUtils.userByRole(user, params);
        PageHelper.startPage(pageNum, pageSize);
        Page<SaleBarginManage> page = saleBarginManageDao.findByPageNew(params);
        return page;
    }
    
    @Override
    public Page<SaleBarginManage> findByPage1(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, 1000);
        Page<SaleBarginManage> page = null;
        page = saleBarginManageDao.findByPage1(params);
        return page;
    }

    @Override
    public Page<SaleBarginManage> getBarginListForDialog(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, pageSize);

        Page<SaleBarginManage> page = saleBarginManageDao.getBarginListForDialog(params);
        return page;
    }

    @Override
    public CrudResultDTO saveInfo(JSONObject json) {
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");

        SaleBarginManage saleBarginManage = json.toJavaObject(SaleBarginManage.class);

        if (saleBarginManage.getTotalMoney() == null || saleBarginManage.getTotalMoney().equals("")) {
            saleBarginManage.setTotalMoney(0.00);
        }
        SysUser user = UserUtils.getCurrUser();
        try {
            if (saleBarginManage.getId() == null) {
                Date currDate = new Date();
                StringBuffer barginCode = new StringBuffer();
                String preBarginCode = saleBarginManageDao.findMaxNum(saleBarginManage.getBarginType());
                String base = new SimpleDateFormat("yyyyMMdd").format(currDate);
                if (preBarginCode == null || preBarginCode.equals("") || preBarginCode.indexOf(base) <= -1) {
                    barginCode.append("RZ");
                    barginCode.append(saleBarginManage.getBarginType());
                    barginCode.append(base);
                    barginCode.append("01");
                } else {
                    String num = base + preBarginCode.substring(11, 13);
                    Long numInteger = Long.valueOf(num) + 1;
                    barginCode.append("RZ");
                    barginCode.append(saleBarginManage.getBarginType());
                    barginCode.append(String.valueOf(numInteger));
                }
                Double total = saleBarginManage.getTotalMoney();
                saleBarginManage.setUserId(user.getId());
                saleBarginManage.setDeptId(user.getDeptId());
                saleBarginManage.setCreateBy(UserUtils.getCurrUser().getAccount());
                saleBarginManage.setCreateDate(new Date());
                saleBarginManage.setUnpayMoney(total);
                saleBarginManage.setPayMoney(0.00);
                saleBarginManage.setPayUnreceivedInvoice(total);
                saleBarginManage.setPayReceivedInvoice(0.00);
                saleBarginManage.setUnreceivedMoney(0.00);
                saleBarginManage.setReceivedMoney(0.00);
                saleBarginManage.setBarginCode(barginCode.toString());
                saleBarginManageDao.save(saleBarginManage);
            } else {
                SaleBarginManage originSaleBarginManage = saleBarginManageDao.findById(saleBarginManage.getId());

                saleBarginManage.setUpdateBy(UserUtils.getCurrUser().getAccount());
                saleBarginManage.setUpdateDate(new Date());
                /*saleBarginManage.setApplyTime(new Date());*/
                saleBarginManage.setUnpayMoney(saleBarginManage.getTotalMoney());
                saleBarginManage.setPayMoney(0.00);
                saleBarginManage.setPayUnreceivedInvoice(saleBarginManage.getTotalMoney());
                saleBarginManage.setPayReceivedInvoice(0.00);
                saleBarginManage.setUnreceivedMoney(0.00);
                saleBarginManage.setReceivedMoney(0.00);

                if (originSaleBarginManage.getBarginType().equals(saleBarginManage.getBarginType())) {
                    BeanUtils.copyProperties(saleBarginManage, originSaleBarginManage);
                    saleBarginManageDao.update(originSaleBarginManage);
                } else {
                    StringBuffer barginCode = new StringBuffer();
                    barginCode.append("RZ");
                    barginCode.append(saleBarginManage.getBarginType());
                    barginCode.append(originSaleBarginManage.getBarginCode().substring(3, 13));
                    saleBarginManage.setBarginCode(barginCode.toString());
                    BeanUtils.copyProperties(saleBarginManage, originSaleBarginManage);
                    saleBarginManageDao.update(originSaleBarginManage);
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
    public CrudResultDTO submit(JSONObject json) {

        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");

        SaleBarginManage saleBarginManage = json.toJavaObject(SaleBarginManage.class);

        SysUser user = UserUtils.getCurrUser();
        ProcessInstance processInstance = null;
        if (saleBarginManage.getTotalMoney() == null || saleBarginManage.getTotalMoney().equals("")) {
            saleBarginManage.setTotalMoney(0.00);
        }
        try {
        	SaleProjectManage saleProjectManage=new SaleProjectManage();
        	if(saleBarginManage.getProjectManageId()!=null) {
        		 saleProjectManage=projectManageDao.findById(saleBarginManage.getProjectManageId());
        	}
        	SysUserPosition userPosition = new SysUserPosition();
			if(saleProjectManage!=null && saleProjectManage.getDutyDeptId()!=null) {
				userPosition=userPositionDao.findByDeptAndLevel(saleProjectManage.getDutyDeptId());
			}else if(saleProjectManage.getUserId()!=null) {
				SysUser sysUser=iSysUserDao.findById(saleProjectManage.getUserId());
				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
		}
            if (saleBarginManage.getId() == null || saleBarginManage.getId().equals("")) {
                Date currDate = new Date();
                StringBuffer barginCode = new StringBuffer();
                String preBarginCode = saleBarginManageDao.findMaxNum(saleBarginManage.getBarginType());
                String base = new SimpleDateFormat("yyyyMMdd").format(currDate);
                if (preBarginCode == null || preBarginCode.equals("") || preBarginCode.indexOf(base) <= -1) {
                    barginCode.append("RZ");
                    barginCode.append(saleBarginManage.getBarginType());
                    barginCode.append(base);
                    barginCode.append("01");
                } else {
                    String num = base + preBarginCode.substring(11, 13);
                    Long numInteger = Long.valueOf(num) + 1;
                    barginCode.append("RZ");
                    barginCode.append(saleBarginManage.getBarginType());
                    barginCode.append(String.valueOf(numInteger));
                }
                saleBarginManage.setUserId(UserUtils.getCurrUser().getId());
                saleBarginManage.setDeptId(UserUtils.getCurrUser().getDeptId());
                saleBarginManage.setCreateBy(UserUtils.getCurrUser().getAccount());
                saleBarginManage.setCreateDate(new Date());
                saleBarginManage.setUnpayMoney(saleBarginManage.getTotalMoney());
                saleBarginManage.setPayMoney(0.00);
                saleBarginManage.setPayUnreceivedInvoice(saleBarginManage.getTotalMoney());
                saleBarginManage.setPayReceivedInvoice(0.00);
                saleBarginManage.setUnreceivedMoney(0.00);
                saleBarginManage.setReceivedMoney(0.00);
                saleBarginManage.setBarginCode(barginCode.toString());
                saleBarginManageDao.save(saleBarginManage);

                // 启动合同流程
                Map<String, Object> variables = Maps.newHashMap();
                Map<String, Object> businessParams = Maps.newHashMap();
                businessParams.put("class", this.getClass().getName());
                businessParams.put("method", "findById");
                businessParams.put("paramValue", new Object[]{saleBarginManage.getId()});

                String type = saleBarginManage.getBarginType();
                variables.put("businessParams", businessParams);
                // 是否经过总经理审批
                boolean toCeo=(type != null && !type.equals("") && (type.equals("L") || type.equals("C") || type.equals("M") || type.equals("E")) ? true : false);
                variables.put("toCeo1", toCeo);
                //判断是否项目管理模块新建，如果是则需要走项目负责人审批
                if(saleBarginManage.getIsNewProject()!=null && saleBarginManage.getIsNewProject() == 1 && !(type != null && !type.equals("") && (type.equals("L") || type.equals("M") || type.equals("E")) ? true : false)) {
                	//如果项目负责人是null，则用发起人代替
                	if(saleProjectManage.getUserId() == null) {
                		SysUser sysUser=iSysUserDao.findById(user.getId());
        				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
        				variables.put("userId", user.getId());
                	}else {
                		variables.put("userId", saleProjectManage.getUserId());
                	}
    				variables.put("userId2", userPosition.getUserId());
    				variables.put("toHead",true);
                }else {
                	variables.put("toHead",false);
                }
                	processInstance =
                			activitiUtils.startProcessInstance(ActivitiUtils.BARGIN_KEY, user.getId().toString(), saleBarginManage.getId().toString(), variables);
                // 跳过初始时的提交申请节点
                List<Map<String, Object>> commentList = Lists.newArrayList();
                Map<String, Object> commentMap = Maps.newHashMap();
                commentMap.put("node", "提交申请");
                commentMap.put("approver", user.getName());
                commentMap.put("comment", "");
                commentMap.put("approveResult", "提交成功");
                commentMap.put("approveDate", saleBarginManage.getCreateDate());
                commentList.add(commentMap);
                variables.put("commentList", commentList);

                List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
                for (Task task : taskList) {
                    if (task.getName().equals("提交申请")) {
                        activitiUtils.completeTask(task.getId(), variables);
                        break;
                    }
                }
                // 设置业务表与Activiti表双向关联
                String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
                saleBarginManage.setProcessInstanceId(processInstance.getId());
                saleBarginManage.setStatus(status);
                saleBarginManageDao.update(saleBarginManage);
            } else {

                SaleBarginManage originSaleBarginManage = saleBarginManageDao.findById(saleBarginManage.getId());

                saleBarginManage.setUpdateBy(UserUtils.getCurrUser().getAccount());
                saleBarginManage.setUpdateDate(new Date());
                /*saleBarginManage.setApplyTime(new Date());*/
                saleBarginManage.setUnpayMoney(saleBarginManage.getTotalMoney());
                saleBarginManage.setPayMoney(0.00);
                saleBarginManage.setPayUnreceivedInvoice(0.00);
                saleBarginManage.setPayReceivedInvoice(0.00);
                saleBarginManage.setUnreceivedMoney(0.00);
                saleBarginManage.setReceivedMoney(0.00);

                if (originSaleBarginManage.getBarginType().equals(saleBarginManage.getBarginType())) {
                    BeanUtils.copyProperties(saleBarginManage, originSaleBarginManage);
                    saleBarginManageDao.update(originSaleBarginManage);
                } else {
                    StringBuffer barginCode = new StringBuffer();
                    barginCode.append("RZ");
                    barginCode.append(saleBarginManage.getBarginType());
                    barginCode.append(originSaleBarginManage.getBarginCode().substring(3, 13));
                    saleBarginManage.setBarginCode(barginCode.toString());
                    BeanUtils.copyProperties(saleBarginManage, originSaleBarginManage);
                    saleBarginManageDao.update(originSaleBarginManage);
                }

                // 启动合同流程
                Map<String, Object> variables = Maps.newHashMap();
                Map<String, Object> businessParams = Maps.newHashMap();
                businessParams.put("class", this.getClass().getName());
                businessParams.put("method", "findById");
                businessParams.put("paramValue", new Object[]{saleBarginManage.getId()});

                String type = saleBarginManage.getBarginType();
                variables.put("businessParams", businessParams);
                // 是否经过总经理审批
                boolean toCeo=(type != null && !type.equals("") && (type.equals("L") || type.equals("C") || type.equals("M") || type.equals("E")) ? true : false);
                variables.put("toCeo1", toCeo);
              //判断是否项目管理模块新建，如果是则需要走项目负责人审批
                if(saleBarginManage.getIsNewProject()!=null && saleBarginManage.getIsNewProject() == 1 && !(type != null && !type.equals("") && (type.equals("L") || type.equals("M") || type.equals("E")) ? true : false)) {
                	//如果项目负责人是null，则用发起人代替
                	if(saleProjectManage.getUserId() == null) {
                		SysUser sysUser=iSysUserDao.findById(user.getId());
        				userPosition = userPositionDao.findByDeptAndLevel(sysUser.getDept().getId());
        				variables.put("userId", user.getId());
                	}else {
                		variables.put("userId", saleProjectManage.getUserId());
                	}
    				variables.put("userId2", userPosition.getUserId());
    				variables.put("toHead",true);
                }else {
                	variables.put("toHead",false);
                }
                processInstance =
                        activitiUtils.startProcessInstance(ActivitiUtils.BARGIN_KEY, user.getId().toString(), saleBarginManage.getId().toString(), variables);
                // 跳过初始时的提交申请节点
                List<Map<String, Object>> commentList = Lists.newArrayList();
                Map<String, Object> commentMap = Maps.newHashMap();
                commentMap.put("node", "提交申请");
                commentMap.put("approver", user.getName());
                commentMap.put("comment", "");
                commentMap.put("approveResult", "提交成功");
                commentMap.put("approveDate", saleBarginManage.getCreateDate());
                commentList.add(commentMap);
                variables.put("commentList", commentList);

                List<Task> taskList = activitiUtils.getActivityTask(processInstance.getId());
                for (Task task : taskList) {
                    if (task.getName().equals("提交申请")) {
                        activitiUtils.completeTask(task.getId(), variables);
                        break;
                    }
                }

                // 设置业务表与Activiti表双向关联
                String status = activitiUtils.findTaskNextStep(processInstance.getId(), processInstance.getProcessDefinitionId(), variables);
                saleBarginManage.setProcessInstanceId(processInstance.getId());
                saleBarginManage.setStatus(status);
                saleBarginManageDao.update(saleBarginManage);
            }
        } catch (Exception e) {
            result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
            e.printStackTrace();
            throw new BusinessException(e.getMessage());
        }
        return result;
    }

    @Override
    public CrudResultDTO findByBarginName(JSONObject json) {
        CrudResultDTO result = null;
        SaleBarginManage saleBarginManage = json.toJavaObject(SaleBarginManage.class);

        try {
            List<SaleBarginManage> saleProjectManageAttach = saleBarginManageDao.findByBarginName(saleBarginManage);

            if (saleProjectManageAttach != null && !saleProjectManageAttach.equals("") && saleProjectManageAttach.size() > 0) {
                result = new CrudResultDTO(CrudResultDTO.SUCCESS, "合同名称已存在，请重新选择");
            } else {
                result = new CrudResultDTO(CrudResultDTO.FAILED, "合同名称不存在");
            }

        } catch (Exception e) {
            result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
            e.printStackTrace();
            throw new BusinessException(e.getMessage());
        }
        return result;
    }

    @Override
    public CrudResultDTO delete(JSONObject json) {
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功!");

        try {
            SaleBarginManage projectManageAttach = json.toJavaObject(SaleBarginManage.class);
            String attachments = projectManageAttach.getAttachments();

            //物理删除
            saleBarginManageDao.deleteById(projectManageAttach.getId());

            if (attachments != null && !attachments.equals("")) {
                FileUtil.forceDelete(attachments);
            }
        } catch (Exception e) {
            result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
            e.printStackTrace();
            throw new BusinessException(e.getMessage());
        }
        return result;
    }

    @Override
    public SaleBarginManage findById(Integer id) {
    	SaleBarginManage saleBarginManage = saleBarginManageDao.findById(id);
			if(saleBarginManage !=null ) {
		    	if(saleBarginManage.getCommissionAmount() == null) {
		    		SaleBarginManage saleBarginManages=saleBarginManageDao.findByChannelHaveBargin(id);
		    		if(saleBarginManages!=null && saleBarginManages.getAllocations()!=null ) {
		    			saleBarginManage.setCommissionAmount(saleBarginManages.getAllocations());
		    		}else {
		    			saleBarginManage.setCommissionAmount(0.0);
		    		}
		    	}
		    	if(saleBarginManage.getContribution() == null) {
		    		SaleBarginManage saleBarginManages=saleBarginManageDao.findByIncomeBargin(id);
		    		if(saleBarginManages!=null && saleBarginManages.getResultsAmount()!=null ) {
		    			saleBarginManage.setContribution(saleBarginManages.getResultsAmount());
		    		}else {
		    			saleBarginManage.setContribution(0.0);
		    		}
		    	}
		        SysUser user = UserUtils.getCurrUser();
		        AdRecord record = recordService.findByUserid(user.getId());
		        String [] result = record.getPosition().split(",");
		        for(int a = 0;a<result.length;a++){
		            if(result[a].contains("出纳") || result[a].contains("复核")) {
		                saleBarginManage.setPosition1("position1");
		            }
		            if(result[a].contains("财务") || result[a].contains("助理") ||result[a].contains("出纳") ||result[a].contains("前台") ||result[a].contains("行政主管") ||result[a].contains("总经理")) {
		                saleBarginManage.setPosition2("position2");
		            }
		            if(result[a].contains("出纳")) {
		                saleBarginManage.setPosition3("position3");
		            }
		        }
			}
        return saleBarginManage;
    }

    @Override
    public CrudResultDTO setStatus(Integer id, String status) {
        CrudResultDTO result = new CrudResultDTO();
        try {
            SaleBarginManage saleBarginManage = saleBarginManageDao.findById(id);
            if (saleBarginManage != null) {

                saleBarginManage.setStatus(status);
                saleBarginManageDao.update(saleBarginManage);

                result.setCode(CrudResultDTO.SUCCESS);
                result.setResult("操作成功!");
            } else {
                result.setCode(CrudResultDTO.FAILED);
                result.setResult("没有ID为：" + id + " 的对象！");
            }
        } catch (Exception e) {
            result.setCode(CrudResultDTO.EXCEPTION);
            result.setResult(e.getMessage());
            throw new BusinessException(e.getMessage());
        }
        return result;
    }
    
    @Override
    public CrudResultDTO setStatus2(Integer id, String status, String remark) {
        CrudResultDTO result = new CrudResultDTO();
        try {
            SaleBarginManage saleBarginManage = saleBarginManageDao.findById(id);
            if (saleBarginManage != null) {

                saleBarginManage.setStatus(status);
                saleBarginManage.setRemark(remark);
                saleBarginManageDao.update(saleBarginManage);

                result.setCode(CrudResultDTO.SUCCESS);
                result.setResult("操作成功!");
            } else {
                result.setCode(CrudResultDTO.FAILED);
                result.setResult("没有ID为：" + id + " 的对象！");
            }
        } catch (Exception e) {
            result.setCode(CrudResultDTO.EXCEPTION);
            result.setResult(e.getMessage());
            throw new BusinessException(e.getMessage());
        }
        return result;
    }

    @Override
    public CrudResultDTO updateConfirm(Integer id,String barginConfirm) {
        CrudResultDTO result = new CrudResultDTO();
        try {
            SaleBarginManage saleBarginManage = saleBarginManageDao.findById(id);
            if (saleBarginManage != null) {
                saleBarginManage.setBarginConfirm(barginConfirm);
                saleBarginManageDao.update(saleBarginManage);
                result.setCode(CrudResultDTO.SUCCESS);
                result.setResult("操作成功!");
            } else {
                result.setCode(CrudResultDTO.FAILED);
                result.setResult("没有ID为：" + id + " 的对象！");
            }
        } catch (Exception e) {
            result.setCode(CrudResultDTO.EXCEPTION);
            result.setResult(e.getMessage());
            throw new BusinessException(e.getMessage());
        }
        return result;
    }

    @Override
    public List<SaleBarginManage> findByProjectManageId(Integer projectManageId) {
        List<SaleBarginManage> saleBarginManages = saleBarginManageDao.findByProjectManageId(projectManageId);
        return saleBarginManages;
    }

    @Override
    public CrudResultDTO findByProjectId(Integer projectId) {
        CrudResultDTO result = new CrudResultDTO();
        try {
            List<SaleBarginManage> barginManages = saleBarginManageDao.findByProjectManageId(projectId);
            result = new CrudResultDTO(CrudResultDTO.SUCCESS, barginManages);
        } catch (Exception e) {
            result.setCode(CrudResultDTO.EXCEPTION);
            result.setResult(e.getMessage());
            throw new BusinessException(e.getMessage());
        }
        return result;
    }

    @Override
    public CrudResultDTO updateBarginInfo(JSONObject json) {
        CrudResultDTO result = new CrudResultDTO();
        try {
            SaleBarginManage barginManage = json.toJavaObject(SaleBarginManage.class);
            SaleBarginManage originBarginManage = saleBarginManageDao.findById(barginManage.getId());
            BeanUtils.copyProperties(barginManage, originBarginManage);
            saleBarginManageDao.update(originBarginManage);

            result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
        } catch (Exception e) {
            result.setCode(CrudResultDTO.EXCEPTION);
            result.setResult(e.getMessage());
            throw new BusinessException(e.getMessage());
        }
        return result;
    }

    @Override
    public CrudResultDTO deleteAttach(String path, Integer id) {
        CrudResultDTO result = new CrudResultDTO();
        SaleBarginManage barginManage = saleBarginManageDao.findById(id);
        if (barginManage.getAttachments() != null && barginManage.getAttachments() != "") {
            try {
                FileUtil.forceDelete(path);
                barginManage.setAttachName("");
                barginManage.setAttachments("");
                saleBarginManageDao.update(barginManage);
                result.setCode(CrudResultDTO.SUCCESS);
                result.setResult("删除成功！");
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
    public CrudResultDTO deleteAttach2(String path, Integer id) {
        CrudResultDTO result = new CrudResultDTO();
        SaleBarginManage barginManage = saleBarginManageDao.findById(id);
        if (barginManage.getAttachments2() != null && barginManage.getAttachments2() != "") {
            try {
                FileUtil.forceDelete(path);
                barginManage.setAttachName2("");
                barginManage.setAttachments2("");
                saleBarginManageDao.update(barginManage);
                result.setCode(CrudResultDTO.SUCCESS);
                result.setResult("删除成功！");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }else {
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("附件不存在！");
        }
        return result;
    }

    /**
     * 发送邮件
     */
    @Override
    public CrudResultDTO sendMail(Integer id, String comment) {
        CrudResultDTO result = new CrudResultDTO();
        SaleBarginManage barginManage = saleBarginManageDao.findById(id);
        Integer userId = barginManage.getUserId();
        //获取提交人的邮箱地址
        String userEmail = recordDao.findByUserid(userId).getEmail();
        //存提交人的Email
        List<String> recipientsList = new ArrayList<>();
        recipientsList.add(userEmail);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            //构造邮件
            String subject = "OA合同提示";
            StringBuffer contentBuffer = new StringBuffer();
            contentBuffer.append("<h3>");
            contentBuffer.append("<span style=\\\"font-family:微软雅黑, Microsoft YaHei\\\">合同通知!");
            contentBuffer.append("</h3><br>您于：");
            contentBuffer.append(sdf.format(barginManage.getApplyTime()) + "&nbsp;");
            contentBuffer.append("提交的合同申请被退回。<br>合同编号为:");
            contentBuffer.append(barginManage.getBarginCode()+"&nbsp;");
            contentBuffer.append("<br>流程备注为:");
            contentBuffer.append(comment + "<br>");
            contentBuffer.append("<br>详情请登陆OA合同管理模块进行查看!</br></span>\r\n");
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
            logger.info("发送了一封合同邮件！合同ID：" + barginManage.getId());
            for (String email : recipientsList) {
                logger.info("向" + email + "发送了一封合同邮件！");
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
	public SaleBarginManage findByContractAmount(Integer projectId) {
		return saleBarginManageDao.findByContractAmount(projectId);
	}

	@Override
	public SaleBarginManage findByIncome(Integer projectId) {
		return saleBarginManageDao.findByIncome(projectId);
	}

	@Override
	public SaleBarginManage findByChannelHave(Integer projectId) {
		return saleBarginManageDao.findByChannelHave(projectId);
	}
}