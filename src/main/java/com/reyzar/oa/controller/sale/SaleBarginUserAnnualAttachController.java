package com.reyzar.oa.controller.sale;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleBarginUserAnnual;
import com.reyzar.oa.domain.SaleBarginUserAnnualAttach;
import com.reyzar.oa.service.sale.ISaleBarginUserAnnualAttachService;
import com.reyzar.oa.service.sale.ISaleBarginUserAnnualService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping(value = "/manage/sale/barginUserAnnualAttach")
public class SaleBarginUserAnnualAttachController extends BaseController {
    @Autowired
    ISaleBarginUserAnnualAttachService iSaleBarginUserAnnualManageService;

    @Autowired
    ISaleBarginUserAnnualService iSaleBarginUserAnnualService;

    @RequestMapping("/toAddOrEdit")
    public String toAddOrEdit(Integer id, Model model, HttpServletRequest request) {
        String userAgent = request.getHeader("USER-AGENT").toLowerCase();
        boolean ismobile = UserUtils.CheckMobile.check(userAgent);
        if (id != null) {
            SaleBarginUserAnnual saleBarginUserAnnual = iSaleBarginUserAnnualService.findById(id);
            model.addAttribute("saleBarginUserAnnual", saleBarginUserAnnual);
        } else {
            SaleBarginUserAnnual saleBarginUserAnnual = iSaleBarginUserAnnualService.findAllAttach();
            model.addAttribute("saleBarginUserAnnual", saleBarginUserAnnual);
        }
        return "manage/sale/barginUserAnnualAttach/list";
    }

    @RequestMapping(value="/saveInfo", method= RequestMethod.POST)
    @ResponseBody
    public CrudResultDTO saveInfo(@RequestBody JSONObject json){
        CrudResultDTO result = iSaleBarginUserAnnualManageService.saveInfo(json);
        return result;
    }
}