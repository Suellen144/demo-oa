package com.reyzar.oa.service.addressbook.impl;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.dao.IAddressBookDao;
import com.reyzar.oa.domain.AddressBook;
import com.reyzar.oa.service.addressbook.IAddressBookService;

@Service
@Transactional
public class AddressBookServiceImpl implements IAddressBookService {

	@Autowired
	private IAddressBookDao addressBookDao;
	
	@Override
	public List<AddressBook> queryAddressBookList(Map<String, Object> param) {
		List<AddressBook> addressBookList=addressBookDao.queryAddressBookList(param);
		return addressBookList;
	}
	
}