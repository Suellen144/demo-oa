package com.reyzar.oa.service.sale;

import com.github.pagehelper.Page;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleBarginUserAnnual;

import java.util.List;
import java.util.Map;

public interface ISaleBarginUserAnnualService {
    Page<SaleBarginUserAnnual> findByPage(Map<String,Object> paramsMap, Integer pageNum, Integer pageSize);

    SaleBarginUserAnnual findById(Integer id);

    SaleBarginUserAnnual findAllAttach();

}
