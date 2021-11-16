package com.reyzar.oa.controller;

import java.io.IOException;

import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.util.ModuleEncryptUtils;
import com.reyzar.oa.service.sys.ISysMenuService;

@Controller
public class MainController extends BaseController {

	private final Logger logger = Logger.getLogger(MainController.class);
	
	@Autowired
	private ISysMenuService menuService;
	
	@RequestMapping(value="/")
	public String root() {
		Subject subject = SecurityUtils.getSubject();
		if(subject.isAuthenticated() || subject.isRemembered()) {
			return "redirect:manage/main";
		} else {
			return "redirect:manage/login";
		}
	}
	
	@RequestMapping(value="/manage/main")
	public String toIndex() {
		return "manage/common/main";
	}
	
	@RequestMapping(value="/manage/mIndex")
	public String toMIndex() {
		return "mobile/index/index";
	}
	
	@RequestMapping(value="/manage/main2")
	public String toIndex2() {
		return "manage/common/main2";
	}
	
	@RequestMapping(value="/manage/personal")
	public String toPersonal() {
		return "mobile/sys/user/user";
	}
	
	@RequestMapping(value="/unauthorized")
	public String unauthorized() {
		return "manage/error/unauthorized";
	}
	
	@RequestMapping(value="/manage/getMenuList")
	@ResponseBody
	public String getMenuList() {
		return menuService.findMenuForJson();
	}
	
	@RequestMapping(value="/manage/getMenuList2")
	@ResponseBody
	public String getMenuList2() {
		return menuService.findMenuForJson2();
	}
	
	@RequestMapping(value="/manage/importEncryptionKey")
	@ResponseBody
	public CrudResultDTO importEncryptionKey(@RequestParam(value="encryptionKeyFile") MultipartFile file) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "导入成功！");
		try {
			byte[] bytes = file.getBytes();
			String encryptionKey = new String(bytes);
			encryptionKey = encryptionKey.trim();
			
			if( "".equals(encryptionKey) ) {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("密钥字符为空，请导入正确的文件！");
			} else if( !ModuleEncryptUtils.validEncryptionKey(encryptionKey) ) {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("密钥不正确，请导入正确的文件！");
			} else {
				ModuleEncryptUtils.setEncryptionKeyToSession(encryptionKey);
			}
		} catch (IOException e) {
			logger.error("导入密钥发生异常，异常信息：" + e.getMessage());
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("导入发生异常，请联系管理员！");
		}
		
		return result;
	}
	
	/**
	* @Title: getEncryptionKey
	* @Description: 获取密钥，需要二次加密，防止原密钥传输被拦截获取
	  @param baseKey 二次加密需要的原文
	  @return
	* @return CrudResultDTO
	 */
	@RequestMapping(value="/manage/getEncryptionKey")
	@ResponseBody
	public CrudResultDTO getEncryptionKey(String baseKey) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "");
		if( baseKey == null || "".equals(baseKey.trim()) ) {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("加密原文不能为空！");
		} else {
			String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
			if( encryptionKey == null ) {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("密钥为空！");
			} else {
				if( ModuleEncryptUtils.validEncryptionKey(encryptionKey) ) {
					result.setCode(CrudResultDTO.SUCCESS);
					result.setResult(AesUtils.encryptECB(encryptionKey, baseKey)); // 二次加密
				} else {
					result.setCode(CrudResultDTO.EXCEPTION);
					result.setResult("密钥已更改，请重新导入新密钥！"); // 二次加密
				}
			}
		}
		
		return result;
	}
}
