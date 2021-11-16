package com.reyzar.oa.controller.sale;

import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SaleBarginPersonCommissionAttach;
import com.reyzar.oa.service.sale.ISaleBarginCommissionAttachService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping(value = "/manage/sale/commissionAttach")
public class SaleBarginCommissionAttachController extends BaseController {
    @Autowired
    ISaleBarginCommissionAttachService iSaleBarginCommissionAttachService;


    @RequestMapping("/getUserList")
    @ResponseBody
    public CrudResultDTO getUserList(@Param("id")Integer id){
        List<SaleBarginPersonCommissionAttach> userList = iSaleBarginCommissionAttachService.findUserList(id);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,userList);
        return result;
    }

    @RequestMapping("/saveUserList")
    @ResponseBody
    public CrudResultDTO saveUserList(@RequestBody JSONObject json){
        return iSaleBarginCommissionAttachService.saveUserList(json);

    }
}
