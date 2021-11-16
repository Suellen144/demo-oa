package com.reyzar.oa.service.institution.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jagregory.shiro.freemarker.UserTag;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IResponsibilityDao;
import com.reyzar.oa.domain.Responsibility;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.institution.IResponsibilityService;


@Service
@Transactional
public class ResponsibilityServiceImpl implements IResponsibilityService {

	@Autowired
	private IResponsibilityDao responsibilityDao;

	@Override
	public Responsibility findByDeptId2(Integer id) {
		return responsibilityDao.findByDeptId2(id);
	}

	@Override
	public Responsibility findById(Integer id) {
		return responsibilityDao.findById(id);
	}

	@Override
	public Integer saveOrUpdate(Responsibility responsibility) {
		Integer id=null;
		if(responsibility!=null ) {
			SysUser user = UserUtils.getCurrUser();
			if(responsibility.getId()== null) {
				responsibility.setCreateBy(user.getAccount());
				responsibility.setCreateDate(new Date());
				id=responsibilityDao.save(responsibility);
			}else {
				responsibility.setUpdateBy(user.getAccount());
				responsibility.setUpdateDate(new Date());
				responsibilityDao.update(responsibility);
				id=responsibility.getId();
			}
		}
		return id;
		
	}

	@Override
	public void delete(Integer id) {
		responsibilityDao.delete(id);
		
	}

	@Override
	public List<Responsibility> findByDeptId(Responsibility responsibility) {
		return responsibilityDao.findByDeptId(responsibility);
	}

}