package com.reyzar.oa.controller.sale;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.github.pagehelper.Page;
import com.reyzar.oa.controller.BaseController;
import com.reyzar.oa.domain.SaleBarginUserAnnual;
import com.reyzar.oa.service.sale.ISaleBarginUserAnnualService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
@RequestMapping(value = "/manage/sale/barginUserAnnual")
public class SaleBarginUserAnnualController extends BaseController{
    @Autowired
    ISaleBarginUserAnnualService iSaleBarginUserAnnualService;

    @RequestMapping("/toList")
    public String toList(){
        return "manage/sale/barginUserAnnual/list";
    }

    @RequestMapping("/getList")
    @ResponseBody
    public String getList(@RequestBody Map<String, Object> requestMap)
                throws JsonProcessingException {
        Map<String,Object> paramMap = parsePageMap(requestMap);
        Page<SaleBarginUserAnnual> page=iSaleBarginUserAnnualService.findByPage(paramMap,
                                    Integer.valueOf(paramMap.get("pageNum").toString()),
                                    Integer.valueOf(paramMap.get("pageSize").toString()));
        Map<String,Object> jsonMap = buildTableData(paramMap,page);
        return JSONObject.toJSONString(jsonMap);
    }
}
