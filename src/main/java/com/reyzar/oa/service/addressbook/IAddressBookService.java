package com.reyzar.oa.service.addressbook;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.domain.AddressBook;


public interface IAddressBookService {

	List<AddressBook> queryAddressBookList(Map<String, Object> param);

}
