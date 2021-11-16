package com.reyzar.oa.service.sale.impl;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.dao.ISaleBarginUserAnnualAttachDao;
import com.reyzar.oa.dao.ISaleBarginUserAnnualDao;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleBarginUserAnnual;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleBarginUserAnnualService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class SaleBarginUserAnnualServiceImpl implements ISaleBarginUserAnnualService {
    @Autowired
    ISaleBarginUserAnnualDao iSaleBarginUserAnnualDao;

    @Autowired
    ISaleBarginUserAnnualAttachDao iSaleBarginUserAnnualAttachDao;

    @Autowired
    ISaleBarginManageDao iSaleBarginManageDao;

    @Override
    public Page<SaleBarginUserAnnual> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.BARGIN);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);

        PageHelper.startPage(pageNum, pageSize);
        Page<SaleBarginUserAnnual> page = null;

        page = iSaleBarginUserAnnualDao.findByPage(params);
        return page;
    }

    /**
     * 根据ID查找附表中相关联的合同
     * @param id
     * @return
     */
    @Override
    public SaleBarginUserAnnual findById(Integer id) {
       return iSaleBarginUserAnnualDao.findById(id);
    }

    /**
     * 查找附表中的销售合同
     * @return
     */
    @Override
    public SaleBarginUserAnnual findAllAttach() {
        List<SaleBarginManage> saleBarginManageList = iSaleBarginManageDao.findBarginBySale();
        SaleBarginUserAnnual saleBarginUserAnnual =new SaleBarginUserAnnual();
        saleBarginUserAnnual.setSaleBarginManageList(saleBarginManageList);
        return saleBarginUserAnnual;
    }


}
