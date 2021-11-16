package com.reyzar.oa.service.ad;

import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdMeeting;

public interface IAdMeetingService {
	public AdMeeting findById(Integer id);
	
	public Page<AdMeeting> findByPage(Map<String, Object> params,Integer pageNum, Integer pageSize);
	
	public void sendMail(AdMeeting meeting);
	
	public CrudResultDTO save(AdMeeting meeting);
	
	public CrudResultDTO  update(AdMeeting meeting);

	public CrudResultDTO deleteById(Integer id);
	
}