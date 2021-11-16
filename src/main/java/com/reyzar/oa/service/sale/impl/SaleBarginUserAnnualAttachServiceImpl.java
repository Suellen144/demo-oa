package com.reyzar.oa.service.sale.impl;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.ISaleBarginUserAnnualAttachDao;
import com.reyzar.oa.dao.ISaleBarginUserAnnualDao;
import com.reyzar.oa.domain.SaleBarginUserAnnual;
import com.reyzar.oa.domain.SaleBarginUserAnnualAttach;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleBarginUserAnnualAttachService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@Service
@Transactional
public class SaleBarginUserAnnualAttachServiceImpl implements ISaleBarginUserAnnualAttachService {

    @Autowired
    ISaleBarginUserAnnualAttachDao iSaleBarginUserAnnualAttachDao;

    @Autowired
    ISaleBarginUserAnnualDao iSaleBarginUserAnnualDao;

    private final static org.apache.log4j.Logger logger
            = org.apache.log4j.Logger.getLogger(SaleBarginUserAnnualAttachServiceImpl.class);
    /**
     * 查找所有的销售合同（已归档的）
     * @return
     */
    @Override
    public CrudResultDTO findAllBySale(Integer id) {
        SaleBarginUserAnnual saleBarginiAnnual = iSaleBarginUserAnnualDao.findById(id);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, saleBarginiAnnual);
        return result;
    }


    /**
     * 添加数据或修改
     * @param json
     * @return
     */
    @Override
    public CrudResultDTO saveInfo(JSONObject json) {

        SaleBarginUserAnnual saleBarginUserAnnual = json.toJavaObject(SaleBarginUserAnnual.class);
        SysUser user = UserUtils.getCurrUser();
        if (saleBarginUserAnnual.getId() == null){
            //新增
            try {
                saleBarginUserAnnual.setCreateBy(user.getAccount());
                saleBarginUserAnnual.setCreateDate(new Date());
                iSaleBarginUserAnnualDao.save(saleBarginUserAnnual);
            }catch (Exception e){
                logger.error("年度合同统计 主表添加数据失败");
            }

             if (saleBarginUserAnnual.getBarginAttachs()!=null
                     && saleBarginUserAnnual.getBarginAttachs().size()>0){
                List<SaleBarginUserAnnualAttach> saleBarginUserAnnualAttachList = Lists.newArrayList();
                 for (SaleBarginUserAnnualAttach attachItem:saleBarginUserAnnual.getBarginAttachs()) {
                     attachItem.setAnnualId(saleBarginUserAnnual.getId());
                     attachItem.setCreateBy(user.getAccount());
                     attachItem.setCreateDate(new Date());
                     saleBarginUserAnnualAttachList.add(attachItem);
                 }
                 try{
                     iSaleBarginUserAnnualAttachDao.saveList(saleBarginUserAnnualAttachList);
                 }catch (Exception e){
                     logger.error("年度合同统计 附表批量增加数据失败");
                 }
             }
            CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,saleBarginUserAnnual);
            return result;
        }else {
            SaleBarginUserAnnual oldSaleBarginUserAnnual
                        = iSaleBarginUserAnnualDao.findById(saleBarginUserAnnual.getId());
            saleBarginUserAnnual.setUpdateBy(user.getAccount());
            saleBarginUserAnnual.setUpdateDate(new Date());
            BeanUtils.copyProperties(saleBarginUserAnnual,oldSaleBarginUserAnnual);
            iSaleBarginUserAnnualDao.update(oldSaleBarginUserAnnual);

            List<SaleBarginUserAnnualAttach> newSaleBarginUserAnnualAttachList
                                                        = saleBarginUserAnnual.getBarginAttachs();
            List<SaleBarginUserAnnualAttach> oldSaleBarginUserAnnualAttachList
                    = iSaleBarginUserAnnualAttachDao.findByAnnualId(saleBarginUserAnnual.getId());

            List<SaleBarginUserAnnualAttach> saveList = Lists.newArrayList();
            List<SaleBarginUserAnnualAttach> updateList = Lists.newArrayList();
            List<Integer> delList = Lists.newArrayList();

            Map<Integer,SaleBarginUserAnnualAttach> oldSaleBarginUserAnnualAttachMap
                       = Maps.newHashMap();
            for (SaleBarginUserAnnualAttach attachItem: oldSaleBarginUserAnnualAttachList) {
                oldSaleBarginUserAnnualAttachMap.put(attachItem.getId(),attachItem);
            }

            for (SaleBarginUserAnnualAttach newAttachItem:newSaleBarginUserAnnualAttachList) {
                if (newAttachItem.getId() != null){
                    newAttachItem.setUpdateBy(user.getAccount());
                    newAttachItem.setUpdateDate(new Date());

                    SaleBarginUserAnnualAttach oldAttachItem
                            = oldSaleBarginUserAnnualAttachMap.get(newAttachItem.getId());
                    if (oldAttachItem != null){
                        BeanUtils.copyProperties(newAttachItem,oldAttachItem);
                        updateList.add(oldAttachItem);
                        oldSaleBarginUserAnnualAttachMap.remove(newAttachItem.getId());
                    }
                }else {
                    newAttachItem.setAnnualId(saleBarginUserAnnual.getId());
                    newAttachItem.setCreateBy(user.getAccount());
                    newAttachItem.setCreateDate(new Date());
                    saveList.add(newAttachItem);
                }
            }
            delList.addAll(oldSaleBarginUserAnnualAttachMap.keySet());

            if (saveList.size() > 0){
                iSaleBarginUserAnnualAttachDao.saveList(saveList);
            }
            if (updateList.size() > 0){
                iSaleBarginUserAnnualAttachDao.updateList(updateList);
            }
            CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,saleBarginUserAnnual);
            return result;
        }
    }
}
