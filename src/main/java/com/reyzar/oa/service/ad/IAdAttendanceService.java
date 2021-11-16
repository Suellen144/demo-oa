package com.reyzar.oa.service.ad; 
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.AdAttendance;

/**
 * 
 * @Description: 
 * @author Lairongfa
 * @date 2016年9月9日 上午10:50:18 
 *
 */
public interface IAdAttendanceService {
	public List<Map<String, Object>> importexcel(String filename);
	CrudResultDTO save(AdAttendance adAttendance,String uploadpath);
	
	public CrudResultDTO getList();
	
	public void exportExcel(ServletOutputStream outputStream);
	public void exportExcel2(HttpServletResponse response);
	public String save2(Map<String, Object> param,MultipartFile[] uploadfile);
	
	public List<AdAttendance> queryAttendanceData();
}
 