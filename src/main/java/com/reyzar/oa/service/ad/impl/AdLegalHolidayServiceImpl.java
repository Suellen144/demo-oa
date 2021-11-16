package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdLegalHolidayDao;
import com.reyzar.oa.domain.AdLegalHoliday;
import com.reyzar.oa.domain.AdLegwork;
import com.reyzar.oa.domain.AdSalary;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdLegalHolidayService;

@Service
@Transactional
public class AdLegalHolidayServiceImpl implements IAdLegalHolidayService {
	private final static Logger logger = Logger.getLogger(AdLegalHolidayServiceImpl.class);
	
	@Autowired 
	IAdLegalHolidayDao legalHolidayDao;
	
	@Override
	public Page<AdLegalHoliday> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
		String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.LEGWORK);
		PageHelper.startPage(pageNum, pageSize);
		PageHelper.orderBy("id desc");
		Page<AdLegalHoliday> page = legalHolidayDao.findByPage(params);
		return page;
	}

	@Override
	public CrudResultDTO save(JSONObject json, SysUser user) {
		List<AdLegalHoliday> lwList=Lists.newArrayList();
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		String uuid = UUID.randomUUID().toString().trim().replaceAll("-", "");
		String[] ntList= json.getJSONArray("name").toArray(new String[]{});
		String[] dtList= json.getJSONArray("dateBelongs").toArray(new String[]{});
		String[] stList= json.getJSONArray("startDate").toArray(new String[]{});
		String[] elaceList= json.getJSONArray("endDate").toArray(new String[]{});
		String[] legalList= json.getJSONArray("legal").toArray(new String[]{});
		String[] numList= json.getJSONArray("numberDays").toArray(new String[]{});
		String[] beforeList= json.getJSONArray("beforeLeave").toArray(new String[]{});
		String[] afterList= json.getJSONArray("afterLeave").toArray(new String[]{});
		try {
			int length=stList.length;
			for (int index = 0; index <length; index++) {
				if (ntList[index]!="" && legalList[index]!=""  && dtList[index]!="" && stList[index] != "" && elaceList[index] !="" && numList[index] !="") {
					AdLegalHoliday adLegalHoliday =new AdLegalHoliday();
					adLegalHoliday.setName(!StringUtils.isBlank(ntList[index])?String.valueOf(ntList[index]) : null);
					adLegalHoliday.setDateBelongs(!StringUtils.isBlank(dtList[index])?String.valueOf(dtList[index]) : null);
					adLegalHoliday.setStartDate(!StringUtils.isBlank(stList[index])?DateUtils.parseDate(stList[index], "yyyy-MM-dd") : null);
					adLegalHoliday.setEndDate(!StringUtils.isBlank(elaceList[index])?DateUtils.parseDate(elaceList[index], "yyyy-MM-dd") : null);
					adLegalHoliday.setLegal(!StringUtils.isBlank(legalList[index])?DateUtils.parseDate(legalList[index], "yyyy-MM-dd") : null);
					adLegalHoliday.setNumberDays(!StringUtils.isBlank(numList[index])?Integer.valueOf(numList[index]) : null);
					adLegalHoliday.setCreateBy(user.getName());
					adLegalHoliday.setCreateDate(new Date());
					if(beforeList[index]!=""){
						adLegalHoliday.setBeforeLeave(!StringUtils.isBlank(beforeList[index])?DateUtils.parseDate(beforeList[index], "yyyy-MM-dd") : null);
					}
					if(afterList[index]!=""){
						adLegalHoliday.setAfterLeave(!StringUtils.isBlank(afterList[index])?DateUtils.parseDate(afterList[index], "yyyy-MM-dd") : null);
					}
					lwList.add(adLegalHoliday);
				}
				
			}
			
			legalHolidayDao.addBatchs(lwList);
		} 
		catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "保存失败" + e.getMessage());
			e.printStackTrace();
			logger.error(result);
			
		}		
		return result;
	}

	
	@Override
	public AdLegalHoliday findById(Integer id) {
		
		return legalHolidayDao.findById(id);
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			legalHolidayDao.delete(id);
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "删除失败" + e.getMessage());
			e.printStackTrace();
			logger.error(result);
		}
		return result;
	}

	@Override
	public CrudResultDTO update(JSONObject json) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "更改成功！");
		AdLegalHoliday adLegalHoliday=json.toJavaObject(AdLegalHoliday.class);
		adLegalHoliday.setUpdateDate(new Date());
		adLegalHoliday.setUpdateBy(UserUtils.getCurrUser().getName());
		try {
			legalHolidayDao.update(adLegalHoliday);
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.FAILED, "更新失败" + e.getMessage());
			e.printStackTrace();
			logger.error(result);
		}
		return result;
	}


}
