package com.reyzar.oa.controller.ad;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.AdRulesRegulation;
import com.reyzar.oa.domain.AdRulesRegulationOutline;
import com.reyzar.oa.service.ad.IAdRulesRegulationService;

/** 
* @ClassName: AdRulesRegulationController 
* @Description: 规章制度管理
* @author Lin 
* @date 2016年11月14日 下午2:20:25 
*  
*/
@Controller
@RequestMapping("/manage/ad/rulesRegulation")
public class AdRulesRegulationController extends BaseController {
	
	private final static int ROOT = -1;
	
	@Autowired
	private IAdRulesRegulationService rulesRegulationService;
	
	@RequestMapping("/toPage")
	public String toPage(Model model) {
		model.addAttribute("hasUnpublic", rulesRegulationService.hasUnpublic());
		return "manage/ad/rulesRegulation/view";
	}
	
	@RequestMapping("/getAllOutline")
	@ResponseBody
	public List<AdRulesRegulationOutline> getAllOutline() {
		return rulesRegulationService.getAllOutline();
	}
	
	@RequestMapping("/getRootOutline")
	@ResponseBody
	public AdRulesRegulationOutline getRootOutline() {
		return rulesRegulationService.findByParentId(ROOT);
	}
	
	@RequestMapping("/toVerify")
	public String toVerify() {
		return "manage/ad/rulesRegulation/verify";
	}
	
	@RequestMapping("/toEdit")
	public String toEdit(Model model, HttpServletRequest request) {
		String isApprove = request.getParameter("approve");
		
		AdRulesRegulation rulesRegulation = rulesRegulationService.findFirst();
		model.addAttribute("rulesRegulation", rulesRegulation);
		model.addAttribute("isApprove", isApprove);
		
		return "manage/ad/rulesRegulation/edit";
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public CrudResultDTO save(AdRulesRegulation rulesRegulation) {
		return rulesRegulationService.save(rulesRegulation);
	}
	
	@RequestMapping("/approve")
	@ResponseBody
	public CrudResultDTO approve(Integer id) {
		return rulesRegulationService.approve(id);
	}
	
	
	
	@RequestMapping("/saveOrUpdateTitle")
	@ResponseBody
	public CrudResultDTO saveOrUpdateTitle(AdRulesRegulationOutline rulesRegulationOutline) {
		return rulesRegulationService.saveOrUpdateTitle(rulesRegulationOutline);
	}
	
	@RequestMapping("/deleteTitle")
	@ResponseBody
	public CrudResultDTO deleteTitle(Integer id) {
		return rulesRegulationService.deleteTitle(id);
	}
	
	@RequestMapping("/saveOrUpdateContent")
	@ResponseBody
	public CrudResultDTO saveOrUpdateContent(AdRulesRegulation rulesRegulation) {
		return rulesRegulationService.saveOrUpdateContent(rulesRegulation);
	}
}