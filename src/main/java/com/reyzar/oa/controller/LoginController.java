package com.reyzar.oa.controller;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.reyzar.oa.common.encrypt.MD5Utils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.common.util.ValidateCode;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysUserService;

@Controller
public class LoginController {
	
	private final Logger logger = Logger.getLogger(LoginController.class);
	
	@Autowired
	private ISysUserService sysUserService;

	@RequestMapping(value="/manage/login", method=RequestMethod.GET)
	public String login(HttpServletRequest request) {
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		if (ismobile) {
			//手机端已经很久没有更新，目前pc更新版本过高，所以先禁止手机端页面，等后续开发手机端了再开放
			//request.setAttribute("isok", 1);
			return "mobile/common/login";
			//return "manage/common/login";
		}else{
			return "manage/common/login";
		}
	}
	
	@RequestMapping(value="/manage/login", method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> login(String username, String password, HttpServletRequest request) {
		Subject subject = SecurityUtils.getSubject();
		Map<String,Object> map = new HashMap<String, Object>();
		String userAgent = request.getHeader( "USER-AGENT" ).toLowerCase();
		boolean ismobile = UserUtils.CheckMobile.check(userAgent);
		if (ismobile) {
			//手机端已经很久没有更新，目前pc更新版本过高，所以先禁止手机端页面，等后续开发手机端了再开放
			map.put("check", false);
    		map.put("errorMsg", "手机端暂未开放！");
			return map;
		}
		UsernamePasswordToken token = new UsernamePasswordToken(username, MD5Utils.get32Code(password));
	    SysUser user = sysUserService.findByAccount(username);
	    if(user==null){
	    	logger.info("用户名不存在！");
			map.put("check", false);
    		map.put("errorMsg", "用户名不存在！");
			return map;
	    }
	    if(user.getMissStart() == 0 && user.getMissTime() != null) {
	    	if(user.getMissTime().getTime() >= (new Date().getTime())) {
				logger.info("登录验证失败，失败信息：请3秒后重新登录！");
				map.put("check", false);
	    		map.put("errorMsg", "请3秒后重新登录！");
				return map;
	    	}
	    }
		try {
			subject.login(token);
			SysUser user2 = new SysUser();
			user2.setMissStart(1);
			user2.setId(user.getId());
			sysUserService.modify(user2);
			map.put("check", true);
		} catch(AuthenticationException ae) {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Calendar c = new GregorianCalendar();
			Date date = new Date();  //获取系统当前时间
			System.out.println("系统当前时间："+ df.format(date));
			c.setTime(date);  //设置参数时间
			c.add(Calendar.SECOND,3);  //把日期往后增加SECOND 秒.整数往后推,负数往前移动
			date = c.getTime();  //这个时间就是日期往后推一天的结果
			String str = df.format(date);
			System.out.println("系统推后3秒时间："+ str);
			user.setMissStart(0);
			user.setMissTime(date);
			sysUserService.modify(user);
			
			token.clear();
			logger.info("登录验证失败，失败信息：" + ae.getMessage());
			map.put("check", false);
	    	map.put("errorMsg", "用户名或密码错误！");
			return map;
		}
		subject.getSession().setAttribute("user", sysUserService.findByAccount(username));
		return map;
	}
	
	@RequestMapping(value="/manage/logout")
	public String logout() {
		Subject user = SecurityUtils.getSubject();
		user.logout();
		return "redirect:/manage/login";
	}
	
	/**
     * 生成验证码
     * @param request
     * @param response
     * @throws IOException
     * @ValidateCode.generateTextCode(验证码字符类型,验证码长度,需排除的特殊字符)
     * @ValidateCode.generateImageCode(文本验证码,图片宽度,图片高度,干扰线的条数,字符的高低位置是否随机,图片颜色,字体颜色,干扰线颜色)
     */

    @RequestMapping(value = "/manage/validateCode")
    public void validateCode(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setHeader("Cache-Control", "no-cache");
        String verifyCode = ValidateCode.generateTextCode(ValidateCode.TYPE_NUM_ONLY, 4, null);
        request.getSession().setAttribute("validateCode", verifyCode);
        response.setContentType("image/jpeg");
        BufferedImage bim = ValidateCode.generateImageCode(verifyCode, 120, 40, 3, true, Color.WHITE, Color.BLUE, null);
        ImageIO.write(bim, "JPEG", response.getOutputStream());
    }
}
