package com.reyzar.oa.service.sale;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleBarginUserAnnualAttach;

import java.util.List;
import java.util.Map;

public interface ISaleBarginUserAnnualAttachService {

    CrudResultDTO findAllBySale(Integer id);

    CrudResultDTO saveInfo(JSONObject json);

}
