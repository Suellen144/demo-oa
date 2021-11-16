package com.reyzar.oa.service.finance;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.reyzar.oa.domain.FinInvoiceProjectMembers;

/**
 * 发票成员
 * @author ljd
 *
 */
@Service
@Transactional
public interface IFinInvoiceProjectMembersService {
	
	public List<FinInvoiceProjectMembers> findAll();
	
	public FinInvoiceProjectMembers findById(Integer id);
	
	public List<FinInvoiceProjectMembers> findByFinInvoicedId(Integer finInvoicedId);
}
