package com.reyzar.oa.service.sale;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.domain.SaleBarginPersonCommissionAttach;

import java.util.List;

public interface ISaleBarginCommissionAttachService {

    public List<SaleBarginPersonCommissionAttach> findUserList(Integer id);

    public CrudResultDTO saveUserList(JSONObject json);

}
