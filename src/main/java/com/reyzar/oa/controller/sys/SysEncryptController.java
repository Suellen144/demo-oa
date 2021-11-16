package com.reyzar.oa.controller.sys;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.DateUtils;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.service.sys.ISysEncryptService;

@Controller
@RequestMapping("/manage/sys/encrypt")
public class SysEncryptController extends BaseController {
	
	private final static Logger logger = Logger.getLogger(SysEncryptController.class);
	
	@Autowired
	private ISysEncryptService encryptService;

	@RequestMapping("/toPage")
	public String toPage() {
		return "manage/sys/encrypt/edit";
	}
	
	@RequestMapping("/generateKey")
	@ResponseBody
	public CrudResultDTO generateKey(@RequestParam(value="encryptionKeyFile") MultipartFile file, HttpServletResponse response) throws Exception {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.FAILED, "操作失败！");
		
		CrudResultDTO checkResult = encryptService.checkEncryptionKey(file);
		if(checkResult.getCode() == CrudResultDTO.SUCCESS) {
			String oldEncryptionKey = checkResult.getResult().toString();
			String newEncryptionKey = encryptService.getEncryptKey();
			
			// 更新最新密文到数据库
			String oldCiphertext = ModuleEncryptUtils.getCipertextFromDatabase();
			String newCiphertext = ModuleEncryptUtils.encryptText(ModuleEncryptUtils.ENCRYPT_ORIGINAL_TEXT, newEncryptionKey);
			ModuleEncryptUtils.updateCipertextToDatabase(newCiphertext);
			
			try {
				result = encryptService.updateCryptedData(oldEncryptionKey, newEncryptionKey);
			} catch(Exception e) {
				ModuleEncryptUtils.updateCipertextToDatabase(oldCiphertext); // 如果失败，要回滚到旧密文
				throw new BusinessException(e);
			}
		} else {
			result = checkResult;
		}
		
		return result;
	}
	
	@RequestMapping("/getEncryptionKey")
	public void getEncryptionKey(HttpServletRequest request, HttpServletResponse response) {
		OutputStream out = null;
		FileInputStream fis = null;
		try {
			String encryptionKeyPath = request.getParameter("encryptionKeyPath");
			File file = new File(encryptionKeyPath);
			fis = new FileInputStream(file);
			byte[] bytes = new byte[fis.available()];
			fis.read(bytes);
			
			response.setContentType("application/x-msdownload;charset=UTF-8");
			String fileName = "EncryptionKey-" + DateUtils.dateToStr(new Date(), "yyyyMMddHHmmss") + ".txt";
			response.setHeader("Content-Disposition","attachment;filename=" + fileName);
			out = response.getOutputStream();
			out.write(bytes);
			out.flush();
			
			if(file.exists()) { // 下载完临时密钥文件，则删除之
				file.delete();
			}
		} catch(Exception e) {
			logger.error("下载密钥文件发生异常，异常信息：" + e.getMessage());
		} finally {
			try {
				if(out != null) { out.close(); }
				if(fis != null) { fis.close(); }
			} catch (IOException e) {}
		}
	}
	
}

