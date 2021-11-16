package com.reyzar.oa.service.sale.impl;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.util.BeanUtils;
import com.reyzar.oa.common.util.UserUtils;
import com.reyzar.oa.dao.ISaleBarginPersonCommissionAttachDao;
import com.reyzar.oa.dao.ISaleBarginPersonCommissionDao;
import com.reyzar.oa.dao.ISysDeptDao;
import com.reyzar.oa.dao.ISysUserDao;
import com.reyzar.oa.domain.SaleBarginPersonCommission;
import com.reyzar.oa.domain.SaleBarginPersonCommissionAttach;
import com.reyzar.oa.domain.SysDept;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sale.ISaleBarginCommissionAttachService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class SaleBarginCommissionAttachServiceImpl implements ISaleBarginCommissionAttachService {

    private final static org.apache.log4j.Logger logger
            = org.apache.log4j.Logger.getLogger(SaleBarginCommissionAttachServiceImpl.class);

    @Autowired
    ISysDeptDao iSysDeptDao;
    @Autowired
    ISysUserDao iSysUserDao;
    @Autowired
    ISaleBarginPersonCommissionDao iSaleBarginPersonCommissionDao;
    @Autowired
    ISaleBarginPersonCommissionAttachDao iSaleBarginPersonCommissionAttachDao;


    /**
     * 查找出用户表
     * @param id
     * @return
     */
    @Override
    public List<SaleBarginPersonCommissionAttach> findUserList(Integer id) {
        if (id == null){
            //新建
            //找出所以部门
            List<SysDept> sysDeptList = iSysDeptDao.findByParentid(1);
            List<SaleBarginPersonCommissionAttach> saleBarginPersonCommissionAttachList
                    = Lists.newArrayList();
            for (SysDept sysDeptItem:sysDeptList) {
                List<SysUser> sysUserList = iSysUserDao.findByDeptid(sysDeptItem.getId());
                if (sysUserList != null && sysUserList.size()>0){
                    for (SysUser sysUserItem:sysUserList) {
                        SaleBarginPersonCommissionAttach saleBarginPersonCommissionAttach
                                =new SaleBarginPersonCommissionAttach();
                        saleBarginPersonCommissionAttach.setDeptId(sysDeptItem.getId());
                        saleBarginPersonCommissionAttach.setDeptName(sysDeptItem.getName());
                        saleBarginPersonCommissionAttach.setUserId(sysUserItem.getId());
                        saleBarginPersonCommissionAttach.setUserName(sysUserItem.getName());
                        saleBarginPersonCommissionAttachList.add(saleBarginPersonCommissionAttach);
                    }
                }
            }
            return saleBarginPersonCommissionAttachList;

        }else {
            //修改
            List<SaleBarginPersonCommissionAttach> saleBarginPersonCommissionAttachList
                                = iSaleBarginPersonCommissionAttachDao.findByCommissionId(id);
            return saleBarginPersonCommissionAttachList;
        }
    }

    /**
     * 将个人对合同信息新增或修改
     * @param json
     * @return
     */
    @Override
    public CrudResultDTO saveUserList(JSONObject json) {

        SaleBarginPersonCommission saleBarginPersonCommission
                = json.toJavaObject(SaleBarginPersonCommission.class);
        SysUser user = UserUtils.getCurrUser();
        if (saleBarginPersonCommission.getId()==null){
            //新增
            try{
                saleBarginPersonCommission.setCreateBy(user.getAccount());
                saleBarginPersonCommission.setCreateDate(new Date());
                iSaleBarginPersonCommissionDao.save(saleBarginPersonCommission);
            }catch (Exception e){
                logger.error("合同个人信息 主表新增失败"+e);
            }
            if (saleBarginPersonCommission.getCommissionAttachList() != null
                    && saleBarginPersonCommission.getCommissionAttachList().size()>0){
                List<SaleBarginPersonCommissionAttach> saleBarginPersonCommissionAttachList
                        =Lists.newArrayList();
                for (SaleBarginPersonCommissionAttach attachItem:saleBarginPersonCommission.getCommissionAttachList()) {
                    attachItem.setCommissionId(saleBarginPersonCommission.getId());
                    attachItem.setCreateBy(user.getAccount());
                    attachItem.setCreateDate(new Date());
                    saleBarginPersonCommissionAttachList.add(attachItem);
                }

                try{
                    iSaleBarginPersonCommissionAttachDao.saveList(saleBarginPersonCommissionAttachList);
                }catch (Exception e){
                    logger.error("年度合同统计 个人附表批量增加失败"+e);
                }
            }
            CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, saleBarginPersonCommission);
            return result;
        }else {
            SaleBarginPersonCommission oldSaleBarginPersonCommission
                    = iSaleBarginPersonCommissionDao.findById(saleBarginPersonCommission.getId());
            oldSaleBarginPersonCommission.setUpdateBy(user.getAccount());
            oldSaleBarginPersonCommission.setUpdateDate(new Date());
            BeanUtils.copyProperties(saleBarginPersonCommission,oldSaleBarginPersonCommission);
            iSaleBarginPersonCommissionDao.update(oldSaleBarginPersonCommission);

            List<SaleBarginPersonCommissionAttach> newSaleBarginPersonCommissionAttachList
                    =saleBarginPersonCommission.getCommissionAttachList();
            List<SaleBarginPersonCommissionAttach> oldSaleBarginPersonCommissionAttachList
                    =iSaleBarginPersonCommissionAttachDao.findByCommissionId(saleBarginPersonCommission.getId());

            List<SaleBarginPersonCommissionAttach> saveList = Lists.newArrayList();
            List<SaleBarginPersonCommissionAttach> updateList = Lists.newArrayList();
            List<Integer> delList = Lists.newArrayList();

            Map<Integer,SaleBarginPersonCommissionAttach> oldSaleBarginPersonCommissionAttachMap
                    = Maps.newHashMap();
            for (SaleBarginPersonCommissionAttach attachItem:oldSaleBarginPersonCommissionAttachList) {
                oldSaleBarginPersonCommissionAttachMap.put(attachItem.getId(),attachItem);
            }

            for (SaleBarginPersonCommissionAttach newAttachItem:newSaleBarginPersonCommissionAttachList) {
                if (newAttachItem.getId() != null){
                    newAttachItem.setUpdateBy(user.getAccount());
                    newAttachItem.setUpdateDate(new Date());

                    SaleBarginPersonCommissionAttach oldAttachItem
                            =oldSaleBarginPersonCommissionAttachMap.get(newAttachItem.getId());

                    if (oldAttachItem != null){
                        BeanUtils.copyProperties(newAttachItem,oldAttachItem);
                        updateList.add(oldAttachItem);
                        oldSaleBarginPersonCommissionAttachMap.remove(newAttachItem.getId());
                    }
                }else {
                    newAttachItem.setCommissionId(saleBarginPersonCommission.getId());
                    newAttachItem.setCreateBy(user.getAccount());
                    newAttachItem.setCreateDate(new Date());
                }
            }
            delList.addAll(oldSaleBarginPersonCommissionAttachMap.keySet());
            if (saveList.size()>0){
                iSaleBarginPersonCommissionAttachDao.saveList(saveList);
            }
            if (updateList.size()>0){
                iSaleBarginPersonCommissionAttachDao.updateList(updateList);
            }
            CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, saleBarginPersonCommission);
            return result;
        }
    }
}
