package com.reyzar.oa.domain;

import java.util.List;

@SuppressWarnings("serial")
public class AdRulesRegulationOutline extends BaseEntity {

	private Integer id; // 主键ID
	private Integer parentId; // 父主键ID
	private String publicTitle; // 发布标题
	private String unpublicTitle; // 未发布标题
	private String publicStatus; // 发布状态 y：发布 n：未发布
	
	private List<AdRulesRegulationOutline> children;
	private AdRulesRegulation rulesRegulation; // 标题所关联的实际内容

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getId() {
		return this.id;
	}
	
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	
	public Integer getParentId() {
		return this.parentId;
	}
	
	public void setPublicTitle(String publicTitle) {
		this.publicTitle = publicTitle;
	}
	
	public String getPublicTitle() {
		return this.publicTitle;
	}
	
	public void setUnpublicTitle(String unpublicTitle) {
		this.unpublicTitle = unpublicTitle;
	}
	
	public String getUnpublicTitle() {
		return this.unpublicTitle;
	}
	
	public void setPublicStatus(String publicStatus) {
		this.publicStatus = publicStatus;
	}
	
	public String getPublicStatus() {
		return this.publicStatus;
	}

	public List<AdRulesRegulationOutline> getChildren() {
		return children;
	}

	public void setChildren(List<AdRulesRegulationOutline> children) {
		this.children = children;
	}

	public AdRulesRegulation getRulesRegulation() {
		return rulesRegulation;
	}

	public void setRulesRegulation(AdRulesRegulation rulesRegulation) {
		this.rulesRegulation = rulesRegulation;
	}
	
}