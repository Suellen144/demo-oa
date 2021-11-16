package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.AddressBook;
@MyBatisDao
public interface IAddressBookDao {

	public List<AddressBook> queryAddressBookList(Map<String, Object> param);
	

}
