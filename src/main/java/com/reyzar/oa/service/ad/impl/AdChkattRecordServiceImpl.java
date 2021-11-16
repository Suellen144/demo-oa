package com.reyzar.oa.service.ad.impl;

import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.service.ad.IAdChkattRecordService;
import com.reyzar.oa.service.ad.IAdLeaveService;
import com.reyzar.oa.service.sys.ISysDeptService;

@Service
@Transactional
public class AdChkattRecordServiceImpl implements IAdChkattRecordService {
	
	@Autowired
	private ISysDeptService deptService;
	@Autowired
	private IAdLeaveService leaveService;

	/**
	 * 获取考勤->请假图表数据
	 */
	@Override
	public Map<String, Object> getLeaveChartData(Map<String, Object> paramsMap) {
		Map<String, Object> result = Maps.newHashMap();
		// 获取参数
		List<Integer> deptIdList = Lists.newArrayList();
		String year = paramsMap.get("year") == null || "".equals(paramsMap.get("year").toString().trim()) 
							? String.valueOf(Calendar.getInstance().get(Calendar.YEAR)) 
							: paramsMap.get("year").toString();
		String month = paramsMap.get("month") == null  || "".equals(paramsMap.get("month").toString().trim()) 
							? String.valueOf(Calendar.getInstance().get(Calendar.MONTH)) 
							: paramsMap.get("month").toString();
		String yearWithMonth = year+"-"+month;
		SysDept dept = deptService.findById(Integer.valueOf(paramsMap.get("deptId").toString()));
		if(dept != null) {
			getIds(dept, deptIdList);
		}
		
		// 构造参数条件
		Map<String, Object> params = Maps.newHashMap();
		params.put("yearWithMonth", yearWithMonth);
		params.put("deptIdList", deptIdList);
		
		// 获取数据与构建返回结果
		List<Map<String, Object>> daysList = leaveService.getLeaveDays(params);
		
		if(daysList.size()>0) {
			List<Object> yAxisData = Lists.newArrayList();
			List<Object> seriesData = Lists.newArrayList();
			for(Map<String, Object> map : daysList) {
				yAxisData.add(map.get("NAME"));
				seriesData.add(map.get("DAYS"));
			}
			result.put("legendData", yearWithMonth);
			result.put("yAxisData", yAxisData);
			result.put("seriesData", seriesData);
		}
		
		return result;
	}
	
	/**
	 * 递归获取部门、子部门的ID集合
	 * */
	private void getIds(SysDept dept, List<Integer> idList) {
		if(dept.getChildren() != null || dept.getChildren().size() > 0) {
			for(SysDept child : dept.getChildren()) {
				getIds(child, idList);
			}
			idList.add(dept.getId());
		} else {
			idList.add(dept.getId());
		}
	}

}
