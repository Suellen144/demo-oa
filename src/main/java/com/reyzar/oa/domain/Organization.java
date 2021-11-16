package com.reyzar.oa.domain;

import java.lang.String;
import java.util.List;
import java.lang.Integer;

@SuppressWarnings("serial")
public class Organization extends BaseEntity {

	private String id; // 主键
	private String parentId; // 父部门主键
	private String name; // 公司名称
	private String code; // 公司代码
	private Integer sort; //排序序号
	private List<Organization> children;
	
	private String clrq;//成立日期
	private String zczb;//注册资本
	private String frdb;//法人代表
	
	private String ognid;
	private String shxydm;//社会信用代码
	private String gswz;  //公司网站
	private String lxdh;  //联系电话
	private String gsdz;  //公司地址
	private String gszh;  //公司账号
	private String zhmc;  //账户名称
	private String khyh;  //开户银行
	private String khhdz; //开户行地址
	private String sjdw;  //上级单位
	private String sjcgbl;//上级持股比例
	private String zxrq;  //注销日期
	private String scrq;  //售出日期
	private String jyfw;  //经营范围
	
	private String zjl; //总经理
	private String cwzj; //财务总监
	private String jshzxjs; //监事会主席/监事
	private String dszzxds; //董事长/执行董事
	
	private String bgrq;//变更日期
	private String bgxm;//变更项目
	private String bgq;//变更前
	private String bgh;//变更后
	
	private String value;//变更项目value
	
	
	private String uuid;

	private String generateKpi;

	private String nodeLinks;
	
	private Organization organization;// 组织机构图 助理级别显示

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
	}
	public List<Organization> getChildren() {
		return children;
	}
	public void setChildren(List<Organization> children) {
		this.children = children;
	}
	public String getClrq() {
		return clrq;
	}
	public void setClrq(String clrq) {
		this.clrq = clrq;
	}
	public String getZczb() {
		return zczb;
	}
	public void setZczb(String zczb) {
		this.zczb = zczb;
	}
	public String getFrdb() {
		return frdb;
	}
	public void setFrdb(String frdb) {
		this.frdb = frdb;
	}

	public String getOgnid() {
		return ognid;
	}
	public void setOgnid(String ognid) {
		this.ognid = ognid;
	}
	public String getShxydm() {
		return shxydm;
	}
	public void setShxydm(String shxydm) {
		this.shxydm = shxydm;
	}
	public String getGswz() {
		return gswz;
	}
	public void setGswz(String gswz) {
		this.gswz = gswz;
	}
	public String getLxdh() {
		return lxdh;
	}
	public void setLxdh(String lxdh) {
		this.lxdh = lxdh;
	}
	public String getGsdz() {
		return gsdz;
	}
	public void setGsdz(String gsdz) {
		this.gsdz = gsdz;
	}
	public String getGszh() {
		return gszh;
	}
	public void setGszh(String gszh) {
		this.gszh = gszh;
	}
	public String getZhmc() {
		return zhmc;
	}
	public void setZhmc(String zhmc) {
		this.zhmc = zhmc;
	}
	public String getKhyh() {
		return khyh;
	}
	public void setKhyh(String khyh) {
		this.khyh = khyh;
	}
	public String getKhhdz() {
		return khhdz;
	}
	public void setKhhdz(String khhdz) {
		this.khhdz = khhdz;
	}
	public String getSjdw() {
		return sjdw;
	}
	public void setSjdw(String sjdw) {
		this.sjdw = sjdw;
	}
	public String getSjcgbl() {
		return sjcgbl;
	}
	public void setSjcgbl(String sjcgbl) {
		this.sjcgbl = sjcgbl;
	}
	public String getZxrq() {
		return zxrq;
	}
	public void setZxrq(String zxrq) {
		this.zxrq = zxrq;
	}
	public String getScrq() {
		return scrq;
	}
	public void setScrq(String scrq) {
		this.scrq = scrq;
	}
	public String getJyfw() {
		return jyfw;
	}
	public void setJyfw(String jyfw) {
		this.jyfw = jyfw;
	}
	public String getZjl() {
		return zjl;
	}
	public void setZjl(String zjl) {
		this.zjl = zjl;
	}
	public String getCwzj() {
		return cwzj;
	}
	public void setCwzj(String cwzj) {
		this.cwzj = cwzj;
	}
	public String getJshzxjs() {
		return jshzxjs;
	}
	public void setJshzxjs(String jshzxjs) {
		this.jshzxjs = jshzxjs;
	}
	public String getBgrq() {
		return bgrq;
	}
	public void setBgrq(String bgrq) {
		this.bgrq = bgrq;
	}
	public String getBgxm() {
		return bgxm;
	}
	public void setBgxm(String bgxm) {
		this.bgxm = bgxm;
	}
	public String getBgq() {
		return bgq;
	}
	public void setBgq(String bgq) {
		this.bgq = bgq;
	}
	public String getBgh() {
		return bgh;
	}
	public void setBgh(String bgh) {
		this.bgh = bgh;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getDszzxds() {
		return dszzxds;
	}
	public void setDszzxds(String dszzxds) {
		this.dszzxds = dszzxds;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}

	public String getGenerateKpi() {
		return generateKpi;
	}

	public void setGenerateKpi(String generateKpi) {
		this.generateKpi = generateKpi;
	}

	public String getNodeLinks() {
		return nodeLinks;
	}

	public void setNodeLinks(String nodeLinks) {
		this.nodeLinks = nodeLinks;
	}
	public Organization getOrganization() {
		return organization;
	}
	public void setOrganization(Organization organization) {
		this.organization = organization;
	}
	
}