package com.reyzar.oa.controller.office;

import java.util.Date;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.OffForum;
import com.reyzar.oa.domain.OffPost;
import com.reyzar.oa.domain.OffReply;
import com.reyzar.oa.service.office.IOffForumService;
import com.reyzar.oa.service.office.IOffPostService;

@Controller
@RequestMapping("/manage/office/review")
public class OffPostController extends BaseController {
	
	@Autowired
	private IOffPostService postService;
	@Autowired 
	private IOffForumService forumService;
	
	@RequestMapping("/toList")
	public String toList(Model model){
		Map<String, Object> map = Maps.newHashMap();
		map.put("tab", "");
		map.put("status", "");
		List<OffPost> posts=postService.findAll(map);
		model.addAttribute("postList", posts);
		model.addAttribute("map", map);
		return "manage/office/post/list";
	}
	
	@RequestMapping("/findAll")
	public String findAll(Model model,Integer tab,Integer status){
		Map<String, Object> map = Maps.newHashMap();
		map.put("tab", tab);
		map.put("status", status);
		List<OffPost> posts=postService.findAll(map);
		model.addAttribute("postList", posts);
		model.addAttribute("map", map);
		return "manage/office/post/list";
	}
	
	@RequestMapping("/new")
	public String findForum(Model model){
		List<OffForum> posts=forumService.findAll();
		model.addAttribute("forumList", posts);
		return "manage/office/post/new";
	}
	
	@RequestMapping("/add")
	@ResponseBody
	public String add(@RequestBody JSONObject json){
		OffPost posts=json.toJavaObject(OffPost.class);
		posts.setApplyTime(new Date());
		posts.setAudit(0);
		posts.setStatus(0);
		posts.setReplyCount(0);
		CrudResultDTO crudResultDTO=postService.save(posts);
		return JSON.toJSONString(crudResultDTO);
	}
	
	@RequestMapping("/findById")
	public String findById(Model model,Integer id){
		OffPost post=postService.findById(id);
		model.addAttribute("post", post);
		return "manage/office/post/detail";
	}
	
	@RequestMapping("/showReply")
	@ResponseBody
	public String showReply(Integer id){
		List<OffReply> replies=postService.findReplyById(id);
		return JSON.toJSONString(replies);
	}
	
	@RequestMapping("/addReply")
	@ResponseBody
	public String addReply(@RequestBody JSONObject json){
		return JSON.toJSONString(postService.addReply(json));
	}
	
	@RequestMapping("/addInReply")
	@ResponseBody
	public String addInReply(@RequestBody JSONObject json){
		return JSON.toJSONString(postService.addInReply(json));
	}
	
	@RequestMapping("/deletePost")
	@ResponseBody
	public String deletePost(Integer id){
		return JSON.toJSONString(postService.deleteById(id));
	}
	
	
	@RequestMapping("/updateAudit")
	@ResponseBody
	public String updateAudit(Integer id,Integer audit){
		return JSON.toJSONString(postService.updateAudit(id, audit));
	}
	
	
	@RequestMapping("/updateStatus")
	@ResponseBody
	public String updateStatus(Integer id,Integer status){
		return JSON.toJSONString(postService.updateStatus(id, status));
	}
	
	
	
}
