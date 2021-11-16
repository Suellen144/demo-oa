package com.reyzar.oa.service.finance.impl;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.*;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.common.dto.StatisticsTravelReimburseDTO;
import com.reyzar.oa.common.util.DateUtils;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.ExportexcelUtil;
import com.reyzar.oa.common.util.StringUtils;
import com.reyzar.oa.dao.*;
import com.reyzar.oa.domain.*;
import com.reyzar.oa.service.finance.IFinStatisticsPayService;
import org.apache.log4j.Logger;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.*;

/**
 * 财务统计
 */
@Service
public class FinStatisticsPayServiceImpl implements IFinStatisticsPayService {
    private final Logger logger = Logger.getLogger(FinStatisticsPayServiceImpl.class);
    //数据字典里睿哲公司type_id的值
    private static final int COMPANY_TYPE_ID_VALUE=17;
    //数据字典里通用付款类型type_id的值
    private static final int GENERAL_TYPE_ID_VALUE=19;
    //睿哲公司在收款付款单位title 的值
    private static final String COMPANY_TYPE_ID="11";
    //差旅表中的TYPE 接待类型
    private static final String TRAVEL_RECEPTION_TYPE="3";
    //差旅表中的TYPE 补贴的类型
    private static final String TRAVEL_SUBSIDY_TYPE="4";
    //通用表中的TYPE 接待类型
    private static final String REIMBURSE_RECEPRION_TYPE="2";
    //通用表中的TYPE 差旅类型
    private static final String REIMBURSE_TRAVEL_TYPE="4";
    //页面信息
    private static final String STATISTICS_SELECT_CONDITION="statisticsSelectCondition";
    //付款
    private static final String PAYCOMBINATION="pay_combination";
    //projectIdSet集合
    private static final String PROJECT_ID_SET="projectIdSet";
    //generalIdSet集合
    private static final String GENERAL_ID_SET="generalIdSet";
    //表的内容
    private static final String CONTENT_OF_FORM="contentOfForm";
    //页面穿回来的字符串为"0" 就代表为空
    private static final String REPRSENT_NULL="0";
    //单条记录项目名称
    private static final String SINGLE_DETAIL_PROJECT_NAME="singleDetailProjectName";
    //单条记录类型名称
    private static final String SINGLE_DETAIL_TYPE_NAME="singleDetailTypeName";

    //付款管理
    @Autowired
    IFinPayDao iFinPayDao;
    //通用报销表
    @Autowired
    IFinReimburseDao iFinReimburseDao;
    //通用报销附表
    @Autowired
    IFinReimburseAttachDao iFinReimburseAttachDao;
    //差旅报销附表
    @Autowired
    IFinTravelreimburseAttachDao iFinTravelreimburseAttachDao;
    //常规付款
    @Autowired
    IFinCommonPayAttachDao iFinCommonPayAttachDao;
    //常规收款
    @Autowired
    IFinCommonReceivedAttachDao iFinCommonReceivedAttachDao;
    //合同表
    @Autowired
    ISaleBarginManageDao iSaleBarginManageDao;
    //数据字典表
    @Autowired
    ISysDictDataDao iSysDictDataDao;
    //部门
    @Autowired
    ISysDeptDao iSysDeptDao;
    //项目
    @Autowired
    ISaleProjectManageDao iSaleProjectManageDao;
    /**
     * 根据页面的搜索条件
     *      进行财务统计
     * @param json
     * @return
     */
    @Override
    public CrudResultDTO searchByStatistics(JSONObject json) {
        // 从页面获取的搜索条件
        StatisticsFromPageDTO statisticsFromPageDTO = json.toJavaObject(StatisticsFromPageDTO.class);
        /*if(!statisticsFromPageDTO.getProjectName().equals("") && statisticsFromPageDTO.getProjectId() == null) {
        	statisticsFromPageDTO.setProjectId(177);
        }*/
        Map<String, Object> sumMap = Maps.newHashMap();
        //向前端标记 是按照 项目分类 还是 类型分类
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getWhetherSelectProject())){
            sumMap = sumByProject(statisticsFromPageDTO);
            sumMap.put("way","project");
        }else {
            sumMap = sumByType(statisticsFromPageDTO);
            sumMap.put("way","type");
        }
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,sumMap);
        return result;
    }
    
    /**
     * 根据 类型 返回页面
     * @param statisticsFromPageDTO
     * @return
     */
    public Map<String,Object> sumByType(StatisticsFromPageDTO statisticsFromPageDTO){
        //存放返回页面的数据
        Map<String,Object> statisticsDTOByTypeMap = new HashMap<String, Object>();

        //公司名称
        String compayName = "";
        if (statisticsFromPageDTO.getPayCompany() != null && !statisticsFromPageDTO.getPayCompany().equals("")) {
            SysDictData sysDictData = iSysDictDataDao.findByValueAndTypeidNotDelet(
                    Integer.valueOf(statisticsFromPageDTO.getPayCompany()), COMPANY_TYPE_ID_VALUE);
            compayName = sysDictData.getName();
        }
        //将三张表的类型综合起来
        //判断是否有费用归属
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getInvestId())
                ||StringUtils.isNotBlank(statisticsFromPageDTO.getStatus())){
            //费用归属 只用将通用跟差旅--需求更改，如果status选择总经理审批汇总，则加上 常规付款、付款管理的数据
            //通用加差旅计算
            Map<String,Object> reimbursAndTravelMap = this.remiburseAndTravelCount(statisticsFromPageDTO);
            Set<String> generalSet = Sets.newHashSet();
            generalSet.addAll((Collection<? extends String>) reimbursAndTravelMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList = Lists.newArrayList();
            try{
                if(!generalIdList.isEmpty()&&generalIdList.size() > 0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, GENERAL_TYPE_ID_VALUE);
                }
            }catch (Exception e){
                logger.error("财务统计 查找通用类型名称失败"+e);
            }
            //根据type 补充typeName
            for (StatisticsFromPageDTO reimbursAndTravelItem:
                    (Collection<? extends StatisticsFromPageDTO>)reimbursAndTravelMap.get(CONTENT_OF_FORM)) {
                for (SysDictData dictDataItem:generalList) {
                    if (StringUtils.equals(reimbursAndTravelItem.getType(), dictDataItem.getValue())){
                        reimbursAndTravelItem.setTypeName(dictDataItem.getName());
                        break;
                    }
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOByTypeMap.put(STATISTICS_SELECT_CONDITION, statisticsFromPageDTO);
            statisticsDTOByTypeMap.put(PAYCOMBINATION,reimbursAndTravelMap.get(CONTENT_OF_FORM));
        }else if (StringUtils.isNotBlank(statisticsFromPageDTO.getUserName())){
            //选了个人和部门 （只包括付款表和通用差旅表）
            //付款计算
            Map<String,Object> payMap = this.payCount(statisticsFromPageDTO);
            //通用加差旅计算
            Map<String,Object> reimbursAndTravelMap = this.remiburseAndTravelCount(statisticsFromPageDTO);
            Set<String> generalSet=Sets.newHashSet();
            generalSet.addAll((Collection<? extends String>) payMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) reimbursAndTravelMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList = Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty() && generalIdList.size() > 0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, GENERAL_TYPE_ID_VALUE);
                }
            }catch (Exception e){
                logger.error("财务统计 查找通用类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList = Lists.newArrayList();
            for (SysDictData sysDictDataItem : generalList){
                //判断当前projectId  general是否在 payList中
                StatisticsFromPageDTO staPay = new StatisticsFromPageDTO();
                judgeThePayOwnTheType(payMap, sysDictDataItem, staPay);
                //判断当前projectId  general是否在 reimbursAndTravel中
                StatisticsFromPageDTO staReimbursAndTravel = new StatisticsFromPageDTO();
                judgeTheReimburseAndTravelOwnTheType(reimbursAndTravelMap, sysDictDataItem, staReimbursAndTravel);
                //综合付款表和通用差旅表
                StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                payCombination.setType(sysDictDataItem.getValue());
                payCombination.setTypeName(sysDictDataItem.getName());
                //判断是否有有效值添加进返回类型，并累加数值
                judgeThePayEffectiveValue(staPay, payCombination);
                judgeTheReimburseAndTravelEffectiveValue(staReimbursAndTravel, payCombination);
                if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00){
                    payCombinationList.add(payCombination);
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOByTypeMap.put(STATISTICS_SELECT_CONDITION, statisticsFromPageDTO);
            statisticsDTOByTypeMap.put(STATISTICS_SELECT_CONDITION, statisticsFromPageDTO);
            statisticsDTOByTypeMap.put(PAYCOMBINATION, payCombinationList);
        }
        else {
            //全部表
            //付款计算
            Map<String,Object> payMap = this.payCount(statisticsFromPageDTO);
            //通用加差旅计算
            Map<String,Object> reimbursAndTravelMap = this.remiburseAndTravelCount(statisticsFromPageDTO);
            //常规付款计算
            Map<String,Object> commonPayMap = this.commonPayCount(statisticsFromPageDTO);
            Set<String> generalSet = Sets.newHashSet();
            generalSet.addAll((Collection<? extends String>) payMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) reimbursAndTravelMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) commonPayMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList = Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty() && generalIdList.size() > 0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, GENERAL_TYPE_ID_VALUE);
                }
            }catch (Exception e){
                logger.error("财务统计 查找通用类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList = Lists.newArrayList();
            for (SysDictData sysDictDataItem : generalList){
                //判断当前projectId  general是否在 payList中
                StatisticsFromPageDTO staPay = new StatisticsFromPageDTO();
                judgeThePayOwnTheType(payMap, sysDictDataItem, staPay);
                //判断当前projectId  general是否在 reimbursAndTravel中
                StatisticsFromPageDTO staReimbursAndTravel = new StatisticsFromPageDTO();
                judgeTheReimburseAndTravelOwnTheType(reimbursAndTravelMap, sysDictDataItem, staReimbursAndTravel);
                //判断当前projectId  general是否在 commonPay中
                StatisticsFromPageDTO staCommonPay = new StatisticsFromPageDTO();
                judgeTheCommonPayOwnType(commonPayMap, sysDictDataItem, staCommonPay);
                //综合三张表
                StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                payCombination.setType(sysDictDataItem.getValue());
                payCombination.setTypeName(sysDictDataItem.getName());
                //判断是否有有效值添加进返回类型，并累加数值
                judgeThePayEffectiveValue(staPay, payCombination);
                judgeTheReimburseAndTravelEffectiveValue(staReimbursAndTravel, payCombination);
                judgeTheCommonPayEffectiveValue(staCommonPay, payCombination);
                if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00){
                    payCombinationList.add(payCombination);
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOByTypeMap.put(STATISTICS_SELECT_CONDITION, statisticsFromPageDTO);
            statisticsDTOByTypeMap.put(STATISTICS_SELECT_CONDITION, statisticsFromPageDTO);
            statisticsDTOByTypeMap.put(PAYCOMBINATION, payCombinationList);
        }
        return statisticsDTOByTypeMap;
    }
    /**
     * 判断常规付款是否有有效值添加进返回类型，并累加数值
     * @param staCommonPay
     * @param payCombination
     */
    private void judgeTheCommonPayEffectiveValue(StatisticsFromPageDTO staCommonPay, StatisticsFromPageDTO payCombination) {
        if (StringUtils.isNotBlank(staCommonPay.getType())){
            payCombination.setCommonPayMainId(staCommonPay.getCommonPayMainId());
            if (payCombination.getMoney()!= null){
                Double money = payCombination.getMoney() + staCommonPay.getMoney();
                payCombination.setMoney(money);
            }else {
                payCombination.setMoney(staCommonPay.getMoney());
            }
        }
    }
    /**
     * 判断差旅报销和通用报销是否有有效值添加进返回类型，并累加数值
     * @param staReimbursAndTravel
     * @param payCombination
     */
    private void judgeTheReimburseAndTravelEffectiveValue(StatisticsFromPageDTO staReimbursAndTravel, StatisticsFromPageDTO payCombination) {
        if (StringUtils.isNotBlank(staReimbursAndTravel.getType())){
            payCombination.setTravelMainId(staReimbursAndTravel.getTravelMainId());
            payCombination.setReimburseMainId(staReimbursAndTravel.getReimburseMainId());
            if (payCombination.getMoney() != null){
                Double money = payCombination.getMoney()+staReimbursAndTravel.getMoney();
                payCombination.setMoney(money);
            }else {
                payCombination.setMoney(staReimbursAndTravel.getMoney());
            }
        }
    }
    /**
     * 判断付款是否有有效值添加进返回类型，并累加数值
     * @param staPay
     * @param payCombination
     */
    private void judgeThePayEffectiveValue(StatisticsFromPageDTO staPay, StatisticsFromPageDTO payCombination) {
        if (StringUtils.isNotBlank(staPay.getType())){
            payCombination.setFinPayMainId(staPay.getFinPayMainId());
            if (payCombination.getMoney() != null){
                Double money = payCombination.getMoney() + staPay.getMoney();
                payCombination.setMoney(money);
            }else {
                payCombination.setMoney(staPay.getMoney());
            }
        }
    }
    /**
     * 判断当前类型是否在常规付款表中
     * @param commonPayMap
     * @param sysDictDataItem
     * @param staCommonPay
     */
    private void judgeTheCommonPayOwnType(Map<String, Object> commonPayMap, SysDictData sysDictDataItem, StatisticsFromPageDTO staCommonPay) {
        for (StatisticsFromPageDTO commonPayItem :
                (Collection<? extends StatisticsFromPageDTO>)commonPayMap.get(CONTENT_OF_FORM)) {
            if (StringUtils.equals(sysDictDataItem.getValue(), commonPayItem.getType())){
                staCommonPay.setCommonPayMainId(commonPayItem.getCommonPayMainId());
                staCommonPay.setType(sysDictDataItem.getValue());
                staCommonPay.setMoney(commonPayItem.getMoney());
                break;
            }
        }
    }
    /**
     * 判断当前类型是否在差旅报销或者通用报销
     * @param reimbursAndTravelMap
     * @param sysDictDataItem
     * @param staReimbursAndTravel
     */
    private void judgeTheReimburseAndTravelOwnTheType(Map<String, Object> reimbursAndTravelMap, SysDictData sysDictDataItem, StatisticsFromPageDTO staReimbursAndTravel) {
        for (StatisticsFromPageDTO reimbursAndTravelItem:
                (Collection<? extends StatisticsFromPageDTO>)reimbursAndTravelMap.get(CONTENT_OF_FORM)) {
            if (StringUtils.equals(reimbursAndTravelItem.getType(),sysDictDataItem.getValue())){
                staReimbursAndTravel.setReimburseMainId(reimbursAndTravelItem.getReimburseMainId());
                staReimbursAndTravel.setTravelMainId(reimbursAndTravelItem.getTravelMainId());
                staReimbursAndTravel.setMoney(reimbursAndTravelItem.getMoney());
                staReimbursAndTravel.setType(sysDictDataItem.getValue());
                break;
            }
        }
    }
    /**
     * 判断当前类型是否在付款表中
     * @param payMap
     * @param sysDictDataItem
     * @param staPay
     */
    private void judgeThePayOwnTheType(Map<String, Object> payMap, SysDictData sysDictDataItem, StatisticsFromPageDTO staPay) {
        for (StatisticsFromPageDTO payItem:
                (Collection<? extends StatisticsFromPageDTO>)payMap.get(CONTENT_OF_FORM)) {
            if (StringUtils.equals(payItem.getType(),sysDictDataItem.getValue())){
                staPay.setFinPayMainId(payItem.getFinPayMainId());
                staPay.setType(sysDictDataItem.getValue());
                staPay.setMoney(payItem.getMoney());
                break;
            }
        }
    }
    /**
     * 根据 项目 返回页面
     * @param statisticsFromPageDTO
     */
    public Map<String,Object> sumByProject(StatisticsFromPageDTO statisticsFromPageDTO) {
        //存放返回页面的数据
        Map<String,Object> statisticsDTOByProjectMap = new HashMap<String, Object>();
        //公司名称
        String compayName = "";
        if (statisticsFromPageDTO.getPayCompany() != null && !statisticsFromPageDTO.getPayCompany().equals("")) {
            SysDictData sysDictData
                    = iSysDictDataDao.findByValueAndTypeidNotDelet(
                            Integer.valueOf(statisticsFromPageDTO.getPayCompany()), COMPANY_TYPE_ID_VALUE);
            compayName = sysDictData.getName();
        }
        //将付款的三张表综合起来
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getInvestId())
                ||StringUtils.isNotBlank(statisticsFromPageDTO.getStatus())){
            //通用加差旅计算  --需求更改，如果status选择总经理审批汇总，则加上 常规付款、付款管理的数据
            Map<String,Object> reimbursAndTravelMap = this.remiburseAndTravelCount(statisticsFromPageDTO);
            //费用归属 只用将通用跟差旅
            Set<Integer> projectIdSet = Sets.newHashSet();
            projectIdSet.addAll((Collection<? extends Integer>) reimbursAndTravelMap.get(PROJECT_ID_SET));
            List<Integer> projectIdList = Lists.newArrayList();
            projectIdList.addAll(projectIdSet);
            List<SaleProjectManage> projectList = Lists.newArrayList();
            try {
                if (!projectIdList.isEmpty() && projectIdList.size() > 0) {
                    projectList = iSaleProjectManageDao.findByIdList(projectIdList);
                }
            }catch (Exception e){
                logger.error("财务统计 查找项目名称失败"+e);
            }
            Set<String> generalSet = Sets.newHashSet();
            generalSet.addAll((Collection<? extends String>) reimbursAndTravelMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList = Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty() && generalIdList.size() > 0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, GENERAL_TYPE_ID_VALUE);
                }
            }catch (Exception e){
                logger.error("财务统计 查找通用类型名称失败"+e);
            }
            //根据project 补充projectName
            for (StatisticsFromPageDTO reimbursAndTravelItem:
                    (Collection<? extends StatisticsFromPageDTO>) reimbursAndTravelMap.get(CONTENT_OF_FORM)) {
                for (SaleProjectManage projectItem : projectList) {
                    if (reimbursAndTravelItem.getProjectId().equals(projectItem.getId())){
                        reimbursAndTravelItem.setProjectName(projectItem.getName());
                        break;
                    }
                }
            }
            //根据type 补充typeName
            for (StatisticsFromPageDTO reimbursAndTravelItem:
                    (Collection<? extends StatisticsFromPageDTO>) reimbursAndTravelMap.get(CONTENT_OF_FORM)) {
                for (SysDictData dictDataItem : generalList) {
                    if (StringUtils.equals(reimbursAndTravelItem.getType(),dictDataItem.getValue())){
                        reimbursAndTravelItem.setTypeName(dictDataItem.getName());
                        break;
                    }
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOByProjectMap.put(STATISTICS_SELECT_CONDITION,statisticsFromPageDTO);
            statisticsDTOByProjectMap.put(PAYCOMBINATION,reimbursAndTravelMap.get(CONTENT_OF_FORM));
        }else if (StringUtils.isNotBlank(statisticsFromPageDTO.getUserName())){
            //判断是否有个人(只有付款跟通用加差旅)
            //付款计算
            Map<String,Object> payMap = this.payCount(statisticsFromPageDTO);
            //通用加差旅计算 
            Map<String,Object> reimbursAndTravelMap = this.remiburseAndTravelCount(statisticsFromPageDTO);
            Set<Integer> projectIdSet= Sets.newHashSet();
            projectIdSet.addAll((Collection<? extends Integer>) payMap.get(PROJECT_ID_SET));
            projectIdSet.addAll((Collection<? extends Integer>) reimbursAndTravelMap.get(PROJECT_ID_SET));
            List<Integer> projectIdList = Lists.newArrayList();
            projectIdList.addAll(projectIdSet);
            List<SaleProjectManage> projectList = Lists.newArrayList();
            try {
                if (!projectIdList.isEmpty() && projectIdList.size() > 0) {
                    projectList = iSaleProjectManageDao.findByIdList(projectIdList);
                }
            }catch (Exception e){
                logger.error("财务统计 查找项目名称失败"+e);
            }
            Set<String> generalSet = Sets.newHashSet();
            generalSet.addAll((Collection<? extends String>) payMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) reimbursAndTravelMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList = Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty() && generalIdList.size() > 0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, GENERAL_TYPE_ID_VALUE);
                }
            }catch (Exception e){
                logger.error("财务统计 查找通用类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList = Lists.newArrayList();
            for (SaleProjectManage projectItem : projectList) {
                for (SysDictData dictDataItem : generalList) {
                    //判断当前projectId  general是否在 payList中
                    StatisticsFromPageDTO staPay = new StatisticsFromPageDTO();
                    judgeThePayOwnTypeAndProject(payMap, projectItem, dictDataItem, staPay);
                    //判断当前projectId  general是否在 reimbursAndTravel中
                    StatisticsFromPageDTO staReimbursAndTravel = new StatisticsFromPageDTO();
                    judgeTheReimbursAndTravelOwnTypeAndProject(reimbursAndTravelMap, projectItem, dictDataItem, staReimbursAndTravel);
                    //综合付款表和通用差旅表
                    StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                    payCombination.setProjectId(projectItem.getId());
                    payCombination.setProjectName(projectItem.getName());
                    payCombination.setType(dictDataItem.getValue());
                    payCombination.setTypeName(dictDataItem.getName());
                    //判断是否有有效值添加进返回类型，并累加数值
                    judgeThePayEffectiveValue(staPay, payCombination);
                    judgeTheReimburseAndTravelEffectiveValue(staReimbursAndTravel, payCombination);
                    if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00){
                        payCombinationList.add(payCombination);
                    }
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOByProjectMap.put(STATISTICS_SELECT_CONDITION, statisticsFromPageDTO);
            statisticsDTOByProjectMap.put(PAYCOMBINATION, payCombinationList);
            statisticsDTOByProjectMap.put(PROJECT_ID_SET, projectIdSet);
        }
        else {
            //全部的表
            //付款计算
            Map<String,Object> payMap = this.payCount(statisticsFromPageDTO);
            //通用加差旅计算
            Map<String,Object> reimbursAndTravelMap = this.remiburseAndTravelCount(statisticsFromPageDTO);
            //常规付款计算
            Map<String,Object> commonPayMap = this.commonPayCount(statisticsFromPageDTO);
            Set<Integer> projectIdSet= Sets.newHashSet();
            projectIdSet.addAll((Collection<? extends Integer>) payMap.get(PROJECT_ID_SET));
            projectIdSet.addAll((Collection<? extends Integer>) reimbursAndTravelMap.get(PROJECT_ID_SET));
            projectIdSet.addAll((Collection<? extends Integer>) commonPayMap.get(PROJECT_ID_SET));
            List<Integer> projectIdList = Lists.newArrayList();
            projectIdList.addAll(projectIdSet);
            List<SaleProjectManage> projectList = Lists.newArrayList();
            try {
                if (!projectIdList.isEmpty() && projectIdList.size() > 0) {
                    projectList = iSaleProjectManageDao.findByIdList(projectIdList);
                }
            }catch (Exception e){
                logger.error("财务统计 查找项目名称失败"+e);
            }
            Set<String> generalSet = Sets.newHashSet();
            generalSet.addAll((Collection<? extends String>) payMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) reimbursAndTravelMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) commonPayMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList = Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty() && generalIdList.size() > 0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, GENERAL_TYPE_ID_VALUE);
                }
            }catch (Exception e){
                logger.error("财务统计 查找通用类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList = Lists.newArrayList();
            for (SaleProjectManage projectItem : projectList) {
                for (SysDictData dictDataItem : generalList) {
                    //判断当前projectId  general是否在 payList中
                    StatisticsFromPageDTO staPay = new StatisticsFromPageDTO();
                    judgeThePayOwnTypeAndProject(payMap, projectItem, dictDataItem, staPay);
                    //判断当前projectId  general是否在 reimbursAndTravel中
                    StatisticsFromPageDTO staReimbursAndTravel = new StatisticsFromPageDTO();
                    judgeTheReimbursAndTravelOwnTypeAndProject(reimbursAndTravelMap, projectItem, dictDataItem, staReimbursAndTravel);
                    //判断当前projectId  general是否在 commonPay中
                    StatisticsFromPageDTO staCommonPay = new StatisticsFromPageDTO();
                    judgeTheCommonPayOwnTypeAndProject(commonPayMap, projectItem, dictDataItem, staCommonPay);
                    //综合三张表
                    StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                    payCombination.setProjectId(projectItem.getId());
                    payCombination.setProjectName(projectItem.getName());
                    payCombination.setType(dictDataItem.getValue());
                    payCombination.setTypeName(dictDataItem.getName());
                    //判断是否有有效值添加进返回类型，并累加数值
                    judgeThePayEffectiveValue(staPay, payCombination);
                    judgeTheReimburseAndTravelEffectiveValue(staReimbursAndTravel, payCombination);
                    judgeTheCommonPayEffectiveValue(staCommonPay, payCombination);
                    if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00){
                        payCombinationList.add(payCombination);
                    }
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOByProjectMap.put(STATISTICS_SELECT_CONDITION, statisticsFromPageDTO);
            statisticsDTOByProjectMap.put(PAYCOMBINATION, payCombinationList);
            statisticsDTOByProjectMap.put(PROJECT_ID_SET, projectIdSet);
        }
        return statisticsDTOByProjectMap;
    }
    /**
     * 判断类型和项目是否在常规付款中
     * @param commonPayMap
     * @param projectItem
     * @param dictDataItem
     * @param staCommonPay
     */
    private void judgeTheCommonPayOwnTypeAndProject(Map<String, Object> commonPayMap, SaleProjectManage projectItem, SysDictData dictDataItem, StatisticsFromPageDTO staCommonPay) {
        for (StatisticsFromPageDTO commonPayItem:
                (Collection<? extends StatisticsFromPageDTO>)commonPayMap.get(CONTENT_OF_FORM)) {
            if (commonPayItem.getProjectId().equals(projectItem.getId())
                    && StringUtils.equals(dictDataItem.getValue(),commonPayItem.getType())){
                staCommonPay.setCommonPayMainId(commonPayItem.getCommonPayMainId());
                staCommonPay.setProjectId(projectItem.getId());
                staCommonPay.setType(dictDataItem.getValue());
                staCommonPay.setMoney(commonPayItem.getMoney());
                break;
            }
        }
    }
    /**
     * 判断类型和项目是否在差旅报销和通用报销中
     * @param reimbursAndTravelMap
     * @param projectItem
     * @param dictDataItem
     * @param staReimbursAndTravel
     */
    private void judgeTheReimbursAndTravelOwnTypeAndProject(Map<String, Object> reimbursAndTravelMap, SaleProjectManage projectItem, SysDictData dictDataItem, StatisticsFromPageDTO staReimbursAndTravel) {
        for (StatisticsFromPageDTO reimbursAndTravelItem:
                (Collection<? extends StatisticsFromPageDTO>)reimbursAndTravelMap.get(CONTENT_OF_FORM)) {
            if (reimbursAndTravelItem.getProjectId().equals(projectItem.getId())
                    && StringUtils.equals(reimbursAndTravelItem.getType(),dictDataItem.getValue())){
                staReimbursAndTravel.setReimburseMainId(reimbursAndTravelItem.getReimburseMainId());
                staReimbursAndTravel.setTravelMainId(reimbursAndTravelItem.getTravelMainId());
                staReimbursAndTravel.setProjectId(projectItem.getId());
                staReimbursAndTravel.setMoney(reimbursAndTravelItem.getMoney());
                staReimbursAndTravel.setType(dictDataItem.getValue());
                break;
            }
        }
    }
    /**
     * 判断类型和项目是否在付款中
     * @param payMap
     * @param projectItem
     * @param dictDataItem
     * @param staPay
     */
    private void judgeThePayOwnTypeAndProject(Map<String, Object> payMap, SaleProjectManage projectItem, SysDictData dictDataItem, StatisticsFromPageDTO staPay) {
        for (StatisticsFromPageDTO payItem:
                (Collection<? extends StatisticsFromPageDTO>)payMap.get(CONTENT_OF_FORM)) {
            if (payItem.getProjectId().equals(projectItem.getId())
                    && StringUtils.equals(payItem.getType(), dictDataItem.getValue())){
                staPay.setFinPayMainId(payItem.getFinPayMainId());
                staPay.setType(dictDataItem.getValue());
                staPay.setProjectId(projectItem.getId());
                staPay.setMoney(payItem.getMoney());
                break;
            }
        }
    }

    /** 付款计算
     *   Status(状态值5);BarginId(合同Id); ProjectId(项目Id);
     *   PayId(付款类型);payCompany(公司value);DeptId(部门Id);UserId(用户Id);
     *   BeginDate(开始时间); EndDate(结束时间)(比对的是申请的时间)
     *   返回 ActualPayMoney(实际花费)
     * */
    @Override
    public Map<String,Object> payCount(StatisticsFromPageDTO statisticsFromPageDTO) {
        //如果是睿哲科技股份有限公司(11)或者是全选 要加上 广东睿哲科技股份有限公司(0)
        List<FinPay> payList = new ArrayList<FinPay>();
        /*Date startDate = statisticsFromPageDTO.getBeginDate();
        Date endDate = statisticsFromPageDTO.getEndDate();
        logger.info(startDate);
        logger.info(endDate);*/
        if (statisticsFromPageDTO.getPayCompany().equals(COMPANY_TYPE_ID)){
            try{
                payList = iFinPayDao.findPayByTitleISZero(statisticsFromPageDTO);
            }catch (Exception e){
                logger.info("财务统计 付款查询包含广东睿哲失败"+e);
            }
        }else {
            try{
            	if(statisticsFromPageDTO.getzBeginDate() != null) {
            		statisticsFromPageDTO.setActName("总经理");
            	}else if(statisticsFromPageDTO.getcBeginDate() != null) {
            		statisticsFromPageDTO.setActName("出纳");
            	}
                payList = iFinPayDao.findPayByStatistics(statisticsFromPageDTO);
            }catch (Exception e){
                logger.info("财务统计 付款查询失败"+e);
            }
        }
        Map<String, Object> payMap = Maps.newHashMap();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getWhetherSelectProject())){
            payMap = getPayListByProject(payList);
        }else {
            payMap = getPayListByType(payList);
        }
        return payMap;
    }
    /**
     * 根据类型 返回 付款表
     * @param payList
     * @return
     */
    public Map<String,Object> getPayListByType(List<FinPay> payList){
        Set<String> reimburseTypeIdSet = Sets.newHashSet();
        for (FinPay payItem : payList) {
            reimburseTypeIdSet.add(payItem.getReimburseType());
        }
        List<StatisticsFromPageDTO> payLastList = Lists.newArrayList();
        for (String reimburseTypeId : reimburseTypeIdSet) {
            StatisticsFromPageDTO staPay = new StatisticsFromPageDTO();
            Double payCountMoney = 0.00;
            Set<String> finPayMainId = Sets.newHashSet();
            for (FinPay payItem : payList){
                if (StringUtils.equals(reimburseTypeId, payItem.getReimburseType())){
                    if (payItem.getActualPayMoney() != null){
                        payCountMoney += payItem.getActualPayMoney();
                        finPayMainId.add(String.valueOf(payItem.getId()));
                    }else {
                    	for (int i = 0; i < payItem.getPayAttachList().size(); i++) {
							payCountMoney += payItem.getPayAttachList().get(i).getPayBill();
	                        finPayMainId.add(String.valueOf(payItem.getId()));
						}
                    }
                }
            }
            if (payCountMoney > 0){
                staPay.setFinPayMainId(StringUtils.join(finPayMainId.toArray(),";"));
                staPay.setType(reimburseTypeId);
                staPay.setMoney(payCountMoney);
                payLastList.add(staPay);
            }
        }
        Map<String,Object> payMap = Maps.newHashMap();
        payMap.put(GENERAL_ID_SET, reimburseTypeIdSet);
        payMap.put(CONTENT_OF_FORM, payLastList);
        return payMap;
    }
    /**
     * 根据项目 返回 付款表
     * @param payList
     * @return
     */
    public Map<String, Object> getPayListByProject(List<FinPay> payList) {
        Set<Integer> projectIdSet = Sets.newHashSet();
        Set<String> reimburseTypeIdSet = Sets.newHashSet();
        for (FinPay payItem: payList) {
            projectIdSet.add(payItem.getProjectManageId());
            reimburseTypeIdSet.add(payItem.getReimburseType());
        }
        List<StatisticsFromPageDTO> payLastList= Lists.newArrayList();
        for (Integer projectId:projectIdSet) {
            for (String reimburseId : reimburseTypeIdSet){
                StatisticsFromPageDTO staPay = new StatisticsFromPageDTO();
                Double payCountMoney = 0.00;
                Set<String> finPayMainId = Sets.newHashSet();
                for (FinPay payItem:payList){
                    if (payItem.getProjectManageId().equals(projectId)
                            && StringUtils.equals(reimburseId, payItem.getReimburseType())){
                    	if (payItem.getActualPayMoney() != null){
                            payCountMoney += payItem.getActualPayMoney();
                            finPayMainId.add(String.valueOf(payItem.getId()));
                        }else {
                        	for (int i = 0; i < payItem.getPayAttachList().size(); i++) {
    							payCountMoney += payItem.getPayAttachList().get(i).getPayBill();
    	                        finPayMainId.add(String.valueOf(payItem.getId()));
    						}
                        }
                    }
                }
                if (payCountMoney > 0){
                    staPay.setFinPayMainId(StringUtils.join(finPayMainId.toArray(), ";"));
                    staPay.setProjectId(projectId);
                    staPay.setType(reimburseId);
                    staPay.setMoney(payCountMoney);
                    payLastList.add(staPay);
                }
            }
        }
        Map<String,Object> payMap = Maps.newHashMap();
        payMap.put(PROJECT_ID_SET, projectIdSet);
        payMap.put(GENERAL_ID_SET, reimburseTypeIdSet);
        payMap.put(CONTENT_OF_FORM, payLastList);
        return payMap;
    }


    /**通用报销计算
     * Status(状态值6);UserName(申请人名字);DeptId(部门Id);
     * generalReimbursType(通用报销类型); projectId(项目Id);
     * BeginDate(开始时间); EndDate(结束时间);
     * 返回 act_reimburse(实际付款)
     *
     * 差旅报销计算
     *Status(状态值6);UserName(申请人名字);DeptId(部门Id);
     * projectId(项目Id);
     * BeginDate(开始时间); EndDate(结束时间);
     * 返回 type act_reimburse food_subsidy traffic_subsidy
     */
    @Override
    public Map<String,Object> remiburseAndTravelCount(StatisticsFromPageDTO statisticsFromPageDTO) {
        //如果是睿哲科技股份有限公司(11)或者是全选 要加上 广东睿哲科技股份有限公司(0)
        List<FinReimburseAttach> attachList = new ArrayList<FinReimburseAttach>();
        List<FinTravelreimburseAttach> travelattachList = new ArrayList<FinTravelreimburseAttach>();
        List<FinCommonPayAttach> finCommonPayAttach = new ArrayList<FinCommonPayAttach>();
        List<FinPay> finPay = new ArrayList<FinPay>();
        if (statisticsFromPageDTO.getPayCompany().equals(COMPANY_TYPE_ID)){
        	if(statisticsFromPageDTO.getzBeginDate() != null) {
        		statisticsFromPageDTO.setActName("总经理");
	        	}else if(statisticsFromPageDTO.getcBeginDate() != null) {
	        		statisticsFromPageDTO.setActName("出纳");
	        	}
        	if(statisticsFromPageDTO.getStatus()!=null && statisticsFromPageDTO.getStatus().equals("10") && StringUtils.isEmpty(statisticsFromPageDTO.getInvestId())){
        		if(statisticsFromPageDTO.getzBeginDate() != null) {
            		statisticsFromPageDTO.setStatus("4");
    	        	}else if(statisticsFromPageDTO.getcBeginDate() != null) {
    	        		statisticsFromPageDTO.setStatus("5");
    	        	}
            	if(StringUtils.isEmpty(statisticsFromPageDTO.getPayCompany())){
            		try{
            			finCommonPayAttach = iFinCommonPayAttachDao.findFinCommonPayAttach(statisticsFromPageDTO);
            		}catch(Exception e){
            			logger.error("财务统计 常规付款查询失败"+e);
            		}
            	}
            	try{
            		finPay = iFinPayDao.findFinPayByStatis(statisticsFromPageDTO);
            	}catch(Exception e){
            		logger.error("财务统计 付款管理查询失败"+e);
            	}
            }
            try{
                attachList = iFinReimburseAttachDao.findReimburseByStatisticsAndTitle(statisticsFromPageDTO);
            }catch(Exception e){
                logger.error("财务统计 通用报销包含广东睿哲查询失败"+e);
            }
            try{
                travelattachList = iFinTravelreimburseAttachDao.findByStatisticsAndTitle(statisticsFromPageDTO);
            }catch(Exception e){
                logger.error("财务统计 差旅报销查询失败"+e);
            }
        }else {
        	if(statisticsFromPageDTO.getzBeginDate() != null) {
        		statisticsFromPageDTO.setActName("总经理");
	        	}else if(statisticsFromPageDTO.getcBeginDate() != null) {
	        		statisticsFromPageDTO.setActName("出纳");
	        	}
        	if(statisticsFromPageDTO.getStatus()!=null && statisticsFromPageDTO.getStatus().equals("10")){
            	if(statisticsFromPageDTO.getzBeginDate() != null) {
        		statisticsFromPageDTO.setStatus("4");
	        	}else if(statisticsFromPageDTO.getcBeginDate() != null) {
	        		statisticsFromPageDTO.setStatus("5");
	        	}
            	if(StringUtils.isEmpty(statisticsFromPageDTO.getPayCompany())){
	            	try{
	            		finCommonPayAttach = iFinCommonPayAttachDao.findFinCommonPayAttach(statisticsFromPageDTO);
	            	}catch(Exception e){
	            		logger.error("财务统计 常规付款查询失败"+e);
	            	}
            	}
            	try{
            		finPay = iFinPayDao.findFinPayByStatis(statisticsFromPageDTO);
            	}catch(Exception e){
            		logger.error("财务统计 付款管理查询失败"+e);
            	}
            }
            try{
                attachList = iFinReimburseAttachDao.findReimburseByStatistics(statisticsFromPageDTO);
            }catch (Exception e){
                logger.error("财务统计 通用报销查询失败"+e);
            }
            try{
                travelattachList = iFinTravelreimburseAttachDao.findByStatistics(statisticsFromPageDTO);
            }catch (Exception e){
                logger.error("财务统计 差旅报销查询失败"+e);
            }
        }
        Map<String, Object> reimburseAndTravelMap = Maps.newHashMap();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getWhetherSelectProject())){
            reimburseAndTravelMap = getReimbursAndTravelByProject(statisticsFromPageDTO, attachList, travelattachList,finCommonPayAttach,finPay);
        }else {
            reimburseAndTravelMap = getReimbursAndTravelByType(statisticsFromPageDTO, attachList, travelattachList,finCommonPayAttach,finPay);
        }
        return reimburseAndTravelMap;
    }

    /**
     * 根据 类型 返回 通用表和差旅表组合
     * @param statisticsFromPageDTO
     * @param attachList
     * @param travelattachList
     * @return
     */
    public Map<String,Object> getReimbursAndTravelByType(StatisticsFromPageDTO statisticsFromPageDTO,
                                                         List<FinReimburseAttach> attachList,
                                                         List<FinTravelreimburseAttach> travelattachList,
                                                         List<FinCommonPayAttach> finCommonPayAttach,
                                                         List<FinPay> finPay){
        /**通用 attachList 加 出差 travelattachList*/
        /** "3":接待费用
         *  "4":补贴费用(交通补贴+餐费补贴)*/
        Double travelExpenseAttach = 0.00;
        Double travelReceptionAttach = 0.00;
        StatisticsTravelReimburseDTO travel = new StatisticsTravelReimburseDTO();
        Set<String> travelReceptionMainId = Sets.newHashSet();
        Set<String> travelSubsidyMainId = Sets.newHashSet();
        for (FinTravelreimburseAttach travelreimburseAttach : travelattachList) {
            if (travelreimburseAttach.getType().equals(TRAVEL_RECEPTION_TYPE)) {
                //接待
                if (travelreimburseAttach.getActReimburse() != null) {
                    travelReceptionAttach += travelreimburseAttach.getActReimburse();
                    travelReceptionMainId.add(String.valueOf(travelreimburseAttach.getId()));
                }
            } else if (travelreimburseAttach.getType().equals(TRAVEL_SUBSIDY_TYPE)) {
                //补贴
                if (travelreimburseAttach.getActReimburse() != null) {
                    travelExpenseAttach += travelreimburseAttach.getActReimburse();
                    travelSubsidyMainId.add(String.valueOf(travelreimburseAttach.getId()));
                }
            } else {
                if (travelreimburseAttach.getActReimburse() != null) {
                    travelExpenseAttach += travelreimburseAttach.getActReimburse();
                    travelSubsidyMainId.add(String.valueOf(travelreimburseAttach.getId()));
                }
            }
        }
        //放了包含主表的主键
        travel.setTravelReceptionMainId(StringUtils.join(travelReceptionMainId.toArray(), ";"));
        travel.setTravelSubsidyMainId(StringUtils.join(travelSubsidyMainId.toArray(), ";"));
        //放的是接待费
        travel.setTravelReceptionAttach(travelReceptionAttach);
        //放的是差旅费（包括了餐补费）
        travel.setTravelExpenseAttach(travelExpenseAttach);
        /**
         * "4" 是差旅费(通用)，要加上出差中的 差旅费
         * "2" 是招待费(通用)，要加上出差中的 招待费
         * */
        Set<String> generalReimburseIdSet = Sets.newHashSet();
        for (FinReimburseAttach attachItem : attachList) {
            generalReimburseIdSet.add(attachItem.getType());
        }
        if (StringUtils.isEmpty(statisticsFromPageDTO.getGeneralReimbursType())){
            if (travel.getTravelExpenseAttach() > 0.00){
                generalReimburseIdSet.add(REIMBURSE_TRAVEL_TYPE);
            }
            if (travel.getTravelReceptionAttach() > 0.00){
                generalReimburseIdSet.add(REIMBURSE_RECEPRION_TYPE);
            }
        }else if (StringUtils.equals(statisticsFromPageDTO.getGeneralReimbursType(), REIMBURSE_RECEPRION_TYPE)){
            //接待
            generalReimburseIdSet.add(REIMBURSE_RECEPRION_TYPE);
        }else if (StringUtils.equals(statisticsFromPageDTO.getGeneralReimbursType(), REIMBURSE_TRAVEL_TYPE)){
            //出差
            generalReimburseIdSet.add(REIMBURSE_TRAVEL_TYPE);
        }
        if(finCommonPayAttach!=null && finCommonPayAttach.size()>0) {
        //把 常用付款 type 拼接至 generalReimburseIdSet
        	for (FinCommonPayAttach finCommonPayAttachItem : finCommonPayAttach) {
        		generalReimburseIdSet.add(finCommonPayAttachItem.getType());
        	}
        }
        if(finPay!=null && finPay.size()>0) {
        //把 付款管理 type 拼接至 generalReimburseIdSet
        for (FinPay finPayItem : finPay) {
            generalReimburseIdSet.add(finPayItem.getReimburseType());
        }
        }
        List<StatisticsFromPageDTO> reimburselAndTravelList = new ArrayList<StatisticsFromPageDTO>();
        for (String generalId : generalReimburseIdSet) {
            Double reimbursCountMoney = 0.00;
            StatisticsFromPageDTO staReimburse = new StatisticsFromPageDTO();
            Set<String> mainId = Sets.newHashSet();
            Set<String> mainId3 = Sets.newHashSet();
            for (FinReimburseAttach attach : attachList) {
                if(StringUtils.equals(attach.getType(), generalId)){
                    if (attach.getActReimburse() != null){
                        reimbursCountMoney += attach.getActReimburse();
                        //等于1则是差旅,等于2则是通用
                        if(attach.getState() == 1) {
                        	mainId3.add(String.valueOf(attach.getId()));
                        } else if(attach.getState() == 2){
                        	mainId.add(String.valueOf(attach.getId()));
                        }
                    }
                }
            }
            Set<String> mainId1 = Sets.newHashSet();
            if(finCommonPayAttach!=null && finCommonPayAttach.size()>0) {
            //常用付款
            for (FinCommonPayAttach finCommonPayAttachItem : finCommonPayAttach) {
                if(StringUtils.equals(finCommonPayAttachItem.getType(), generalId)){
                    if (finCommonPayAttachItem.getMoney() != null){
                        reimbursCountMoney += Double.valueOf(finCommonPayAttachItem.getMoney());
                        mainId1.add(String.valueOf(finCommonPayAttachItem.getId()));
                    }
                }
            }
            }
            Set<String> mainId2 = Sets.newHashSet();
            if(finPay!=null && finPay.size()>0) {
            //付款管理
            for (FinPay finPayItem : finPay) {
                if(StringUtils.equals(finPayItem.getReimburseType(), generalId)){
                    if (finPayItem.getActualPayMoney() != null){
                        reimbursCountMoney += finPayItem.getActualPayMoney();
                        mainId2.add(String.valueOf(finPayItem.getId()));
                    }
                }
            }
            }
            if (StringUtils.equals(generalId, REIMBURSE_TRAVEL_TYPE)){
                reimbursCountMoney += travel.getTravelExpenseAttach();
                staReimburse.setTravelMainId(travel.getTravelSubsidyMainId());
            }
            if (StringUtils.equals(generalId, REIMBURSE_RECEPRION_TYPE)){
                reimbursCountMoney += travel.getTravelReceptionAttach();
                staReimburse.setTravelMainId(travel.getTravelReceptionMainId());
            }
            if (reimbursCountMoney > 0){
                if(!mainId.isEmpty() && mainId.size() > 0){
                    staReimburse.setReimburseMainId(StringUtils.join(mainId.toArray(), ";"));
                }
                if(!mainId3.isEmpty() && mainId3.size() > 0) {
                	staReimburse.setReimburseOrTravelMainId(StringUtils.join(mainId3.toArray(), ";"));
                }
                if(!mainId1.isEmpty() && mainId1.size() > 0){
                    staReimburse.setCommonPayMainId(StringUtils.join(mainId1.toArray(), ";"));
                }
                if(!mainId2.isEmpty() && mainId2.size() > 0){
                    staReimburse.setFinPayMainId(StringUtils.join(mainId2.toArray(), ";"));
                }
                staReimburse.setType(generalId);
                staReimburse.setMoney(reimbursCountMoney);
                reimburselAndTravelList.add(staReimburse);
            }
        }
        Map<String,Object> reimburseAndTravelMap = Maps.newHashMap();
        reimburseAndTravelMap.put(GENERAL_ID_SET, generalReimburseIdSet);
        reimburseAndTravelMap.put(CONTENT_OF_FORM, reimburselAndTravelList);
        return reimburseAndTravelMap;
    }
    /**
     * 根据 项目 返回 通用表和差旅表组合
     * @param statisticsFromPageDTO
     * @param attachList
     * @param travelattachList
     * @return
     */
    public Map<String, Object> getReimbursAndTravelByProject(StatisticsFromPageDTO statisticsFromPageDTO,
                                                             List<FinReimburseAttach> attachList,
                                                             List<FinTravelreimburseAttach> travelattachList,
                                                             List<FinCommonPayAttach> finCommonPayAttach,
                                                             List<FinPay> finPay) {
        //获取有有效值的项目ID
        Set<Integer> projectIdTravelIdSet = Sets.newHashSet();
        for (FinTravelreimburseAttach travelAttachItem : travelattachList) {
            projectIdTravelIdSet.add(travelAttachItem.getProjectId());
        }
        /**通用 attachList 加 出差 travelattachList*/
        /** "3":接待费用
         *  "4":补贴费用(交通补贴+餐费补贴)*/
        List<StatisticsTravelReimburseDTO> staTravelList= Lists.newArrayList();
        for (Integer projectId : projectIdTravelIdSet) {
            Double travelExpenseAttach = 0.00;
            Double travelReceptionAttach = 0.00;
            StatisticsTravelReimburseDTO travel = new StatisticsTravelReimburseDTO();
            Set<String> travelReceptionMainId = Sets.newHashSet();
            Set<String> travelSubsidyMainId = Sets.newHashSet();
            for (FinTravelreimburseAttach travelreimburseAttach : travelattachList) {
                if (travelreimburseAttach.getType().equals(TRAVEL_RECEPTION_TYPE)
                        && travelreimburseAttach.getProjectId().equals(projectId)) {
                    if (travelreimburseAttach.getActReimburse() != null) {
                        travelReceptionAttach += travelreimburseAttach.getActReimburse();
                        travelReceptionMainId.add(String.valueOf(travelreimburseAttach.getId()));
                    }
                } else if (travelreimburseAttach.getType().equals(TRAVEL_SUBSIDY_TYPE)
                        && travelreimburseAttach.getProjectId().equals(projectId)) {
                    if (travelreimburseAttach.getActReimburse() != null) {
                        travelExpenseAttach += travelreimburseAttach.getActReimburse();
                        travelSubsidyMainId.add(String.valueOf(travelreimburseAttach.getId()));
                    }
                } else if (travelreimburseAttach.getProjectId().equals(projectId)){
                    if (travelreimburseAttach.getActReimburse() != null) {
                        travelExpenseAttach += travelreimburseAttach.getActReimburse();
                        travelSubsidyMainId.add(String.valueOf(travelreimburseAttach.getId()));
                    }
                }
            }
            //放了包含主表的主键
            travel.setTravelReceptionMainId(StringUtils.join(travelReceptionMainId.toArray(), ";"));
            travel.setTravelSubsidyMainId(StringUtils.join(travelSubsidyMainId.toArray(), ";"));
            travel.setProjectId(projectId);
            //放的是接待费
            travel.setTravelReceptionAttach(travelReceptionAttach);
            //放的是差旅费（包括了餐补费）
            travel.setTravelExpenseAttach(travelExpenseAttach);
            staTravelList.add(travel);
        }
        /**
         * "4" 是差旅费(通用)，要加上出差中的 差旅费
         * "2" 是招待费(通用)，要加上出差中的 招待费
         * */
        Set<Integer> projectIdSet = Sets.newHashSet();
        Set<String> generalReimburseIdSet = Sets.newHashSet();
        for (FinReimburseAttach reimburseItem : attachList) {
            projectIdSet.add(reimburseItem.getProjectId());
            generalReimburseIdSet.add(reimburseItem.getType());
        }
        List<StatisticsFromPageDTO> reimburselList = new ArrayList<StatisticsFromPageDTO>();
        for (Integer projectId : projectIdSet) {
            for (String generalId : generalReimburseIdSet) {
                Double reimbursCountMoney = 0.00;
                StatisticsFromPageDTO staReimburse = new StatisticsFromPageDTO();
                Set<String> mainId = Sets.newHashSet();
                Set<String> mainId3 = Sets.newHashSet();
                for (FinReimburseAttach attach : attachList) {
                    if(StringUtils.equals(attach.getType(), generalId)
                            && attach.getProjectId().equals(projectId)){
                        if (attach.getActReimburse() != null){
                            reimbursCountMoney += attach.getActReimburse();
                            //等于1则是差旅,等于2则是通用
                            if(attach.getState() == 1) {
                            	mainId3.add(String.valueOf(attach.getId()));
                            } else if(attach.getState() == 2){
                            	mainId.add(String.valueOf(attach.getId()));
                            }
                        }
                    }
                }
                if (reimbursCountMoney > 0){
                    if(!mainId.isEmpty() && mainId.size() > 0) {
                        staReimburse.setReimburseMainId(StringUtils.join(mainId.toArray(), ";"));
                    }
                    if(!mainId3.isEmpty() && mainId3.size() > 0) {
                    	staReimburse.setReimburseOrTravelMainId(StringUtils.join(mainId3.toArray(), ";"));
                    }
                    staReimburse.setType(generalId);
                    staReimburse.setProjectId(projectId);
                    staReimburse.setMoney(reimbursCountMoney);
                    reimburselList.add(staReimburse);
                }
            }
        }
        Set<Integer> projectCommonIdSet = Sets.newHashSet();
        Set<String> generalCommonIdSet = Sets.newHashSet();
        List<StatisticsFromPageDTO> finCommonPayAttachList = new ArrayList<StatisticsFromPageDTO>();
        if(finCommonPayAttach!=null && finCommonPayAttach.size()>0) {
        //组合常规付款 finCommonPayAttach
        for (FinCommonPayAttach finCommonPayAttach1 : finCommonPayAttach) {
        	projectCommonIdSet.add(finCommonPayAttach1.getProjectManageId());
        	generalCommonIdSet.add(finCommonPayAttach1.getType());
        }
        for (Integer projectId : projectCommonIdSet) {
            for (String generalId : generalCommonIdSet) {
                Double reimbursCountMoney = 0.00;
                StatisticsFromPageDTO staReimburse = new StatisticsFromPageDTO();
                Set<String> mainId = Sets.newHashSet();
                for (FinCommonPayAttach finCommonPayAttach2 : finCommonPayAttach) {
                    if(StringUtils.equals(finCommonPayAttach2.getType(), generalId)
                            && finCommonPayAttach2.getProjectManage().equals(projectId)){
                        if (finCommonPayAttach2.getMoney() != null){
                            reimbursCountMoney += Double.valueOf(finCommonPayAttach2.getMoney());
                            mainId.add(String.valueOf(finCommonPayAttach2.getId()));
                        }
                    }
                }
                if (reimbursCountMoney > 0){
                    if(!mainId.isEmpty() && mainId.size() > 0) {
                        staReimburse.setReimburseMainId(StringUtils.join(mainId.toArray(), ";"));
                    }
                    staReimburse.setType(generalId);
                    staReimburse.setProjectId(projectId);
                    staReimburse.setMoney(reimbursCountMoney);
                    finCommonPayAttachList.add(staReimburse);
                }
            }
        }
        }
        Set<Integer> projectFinPayIdSet = Sets.newHashSet();
        Set<String> generalFinPayIdSet = Sets.newHashSet();
        List<StatisticsFromPageDTO> finPayList = new ArrayList<StatisticsFromPageDTO>();
        if(finPay!=null && finPay.size()>0){
        //组合付款管理 finPay
        for (FinPay finPay1 : finPay) {
        	projectFinPayIdSet.add(finPay1.getProjectManageId());
        	generalFinPayIdSet.add(finPay1.getReimburseType());
        }
        for (Integer projectId : projectFinPayIdSet) {
            for (String generalId : generalFinPayIdSet) {
                Double reimbursCountMoney = 0.00;
                StatisticsFromPageDTO staReimburse = new StatisticsFromPageDTO();
                Set<String> mainId = Sets.newHashSet();
                for (FinPay finPay2 : finPay) {
                    if(StringUtils.equals(finPay2.getReimburseType(), generalId)
                            && finPay2.getProjectManage().equals(projectId)){
                        if (finPay2.getActualPayMoney() != null){
                            reimbursCountMoney += Double.valueOf(finPay2.getActualPayMoney());
                            mainId.add(String.valueOf(finPay2.getId()));
                        }
                    }
                }
                if (reimbursCountMoney > 0){
                    if(!mainId.isEmpty() && mainId.size() > 0) {
                        staReimburse.setReimburseMainId(StringUtils.join(mainId.toArray(), ";"));
                    }
                    staReimburse.setType(generalId);
                    staReimburse.setProjectId(projectId);
                    staReimburse.setMoney(reimbursCountMoney);
                    finPayList.add(staReimburse);
                }
            }
        }
        }
        //将差旅和通用、常用付款、付款四个List 合成一个总的List
        Set<Integer> projectIdSets = Sets.newHashSet();
        projectIdSets.addAll(projectIdTravelIdSet);
        projectIdSets.addAll(projectIdSet);
        if(finCommonPayAttach!=null && finCommonPayAttach.size()>0)
        projectIdSets.addAll(projectCommonIdSet);
        if(finPay!=null && finPay.size()>0)
        projectIdSets.addAll(projectFinPayIdSet);

        Set<String> generalIdAll = Sets.newHashSet();
        Set<String> generalTravel = Sets.newHashSet();
        if (StringUtils.isEmpty(statisticsFromPageDTO.getGeneralReimbursType())) {
            for (StatisticsTravelReimburseDTO travelItem : staTravelList) {
                if (travelItem.getTravelReceptionAttach() > 0.00) {
                    //接待
                    generalTravel.add(REIMBURSE_RECEPRION_TYPE);
                }
                if (travelItem.getTravelExpenseAttach() > 0.00) {
                    //出差
                    generalTravel.add(REIMBURSE_TRAVEL_TYPE);
                }
            }
        }else if (StringUtils.equals(statisticsFromPageDTO.getGeneralReimbursType(), REIMBURSE_RECEPRION_TYPE)){
            //接待
            generalTravel.add(REIMBURSE_RECEPRION_TYPE);
        }else if (StringUtils.equals(statisticsFromPageDTO.getGeneralReimbursType(), REIMBURSE_TRAVEL_TYPE)){
            //出差
            generalTravel.add(REIMBURSE_TRAVEL_TYPE);
        }
        generalIdAll.addAll(generalTravel);
        generalIdAll.addAll(generalReimburseIdSet);
        if(finCommonPayAttach!=null && finCommonPayAttach.size()>0)
        generalIdAll.addAll(generalCommonIdSet);
        if(finPay!=null && finPay.size()>0)
        generalIdAll.addAll(generalFinPayIdSet);
        
        List<StatisticsFromPageDTO> reimburseAndTravelList = Lists.newArrayList();
        for (Integer projectId : projectIdSets) {
            for (String generalId : generalIdAll) {
                //判断 project general 是否在通用表中
                StatisticsFromPageDTO staReimburse = new StatisticsFromPageDTO();
                for (StatisticsFromPageDTO reimburseItem : reimburselList) {
                    if (reimburseItem.getProjectId().equals(projectId)
                            && StringUtils.equals(reimburseItem.getType(),generalId)){
                        staReimburse.setReimburseMainId(reimburseItem.getReimburseMainId());
                        staReimburse.setProjectId(projectId);
                        staReimburse.setType(generalId);
                        staReimburse.setMoney(reimburseItem.getMoney());
                        break;
                    }
                }
                //判断 project general 是否在差旅表中
                StatisticsFromPageDTO staTravel = new StatisticsFromPageDTO();
                for (StatisticsTravelReimburseDTO travelItem : staTravelList) {
                    if (travelItem.getProjectId().equals(projectId)){
                        if (StringUtils.equals(generalId,REIMBURSE_TRAVEL_TYPE)){
                            //出差
                            if (travelItem.getTravelExpenseAttach() > 0.00){
                                staTravel.setTravelMainId(travelItem.getTravelSubsidyMainId());
                                staTravel.setProjectId(projectId);
                                staTravel.setType(generalId);
                                staTravel.setMoney(travelItem.getTravelExpenseAttach());
                                break;
                            }
                        }
                        if (StringUtils.equals(generalId, REIMBURSE_RECEPRION_TYPE)){
                            //接待
                            if (travelItem.getTravelReceptionAttach() > 0.00){
                                staTravel.setTravelMainId(travelItem.getTravelReceptionMainId());
                                staTravel.setProjectId(projectId);
                                staTravel.setType(generalId);
                                staTravel.setMoney(travelItem.getTravelReceptionAttach());
                                break;
                            }
                        }
                    }
                }
                StatisticsFromPageDTO finCommonPayAttach2 = new StatisticsFromPageDTO();
                if(finCommonPayAttach!=null && finCommonPayAttach.size()>0) {
              //判断 project general 是否在常用付款表中
                for (StatisticsFromPageDTO reimburseItem : finCommonPayAttachList) {
                    if (reimburseItem.getProjectId().equals(projectId)
                            && StringUtils.equals(reimburseItem.getType(),generalId)){
                    	finCommonPayAttach2.setCommonPayMainId(reimburseItem.getCommonPayMainId());
                    	finCommonPayAttach2.setProjectId(projectId);
                    	finCommonPayAttach2.setType(generalId);
                    	finCommonPayAttach2.setMoney(reimburseItem.getMoney());
                        break;
                    }
                }
                }
                StatisticsFromPageDTO finPay2 = new StatisticsFromPageDTO();
                if(finPay!=null && finPay.size()>0){
                    //判断 project general 是否在付款管理表中
                    for (StatisticsFromPageDTO reimburseItem : finPayList) {
                        if (reimburseItem.getProjectId().equals(projectId)
                                && StringUtils.equals(reimburseItem.getType(),generalId)){
                        	finPay2.setFinPayMainId(reimburseItem.getFinPayMainId());
                        	finPay2.setProjectId(projectId);
                        	finPay2.setType(generalId);
                        	finPay2.setMoney(reimburseItem.getMoney());
                            break;
                        }
                    }
                    }
                StatisticsFromPageDTO reimbursAndTravel = new StatisticsFromPageDTO();
                reimbursAndTravel.setProjectId(projectId);
                reimbursAndTravel.setType(generalId);
                if (StringUtils.isNotBlank(staReimburse.getReimburseMainId())){
                    reimbursAndTravel.setReimburseMainId(staReimburse.getReimburseMainId());
                }
                if (StringUtils.isNotBlank(staTravel.getTravelMainId())){
                    reimbursAndTravel.setTravelMainId(staTravel.getTravelMainId());
                }
                
                if (StringUtils.isNotBlank(finCommonPayAttach2.getCommonPayMainId())){
                    reimbursAndTravel.setCommonPayMainId(finCommonPayAttach2.getCommonPayMainId());
                }
                if (StringUtils.isNotBlank(finPay2.getFinPayMainId())){
                    reimbursAndTravel.setFinPayMainId(finPay2.getFinPayMainId());
                }
                
                if (StringUtils.isNotBlank(staReimburse.getType())){
                    if (reimbursAndTravel.getMoney() != null){
                        Double money = staReimburse.getMoney() + reimbursAndTravel.getMoney();
                        reimbursAndTravel.setMoney(money);
                    }else {
                        reimbursAndTravel.setMoney(staReimburse.getMoney());
                    }
                }
                if (StringUtils.isNotBlank(staTravel.getType())){
                    if (reimbursAndTravel.getMoney() != null){
                        Double money = staTravel.getMoney() + reimbursAndTravel.getMoney();
                        reimbursAndTravel.setMoney(money);
                    }else {
                        reimbursAndTravel.setMoney(staTravel.getMoney());
                    }
                }
                if (StringUtils.isNotBlank(finCommonPayAttach2.getType())){
                    if (reimbursAndTravel.getMoney() != null){
                        Double money = finCommonPayAttach2.getMoney() + reimbursAndTravel.getMoney();
                        reimbursAndTravel.setMoney(money);
                    }else {
                        reimbursAndTravel.setMoney(finCommonPayAttach2.getMoney());
                    }
                }
                if (StringUtils.isNotBlank(finPay2.getType())){
                    if (reimbursAndTravel.getMoney() != null){
                        Double money = finPay2.getMoney() + reimbursAndTravel.getMoney();
                        reimbursAndTravel.setMoney(money);
                    }else {
                        reimbursAndTravel.setMoney(finPay2.getMoney());
                    }
                }
                if (reimbursAndTravel.getMoney() != null && reimbursAndTravel.getMoney() > 0.00){
                    reimburseAndTravelList.add(reimbursAndTravel);
                }
            }
        }
        Map<String,Object> reimburseAndTravelMap = Maps.newHashMap();
        reimburseAndTravelMap.put(PROJECT_ID_SET, projectIdSets);
        reimburseAndTravelMap.put(GENERAL_ID_SET, generalIdAll);
        reimburseAndTravelMap.put(CONTENT_OF_FORM, reimburseAndTravelList);
        return reimburseAndTravelMap;
    }

    /**
     * 常规付款计算
     * projectId(项目Id);generalReimbursType(通用报销类型);
     * PayId(付款类型);payCompany(公司value)付款单位;
     * BeginDate(开始时间); EndDate(结束时间);
     * 返回 money
     */
    @Override
    public Map<String,Object> commonPayCount(StatisticsFromPageDTO statisticsFromPageDTO) {
        List<FinCommonPayAttach> commonPayAttachList = new ArrayList<FinCommonPayAttach>();
        try{
            commonPayAttachList = iFinCommonPayAttachDao.findByStatistics(statisticsFromPageDTO);
        }catch (Exception e){
            logger.error("财务统计 常规付款查找失败"+e);
        }
        Map<String, Object> commonPayMap = Maps.newHashMap();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getWhetherSelectProject())){
            commonPayMap = getCommonPayByProject(commonPayAttachList);
        }else {
            commonPayMap = getCommonPayByType(commonPayAttachList);
        }
        return commonPayMap;
    }
    /**
     * 根据类型 返回 常规付款
     * @param commonPayAttachList
     * @return
     */
    public Map<String,Object> getCommonPayByType(List<FinCommonPayAttach> commonPayAttachList){
        Set<String> generalReimburseIdSet = Sets.newHashSet();
        for (FinCommonPayAttach attachItem : commonPayAttachList){
            generalReimburseIdSet.add(attachItem.getType());
        }
        List<StatisticsFromPageDTO> commPayList = Lists.newArrayList();
        for (String generalId:generalReimburseIdSet) {
            StatisticsFromPageDTO staCommonPay = new StatisticsFromPageDTO();
            Double commonPayCountMoney = 0.00;
            Set<String> mianId = Sets.newHashSet();
            for (FinCommonPayAttach commonPayAttach : commonPayAttachList){
                if (StringUtils.equals(commonPayAttach.getType(), generalId)){
                    if (StringUtils.isNotBlank(commonPayAttach.getMoney())){
                        commonPayCountMoney += Double.valueOf(commonPayAttach.getMoney());
                        //将主表主键放入mianId中
                        mianId.add(String.valueOf(commonPayAttach.getId()));
                    }
                }
            }
            if (commonPayCountMoney > 0.00) {
                staCommonPay.setCommonPayMainId(StringUtils.join(mianId.toArray(), ";"));
                staCommonPay.setType(generalId);
                staCommonPay.setMoney(commonPayCountMoney);
                commPayList.add(staCommonPay);
            }
        }
        Map<String,Object> commonPayMap = Maps.newHashMap();
        commonPayMap.put(GENERAL_ID_SET, generalReimburseIdSet);
        commonPayMap.put(CONTENT_OF_FORM, commPayList);
        return commonPayMap;
    }
    /**
     * 根据项目 返回 常规付款
     * @param commonPayAttachList
     * @return
     */
    public Map<String, Object> getCommonPayByProject(List<FinCommonPayAttach> commonPayAttachList) {
        Set<Integer> projectIdSet = Sets.newHashSet();
        Set<String> generalReimburseIdSet = Sets.newHashSet();
        //得到拥有有效数据项目ID 和 付款类型
        for (FinCommonPayAttach attachItem : commonPayAttachList) {
            projectIdSet.add(attachItem.getProjectManageId());
            generalReimburseIdSet.add(attachItem.getType());
        }
        List<StatisticsFromPageDTO> commPayList = Lists.newArrayList();
        for (Integer projectId : projectIdSet) {
            for (String generalId : generalReimburseIdSet) {
                StatisticsFromPageDTO staCommonPay = new StatisticsFromPageDTO();
                Double commonPayCountMoney = 0.00;
                Set<String> mianId = Sets.newHashSet();
                for (FinCommonPayAttach commonPayAttach : commonPayAttachList){
                    if (commonPayAttach.getProjectManageId().equals(projectId)
                            && StringUtils.equals(commonPayAttach.getType(), generalId)){
                        if (StringUtils.isNotBlank(commonPayAttach.getMoney())){
                            commonPayCountMoney += Double.valueOf(commonPayAttach.getMoney());
                            //将主表主键放入mianId中
                            mianId.add(String.valueOf(commonPayAttach.getId()));
                        }
                    }
                }
                if (commonPayCountMoney > 0.00) {
                    staCommonPay.setCommonPayMainId(StringUtils.join(mianId.toArray(), ";"));
                    staCommonPay.setProjectId(projectId);
                    staCommonPay.setType(generalId);
                    staCommonPay.setMoney(commonPayCountMoney);
                    commPayList.add(staCommonPay);
                }
            }
        }
        Map<String,Object> commonPayMap = Maps.newHashMap();
        commonPayMap.put(PROJECT_ID_SET, projectIdSet);
        commonPayMap.put(GENERAL_ID_SET, generalReimburseIdSet);
        commonPayMap.put(CONTENT_OF_FORM, commPayList);
        return commonPayMap;
    }

    /**单条详细记录查询
     * finPayMainId:付款表相关的ID
     * reimburseMainId:通用表相关的ID
     * travelMainId:差旅表相关的ID
     *  commonPayMainId:常规付款的相关ID
     * */
    @Override
    public CrudResultDTO singleDetail(StatisticsFromPageDTO statisticsFromPageDTO) {
        List<SingleDetail> singleDetailList = Lists.newArrayList();
        if (!StringUtils.equals(statisticsFromPageDTO.getFinPayMainId(), REPRSENT_NULL)){
            String[] finPayMainIdString = statisticsFromPageDTO.getFinPayMainId().split(";");
            try {
                List<SingleDetail> payByIdList = iFinPayDao.findPayByIdList(Arrays.asList(finPayMainIdString));
                singleDetailList.addAll(payByIdList);
            }catch (Exception e){
                logger.error("财务统计 付款详细信息查找失败"+e);
            }
        }
        if (!StringUtils.equals(statisticsFromPageDTO.getReimburseMainId(), REPRSENT_NULL)){
            String[] reimburseMainIdString = statisticsFromPageDTO.getReimburseMainId().split(";");
            try {
                List<SingleDetail> reimburseByIdList = iFinReimburseAttachDao.findReimburseByIdList(Arrays.asList(reimburseMainIdString));
                singleDetailList.addAll(reimburseByIdList);
            }catch (Exception e){
                logger.error("财务统计 通用附表详细信息查找失败");
            }
        }
        //差旅的业务费和攻关费
        if (!StringUtils.equals(statisticsFromPageDTO.getReimburseOrTravelMainId(), REPRSENT_NULL)){
        	 String[] reimburseOrTravelMainIdString = statisticsFromPageDTO.getReimburseOrTravelMainId().split(";");
        	   try {
        	 List<SingleDetail> travelByIdList = iFinTravelreimburseAttachDao.findByTravelByIdList(Arrays.asList(reimburseOrTravelMainIdString));
        	 singleDetailList.addAll(travelByIdList);
        	   }catch (Exception e){
                   logger.error("财务统计 差旅的业务费和攻关费详细信息查找失败");
               }
        }
        if (!StringUtils.equals(statisticsFromPageDTO.getTravelMainId(), REPRSENT_NULL)){
            String[] travelMainIdString = statisticsFromPageDTO.getTravelMainId().split(";");
            try{
                List<SingleDetail> travelByIdList = iFinTravelreimburseAttachDao.findByTravelByIdList(Arrays.asList(travelMainIdString));
                singleDetailList.addAll(travelByIdList);
            }catch (Exception e){
                logger.error("财务统计 差旅表附表详细信息查找失败");
            }
        }
        if (!StringUtils.equals(statisticsFromPageDTO.getCommonPayMainId(), REPRSENT_NULL)){
            String[] commonPayMainIdString = statisticsFromPageDTO.getCommonPayMainId().split(";");
            try{
                List<SingleDetail> commonPayByIdList = iFinCommonPayAttachDao.findCommonPayByIdList(Arrays.asList(commonPayMainIdString));
                singleDetailList.addAll(commonPayByIdList);
            }catch (Exception e){
                logger.error("财务统计 常规付款附表详细信息查询失败");
            }
        }
        Map<String,Object> singleDetailMap = Maps.newHashMap();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getProjectName())){
            singleDetailMap.put(SINGLE_DETAIL_PROJECT_NAME, statisticsFromPageDTO.getProjectName());
        }
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getTypeName())){
            singleDetailMap.put(SINGLE_DETAIL_TYPE_NAME, statisticsFromPageDTO.getTypeName());
        }
        singleDetailMap.put(CONTENT_OF_FORM, singleDetailList);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, singleDetailMap);
        return result;
    }
    
	@Override
	public void exportDetails(HttpServletRequest request, HttpServletResponse response, Map<String, String> param) {
		List<SingleDetail> singleDetailList = Lists.newArrayList();
        if (!StringUtils.equals(param.get("finPayMainId"), REPRSENT_NULL)){
            String[] finPayMainIdString = param.get("finPayMainId").split(";");
            try {
                List<SingleDetail> payByIdList = iFinPayDao.findPayByIdList(Arrays.asList(finPayMainIdString));
                for (SingleDetail singleDetail : payByIdList) {
					if(singleDetail.getMoney() == null && singleDetail.getPayMoney() != null) {
						singleDetail.setMoney(singleDetail.getPayMoney());
					}
					if(singleDetail.getPayDate()!=null && singleDetail.getDate() ==null) {
						singleDetail.setDate(singleDetail.getPayDate());
					}
				}
                singleDetailList.addAll(payByIdList);
            }catch (Exception e){
                logger.error("财务统计 付款详细信息查找失败"+e);
            }
        }
        if (!StringUtils.equals(param.get("reimburseMainId"),REPRSENT_NULL)){
            String[] reimburseMainIdString = param.get("reimburseMainId").split(";");
            try {
                List<SingleDetail> reimburseByIdList
                        = iFinReimburseAttachDao.findReimburseByIdList(Arrays.asList(reimburseMainIdString));
                singleDetailList.addAll(reimburseByIdList);
            }catch (Exception e){
                logger.error("财务统计 通用附表详细信息查找失败");
            }
        }
        //差旅的业务费和攻关费
        if (!StringUtils.equals(param.get("reimburseOrTravelMainId"),REPRSENT_NULL)){
        	 String[] reimburseOrTravelMainIdString = param.get("reimburseOrTravelMainId").split(";");
        	   try {
        	 List<SingleDetail> travelByIdList = iFinTravelreimburseAttachDao.findByTravelByIdList(Arrays.asList(reimburseOrTravelMainIdString));
        	 singleDetailList.addAll(travelByIdList);
        	   }catch (Exception e){
                   logger.error("财务统计 差旅的业务费和攻关费详细信息查找失败");
               }
        }
        if (!StringUtils.equals(param.get("travelMainId"),REPRSENT_NULL)){
            String[] travelMainIdString = param.get("travelMainId").split(";");
            try{
                List<SingleDetail> travelByIdList
                        = iFinTravelreimburseAttachDao.findByTravelByIdList(Arrays.asList(travelMainIdString));
                singleDetailList.addAll(travelByIdList);
            }catch (Exception e){
                logger.error("财务统计 差旅表附表详细信息查找失败");
            }
        }
        if (!StringUtils.equals(param.get("commonPayMainId"),REPRSENT_NULL)){
            String[] commonPayMainIdString = param.get("commonPayMainId").split(";");
            try{
                List<SingleDetail> commonPayByIdList
                        = iFinCommonPayAttachDao.findCommonPayByIdList(Arrays.asList(commonPayMainIdString));
                singleDetailList.addAll(commonPayByIdList);
            }catch (Exception e){
                logger.error("财务统计 常规付款附表详细信息查询失败");
            }
        }
        
        String title = "";
        if(!StringUtils.isEmpty(param.get("beginDate"))&&!StringUtils.isEmpty(param.get("endDate"))){
        	title = param.get("beginDate")+"至"+param.get("endDate")+param.get("title");
        }else{
        	title = param.get("title");
        }
        //导出
		try {
			ExportexcelUtil.expRptDataToExcel(response, this.getClass().getResource("doc/exportDetails.xls"), singleDetailList, title+"详情信息");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

    /**
     * 导出excel
     * @param out
     * @param paramMap
     */
    @Override
    public void exportExcel(ServletOutputStream out, Map<String, Object> paramMap){
//       String cc = java.net.URLDecoder.decode(aa,"UTF-8");
        //将页面的搜索信息放入statisticsFromPageDTO 方便调用 searchByStatistics
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("beginDate",paramMap.get("beginDate"));
        jsonObj.put("endDate", paramMap.get("endDate"));
        jsonObj.put("whetherSelectProject",paramMap.get("whetherSelectProject"));
        //由于调用searchByStatistics 方法，其中要对payCompany 进行取值判断 所以这里不能设置为 null
        if (paramMap.get("payCompany") != null && !paramMap.get("payCompany").equals("")) {
            jsonObj.put("payCompany", paramMap.get("payCompany"));
        }else {
            jsonObj.put("payCompany","");
        }
        jsonObj.put("deptId", paramMap.get("deptId"));
        jsonObj.put("investId", paramMap.get("investId"));
        jsonObj.put("projectId", paramMap.get("projectId"));
        jsonObj.put("userId", paramMap.get("userId"));
        jsonObj.put("generalReimbursType", paramMap.get("generalReimbursType"));
        jsonObj.put("status", paramMap.get("status"));
        try {
            if (paramMap.get("deptName") != null && !paramMap.get("deptName").equals("")){
                jsonObj.put("deptName", URLDecoder.decode(String.valueOf(paramMap.get("deptName")), "UTF-8"));
            }else {
                jsonObj.put("deptName", "");
            }
            if (paramMap.get("projectName") != null && !paramMap.get("projectName").equals("")){
                jsonObj.put("projectName", URLDecoder.decode(String.valueOf(paramMap.get("projectName")), "UTF-8"));
            }else {
                jsonObj.put("projectName", "");
            }
            if (paramMap.get("userName") != null && !paramMap.get("userName").equals("")){
                jsonObj.put("userName", URLDecoder.decode(String.valueOf(paramMap.get("userName")), "UTF-8"));
            }else {
                jsonObj.put("userName", "");
            }

        } catch (UnsupportedEncodingException e) {
            logger.error("财务统计 导出Excel时，中文转码错误"+e);
        }
        CrudResultDTO crudResultDTO = this.searchByStatistics(jsonObj);
        Map<String,Object>result = (Map<String, Object>) crudResultDTO.getResult();
        StatisticsFromPageDTO statisticsFromPageDTO = (StatisticsFromPageDTO) result.get(STATISTICS_SELECT_CONDITION);
        Context context = new Context();
        context.putVar("beginDate", paramMap.get("beginDate"));
        context.putVar("endDate", paramMap.get("endDate"));
        context.putVar("payCompany", paramMap.get("payCompany"));
        context.putVar("deptName", statisticsFromPageDTO.getDeptName());
        context.putVar("projectName", statisticsFromPageDTO.getCompanyName());
        context.putVar("userName", statisticsFromPageDTO.getUserName());

        context.putVar("dataList", result.get(PAYCOMBINATION));

        ExcelUtil.export("statisticsPay.xls", out, context);
    }
    /**
     * 导出excel --全部搜索字段
     * @param out
     * @param paramMap
     */
    @Override
    public void exportExcelOne(ServletOutputStream out, Map<String, Object> paramMap){
        Context context = new Context();
        SingleDetail singleDetail=new SingleDetail();
        if(paramMap.get("beginDate")!=null)
        singleDetail.setBeginDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", paramMap.get("beginDate")!=null?paramMap.get("beginDate").toString()+" 00:00:00":null));
        if(paramMap.get("endDate")!=null)
        singleDetail.setEndDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", paramMap.get("endDate")!=null?paramMap.get("endDate").toString()+" 23:59:59":null));
        singleDetail.setProjectName(paramMap.get("projectId")!=null?paramMap.get("projectId").toString():null);
        singleDetail.setTitle(paramMap.get("payCompany")!=null?paramMap.get("payCompany").toString():null);
        singleDetail.setDeptName(paramMap.get("deptId")!=null?paramMap.get("deptId").toString():null);
        singleDetail.setUserName(paramMap.get("userId")!=null?paramMap.get("userId").toString():null);
        if(paramMap.get("generalReimbursType")!=null){
        	if(paramMap.get("generalReimbursType").toString().equals("5"))
        		singleDetail.setTypeOne(0);
        	else if(paramMap.get("generalReimbursType").toString().equals("4"))
        		singleDetail.setTypeOne(1);
        	else if(paramMap.get("generalReimbursType").toString().equals("2"))
        		singleDetail.setTypeOne(3);
        	else if(paramMap.get("generalReimbursType").toString().equals("7"))
        		singleDetail.setTypeOne(4);
        	else 
        		singleDetail.setTypeOne(5);
        }
        if(paramMap.get("zBeginDate") != null && paramMap.get("zEndDate") != null) {
        	singleDetail.setActName("总经理");
    	}else if(paramMap.get("cBeginDate") != null && paramMap.get("cEndDate") != null) {
    		singleDetail.setActName("出纳");
    	}
        if(paramMap.get("zBeginDate") != null)
        	 singleDetail.setzBeginDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", paramMap.get("zBeginDate")!=null?paramMap.get("zBeginDate").toString()+" 00:00:00":null));
        if(paramMap.get("zEndDate") != null)
       	 singleDetail.setzEndDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", paramMap.get("zEndDate")!=null?paramMap.get("zEndDate").toString()+" 23:59:59":null));
        if(paramMap.get("cBeginDate") != null)
          	 singleDetail.setcBeginDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", paramMap.get("cBeginDate")!=null?paramMap.get("cBeginDate").toString()+" 00:00:00":null));
        if(paramMap.get("cEndDate") != null) {
        	singleDetail.setcEndDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", paramMap.get("cEndDate")!=null?paramMap.get("cEndDate").toString()+" 23:59:59":null));
        	String gBeginDate=paramMap.get("cEndDate").toString();
    		gBeginDate=gBeginDate.substring(0, 7)+"-01";
    		 singleDetail.setgBeginDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", gBeginDate+" 00:00:00"));
    		 singleDetail.setgEndDate(DateUtils.strToDate("yyyy-MM-dd HH:mm:ss", paramMap.get("cEndDate")!=null?paramMap.get("cEndDate").toString()+" 23:59:59":null));
        }
        singleDetail.setType(paramMap.get("generalReimbursType")!=null?paramMap.get("generalReimbursType").toString():null);
        singleDetail.setValueName(paramMap.get("investId")!=null?paramMap.get("investId").toString():null);
        if(paramMap.get("status")!=null && paramMap.get("status").equals("10")){
        	singleDetail.setStatusName1("10");
        	if(paramMap.get("zBeginDate") != null && paramMap.get("zEndDate") != null) {
        		singleDetail.setStatusName("4");
        	}else if(paramMap.get("cBeginDate") != null && paramMap.get("cEndDate") != null) {
        		singleDetail.setStatusName("5");
        	}
        }else
        	singleDetail.setStatusName(paramMap.get("status")!=null?paramMap.get("status").toString():null);
        List<SingleDetail> singleDetails=iFinPayDao.findStatisticsList(singleDetail);
        context.putVar("dataList", singleDetails);  
        ExcelUtil.export("statisticsPayOne.xls", out, context);
    }
}


