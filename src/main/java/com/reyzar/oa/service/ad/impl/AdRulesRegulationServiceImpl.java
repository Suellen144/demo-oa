package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdRulesRegulationDao;
import com.reyzar.oa.dao.IAdRulesRegulationOutlineDao;
import com.reyzar.oa.domain.AdRulesRegulation;
import com.reyzar.oa.domain.AdRulesRegulationOutline;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.ad.IAdRulesRegulationService;

@Service
@Transactional
public class AdRulesRegulationServiceImpl implements IAdRulesRegulationService {

	private final static Logger logger = Logger.getLogger(AdRulesRegulationServiceImpl.class);
	
	@Autowired
	private IAdRulesRegulationOutlineDao rulesRegulationOutlineDao;
	@Autowired
	private IAdRulesRegulationDao rulesRegulationDao;
	
	@Override
	public List<AdRulesRegulationOutline> getAllOutline() {
		List<AdRulesRegulationOutline> outlineList = rulesRegulationOutlineDao.findAll();
		return outlineList;
	}
	
	@Override
	public AdRulesRegulationOutline findByParentId(Integer parentId) {
		return rulesRegulationOutlineDao.findByParentId(parentId);
	}
	
	@Override
	public AdRulesRegulation findFirst() {
		AdRulesRegulation rulesRegulation = new AdRulesRegulation();
		
		List<AdRulesRegulation> rulesRegulationList = rulesRegulationDao.findAll();
		if(rulesRegulationList != null && rulesRegulationList.size() > 0) {
			rulesRegulation = rulesRegulationList.get(0);
		}
		
		return rulesRegulation;
	}

	@Override
	public CrudResultDTO save(AdRulesRegulation rulesRegulation) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		SysUser user = UserUtils.getCurrUser();
		
		if(rulesRegulation.getId() == null) {
			rulesRegulation.setCreateBy(user.getAccount());
			rulesRegulation.setCreateDate(new Date());
			
			rulesRegulationDao.save(rulesRegulation);
		} else {
			rulesRegulation.setUpdateBy(user.getAccount());
			rulesRegulation.setUpdateDate(new Date());
			
			AdRulesRegulation old = rulesRegulationDao.findById(rulesRegulation.getId());
			BeanUtils.copyProperties(rulesRegulation, old);
//			old.setPrivateContent(rulesRegulation.getPrivateContent());
			
			rulesRegulationDao.update(old);
		}
		
		return result;
	}

	@Override
	public CrudResultDTO approve(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		if(id != null) {
			AdRulesRegulation rulesRegulation = rulesRegulationDao.findByOutlinId(id);
			AdRulesRegulationOutline regulationOutline = rulesRegulationOutlineDao.findById(id);
			if ((regulationOutline.getPublicStatus().equals("n") && regulationOutline.getUnpublicTitle() != null) || (rulesRegulation != null && rulesRegulation.getPublicStatus().equals("n") && rulesRegulation.getUnpublicContent() != null)) {
					regulationOutline.setPublicStatus("y");
					if (!regulationOutline.getUnpublicTitle().equals("")) {
						regulationOutline.setPublicTitle(regulationOutline.getUnpublicTitle());
					}
					else {
						regulationOutline.setPublicTitle(regulationOutline.getPublicTitle());
					}
					regulationOutline.setUnpublicTitle("");
					regulationOutline.setUpdateBy(UserUtils.getCurrUser().getAccount());
					regulationOutline.setUpdateDate(new Date());
					rulesRegulationOutlineDao.update(regulationOutline);
					if(rulesRegulation != null){
					rulesRegulation.setPublicStatus("y");
					if (!rulesRegulation.getUnpublicContent().equals(" ")){
						rulesRegulation.setPublicContent(rulesRegulation.getUnpublicContent());
					}
					else {
						rulesRegulation.setPublicContent(rulesRegulation.getPublicContent());
					}
					rulesRegulation.setUnpublicContent(" ");
					rulesRegulation.setUpdateBy(UserUtils.getCurrUser().getAccount());
					rulesRegulation.setUpdateDate(new Date());
					rulesRegulationDao.update(rulesRegulation);
					}
			}
		} else {
			result.setCode(CrudResultDTO.FAILED);
			result.setResult("操作失败！");
		}
		
		return result;
	}

	@Override
	public CrudResultDTO saveOrUpdateTitle(AdRulesRegulationOutline rulesRegulationOutline) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			SysUser currUser = UserUtils.getCurrUser();
			if(rulesRegulationOutline.getId() == null) {
				rulesRegulationOutline.setPublicStatus("n");
				rulesRegulationOutline.setCreateBy(currUser.getAccount());
				rulesRegulationOutline.setCreateDate(new Date());
				
				rulesRegulationOutlineDao.save(rulesRegulationOutline);
			} else {
				AdRulesRegulationOutline old = rulesRegulationOutlineDao.findById(rulesRegulationOutline.getId());
				rulesRegulationOutline.setPublicStatus("n");
				rulesRegulationOutline.setUpdateBy(currUser.getAccount());
				rulesRegulationOutline.setUpdateDate(new Date());
				BeanUtils.copyProperties(rulesRegulationOutline, old);
				
				rulesRegulationOutlineDao.update(old);
				rulesRegulationOutline = old;
			}
			result.setResult(rulesRegulationOutline);
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult( (rulesRegulationOutline.getId() == null?"保存":"编辑") + "标题发生异常，请联系管理员！" );
			logger.error( (rulesRegulationOutline.getId() == null?"保存":"编辑") + "规章制度标题发生异常，异常信息：" + e.getMessage());
			throw new BusinessException(e);
		}
		return result;
	}
	
	@Override
	public CrudResultDTO saveOrUpdateContent(AdRulesRegulation rulesRegulation) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "操作成功！");
		try {
			SysUser currUser = UserUtils.getCurrUser();
			if(rulesRegulation.getId() == null) {
				rulesRegulation.setPublicStatus("n");
				rulesRegulation.setCreateBy(currUser.getAccount());
				rulesRegulation.setCreateDate(new Date());
				
				rulesRegulationDao.save(rulesRegulation);
			} else {
				AdRulesRegulation old = rulesRegulationDao.findById(rulesRegulation.getId());
				rulesRegulation.setPublicStatus("n");
				rulesRegulation.setUpdateBy(currUser.getAccount());
				rulesRegulation.setUpdateDate(new Date());
				BeanUtils.copyProperties(rulesRegulation, old);
				old.setUnpublicContent(rulesRegulation.getUnpublicContent());
				
				rulesRegulationDao.update(old);
				rulesRegulation = old;
			}
			result.setResult(rulesRegulation);
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult( (rulesRegulation.getId() == null?"保存":"编辑") + "内容发生异常，请联系管理员！" );
			logger.error( (rulesRegulation.getId() == null?"保存":"编辑") + "规章制度内容发生异常，异常信息：" + e.getMessage());
			throw new BusinessException(e);
		}
		return result;
	}

	@Override
	public CrudResultDTO deleteTitle(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			rulesRegulationOutlineDao.deleteById(id);
			rulesRegulationDao.deleteByOutlineId(id);
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("删除标题发生异常，请联系管理员！");
			logger.error("删除规章制度标题发生异常，异常信息：" + e.getMessage());
			throw new BusinessException(e);
		}
		return result;
	}

	@Override
	public boolean hasUnpublic() {
		int count = rulesRegulationDao.countUnpublic();
		return count > 0;
	}

}