package com.reyzar.oa.controller;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Date;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.reyzar.oa.common.util.DateUtils;
import com.reyzar.oa.common.util.FileUtil;
import com.reyzar.oa.controller.ad.AdTravelController;


@Controller
@RequestMapping("/ckeditor")
public class CkeditorController {
	
	private final Logger logger = Logger.getLogger(CkeditorController.class);

	@Value("${ckeditor.file.root}")
	private String rootPath;
	private String filePath;
	
	@Value("${ckeditor.file.path}")
	private String filePathForLinux;
	private String filePathForWindows = System.getProperty("oa.webroot") + "/upload/ckeditor";
	
	
	@PostConstruct
	private void initFilePath() {
		// 判断操作系统平台
		if(System.getProperty("os.name").toLowerCase().indexOf("windows") > -1) {
			filePath = filePathForWindows;
		} else {
			filePath = filePathForLinux;
		}
	}
	
	@ResponseBody 
    @RequestMapping(value = "/upload/ckeditor/{day}/{fileName}.{extensions}", method = RequestMethod.GET)
    public byte[] getFile(@PathVariable String day,@PathVariable String fileName,HttpServletRequest request,HttpServletResponse response,@PathVariable String  extensions) {
		fileName = fileName+"."+extensions;
		byte[] buffer = null;  
		
		try {  
			//图片地址
			String imagePath = filePath +"/"+day+ "/" +fileName;
            File file = new File(imagePath);  
            
            if(!file.exists()){
            	String basePath = CkeditorController.class.getClassLoader().getResource("").getPath();
            	file = new File(basePath+"static/img/lose.jpg");
            }
            
            
            FileInputStream fis = new FileInputStream(file);  
            ByteArrayOutputStream bos = new ByteArrayOutputStream(1000);  
            byte[] b = new byte[1000];  
            int n;  
            while ((n = fis.read(b)) != -1) {  
                bos.write(b, 0, n);  
            }  
            fis.close();  
            bos.close();  
            buffer = bos.toByteArray();  
        } catch (FileNotFoundException e) {  
            e.printStackTrace();  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
        return buffer;  
    }
	
	@ResponseBody 
	@RequestMapping(value="/upload",produces = "text/html; charset=utf-8",method = RequestMethod.POST)
	public String upload(@RequestParam("upload") MultipartFile file,HttpServletRequest request,HttpServletResponse response) throws Exception { 
		
		String basePath = request.getContextPath();
		StringBuilder returnMessage = new StringBuilder();
		
        response.setCharacterEncoding("UTF-8");  
  
        // CKEditor提交的很重要的一个参数  
        String callback = request.getParameter("CKEditorFuncNum");   
          
        //判断文件是否图片
        String expandedName = FileUtil.getPrefixOfFile(file.getOriginalFilename()); //文件扩展名  
        if (!expandedName.equals("jpg") && !expandedName.equals("png") && !expandedName.equals("gif") && !expandedName.equals("bmp") ) {  
            returnMessage.append("<script type=\"text/javascript\">");    
            returnMessage.append("window.parent.CKEDITOR.tools.callFunction(" + callback + ",''," + "'文件格式不正确（必须为.jpg/.gif/.bmp/.png文件）');");   
            returnMessage.append("</script>");  
            return returnMessage.toString();  
        }  
        //判断文件大小  
        if(file.getSize() > 2*1024*1024){  
            returnMessage.append("<script type=\"text/javascript\">");    
            returnMessage.append("window.parent.CKEDITOR.tools.callFunction(" + callback + ",''," + "'文件大小不得大于2M');");   
            returnMessage.append("</script>");  
            return returnMessage.toString();  
        }  
          
          
        //用毫秒数指定文件名称
		String fileName = new Date().getTime()+"."+expandedName;
		String dayStr = DateUtils.dateToStr(new Date(), "yyyyMMdd");
		File imgFile = FileUtil.makeFileByPath(filePath + "/" + dayStr + "/" +fileName);
		
		//上传文件
	    if (!file.isEmpty()) {
	          try {
	          	
	              byte[] bytes = file.getBytes();
	              BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(imgFile));
	              stream.write(bytes);
	              stream.close();
	              
	          } catch (Exception e) {
	          	  returnMessage.append("<script type=\"text/javascript\">");    
	              returnMessage.append("window.parent.CKEDITOR.tools.callFunction(" + callback + ",''," + "'文件上传失败');");   
	              returnMessage.append("</script>");  
	              return returnMessage.toString();  
	          }
	    }
	    
        // 返回“图像”选项卡并显示图片  
        returnMessage.append("<script type=\"text/javascript\">");    
        returnMessage.append("window.parent.CKEDITOR.tools.callFunction(" + callback + ",'" + basePath + "/ckeditor" + rootPath + "/" + dayStr+"/" + fileName + "','')");    
        returnMessage.append("</script>");  
        
        return returnMessage.toString();  
    }  
	
	
}
