package com.reyzar.oa.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;

import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.FileUploadDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.common.util.SpringContextUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: FileUploadController 
* @Description: 通用的文件上传工具
* @author Lin 
* @date 2016年8月26日 上午11:27:21 
*  
*/
@Controller
@RequestMapping("/fileUpload")
public class FileUploadController extends BaseController {
	
	private final Logger logger = Logger.getLogger(FileUploadController.class);

	private String rootPath;
	private String uploadPath; // 上传文件夹根目录
	private final static String fileNameRegexp = ".*(\\&|\\*|\\%|\\?).*";
	
	
	@Value("${file.root.upload}")
	private String rootPathForLinux;
	@Value("${file.upload}")
	private String uploadPathForLinux;
	
	private String rootPathForWindows = System.getProperty("oa.webroot");;
	private String uploadPathForWindows = rootPathForWindows + "/upload/";
	
	
	@PostConstruct
	private void initFilePath() {
		// 判断操作系统平台
		if(System.getProperty("os.name").toLowerCase().indexOf("windows") > -1) {
			rootPath = rootPathForWindows;
			uploadPath = uploadPathForWindows;
		} else {
			rootPath = rootPathForLinux;
			uploadPath = uploadPathForLinux;
		}
	}
	
	/**
	* @Title: upload
	* @Description: 接收上传的文件（单文件）
	* @param response
	* @param request 可接收的参数
	* 			path: 文件保存路径，必须指定
	* 
	*			deleteFile：要删除的文件路径，有些上传是为了替换原来的文件。删除路径 /upload/deleteFile
	*						null 或 "" 时不删除，表示只上传不替换
	*
	*			class：文件保存完毕后要调用的Java类
	*						null 或 "" 时不实例化
	*
	*			method：与class参数搭配使用，被调方法必须有且只有一个Map<String, Object>参数
	*						null 或 "" 时不调用，upload方法则返回FileUploadDTO对象给客户端
	*						有调用方法时，则封装FileUploadDTO、response与request的其他参数作为方法参数传入
	*						Map<String, Object>参数值：
	*							K = fileUploadDto V = FileUploadDTO
	*							K = request       V = HttpServletRequest
	*							K = response	  V = HttpServletResponse
	* @throws
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("")
	@ResponseBody
	public void upload(HttpServletRequest request, HttpServletResponse response) {
		
		FileUploadDTO fileUploadDto = new FileUploadDTO();
		DefaultMultipartHttpServletRequest fileRequest = null;
		CrudResultDTO execResult = null;
		Object callObj = null;
		Method callMethod = null; 
		// 获取所有请求参数
		String path = request.getParameter("path");
		String deleteFile = request.getParameter("deleteFile");
		String clz = request.getParameter("class");
		String method = request.getParameter("method");
		
		if(request instanceof DefaultMultipartHttpServletRequest) {
			fileRequest = (DefaultMultipartHttpServletRequest)request;
		} else { // 不是有效请求则直接返回错误提示到客户端
			execResult = new CrudResultDTO(CrudResultDTO.FAILED, "不是有效文件！");
			fileUploadDto.setExecResult(execResult);
			renderJSONString(response, fileUploadDto);
			return ;
		}
		
		// 解析参数
		try {
			if(path == null || "".equals(path.trim())) {
				execResult = new CrudResultDTO(CrudResultDTO.FAILED, "保存路径不能为空！");
				fileUploadDto.setExecResult(execResult);
			}
			if(clz != null && !"".equals(clz.trim())) {
				Class clazz = Class.forName(clz);
				callObj = SpringContextUtils.getBean(clazz);
				if(callObj == null) {
					callObj = clazz.newInstance();
				}
			}
			if(callObj != null) {
				if(method != null && !"".equals(method.trim())) {
					callMethod = callObj.getClass().getMethod(method, Map.class);
				} else {
					execResult = new CrudResultDTO(CrudResultDTO.FAILED, clz+": 没有指定调用方法！");
				}
			}
		} catch(Exception e) {
			execResult = new CrudResultDTO(CrudResultDTO.FAILED, e.getMessage());
		}
		
		// 参数解析错误，返回信息给客户端
		if(execResult != null) {
			fileUploadDto.setExecResult(execResult);
			renderJSONString(response, fileUploadDto);
			return ;
		}
		
		
	 	MultipartFile multipartFile = null;
        Iterator<String> itr = fileRequest.getFileNames();
        while(itr.hasNext()){
        	multipartFile = fileRequest.getFile(itr.next()); 
            try {
            	// 保存图片到服务器
            	if(path.startsWith("/")) {
            		path = path.substring(1);
            	}
            	File dir = new File(uploadPath + path);
            	if(!dir.exists()) {
            		dir.mkdirs();
            	}
            	
            	String suffix = FileUtil.getPrefixOfFile(multipartFile.getOriginalFilename()); // 文件后缀
            	String fileName = new Date().getTime() + "." + suffix; // 新文件名
            	String savePath = dir.getPath()+ "/" + fileName; // 文件保存路径
            	
                FileCopyUtils.copy(multipartFile.getBytes(), new FileOutputStream(savePath));
                
                execResult = new CrudResultDTO(CrudResultDTO.SUCCESS, "文件保存成功！");
                fileUploadDto.setExecResult(execResult);
                fileUploadDto.setName(fileName);
                fileUploadDto.setOriginName(multipartFile.getOriginalFilename());
                fileUploadDto.setSize(Long.valueOf(multipartFile.getBytes().length));
                fileUploadDto.setPath("/upload/"+path+"/"+fileName);
                fileUploadDto.setSuffix(suffix);
                fileUploadDto.setUploadDate(new Date());
                
                // 删除旧文件
                if(deleteFile != null && !"".equals(deleteFile.trim())) {
                	SysUser user = UserUtils.getCurrUser();
                	if(user != null) {
                		if(!deleteFile.startsWith("/upload")) {
                			deleteFile = "/upload" + deleteFile;
                		}
                		File delFile = new File(rootPath + deleteFile);
                		if(delFile.exists()) {
                			delFile.delete();
                			logger.info(user.getName() + "执行删除文件。文件：" + delFile);
                		}
                	}
                }
                
                logger.info("上传文件成功：" + savePath);
                break ;
           } catch (IOException e) {
        	   execResult = new CrudResultDTO(CrudResultDTO.FAILED, e.getMessage());
           }
        }
        
        // 如果有回调方法则调用
    	try {
    		if(callMethod != null) {
    			Map<String, Object> params = Maps.newHashMap();
    			params.put("fileUploadDto", fileUploadDto);
    			params.put("request", request);
    			params.put("response", response);
    			
    			callMethod.invoke(callObj, params);
    			return ;
    		}
		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			execResult = new CrudResultDTO(CrudResultDTO.EXCEPTION, "文件已保存，但回调方法时出错！错误信息：" + e.getMessage());
		}
		
    	fileUploadDto.setExecResult(execResult);
		renderJSONString(response, fileUploadDto);
		return ;
	} 
	
	
	@RequestMapping("/download")
	public void download(HttpServletRequest request, HttpServletResponse response) {
		String filePath = request.getParameter("filePath");
		String fileName = request.getParameter("fileName");
		OutputStream out = null;
		
		
		if(filePath != null && !"".equals(filePath.trim())) {
			try {
	        	SysUser user = UserUtils.getCurrUser();
	        	if(user != null) {
	        		if(!filePath.startsWith("/upload")) {
	        			filePath = "/upload" + filePath;
	        		}
	        		File file = new File(rootPath + filePath);
	        		if(file.exists()) {
	        			if( fileName.matches(fileNameRegexp) ) { // 有特殊字符的需要做编码处理       				
	        				fileName = URLEncoder.encode(fileName, "UTF-8");
	        			} else {
	        				fileName = new String(fileName.getBytes(), "UTF-8");
	        			}
	        			
	        			response.setContentType("application/octet-stream;");
	        			response.setHeader("Content-Disposition", "attachment;fileName=" + fileName);
	        			out = response.getOutputStream();
	        			out.write(FileUtils.readFileToByteArray(file));
	        			out.flush();
	        			
	        			logger.info(user.getName() + "下载文件。文件：" + file);
	        		} else {
	        			throw new Exception("文件：[" + fileName + "]不存在！");
	        		}
	        	}
			} catch(Exception e) {
				throw new BusinessException(e.getMessage());
			} finally {
				if(out != null) {
					try {
						out.close();
					} catch (IOException e) {
						throw new BusinessException(e.getMessage());
					}
				}
			}
        }
	}
	
}