package com.reyzar.oa.service.ad.impl;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.constant.DataPermissionModuleConstant;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.RecordExcelDTO;
import com.reyzar.oa.common.encrypt.AesUtils;
import com.reyzar.oa.common.exception.BusinessException;
import com.reyzar.oa.common.util.*;
import com.reyzar.oa.dao.IAdrewardAttachDao;
import com.reyzar.oa.dao.IAdrewardDao;
import com.reyzar.oa.domain.AdRecord;
import com.reyzar.oa.domain.Adreward;
import com.reyzar.oa.domain.AdrewardAttach;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.IEncryptService;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.apache.log4j.Logger;
import com.reyzar.oa.service.ad.IAdrewardService;

import javax.servlet.ServletOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author since
 */
@Service
public class AdrewardServiceImpl implements IAdrewardService,IEncryptService {
    private final  static Logger logger = Logger.getLogger(AdrewardServiceImpl.class);
    @Autowired
    private IAdrewardDao rewardDao;
    @Autowired
    private IAdrewardAttachDao attachDao;

    @Override
    public Page<Adreward> findByPage(Map<String, Object> params, Integer pageNum, Integer pageSize) {
        SysUser user = UserUtils.getCurrUser();
        String moduleName = DataPermissionModuleConstant.getValue(DataPermissionModuleConstant.SALARY);
        Set<Integer> deptIdSet = UserUtils.getDataPermission(user, moduleName);
        params.put("userId", user.getId());
        params.put("deptIdSet", deptIdSet);
        PageHelper.startPage(pageNum, pageSize);
        Page<Adreward> page = rewardDao.findByPage(params);
        return page;
    }

    @Override
    public Adreward findById(Integer id) {
        return rewardDao.findById(id);
    }

    @Override
    public List<Adreward> findAll() {
        return rewardDao.findAll();
    }

    @Override
    public CrudResultDTO save(JSONObject json) {
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
        SysUser user = UserUtils.getCurrUser();
        try {
            Adreward reward = json.toJavaObject(Adreward.class);
            reward.setUserId(user.getId());
            reward.setDeptId(user.getDeptId());
            reward.setCreateBy(user.getAccount());
            reward.setCreateDate(new Date());
            reward.setEncrypted("n");
            rewardDao.save(reward);

            if (reward.getAdrewardAttachList() != null){
                for(AdrewardAttach attach : reward.getAdrewardAttachList()){
                    attach.setRewardId(reward.getId());
                    attach.setCreateBy(user.getAccount());
                    attach.setCreateDate(new Date());
                }
                attachDao.insertAll(reward.getAdrewardAttachList());
            }
        }
        catch (Exception e){
            throw new BusinessException(e.getMessage());
        }
        return  result;
    }

    @Override
    public CrudResultDTO update(JSONObject json) {
        lock(json);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
        SysUser user = UserUtils.getCurrUser();
        String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
        if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("密钥已更改，请重新导入新密钥！");
        }
        boolean hasEncryptionKey = encryptionKey != null && ModuleEncryptUtils.validEncryptionKey(encryptionKey) ? true : false;
        Adreward reward = json.toJavaObject(Adreward.class);
        Adreward orginreward = rewardDao.findById(reward.getId());
        reward.setUpdateBy(user.getAccount());
        reward.setUpdateDate(new Date());
        BeanUtils.copyProperties(reward,orginreward);

        List<AdrewardAttach> orginRewardAttachList = attachDao.findByRewardId(reward.getId());
        List<AdrewardAttach> RewardAttachList = reward.getAdrewardAttachList();

        List<AdrewardAttach> saveList = Lists.newArrayList();
        List<AdrewardAttach> updateList = Lists.newArrayList();
        List<Integer> delList = Lists.newArrayList();

        Map<Integer, AdrewardAttach> originRewardAttachMap = Maps.newHashMap();

        for (AdrewardAttach attach : orginRewardAttachList){
            originRewardAttachMap.put(attach.getId(),attach);
        }

        for (AdrewardAttach attach : RewardAttachList){
            if (attach.getId() != null){
                attach.setUpdateBy(user.getAccount());
                attach.setUpdateDate(new Date());

                AdrewardAttach origin = originRewardAttachMap.get(attach.getId());
                if (origin != null){
                    if ("y".equals(orginreward.getEncrypted()) && !hasEncryptionKey){
                        attach.setBusinessreward(origin.getBusinessreward());
                        attach.setOtherreward(origin.getOtherreward());
                        attach.setTotalreward(origin.getTotalreward());
                        attach.setCoefficient(origin.getCoefficient());
                    }
                    BeanUtils.copyProperties(attach,origin);
                    updateList.add(origin);
                    originRewardAttachMap.remove(origin.getId());
                }
            }else{
                attach.setRewardId(reward.getId());
                saveList.add(attach);
            }

        }
        delList.addAll(originRewardAttachMap.keySet());
        rewardDao.update(orginreward);
        if(saveList.size() > 0 ){
            if("y".equals(orginreward.getEncrypted()) && hasEncryptionKey){
                encryptData(saveList,encryptionKey);
            }
            attachDao.insertAll(saveList);
        }
        if (updateList.size() > 0 ){
            if( "y".equals(orginreward.getEncrypted()) && hasEncryptionKey ) {
                /*decryptData(updateList, encryptionKey);*/
                encryptData(updateList, encryptionKey);
            }

            attachDao.batchUpdate(updateList);
        }
        if(delList.size() > 0) {
            attachDao.deleteByIdList(delList);
        }
        return result;
    }

    @Override
    public CrudResultDTO lock(JSONObject json) {
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "加密成功！");
        try {
            if( json == null){
                result.setCode(CrudResultDTO.FAILED);
                result.setResult("加密数据不能为空！");
            }else {
                String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
                if( encryptionKey == null ) {
                    result.setCode(CrudResultDTO.FAILED);
                    result.setResult("请导入密钥！");
                }else if( !ModuleEncryptUtils.validEncryptionKey(encryptionKey) ) {
                    result.setCode(CrudResultDTO.FAILED);
                    result.setResult("当前密钥已失效，请更新您的密钥！");
                }else {
                    Integer id = json.getInteger("id");
                    Adreward adreward = rewardDao.findById(id);
                    if( !"y".equals(adreward.getEncrypted()) ){
                        Set<Integer> idSet = Sets.newHashSet();
                        Map<Integer,AdrewardAttach> adrewardAttachMap = Maps.newHashMap();
                        JSONArray rewardAttachList = json.getJSONArray("adrewardAttachList");
                        for (int i = 0; i<rewardAttachList.size();i++){
                            AdrewardAttach attach = rewardAttachList.getObject(i,AdrewardAttach.class);
                            if (attach.getWages() != null){
                                attach.setWages(AesUtils.encryptECB(attach.getWages(),encryptionKey));
                            }
                            if (attach.getBusinessreward() != null){
                                attach.setBusinessreward(AesUtils.encryptECB(attach.getBusinessreward(),encryptionKey));
                            }
                            if (attach.getOtherreward() != null){
                                attach.setOtherreward(AesUtils.encryptECB(attach.getOtherreward(),encryptionKey));
                            }
                            if (attach.getTotalreward() != null){
                                attach.setTotalreward(AesUtils.encryptECB(attach.getTotalreward(),encryptionKey));
                            }
                            if (attach.getCoefficient() != null){
                                attach.setCoefficient(AesUtils.encryptECB(attach.getCoefficient(),encryptionKey));
                            }

                            AdrewardAttach temp = adrewardAttachMap.get(attach.getId());
                            if (temp != null){
                                BeanUtils.copyProperties(attach, temp);
                            }else{
                                adrewardAttachMap.put(attach.getId(),attach);
                            }
                            idSet.add(attach.getId());
                        }

                        List<AdrewardAttach> oldList = attachDao.findByIds(idSet);
                        for(AdrewardAttach oldAttach : oldList){
                            AdrewardAttach attach = adrewardAttachMap.get(oldAttach.getId());
                            BeanUtils.copyProperties(attach,oldAttach);
                        }

                        adreward.setEncrypted("y");
                        rewardDao.update(adreward);
                        attachDao.batchUpdate(oldList);
                    }
                    else {
                        result.setCode(CrudResultDTO.FAILED);
                        result.setResult("当前数据已加密，无须再次加密！");
                    }
                }
            }
        }catch (Exception e){
            logger.error("加密发生异常，异常信息：" + e.getMessage());
            result.setCode(CrudResultDTO.EXCEPTION);
            result.setResult("加密发生异常，请联系管理员！");
            throw new BusinessException(e);
        }
        return null;
    }

    @Override
    public void exportExcel(ServletOutputStream out, Map<String, Object> paramMap) {
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "导出Excel成功！");
        String encryptionKey = ModuleEncryptUtils.getEncryptionKeyFromSession();
        if( encryptionKey == null ) {
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("请导入密钥！");
        }else if(encryptionKey != null && !ModuleEncryptUtils.validEncryptionKey(encryptionKey)) {
            result.setCode(CrudResultDTO.FAILED);
            result.setResult("密钥已更改，请重新导入新密钥！");
        }else{
            if(paramMap.get("id")!=null&&paramMap.get("id")!=""){
                String idString= (String) paramMap.get("id");
                Integer id= Integer.valueOf(idString);
                Adreward reward=new Adreward();
                try{
                    reward = this.findById(id);
                }catch (Exception e){
                    logger.error("留任奖内容查找失败"+e);
                }
                List<AdrewardAttach> rewardList = reward.getAdrewardAttachList();
                this.decryptData(rewardList,encryptionKey);
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                for (AdrewardAttach attachItem:rewardList) {
                    RecordExcelDTO dto=new RecordExcelDTO();
                    dto.setTime(formatter.format(attachItem.getRecord().getEntryTime()));
                    attachItem.setRecordExcelDTO(dto);
                }
                Context context =new Context();
                context.putVar("year",reward.getTitle());
                context.putVar("dataList",rewardList);
                //调用ExcelUtil 进行文件导出
                ExcelUtil.export("reward.xls", out, context);
            }
        }
    }

    @Override
    public void updateEncryptedData(String oldEncryptionKey, String newEncryptionKey) {
            List<Adreward> adrewardList = rewardDao.findByEncrypted("y");
            List<AdrewardAttach> adrewardAttachList = Lists.newArrayList();
            for(Adreward adreward : adrewardList){
                List<AdrewardAttach> tempAttachList = adreward.getAdrewardAttachList();

                List<AdrewardAttach> tempAttachList2 = Lists.newArrayList();

                Map<Integer,AdrewardAttach> attachMap = Maps.newHashMap();

                for(AdrewardAttach attach : tempAttachList){
                    AdrewardAttach temp  = new AdrewardAttach();
                    temp.setId(attach.getId());
                    temp.setBusinessreward(attach.getBusinessreward() == null ? "" : attach.getBusinessreward());
                    temp.setOtherreward(attach.getOtherreward() == null ? "" : attach.getOtherreward());
                    temp.setTotalreward(attach.getTotalreward() == null ? "" : attach.getTotalreward());
                    temp.setCoefficient(attach.getCoefficient() == null ? "" : attach.getCoefficient());
                    attachMap.put(attach.getId(),temp);
                }

                decryptData(tempAttachList,oldEncryptionKey);

                for(AdrewardAttach attach : tempAttachList){
                    AdrewardAttach temp = attachMap.get(attach.getId());
                    if(!temp.getBusinessreward().equals(attach.getBusinessreward() == null ? "" : attach.getBusinessreward())
                            && !temp.getOtherreward().equals(attach.getOtherreward() == null ? "" : attach.getOtherreward())
                            && !temp.getTotalreward().equals(attach.getTotalreward() == null ? "" : attach.getTotalreward())
                            && !temp.getCoefficient().equals(attach.getCoefficient() == null ? "" : attach.getCoefficient())){
                        tempAttachList2.add(attach);
                    }
                }

                encryptData(tempAttachList2,newEncryptionKey);
                adrewardAttachList.addAll(tempAttachList2);
            }

            if (adrewardAttachList.size() > 0 ){
                attachDao.batchUpdate(adrewardAttachList);
            }
    }

    @Override
    public <T> void decryptData(List<T> list, String oldEncryptionKey) {
        for( T temp : list ) {
            AdrewardAttach attach = (AdrewardAttach) temp;
            if (StringUtils.isNotEmpty(attach.getBusinessreward())){
                String buinessreward  = ModuleEncryptUtils.decryptText(attach.getBusinessreward(),oldEncryptionKey);
                if (StringUtils.isNotEmpty(buinessreward)){
                    attach.setBusinessreward(buinessreward);
                }
            }

            if(StringUtils.isNotEmpty(attach.getOtherreward())){
                String otherreward  = ModuleEncryptUtils.decryptText(attach.getOtherreward(),oldEncryptionKey);
                if (StringUtils.isNotEmpty(otherreward)){
                    attach.setOtherreward(otherreward);
                }
            }

            if(StringUtils.isNotEmpty(attach.getTotalreward())){
                String totalreward  = ModuleEncryptUtils.decryptText(attach.getTotalreward(),oldEncryptionKey);
                if (StringUtils.isNotEmpty(totalreward)){
                    attach.setTotalreward(totalreward);
                }
            }

            if(StringUtils.isNotEmpty(attach.getCoefficient())){
                String coefficient  = ModuleEncryptUtils.decryptText(attach.getCoefficient(),oldEncryptionKey);
                if (StringUtils.isNotEmpty(coefficient)){
                    attach.setCoefficient(coefficient);
                }
            }
        }
    }

    @Override
    public <T> void encryptData(List<T> list, String newEncryptionKey) {
        for( T temp : list ) {
            AdrewardAttach attach = (AdrewardAttach) temp;
            if (StringUtils.isNotEmpty(attach.getWages())){
                String wages  = ModuleEncryptUtils.encryptText(attach.getWages(),newEncryptionKey);
                if (StringUtils.isNotEmpty(wages)){
                    attach.setWages(wages);
                }
            }
            
            if (StringUtils.isNotEmpty(attach.getBusinessreward())){
                String buinessreward  = ModuleEncryptUtils.encryptText(attach.getBusinessreward(),newEncryptionKey);
                if (StringUtils.isNotEmpty(buinessreward)){
                    attach.setBusinessreward(buinessreward);
                }
            }

            if(StringUtils.isNotEmpty(attach.getOtherreward())){
                String otherreward  = ModuleEncryptUtils.encryptText(attach.getOtherreward(),newEncryptionKey);
                if (StringUtils.isNotEmpty(otherreward)){
                    attach.setOtherreward(otherreward);
                }
            }

            if(StringUtils.isNotEmpty(attach.getTotalreward())){
                String totalreward  = ModuleEncryptUtils.encryptText(attach.getTotalreward(),newEncryptionKey);
                if (StringUtils.isNotEmpty(totalreward)){
                    attach.setTotalreward(totalreward);
                }
            }


            if(StringUtils.isNotEmpty(attach.getCoefficient())){
                String coefficient  = ModuleEncryptUtils.encryptText(attach.getCoefficient(),newEncryptionKey);
                if (StringUtils.isNotEmpty(coefficient)){
                    attach.setCoefficient(coefficient);
                }
            }
        }
    }
}