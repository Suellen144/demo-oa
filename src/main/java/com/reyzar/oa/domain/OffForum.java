package com.reyzar.oa.domain;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@SuppressWarnings("serial")
public class OffForum extends BaseEntity{

	private Integer id;
	private String name;		//版块名
	private Integer postCount;	//帖子回复数
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date lastPostTime;	//最后回复时间
	private String url;			//版块图标
	private List<OffPost> posts;	//帖子
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getPostCount() {
		return postCount;
	}
	public void setPostCount(Integer postCount) {
		this.postCount = postCount;
	}
	public Date getLastPostTime() {
		return lastPostTime;
	}
	public void setLastPostTime(Date lastPostTime) {
		this.lastPostTime = lastPostTime;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public List<OffPost> getPosts() {
		return posts;
	}
	public void setPosts(List<OffPost> posts) {
		this.posts = posts;
	}
	
}
