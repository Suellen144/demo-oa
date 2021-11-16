package com.reyzar.oa.service.ad;

import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdUserCar;

public interface IAdUserCarService {
	public Page<AdUserCar> findByPage(Map<String, Object> paramsMap, Integer pageNum, Integer pageSize);
	
	public AdUserCar findById(Integer id);
	
	public CrudResultDTO save(AdUserCar userCar);
	
	public CrudResultDTO update(AdUserCar userCar);
	
	public CrudResultDTO setStatus(Integer id, String status);
	
}