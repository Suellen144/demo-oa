package com.reyzar.oa.service.sys.impl;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.dict.cache.DictionaryCache;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.dao.ISysDictDataDao;
import com.reyzar.oa.dao.ISysDictTypeDao;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.service.sys.ISysDictDataService;

@Service
@Transactional
public class SysDictDataServiceImpl implements ISysDictDataService {

	@Autowired
	private ISysDictDataDao datadao;
	
	@Autowired
	private ISysDictTypeDao typedao;

	@Override
	public List<SysDictData> findAll() {
		return datadao.findAll();
	}

	@Override
	public Page<SysDictData> findByPage(Map<String, Object> params,int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		PageHelper.orderBy("type_id desc");
		Page<SysDictData> page = datadao.findByPage(params);
		return page;
	}

	@Override
	public SysDictData findById(Integer id) {
		return datadao.findById(id);
	}

	@Override
	public CrudResultDTO save(SysDictData dictData ) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		try {
			if(dictData.getId() == null) {
				datadao.save(dictData);
			} else {
				
				SysDictData old = datadao.findById(dictData.getId());
				BeanUtils.copyProperties(dictData, old);
				
				datadao.update(old);
			}
			
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult(dictData);
			
			DictionaryCache.initCache();
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("操作异常！");
			throw new BusinessException(e.getMessage());
		}
		return result;
	}


	@Override
	public boolean deleteById(Integer id) {
		try {
			datadao.delete(id);
			
			DictionaryCache.initCache();
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	@Override
	public SysDictData findByTypeId(Integer TypeId) {
		return datadao.findByTypeId(TypeId);
	}

	@Override
	public boolean deleteByTypeId(Integer typeid) {
		try {
			datadao.deleteByTypeId(typeid);
			DictionaryCache.initCache();
		} catch (Exception e) {
			return false;
		}
		return true;
	}

	@Override
	public CrudResultDTO update(SysDictData dictData) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		try {
			if(dictData.getId() == null) {
				datadao.save(dictData);
			} else {
				
				SysDictData old = datadao.findById(dictData.getId());
				BeanUtils.copyProperties(dictData, old);
				
				datadao.update(old);
			}
			
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult(dictData);
			
			DictionaryCache.initCache();
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("操作异常！");
			throw new BusinessException(e.getMessage());
		}
		return result;
	}

	@Override
	public CrudResultDTO updatebyId(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			if (id != null) {
				SysDictData old = datadao.findById(id);
				old.setIsdeleted("1");
				datadao.update(old);
				DictionaryCache.initCache();
			}
			else {
				result.setCode(CrudResultDTO.FAILED);
				result.setResult("ID不存在！");
			}
		} catch (Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("操作异常！");
			e.printStackTrace();
		}
		return result;
	}

}