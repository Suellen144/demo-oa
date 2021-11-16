package com.reyzar.oa.service.office;

import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.OffNotice;
import com.reyzar.oa.domain.SysUser;

public interface IOffNoticeService {
	
	public int getNoticeCount(Map<String, Object> params);
	
	public int getUnreadCount(Map<String, Object> params);
	
	public Page<OffNotice> findByPage(Map<String, Object> params, int pageNum, int pageSize);

	public CrudResultDTO save(OffNotice notice, SysUser user);
	
	public CrudResultDTO update(OffNotice notice);
	
	public void batchUpdateIsPublished(List<OffNotice> noticeList);

	public OffNotice findById(Integer id);

	public CrudResultDTO deleteById(Integer id); 
	
	public List<OffNotice> findAll();
	
	public CrudResultDTO setReadStatus(Integer noticeId);
	
	public CrudResultDTO setApproveStatus(Integer id, String approveStatus);
	
	public void sendMail(OffNotice notice);
	
	public List<OffNotice> getUnpublishNotice();

	public Page<OffNotice> findPointByPage(Map<String, Object> paramsMap, int pageNum, int pageSize);
	
	public List<OffNotice> getTop5Notice(Map<String, Object> params);
 
}
