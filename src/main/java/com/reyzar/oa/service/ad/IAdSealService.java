package com.reyzar.oa.service.ad;

import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdSeal;

public interface IAdSealService {
	
	public Page<AdSeal> findByPage(Map<String, Object> params, int pageNum, int pageSize);
	
	public AdSeal findById(Integer id);
	
	public CrudResultDTO save(AdSeal seal);
	
	public CrudResultDTO update(AdSeal seal);
	
	public CrudResultDTO setStatus(Integer id, String status);

	CrudResultDTO sendMail(Integer id,String comment);
	
}