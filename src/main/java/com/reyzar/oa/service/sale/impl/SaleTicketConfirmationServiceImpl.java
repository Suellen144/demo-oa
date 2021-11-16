package com.reyzar.oa.service.sale.impl;

import java.util.Date;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.ISaleTicketConfirmationDao;
import com.reyzar.oa.domain.SaleTicketConfirmation;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleTicketConfirmationService;

@Service
@Transactional
public class SaleTicketConfirmationServiceImpl  implements ISaleTicketConfirmationService {

	@Autowired
	private ISaleTicketConfirmationDao iSaleTicketConfirmationDao;

	@Override
	public SaleTicketConfirmation findById(Integer id) {
		// TODO Auto-generated method stub
		return iSaleTicketConfirmationDao.findById(id);
	}

	@Override
	public CrudResultDTO save(JSONObject json) {
		CrudResultDTO result =new CrudResultDTO(CrudResultDTO.SUCCESS,"保存成功！");
		try {
			SysUser user = UserUtils.getCurrUser();
			SaleTicketConfirmation saleTicketConfirmation=json.toJavaObject(SaleTicketConfirmation.class);
			if(saleTicketConfirmation.getId()==null) {
				iSaleTicketConfirmationDao.save(saleTicketConfirmation);
			}else {
				saleTicketConfirmation.setUpdateBy(user.getAccount());
				saleTicketConfirmation.setUpdateDate(new Date());
				iSaleTicketConfirmationDao.update(saleTicketConfirmation);
			}
		} catch (Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
			e.printStackTrace();
			throw new BusinessException(e.getMessage());
		}
		 return result;
	}

	@Override
	public Page<SaleTicketConfirmation> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, 1000);
        Page<SaleTicketConfirmation> page = null;
        page = iSaleTicketConfirmationDao.findByPage(params);
        double ticketLines=0.0;//收票额
        double deductionLines=0.0;//抵扣额
        if(page!=null && page.size()>0) {
        	SaleTicketConfirmation saleTicketConfirmation=new SaleTicketConfirmation();
        	for(int i=0;i<page.size();i++) {
        		ticketLines+=page.get(i).getTicketLines();
        		deductionLines+=page.get(i).getDeductionLines();
        	}
        	saleTicketConfirmation.setTicketLines(ticketLines);
        	saleTicketConfirmation.setDeductionLines(deductionLines);
        	saleTicketConfirmation.setCumulative("累计");
        	page.add(saleTicketConfirmation);
        }
        return page;
    }
}
