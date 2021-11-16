package com.reyzar.oa.controller.addressbook;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.reyzar.oa.common.util.WebUtil;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AddressBook;
import com.reyzar.oa.service.addressbook.IAddressBookService;

/** 
* @ClassName: AddressBookController
* @Description: 通讯录控制器
* @author LWY
* @date 2018年08月07日
*  
*/
@Controller
@RequestMapping("/manage/addressbook")
public class AddressBookController extends BaseController {
	@Autowired
	private IAddressBookService addressBookService;
	
	@RequestMapping("/toList")
	public String toList(HttpServletRequest request) {
		return "manage/addressbook/addressBookList";
		
	}
	
	@RequestMapping("/queryAddressBookList")
	@ResponseBody
	public List<AddressBook> queryAddressBookList(HttpServletRequest request, HttpServletResponse response) {
		@SuppressWarnings("unchecked")
		Map<String, Object> param = WebUtil.paramsToMap(request.getParameterMap());
		Map<String, Object> param1=new HashMap<String, Object>();
		if(StringUtils.isEmpty(param.get("queryVal"))){
			param1.put("queryVal1", param.get("queryVal"));
		}else{
			//校验
			Pattern pat = Pattern.compile("[\u4e00-\u9fa5]");
			boolean isChinese = pat.matcher(param.get("queryVal").toString()).find();
			
			Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");  
			boolean isNuber = pattern.matcher(param.get("queryVal").toString()).matches();
			
			int result1 =  param.get("queryVal").toString().indexOf("@");  
	        
	        if(isChinese){
	        	//姓名
	        	param1.put("queryVal1", param.get("queryVal"));
	        }
	        if(isNuber){
				//电话
				param1.put("queryVal2", param.get("queryVal"));
			}
			if(result1 != -1){
				//邮箱
				param1.put("queryVal3", param.get("queryVal"));
			}
		}
		List<AddressBook> addressBookList=addressBookService.queryAddressBookList(param1);
		return addressBookList;
	}
}