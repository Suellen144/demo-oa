package com.reyzar.oa.service.finance;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.reyzar.oa.domain.FinCollectionMembers;

/**
 * 收票成员
 * @author ljd
 *
 */
@Service
@Transactional
public interface IFinCollectionMembersService {
	
	public List<FinCollectionMembers> findAll();
	
	public FinCollectionMembers findById(Integer id);
	
	public List<FinCollectionMembers> findByFinCollectionId(Integer finCollectionId);
}
