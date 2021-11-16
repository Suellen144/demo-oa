package com.reyzar.oa.service.sys.impl;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dict.cache.DictionaryCache;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.dao.ISysDictDataDao;
import com.reyzar.oa.dao.ISysDictTypeDao;
import com.reyzar.oa.domain.SysDictType;
import com.reyzar.oa.service.sys.ISysDictTypeService;


@Service
@Transactional
public class SysDictTypeServiceImpl implements ISysDictTypeService {

	@Autowired
	private ISysDictTypeDao typedao;
	@Autowired
	private ISysDictDataDao datadao;

	@Override
	public List<SysDictType> findAll() {
		return typedao.findAll();
	}
	
	@Override
	public SysDictType findById(Integer id) {
		return typedao.findById(id);
	}
	
	@Override
	public CrudResultDTO save(SysDictType dictType ) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		try {
			if(dictType.getId() == null) {
				typedao.save(dictType);
			} else {
				
				SysDictType old = typedao.findById(dictType.getId());
				BeanUtils.copyProperties(dictType, old);
				
				typedao.update(old);
			}
			
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult(dictType);
			
			DictionaryCache.initCache();
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("操作异常！");
			throw new BusinessException(e.getMessage());
		}
		return result;
	}
	
	@Override
	public CrudResultDTO deleteById(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			typedao.delete(id);
			datadao.deleteByTypeId(id);
			
			DictionaryCache.initCache();
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除失败！");
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> getTypeList(String root) {
		List<SysDictType> typeList = typedao.findAll();
		List<Map<String, Object>> result = Lists.newArrayList();
		if (typeList != null) {
			for (SysDictType type : typeList ) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", type.getId());
				map.put("parentId", type.getParentId());
				map.put("name", type.getName());
				map.put("remark", type.getRemark());
				map.put("icon", root+"/static/images/dept.png");
				
				result.add(map);
			}
		}
		return result;
	}

}