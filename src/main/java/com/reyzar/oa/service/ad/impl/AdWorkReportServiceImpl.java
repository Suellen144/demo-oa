package com.reyzar.oa.service.ad.impl;

import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.reyzar.oa.common.util.DateUtils;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.WorkReportExcelDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdWorkReportAttachDao;
import com.reyzar.oa.dao.IAdWorkReportDao;
import com.reyzar.oa.domain.AdWorkReport;
import com.reyzar.oa.domain.AdWorkReportAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdWorkReportService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Service
@Transactional
public class AdWorkReportServiceImpl implements IAdWorkReportService {
	
	@Autowired
	private IAdWorkReportDao workReportDao;
	@Autowired
	private IAdWorkReportAttachDao workReportAttachDao;
	@Autowired
	private ISysDeptService deptService;

	@Override
	public Page<AdWorkReport> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		return workReportDao.findByPage(params);
	}

	@Override
	public AdWorkReport findById(Integer id) {
		return workReportDao.findById(id);
	}

	@Override
	public CrudResultDTO saveOrUpdate(JSONObject json) {
		CrudResultDTO result = null;
		AdWorkReport workReport = json.toJavaObject(AdWorkReport.class);
		
		if(workReport.getId() == null) {
			result = save(workReport);
		} else {
			result = update(workReport);
		}
		
		return result;
	}
	
	public CrudResultDTO save(AdWorkReport workReport) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		
		workReport.setUserId(user.getId());
		workReport.setCreateBy(user.getAccount());
		workReport.setCreateDate(new Date());
		workReport.setUpdateBy(user.getAccount());
		workReport.setUpdateDate(new Date());
		workReport.setStatus("0");
		
		workReportDao.save(workReport);
		
		List<AdWorkReportAttach> workReportAttachList = workReport.getWorkReportAttachList();
		for(AdWorkReportAttach attach : workReportAttachList) {
			attach.setWorkReportId(workReport.getId());
			attach.setCreateBy(user.getAccount());
			attach.setCreateDate(new Date());
			attach.setUpdateBy(user.getAccount());
			attach.setUpdateDate(new Date());
		}
		
		workReportAttachDao.insertAll(workReportAttachList);
		
		return result;
	}
	
	public CrudResultDTO update(AdWorkReport workReport) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		SysUser user = UserUtils.getCurrUser();
		Date currDate = new Date();
		
		workReport.setUpdateBy(user.getAccount());
		workReport.setUpdateDate(currDate);
		AdWorkReport originWorkReport = workReportDao.findById(workReport.getId());
		List<AdWorkReportAttach> originWorkReportAttachList = originWorkReport.getWorkReportAttachList();
		BeanUtils.copyProperties(workReport, originWorkReport);
		
		
		List<AdWorkReportAttach> saveList = Lists.newArrayList();
		List<AdWorkReportAttach> updateList = Lists.newArrayList();
		List<Integer> delList = Lists.newArrayList();
		
		Map<Integer, AdWorkReportAttach> originWorkReportAttachMap = Maps.newHashMap();
		for(AdWorkReportAttach workReportAttach : originWorkReportAttachList) {
			originWorkReportAttachMap.put(workReportAttach.getId(), workReportAttach);
		}
		
		List<AdWorkReportAttach> workReportAttachList = workReport.getWorkReportAttachList();
		for(AdWorkReportAttach workReportAttach : workReportAttachList) {
			if(workReportAttach.getId() != null) {
				if(workReportAttach.getUpdateDate() != null) { // 更新时间由前端指定
					workReportAttach.setUpdateBy(user.getAccount());
				}
				AdWorkReportAttach origin = originWorkReportAttachMap.get(workReportAttach.getId());
				if(origin != null) {
					BeanUtils.copyProperties(workReportAttach, origin);
					updateList.add(origin);
					originWorkReportAttachMap.remove(origin.getId());
				}
			} else {
				workReportAttach.setWorkReportId(workReport.getId());
				workReportAttach.setCreateBy(user.getAccount());
				workReportAttach.setCreateDate(currDate);
				workReportAttach.setUpdateBy(user.getAccount());
				workReportAttach.setUpdateDate(currDate);
				saveList.add(workReportAttach);
			}
		}
		
		delList.addAll(originWorkReportAttachMap.keySet());
		
		workReportDao.update(originWorkReport);
		if(saveList.size() > 0) {
			workReportAttachDao.insertAll(saveList);
		}
		if(updateList.size() > 0) {
			workReportAttachDao.batchUpdate(updateList);
		}
		if(delList.size() > 0) {
			workReportAttachDao.deleteByIdList(delList);
		}
		
		return result;
	}

	@Override
	public CrudResultDTO checkStatus(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		
		AdWorkReport workReport = workReportDao.findById(id);
		workReport.setStatus("1");
		workReportDao.update(workReport);
		
		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		
		AdWorkReport workReport = workReportDao.findById(id);
		List<AdWorkReportAttach> workReportAttachList = workReport.getWorkReportAttachList();
		List<Integer> idList = Lists.newArrayList();
		
		for(AdWorkReportAttach attach : workReportAttachList) {
			idList.add(attach.getId());
		}
		
		workReportDao.deleteById(id);
		workReportAttachDao.deleteByIdList(idList);
		return result;
	}

	/**
	 * 获取报表数据
	 * */
	@Override
	public Map<String, Object> getWorkReportChartsData(Map<String, String> paramsMap) {
		Map<String, Object> result = Maps.newHashMap();
		Map<String, Object> params = parseParam(paramsMap);
		
		// 获取数据与构建返回结果
		List<Map<String, Object>> dataList = workReportDao.getChartsData(params);
		if(dataList != null && dataList.size() > 0) {
			if(params.get("yearWithMonth") != null) { // 选择了年月，则legend是周数
				
				Map<Integer, String> legendMap = Maps.newHashMap();
				legendMap.put(1, "第一周");
				legendMap.put(2, "第二周");
				legendMap.put(3, "第三周");
				legendMap.put(4, "第四周");
				legendMap.put(5, "第五周");
				
				if(params.get("number") == null) {
					List<Object> yAxisData = Lists.newArrayList();
					List<Map<String, Object>> series = Lists.newArrayList();
//					List<Object> seriesData = Lists.newArrayList();
					for(Map<String, Object> map : dataList) {
						yAxisData.add(map.get("WORK_TIME"));
						
						Integer number = Integer.valueOf(map.get("NUMBER").toString());
						Map<String, Object> seriesData = series.get(number);
						if(seriesData == null) {
							seriesData = Maps.newHashMap();
							series.add(number, seriesData);
						}
						
						seriesData.put("name", legendMap.get(number));
						seriesData.put("type", "line");
						seriesData.put("data", null);
						
//						seriesData.add(map.get("WORK_DATE"));
						
					}
					result.put("legendData", new String[] {"第一周", "第二周", "第三周", "第四周", "第五周"});
					result.put("yAxisData", yAxisData);
//					result.put("seriesData", seriesData);
				} else {
					Integer number = Integer.valueOf(params.get("number").toString());
					Map<Integer, Map<String, Double>> workDateMap = Maps.newHashMap();
					
					for(Map<String, Object> map : dataList) {
						Map<String, Double> workTimeMap = workDateMap.get(number);
						if(workTimeMap == null) {
							workTimeMap = Maps.newLinkedHashMap();
							workDateMap.put(number, workTimeMap);
						}
						Double workTime = workTimeMap.get(map.get("WORK_DATE").toString());
						if(workTime == null) {
							workTime = 0.0;
						}
						workTime += Double.valueOf(map.get("WORK_TIME").toString());
						workTimeMap.put(map.get("WORK_DATE").toString(), workTime);
					}
					
					List<Object> yAxisData = Lists.newArrayList();
					List<Object> xAxisData = Lists.newArrayList();
					
					Map<String, Double> workTimeMap = workDateMap.get(number);
					Set<String> wtKeys = workTimeMap.keySet();
					for(String key : wtKeys) {
						yAxisData.add(key);
						xAxisData.add(workTimeMap.get(key));
					}
					
					Map<String, Object> seriesData = Maps.newHashMap();
					seriesData.put("name", legendMap.get(number).toString());
					seriesData.put("type", "line");
					seriesData.put("data", xAxisData.toArray());
					
					result.put("legendData", legendMap.get(number));
					result.put("yAxisData", yAxisData.toArray());
					result.put("seriesData", seriesData);
				}
				
			}
		}
		
		return result;
	}
	
	private Map<String, Object> parseParam(Map<String, String> paramsMap) {
		Map<String, Object> params = Maps.newHashMap();
		
		// 获取参数
		List<Integer> deptIdList = Lists.newArrayList();
		String year = paramsMap.get("year");
		String month = paramsMap.get("month");
		String number = paramsMap.get("number");
		String deptId = paramsMap.get("deptId");
		String userId = paramsMap.get("userId");
		
		// 构造参数条件
		if(month != null && !"".equals(month)) {
			String yearWithMonth = year+"-"+month;
			params.put("yearWithMonth", yearWithMonth);
		} else {
			params.put("year", year);
		}
		if(deptId != null && !"".equals(deptId)) {
			SysDept dept = deptService.findById(Integer.valueOf(paramsMap.get("deptId").toString()));
			if(dept != null) {
				deptService.getIds(dept, deptIdList);
			}
		} else {
			params.put("userId", userId);
		}
		
		params.put("deptIdList", deptIdList);
		params.put("number", number);
		
		return params;
	}
	
	@Override
	public CrudResultDTO checkNumber(Integer id, Integer userId, Integer month, Integer number, String workDate) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		try {
			Date date = sdf.parse(workDate);
			Calendar c = Calendar.getInstance();
			c.setTime(date);
			Integer year = c.get(Calendar.YEAR);
			List<AdWorkReport> list = workReportDao.findByCondition(id, userId, year, month, number);
			if( list != null && list.size() > 0 ) {
				return new CrudResultDTO(CrudResultDTO.FAILED, year+"年"+month+"月"+"第"+number+"周已存在，请重新选择周数！");
			} else {
				return new CrudResultDTO(CrudResultDTO.SUCCESS, "周数不存在！");
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return new CrudResultDTO(CrudResultDTO.EXCEPTION,"异常");

	}

	@Override
	public void exportExcel(OutputStream out, Map<String, Object> paramMap) {
		List<Integer> deptIdList = Lists.newArrayList();
		if(paramMap.get("deptId") != null) {
			SysDept dept = deptService.findById( Integer.valueOf(paramMap.get("deptId").toString()));
			deptService.getIds(dept, deptIdList);
		}
		paramMap.put("deptIdList", deptIdList);
		
		List<WorkReportExcelDTO> dataList = workReportDao.getExcelData(paramMap);
		Context context = new Context();
		context.putVar("year", paramMap.get("year"));
		context.putVar("month", paramMap.get("month"));
		context.putVar("dataList", dataList);

		ExcelUtil.export("workreport.xls", out, context);
	}

}