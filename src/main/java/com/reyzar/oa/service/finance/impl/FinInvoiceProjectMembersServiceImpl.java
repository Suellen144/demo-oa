package com.reyzar.oa.service.finance.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.dao.IFinInvoiceProjectMembersDao;
import com.reyzar.oa.domain.FinInvoiceProjectMembers;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.service.finance.IFinInvoiceProjectMembersService;

@Service
@Transactional
public class FinInvoiceProjectMembersServiceImpl  implements IFinInvoiceProjectMembersService{

	@Autowired
	private IFinInvoiceProjectMembersDao iFinInvoiceProjectMembersDao;
	
	@Override
	public List<FinInvoiceProjectMembers> findAll() {
		// TODO Auto-generated method stub
		return iFinInvoiceProjectMembersDao.findAll();
	}

	@Override
	public FinInvoiceProjectMembers findById(Integer id) {
		// TODO Auto-generated method stub
		return iFinInvoiceProjectMembersDao.findById(id);
	}

	@Override
	public List<FinInvoiceProjectMembers> findByFinInvoicedId(Integer finInvoicedId) {
		// TODO Auto-generated method stub
		return iFinInvoiceProjectMembersDao.findByFinInvoicedId(finInvoicedId);
	}

}
