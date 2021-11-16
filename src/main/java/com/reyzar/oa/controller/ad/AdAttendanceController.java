package com.reyzar.oa.controller.ad; 
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.WebUtil;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdAttendance;
import com.reyzar.oa.service.ad.IAdAttendanceService;

/**
 * 
 * @Description: 
 * @author Lairongfa
 *
 */

@Controller
@RequestMapping("/manage/ad/attendance")
public class AdAttendanceController extends BaseController{

	@SuppressWarnings("unused")
	private final Logger logger = Logger.getLogger(AdAttendanceController.class);
	@Autowired
	private IAdAttendanceService iAdAttendanceService;
	
	@RequestMapping("/toList")
	public String toList() {
		return "manage/ad/chkatt/attendance/addOrEdit";
	}
	
	@RequestMapping("/getList")
	@ResponseBody
	public String getList() {
		return JSON.toJSONString(iAdAttendanceService.getList());
	}
	
	
	@RequestMapping(value="save", method=RequestMethod.POST )
	@ResponseBody
	public CrudResultDTO save(AdAttendance adAttendance,HttpServletRequest request) throws Exception {
		final String rootPath = System.getProperty("oa.webroot"); // Web应用物理路径
		final String webRoot="F:/javaspace4/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps";
//		String path ="/opt/oa_upload"+request.getParameter("filePath");  //测试环境
		String path ="/opt/data/oa_upload"+request.getParameter("filePath");  //生产环境
//		String path ="E:/LWY/tomcat/OATomcat/apache-tomcat-8.0.14/webapps/oa"+request.getParameter("filePath");//本机

		//String path =webRoot+"/oa"+request.getParameter("filePath");
//		String filePath = rootPath.replaceAll("\\\\", "/");
//		final String temp = filePath + path;
//		String uploadPath=path.replaceAll("//", "/");
//		System.out.println(uploadPath);
		HttpSession session=request.getSession();
		CrudResultDTO result=iAdAttendanceService.save(adAttendance,path);
		
		if(result.getResult().equals("入库成功！")){
			session.setAttribute("attendance","入库成功！");
		}else{
			session.setAttribute("attendance","false");
		}
		return result;
	}
	
	@RequestMapping(value="save2", method=RequestMethod.POST )
	@ResponseBody
	public String save2(HttpServletRequest request,@RequestParam("file") MultipartFile[] uploadfile) throws Exception {
		@SuppressWarnings("unchecked")
		Map<String, Object> param  = WebUtil.paramsToMap(request.getParameterMap());
		String result=iAdAttendanceService.save2(param,uploadfile);
		return result;
	}
	
//	@RequestMapping("/exportExcel")
//	public void exportExcel(HttpServletResponse response, HttpServletRequest request) throws IOException {
//		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
//		String fileName = "考勤记录-"+sdf.format(new Date())+".xls";
//		String agent = request.getHeader("USER-AGENT").toLowerCase();
//		if (agent.contains("firefox")) {
//			response.setCharacterEncoding("UTF-8");
//			fileName = new String(fileName.getBytes(), "ISO8859-1");
//		} else {
//			fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
//		}
//		
//		response.setContentType("application/vnd.ms-excel; charset=utf-8");  
//        response.addHeader("Content-Disposition", "attachment;filename=" + fileName);
//        
//        iAdAttendanceService.exportExcel(response.getOutputStream());
//	}
	
	@RequestMapping("/exportExcel2")
	public void exportExcel2(HttpServletResponse response, HttpServletRequest request){
		iAdAttendanceService.exportExcel2(response);
	}
	
	@RequestMapping("/queryAttendanceData")
	@ResponseBody
	public List<AdAttendance> queryAttendanceData(HttpServletResponse response, HttpServletRequest request){
		List<AdAttendance> list=iAdAttendanceService.queryAttendanceData();
		return list;
	}
	
    
}
 