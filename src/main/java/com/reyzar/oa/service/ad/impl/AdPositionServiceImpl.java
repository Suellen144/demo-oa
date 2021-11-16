package com.reyzar.oa.service.ad.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.IAdPositionDao;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.dao.IUserPositionDao;
import com.reyzar.oa.domain.AdPosition;
import com.reyzar.oa.service.ad.IAdPositionService;

@Service
@Transactional
public class AdPositionServiceImpl implements IAdPositionService {
	
	@Autowired
	private IAdPositionDao positionDao;
	@Autowired
	private IUserPositionDao userPositionDao;
	@Autowired
	private ISysDeptDao deptDao;

	@Override
	public Page<AdPosition> findByPage(Map<String, Object> params, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		PageHelper.orderBy("ID asc");
		return positionDao.findByPage(params);
	}
	
	@Override
	public List<AdPosition> findByDeptId(Integer DeptId) {
		return positionDao.findByDeptId(DeptId);
	}

	@Override
	public AdPosition findById(Integer id) {
		return positionDao.findById(id);
	}
	
	@Override
	public CrudResultDTO save(AdPosition position) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		try {
			if(position.getId() == null) {
				position.setName(position.getName().trim());
	/*			position.setEnname(position.getEnname().trim());*/
				position.setCode(getMaxCode());
				position.setCreateBy(UserUtils.getCurrUser().getAccount());
				position.setCreateDate(new Date());
				positionDao.save(position);
			} else {
				position.setName(position.getName().trim());
		/*		position.setEnname(position.getEnname().trim());*/
				position.setUpdateBy(UserUtils.getCurrUser().getAccount());
				position.setUpdateDate(new Date());
				
				AdPosition old = positionDao.findById(position.getId());
				BeanUtils.copyProperties(position, old);
				
				positionDao.update(old);
			}
			
			result.setCode(CrudResultDTO.SUCCESS);
			result.setResult(position);
		} catch(Exception e) {
			result.setCode(CrudResultDTO.EXCEPTION);
			result.setResult("操作异常！");
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}

	@Override
	public CrudResultDTO delete(Integer id) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除成功！");
		try {
			positionDao.deleteById(id);
			userPositionDao.delByPositionId(id);
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.SUCCESS, "删除失败！");
			throw new BusinessException(e.getMessage());
		}
		
		return result;
	}

	@Override
	public List<AdPosition> findAll() {
		return positionDao.findAll();
	}

	@Override
	public AdPosition findByCode(String code) {
		return positionDao.findByCode(code);
	}

	private String getMaxCode() {
		String code = "001";
		List<Map<String, Object>> codeList = positionDao.getMaxCode();
		if(codeList != null) {
			int max = 0;
			for(Map<String, Object> map : codeList) {
				String value = map.get("code").toString();
				if(value.startsWith("00")) {
					value = value.replaceFirst("00", "");
				} else if(value.startsWith("0")) {
					value = value.replaceFirst("0", "");
				}
				
				max = Math.max(max, Integer.parseInt(value));
			}
			
			max++;
			if(String.valueOf(max).length() == 1) {
				code = "00" + max;
			} else if(String.valueOf(max).length() == 2) {
				code = "0" + max;
			} else {
				code = String.valueOf(max);
			}
		}
		
		return code;
	}

	@Override
	public List<AdPosition> findPositionOfManagerByDeptIdAndLevel(Integer deptId, Integer level) {
		return positionDao.findPositionOfManagerByDeptIdAndLevel(deptId, level);
	}

	@Override
	public void update(AdPosition position) {
		 positionDao.update(position);
	}
}