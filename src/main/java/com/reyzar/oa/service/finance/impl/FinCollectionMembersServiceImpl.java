package com.reyzar.oa.service.finance.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.dao.IFinCollectionMembersDao;
import com.reyzar.oa.domain.FinCollectionMembers;
import com.reyzar.oa.service.finance.IFinCollectionMembersService;

@Service
@Transactional
public class FinCollectionMembersServiceImpl  implements IFinCollectionMembersService{

	@Autowired
	private IFinCollectionMembersDao iFinCollectionMembersDao;
	
	@Override
	public List<FinCollectionMembers> findAll() {
		// TODO Auto-generated method stub
		return iFinCollectionMembersDao.findAll();
	}

	@Override
	public FinCollectionMembers findById(Integer id) {
		// TODO Auto-generated method stub
		return iFinCollectionMembersDao.findById(id);
	}

	@Override
	public List<FinCollectionMembers> findByFinCollectionId(Integer finCollectionId) {
		// TODO Auto-generated method stub
		return iFinCollectionMembersDao.findByFinCollectionId(finCollectionId);
	}

}
