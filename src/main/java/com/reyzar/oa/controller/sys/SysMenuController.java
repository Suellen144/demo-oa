package com.reyzar.oa.controller.sys;

import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.log4j.Logger;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.reyzar.oa.common.util.StringUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SysMenu;
import com.reyzar.oa.service.sys.ISysMenuService;

@Controller
@RequestMapping("/manage/sys/menu")
public class SysMenuController extends BaseController {
	
	private final Logger logger = Logger.getLogger(SysMenuController.class);
	
	@Autowired
	private ISysMenuService menuService;
	
	@RequiresPermissions("sys:menu:view")
	@RequestMapping("/toList")
	public String toList(Model model) {
		List<SysMenu> menuList = menuService.findAll();
		model.addAttribute("menuList", menuList);
		return "manage/sys/menu/list";
	}
	
	@RequiresPermissions("sys:menu:view")
	@RequestMapping("/getMenuList") 
	public void getMenuList(HttpServletResponse response) {
		List<SysMenu> menuList = menuService.findByParentid(-1);
		renderJSONString(response, (menuList != null && menuList.size() > 0)?menuList.get(0):null);
	}
	
	@RequestMapping("/toAddOrEdit")
	public String toAddOrEdit(@RequestParam Integer id, 
			@RequestParam(value="isEdit", required=false) String isEdit,
			Model model) {
		
		SysMenu self = null;
		SysMenu parentMenu = null;
		
		// 编辑操作
		if(!StringUtils.isBlank(isEdit) && "true".equals(isEdit)) {
			self = menuService.findById(id);
			parentMenu = menuService.findParentById(self.getParentId());
		} else { // 添加子菜单操作，当前ID是父级菜单ID
			self = new SysMenu();
			parentMenu = menuService.findById(id); 
		}
		
		model.addAttribute("menu", self);
		model.addAttribute("parentMenu", parentMenu);
		
		return "manage/sys/menu/addOrEdit";
	}
	
	@RequestMapping(value="/save", method=RequestMethod.POST)
	public String save(@Valid SysMenu menu, BindingResult result) {
		menuService.save(menu);

		return "redirect:/manage/sys/menu/toList";
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam Integer id) {
		menuService.deleteById(id);
		
		return "redirect:/manage/sys/menu/toList";
	}
	
}