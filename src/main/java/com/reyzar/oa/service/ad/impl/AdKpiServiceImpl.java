package com.reyzar.oa.service.ad.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.service.ad.IAdRecordService;
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
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdKpiAttachDao;
import com.reyzar.oa.dao.IAdKpiDao;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.domain.AdKpi;
import com.reyzar.oa.domain.AdKpiAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdKpiService;

@Service
@Transactional
public class AdKpiServiceImpl implements IAdKpiService {

	@Autowired
	private IAdKpiDao kpiDao;
	@Autowired
	private IAdKpiAttachDao kpiAttachDao;
	@Autowired
	private ISysDeptDao iAdSysDeptDao;
	@Autowired
	private IAdRecordService recordService;

	@Override
	public List<AdKpiAttach> findAllByDpetIdAndDate2(Map<String,Object> parms) {
		return kpiAttachDao.findAllByDpetIdAndDate2(parms);
	}
	
	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		AdKpiAttach kpiAttach = json.toJavaObject(AdKpiAttach.class);
		if (kpiAttach.getStatus() != null) {
			kpiAttach.setStatus(1);
			kpiAttach.setUserScore(kpiAttach.getUserScore());
			kpiAttach.setUserEvaluation(kpiAttach.getUserEvaluation());
			kpiAttach.setUpdateBy(user.getAccount());
			kpiAttach.setUpdateDate(new Date());
			kpiAttach.setUserTime(new Date());
			kpiAttachDao.update(kpiAttach);
		} else {
			kpiAttach.setUserScore(kpiAttach.getUserScore());
			kpiAttach.setUserEvaluation(kpiAttach.getUserEvaluation());
			kpiAttach.setUpdateBy(user.getAccount());
			kpiAttach.setUpdateDate(new Date());
			kpiAttach.setUserTime(new Date());
			kpiAttachDao.update(kpiAttach);
		}
		return result;
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) throws ParseException {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		AdKpi kpi = json.toJavaObject(AdKpi.class);
		if (kpi.getId() == null) {
			kpi.setDeptId(user.getDeptId());
			kpi.setCreateDate(new Date());
			kpi.setTime(sdf.format(new Date()));
			kpi.setDate(new Date());
			kpiDao.save(kpi);
			if (kpi.getKpiAttachsList() != null) {
				for (AdKpiAttach kpiAttach : kpi.getKpiAttachsList()) {
					kpiAttach.setKpiId(kpi.getId());
					kpiAttach.setUserId(user.getId());
					kpiAttach.setUserName(user.getName());
					kpiAttach.setDeptId(user.getDeptId());
					kpiAttach.setDeptName(user.getDept().getName());
					kpiAttach.setCreateBy(user.getAccount());
					kpiAttach.setCreateDate(new Date());
				}
				kpiAttachDao.insertAll(kpi.getKpiAttachsList());
			}
		} else {
			AdKpi originKpi = kpiDao.findById(kpi.getId());
			kpi.setUpdateBy(user.getAccount());
			kpi.setUpdateDate(new Date());
			AdRecord record = recordService.findByUserid(user.getId());
			String [] result2 = record.getPosition().split(",");
			for(int a = 0;a<result2.length;a++) {
				if(result2[a].contains("\r\n")) {
					result2[a] = result2[a].replaceAll("(\r\n)", "").trim();
				}
			}
			BeanUtils.copyProperties(kpi, originKpi);
			if(originKpi.getDeptId() == 2) {
				if (Arrays.asList(result).contains("总经理")) {
					if (kpi.getStatus() != null) {
						originKpi.setStatus(1);
					}
				}else {
					originKpi.setStatus(3);
				}
			}else {
				if (kpi.getStatus() != null) {
					originKpi.setStatus(1);
				}
			}
			List<AdKpiAttach> orginKpiAttachList = kpiAttachDao.findByKpiId(kpi.getId());
			 List<SysDept> sysDepts=iAdSysDeptDao.findByParentid(kpi.getDeptId());
			 for (SysDept sysDept : sysDepts) {
				 AdKpi adKpi=kpiDao.findBydeptIdAndDate(sysDept.getId(),kpi.getTime());
				 if(adKpi!=null) {
					 List<AdKpiAttach> kpiAttachs1=kpiAttachDao.findByKpiId(adKpi.getId());
					 orginKpiAttachList.addAll(kpiAttachs1);
				 }
			 }
			List<AdKpiAttach> kpiAttachList = kpi.getKpiAttachsList();
			List<AdKpiAttach> saveList = Lists.newArrayList();
			List<AdKpiAttach> updateList = Lists.newArrayList();
			List<Integer> delList = Lists.newArrayList();
			Map<Integer, AdKpiAttach> orginKpiAttachMap = Maps.newHashMap();
			
			for (AdKpiAttach kpiAttach : orginKpiAttachList) {
				orginKpiAttachMap.put(kpiAttach.getId(), kpiAttach);
			}
			for (AdKpiAttach kpiAttach : kpiAttachList) {
				if (kpiAttach.getId() != null) {
					kpiAttach.setUpdateBy(user.getAccount());
					kpiAttach.setUpdateDate(new Date());
					AdKpiAttach orgin = orginKpiAttachMap.get(kpiAttach.getId());
					if (orgin != null) {
						if (kpiAttach.getUserId().equals(user.getId())) {
							orgin.setUserScore(kpiAttach.getUserScore());
							orgin.setUserEvaluation(kpiAttach.getUserEvaluation());
							orgin.setManagerEvaluation(kpiAttach.getManagerEvaluation());
							orgin.setManagerScore(kpiAttach.getManagerScore());
							orgin.setCeoScore(kpiAttach.getCeoScore());
							orgin.setCeoPraisedPunished(kpiAttach.getCeoPraisedPunished());
							orgin.setUpdateBy(kpiAttach.getUpdateBy());
							orgin.setUserTime(new Date());
							updateList.add(orgin);
							orginKpiAttachMap.remove(orgin.getId());
						} else {
							orgin.setManagerEvaluation(kpiAttach.getManagerEvaluation());
							orgin.setManagerScore(kpiAttach.getManagerScore());
							orgin.setCeoScore(kpiAttach.getCeoScore());
							orgin.setCeoPraisedPunished(kpiAttach.getCeoPraisedPunished());
							orgin.setUpdateBy(kpiAttach.getUpdateBy());
							orgin.setUpdateDate(new Date());
							updateList.add(orgin);
							orginKpiAttachMap.remove(orgin.getId());
						}
					}
				} else {
					kpiAttach.setKpiId(kpi.getId());
					kpiAttach.setUpdateBy(user.getAccount());
					kpiAttach.setUpdateDate(new Date());
					saveList.add(kpiAttach);
				}
			}
			delList.addAll(orginKpiAttachMap.keySet());
			kpiDao.update(originKpi);
			if (saveList.size() > 0) {
				kpiAttachDao.insertAll(saveList);
			}
			if (updateList.size() > 0) {
				kpiAttachDao.batchUpdate2(updateList);
			}
			if (delList.size() > 0) {
				kpiAttachDao.deleteByIdList(delList);
			}
		}
		return result;
	}

	@Override
	public CrudResultDTO saveone(JSONObject json) throws ParseException {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		AdKpi kpi = json.toJavaObject(AdKpi.class);
		if (kpi.getId() == null) {
			kpi.setDeptId(user.getDeptId());
			kpi.setCreateDate(new Date());
			kpi.setTime(sdf.format(new Date()));
			kpi.setDate(new Date());
			kpiDao.save(kpi);
			if (kpi.getKpiAttachsList() != null) {
				for (AdKpiAttach kpiAttach : kpi.getKpiAttachsList()) {
					kpiAttach.setKpiId(kpi.getId());
					kpiAttach.setUserId(user.getId());
					kpiAttach.setUserName(user.getName());
					kpiAttach.setDeptId(user.getDeptId());
					kpiAttach.setDeptName(user.getDept().getName());
					kpiAttach.setCreateBy(user.getAccount());
					kpiAttach.setCreateDate(new Date());
				}
				kpiAttachDao.insertAll(kpi.getKpiAttachsList());
			}
		} else {
			List<AdKpiAttach> orginKpiAttachList = kpiAttachDao.findByKpiId(kpi.getId());
			List<AdKpiAttach> kpiAttachList = kpi.getKpiAttachsList();
			Map<Integer, AdKpiAttach> orginKpiAttachMap = Maps.newHashMap();
			
			for (AdKpiAttach kpiAttach : orginKpiAttachList) {
				orginKpiAttachMap.put(kpiAttach.getId(), kpiAttach);
			}
			for (AdKpiAttach kpiAttach : kpiAttachList) {
				if (kpiAttach.getId() != null) {
					kpiAttach.setUpdateBy(user.getAccount());
					kpiAttach.setUpdateDate(new Date());
					AdKpiAttach orgin = orginKpiAttachMap.get(kpiAttach.getId());
					if (orgin != null) {
						if (kpiAttach.getUserId().equals(user.getId())) {
							if (kpiAttach.getStatus() != null) {
								orgin.setStatus(1);
								orgin.setUserScore(kpiAttach.getUserScore());
								orgin.setUserEvaluation(kpiAttach.getUserEvaluation());
								orgin.setManagerEvaluation(kpiAttach.getManagerEvaluation());
								orgin.setManagerScore(kpiAttach.getManagerScore());
								orgin.setUpdateBy(kpiAttach.getUpdateBy());
								orgin.setUpdateDate(new Date());
								orgin.setUserTime(new Date());
								kpiAttachDao.update(orgin);
							} else {
								orgin.setUserScore(kpiAttach.getUserScore());
								orgin.setUserEvaluation(kpiAttach.getUserEvaluation());
								orgin.setManagerEvaluation(kpiAttach.getManagerEvaluation());
								orgin.setManagerScore(kpiAttach.getManagerScore());
								orgin.setUpdateBy(kpiAttach.getUpdateBy());
								orgin.setUpdateDate(new Date());
								orgin.setUserTime(new Date());
								kpiAttachDao.update(orgin);
							}
						}
					}
				}
			}

		}
		return result;
	}

	@Override
	public CrudResultDTO approve(JSONObject json) throws ParseException {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		AdKpi kpi = json.toJavaObject(AdKpi.class);
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, -1);
		Date time = c.getTime();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		if (user.getAccount().equals("yanggl")) {
			AdKpi status = kpiDao.findBydeptIdAndDate(2, sdf.format(new Date()));
			if (status == null) {
				status = kpiDao.findBydeptIdAndDate(2, sdf.format(time));
				status.setStatus(1);
				status.setUpdateBy(user.getAccount());
				status.setUpdateDate(new Date());
				kpiDao.update(status);
			} else {
				status.setStatus(1);
				status.setUpdateBy(user.getAccount());
				status.setUpdateDate(new Date());
				kpiDao.update(status);
			}
		} else {
			AdKpi status = kpiDao.findBydeptIdAndDate(6, sdf.format(new Date()));
			if (status == null) {
				status = kpiDao.findBydeptIdAndDate(6, sdf.format(time));
				status.setStatus(1);
				status.setUpdateBy(user.getAccount());
				status.setUpdateDate(new Date());
				kpiDao.update(status);
			} else {
				status.setStatus(1);
				status.setUpdateBy(user.getAccount());
				status.setUpdateDate(new Date());
				kpiDao.update(status);
			}
		}
		List<AdKpiAttach> orginKpiAttachList = kpiAttachDao.findByKpiId(kpi.getId());
		List<AdKpiAttach> kpiAttachList = kpi.getKpiAttachsList();

		List<AdKpiAttach> saveList = Lists.newArrayList();
		List<AdKpiAttach> updateList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();

		Map<Integer, AdKpiAttach> orginKpiAttachMap = Maps.newHashMap();
		for (AdKpiAttach kpiAttach : orginKpiAttachList) {
			orginKpiAttachMap.put(kpiAttach.getId(), kpiAttach);
		}
		for (AdKpiAttach kpiAttach : kpiAttachList) {
			kpiAttach.setUpdateBy(user.getAccount());
			kpiAttach.setUpdateDate(new Date());
			updateList.add(kpiAttach);
		}
		if (saveList.size() > 0) {
			kpiAttachDao.insertAll(saveList);
		}
		if (updateList.size() > 0) {
			kpiAttachDao.batchUpdate(updateList);
		}
		if (delList.size() > 0) {
			kpiAttachDao.deleteByIdList(delList);
		}
		return result;
	}

	@Override
	public CrudResultDTO saveall(JSONObject json) throws ParseException {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		AdKpi kpi = json.toJavaObject(AdKpi.class);
		List<AdKpiAttach> orginKpiAttachList = kpiAttachDao.findByKpiId(kpi.getId());
		List<AdKpiAttach> kpiAttachList = kpi.getKpiAttachsList();
		List<AdKpiAttach> saveList = Lists.newArrayList();
		List<AdKpiAttach> updateList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		Map<Integer, AdKpiAttach> orginKpiAttachMap = Maps.newHashMap();
		for (AdKpiAttach kpiAttach : orginKpiAttachList) {
			orginKpiAttachMap.put(kpiAttach.getId(), kpiAttach);
		}
		for (AdKpiAttach kpiAttach : kpiAttachList) {
			kpiAttach.setUpdateBy(user.getAccount());
			kpiAttach.setUpdateDate(new Date());
			updateList.add(kpiAttach);
		}
		if (saveList.size() > 0) {
			kpiAttachDao.insertAll(saveList);
		}
		if (updateList.size() > 0) {
			kpiAttachDao.batchUpdate(updateList);
		}
		if (delList.size() > 0) {
			kpiAttachDao.deleteByIdList(delList);
		}
		return result;
	}

	@Override
	public AdKpi findBydeptIdAndDate(Integer deptId, String time) {
		return kpiDao.findBydeptIdAndDate(deptId, time);
	}

	@Override
	public List<AdKpi> findAll() {
		return kpiDao.findAll();
	}

	@Override
	public List<AdKpiAttach> findAllByDpetIdAndDate(Integer deptId, Date date) {
		return kpiAttachDao.findAllByDpetIdAndDate(deptId, date);
	}

	@Override
	public Page<AdKpiAttach> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		SysUser user = UserUtils.getCurrUser();
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.KPI);
		Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
		params.put("userId", user.getId());
		params.put("deptIdSet", deptIdSet);
		String value = (String) params.get("selectIsDelete");
		if (value.equals("0")) {// 是否离职条件判断
			params.put("no", "0");
		}
		if (value.equals("1")) {
			params.put("is", "1");
		}
		PageHelper.startPage(pageNum, pageSize);
		Page<AdKpiAttach> page = kpiAttachDao.findByPage(params);
		return page;
	}

	@Override
	public AdKpi findById(Integer id) {
		return kpiDao.findById(id);
	}

	@Override
	public Integer getStatus(Integer deptId, String time) {
		AdKpi kpi = new AdKpi();
		try {
			Date date = new Date(); // 获取当前时间
			Calendar c = Calendar.getInstance();
			c.add(Calendar.MONTH, -1); // 获取上个月时间
			Date temp = c.getTime();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
			time = sdf.format(date);
			kpi = kpiDao.findBydeptIdAndDate(deptId, time);
			if (kpi == null) {
				kpi = kpiDao.findBydeptIdAndDate(deptId, sdf.format(temp));
			}
			if (kpi == null) {
				return 0;
			} else {
				return kpi.getStatus() == null ? 0 : kpi.getStatus();
			}
		} catch (Exception e) {
			e.getMessage();
		}
		return 0;
	}

	@Override
	public List<AdKpiAttach> findByUserIdAndTime(Integer userId, String startTime, String endTime) {
		return kpiAttachDao.findByUserIdAndTime(userId, startTime, endTime);
	}
}