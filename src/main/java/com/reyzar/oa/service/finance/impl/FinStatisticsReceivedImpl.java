package com.reyzar.oa.service.finance.impl;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.ExportexcelUtil;
import com.reyzar.oa.common.util.StringUtils;
import com.reyzar.oa.dao.*;
import com.reyzar.oa.domain.*;
import com.reyzar.oa.service.finance.IFinStatisticsReceivedService;
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

@Service
public class FinStatisticsReceivedImpl implements IFinStatisticsReceivedService {
    private final Logger logger = Logger.getLogger(FinStatisticsReceivedImpl.class);
    //数据字典里睿哲公司type_id的值
    private static final int COMPANY_TYPE_ID_VALUE=17;
    //数据字典里收款类型type_id的值
    private static final int COST_TYPE_ID=72;
    //页面信息
    private static final String STATISTICS_SELECT_CONDITION="statisticsSelectCondition";
    //收款
    private static final String RECEIVEDCOMBINATION="received_combination";
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
    //常规收款
    @Autowired
    IFinCommonReceivedAttachDao iFinCommonReceivedAttachDao;
    //收款表
    @Autowired
    IFinCollectionAttachDao iFinCollectionAttachDao;
    //部门
    @Autowired
    ISysDeptDao iSysDeptDao;
    //数据字典表
    @Autowired
    ISysDictDataDao iSysDictDataDao;
    //项目
    @Autowired
    ISaleProjectManageDao iSaleProjectManageDao;
    @Override
    public CrudResultDTO  searchByStatistics(JSONObject json) {
        // 从页面获取的搜索条件
        StatisticsFromPageDTO statisticsFromPageDTO = json.toJavaObject(StatisticsFromPageDTO.class);
        Map<String, Object> sumMap = Maps.newHashMap();
        //向前端标记 是按照 项目分类 还是 类型分类
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getWhetherSelectProject())){
            sumMap=sumByProject(statisticsFromPageDTO);
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
    @Override
    public Map<String,Object> sumByType(StatisticsFromPageDTO statisticsFromPageDTO){
        //存放返回页面的数据
        Map<String,Object> statisticsDTOMap=new HashMap<String, Object>();
        //将收款的表综合起来
        Set<String> generalSet=Sets.newHashSet();
        //公司名称
        String compayName="";
        if (statisticsFromPageDTO.getPayCompany()!=null&&!statisticsFromPageDTO.getPayCompany().equals("")) {
            SysDictData sysDictData
                    = iSysDictDataDao.findByValueAndTypeidNotDelet(
                    Integer.valueOf(statisticsFromPageDTO.getPayCompany()), COMPANY_TYPE_ID_VALUE);
            compayName=sysDictData.getName();
        }
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getUserName())
                ||StringUtils.isNotBlank(statisticsFromPageDTO.getStatus())){
            //个人，状态只计算收款表和
            //收款计算
            Map<String,Object> collectionMap=this.collectionCount(statisticsFromPageDTO);
            generalSet.addAll((Collection<? extends String>) collectionMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList =Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty()&&generalIdList.size()>0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, COST_TYPE_ID);
                }
            }catch (Exception e){
                logger.error("财务统计(收款) 查找付款类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList=Lists.newArrayList();
            for (SysDictData dictDataItem : generalList){
                //判断当前general是否在 collection(收款)中
                StatisticsFromPageDTO staCollection = new StatisticsFromPageDTO();
                judgeTheCollectionOwnType(collectionMap, dictDataItem, staCollection);
                StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                payCombination.setType(dictDataItem.getValue());
                payCombination.setTypeName(dictDataItem.getName());
                //判断该条记录是否是有效值，并进行数值的累加
                judgeTheCollectionEffectiveValue(staCollection, payCombination);
                if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00) {
                    payCombinationList.add(payCombination);
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOMap.put(STATISTICS_SELECT_CONDITION,statisticsFromPageDTO);
            statisticsDTOMap.put(RECEIVEDCOMBINATION,payCombinationList);
            return statisticsDTOMap;
        }else {
            //计算常规收款表，收款表
            //常规收款计算
            Map<String,Object> commonReceivedMap=this.commonReceivedCount(statisticsFromPageDTO);
            //收款计算
            Map<String,Object> collectionMap=this.collectionCount(statisticsFromPageDTO);
            generalSet.addAll((Collection<? extends String>) commonReceivedMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) collectionMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList =Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty()&&generalIdList.size()>0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, COST_TYPE_ID);
                }
            }catch (Exception e){
                logger.error("财务统计(收款) 查找付款类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList=Lists.newArrayList();
            for (SysDictData dictDataItem : generalList) {
                //判断当前general是否在 commonReceived中
                StatisticsFromPageDTO staCommonReceived = new StatisticsFromPageDTO();
                judgeTheCommonReceivedOwnType(commonReceivedMap, dictDataItem, staCommonReceived);
                //判断当前general是否在 collection中
                StatisticsFromPageDTO staCollection = new StatisticsFromPageDTO();
                judgeTheCollectionOwnType(collectionMap, dictDataItem, staCollection);
                StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                payCombination.setType(dictDataItem.getValue());
                payCombination.setTypeName(dictDataItem.getName());
                //判断有效值，进行数值的累加
                judgeTheCommonReceivedEffectiveValue(staCommonReceived, payCombination);
                judgeTheCollectionEffectiveValue(staCollection, payCombination);
                if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00) {
                    payCombinationList.add(payCombination);
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOMap.put(STATISTICS_SELECT_CONDITION,statisticsFromPageDTO);
            statisticsDTOMap.put(RECEIVEDCOMBINATION,payCombinationList);
            return statisticsDTOMap;
        }
    }
    /**
     * 判断常规收款是否有有效值添加进返回类型，并累加数值
     * @param staCommonReceived
     * @param payCombination
     */
    private void judgeTheCommonReceivedEffectiveValue(StatisticsFromPageDTO staCommonReceived,
                                                        StatisticsFromPageDTO payCombination) {
        if (StringUtils.isNotBlank(staCommonReceived.getCostProperty())) {
            payCombination.setCommonReceivedMainId(staCommonReceived.getCommonReceivedMainId());
            if (payCombination.getMoney() != null) {
                Double money = payCombination.getMoney() + staCommonReceived.getMoney();
                payCombination.setMoney(money);
            } else {
                payCombination.setMoney(staCommonReceived.getMoney());
            }
        }
    }
    /**
     * 判断类型是不是在常规收款表中
     * @param commonReceivedMap
     * @param dictDataItem
     * @param staCommonReceived
     */
    private void judgeTheCommonReceivedOwnType(Map<String, Object> commonReceivedMap,
                                                SysDictData dictDataItem, StatisticsFromPageDTO staCommonReceived) {
        for (StatisticsFromPageDTO commonReceivedItem :
                (Collection<? extends StatisticsFromPageDTO>) commonReceivedMap.get(CONTENT_OF_FORM)) {
            if (StringUtils.equals(commonReceivedItem.getCostProperty(), dictDataItem.getValue())) {
                staCommonReceived.setCommonReceivedMainId(commonReceivedItem.getCommonReceivedMainId());
                staCommonReceived.setCostProperty(dictDataItem.getValue());
                staCommonReceived.setMoney(commonReceivedItem.getMoney());
                break;
            }
        }
    }
    /**
     * 判断收款是否有有效值添加进返回类型，并累加数值
     * @param staCollection
     * @param payCombination
     */
    private void judgeTheCollectionEffectiveValue(StatisticsFromPageDTO staCollection,
                                                    StatisticsFromPageDTO payCombination) {
        if (StringUtils.isNotBlank(staCollection.getCostProperty())){
            payCombination.setCollectionMainId(staCollection.getCollectionMainId());
            if (payCombination.getMoney() != null){
                Double money = payCombination.getMoney() + staCollection.getMoney();
                payCombination.setMoney(money);
            }else {
                payCombination.setMoney(staCollection.getMoney());
            }
        }
    }
    /**
     * 判断类型是不是在收款表中
     * @param collectionMap
     * @param dictDataItem
     * @param staCollection
     */
    private void judgeTheCollectionOwnType(Map<String, Object> collectionMap,
                                            SysDictData dictDataItem, StatisticsFromPageDTO staCollection) {
        for (StatisticsFromPageDTO collectionItem:
                (Collection<? extends StatisticsFromPageDTO>)collectionMap.get(CONTENT_OF_FORM)) {
            if (StringUtils.equals(collectionItem.getCostProperty(),dictDataItem.getValue())){
                staCollection.setCollectionMainId(collectionItem.getCollectionMainId());
                staCollection.setCostProperty(dictDataItem.getValue());
                staCollection.setMoney(collectionItem.getMoney());
                break;
            }
        }
    }
    /**
     * 根据 项目 返回页面
     * @param statisticsFromPageDTO
     * @return
     */
    @Override
    public Map<String,Object> sumByProject(StatisticsFromPageDTO statisticsFromPageDTO){
        //存放返回页面的数据
        Map<String,Object> statisticsDTOMap=new HashMap<String, Object>();
        //获取公司名称
        String compayName="";
        if (statisticsFromPageDTO.getPayCompany()!=null&&!statisticsFromPageDTO.getPayCompany().equals("")) {
            SysDictData sysDictData
                    = iSysDictDataDao.findByValueAndTypeidNotDelet(
                    Integer.valueOf(statisticsFromPageDTO.getPayCompany()), COMPANY_TYPE_ID_VALUE);
            compayName=sysDictData.getName();
        }
        Set<Integer> projectIdSet= Sets.newHashSet();
        Set<String> generalSet=Sets.newHashSet();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getUserName())
                ||StringUtils.isNotBlank(statisticsFromPageDTO.getStatus())){
            //个人，状态，只算收款表
            //收款计算
            Map<String,Object> collectionMap=this.collectionCount(statisticsFromPageDTO);
            projectIdSet.addAll((Collection<? extends Integer>) collectionMap.get(PROJECT_ID_SET));
            List<Integer> projectIdList = Lists.newArrayList();
            projectIdList.addAll(projectIdSet);
            List<SaleProjectManage> projectList=Lists.newArrayList();
            try {
                if (!projectIdList.isEmpty()&&projectIdList.size()>0) {
                    projectList = iSaleProjectManageDao.findByIdList(projectIdList);
                }
            }catch (Exception e){
                logger.error("财务统计(收款) 查找项目名称失败"+e);
            }
            generalSet.addAll((Collection<? extends String>) collectionMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList =Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty()&&generalIdList.size()>0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, COST_TYPE_ID);
                }
            }catch (Exception e){
                logger.error("财务统计(收款) 查找付款类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList=Lists.newArrayList();
            for (SaleProjectManage projectItem:projectList) {
                for (SysDictData dictDataItem : generalList) {
                    //判断当前projectId general是否在 collection中
                    StatisticsFromPageDTO staCollection=new StatisticsFromPageDTO();
                    judgeTheCollectionOwnTheTypeAndProject(collectionMap, projectItem, dictDataItem, staCollection);
                    StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                    payCombination.setProjectId(projectItem.getId());
                    payCombination.setProjectName(projectItem.getName());
                    payCombination.setType(dictDataItem.getValue());
                    payCombination.setTypeName(dictDataItem.getName());
                    //判断收款表
                    judgeTheCollectionEffectiveValue(staCollection, payCombination);
                    if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00) {
                        payCombinationList.add(payCombination);
                    }
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOMap.put(STATISTICS_SELECT_CONDITION,statisticsFromPageDTO);
            statisticsDTOMap.put(RECEIVEDCOMBINATION,payCombinationList);
            return statisticsDTOMap;
        }else {
            //计算常规收款，收款
            //常规收款计算
            Map<String,Object> commonReceivedMap=this.commonReceivedCount(statisticsFromPageDTO);
            //收款计算
            Map<String,Object> collectionMap=this.collectionCount(statisticsFromPageDTO);
            //将收款的表综合起来
            projectIdSet.addAll((Collection<? extends Integer>) commonReceivedMap.get(PROJECT_ID_SET));
            projectIdSet.addAll((Collection<? extends Integer>) collectionMap.get(PROJECT_ID_SET));
            List<Integer> projectIdList = Lists.newArrayList();
            projectIdList.addAll(projectIdSet);
            List<SaleProjectManage> projectList=Lists.newArrayList();
            try {
                if (!projectIdList.isEmpty()&&projectIdList.size()>0) {
                    projectList = iSaleProjectManageDao.findByIdList(projectIdList);
                }
            }catch (Exception e){
                logger.error("财务统计(收款) 查找项目名称失败"+e);
            }
            generalSet.addAll((Collection<? extends String>) commonReceivedMap.get(GENERAL_ID_SET));
            generalSet.addAll((Collection<? extends String>) collectionMap.get(GENERAL_ID_SET));
            List<String> generalIdList = Lists.newArrayList();
            generalIdList.addAll(generalSet);
            List<SysDictData> generalList =Lists.newArrayList();
            try{
                if (!generalIdList.isEmpty()&&generalIdList.size()>0) {
                    generalList = iSysDictDataDao.findByValueAndTypeidNotDeletList(generalIdList, COST_TYPE_ID);
                }
            }catch (Exception e){
                logger.error("财务统计(收款) 查找付款类型名称失败"+e);
            }
            List<StatisticsFromPageDTO> payCombinationList=Lists.newArrayList();
            for (SaleProjectManage projectItem:projectList) {
                for (SysDictData dictDataItem : generalList) {
                    //判断当前projectId  general是否在 commonReceived中
                    StatisticsFromPageDTO staCommonReceived = new StatisticsFromPageDTO();
                    judgeTheCommonReceivedOwnTheTypeAndProject(commonReceivedMap, projectItem, dictDataItem, staCommonReceived);
                    //判断当前projectId general是否在 collection中
                    StatisticsFromPageDTO staCollection=new StatisticsFromPageDTO();
                    judgeTheCollectionOwnTheTypeAndProject(collectionMap, projectItem, dictDataItem, staCollection);
                    StatisticsFromPageDTO payCombination = new StatisticsFromPageDTO();
                    payCombination.setProjectId(projectItem.getId());
                    payCombination.setProjectName(projectItem.getName());
                    payCombination.setType(dictDataItem.getValue());
                    payCombination.setTypeName(dictDataItem.getName());
                    //判断常规收款表
                    judgeTheCommonReceivedEffectiveValue(staCommonReceived, payCombination);
                    //判断收款表
                    judgeTheCollectionEffectiveValue(staCollection, payCombination);
                    if (payCombination.getMoney() != null && payCombination.getMoney() > 0.00) {
                        payCombinationList.add(payCombination);
                    }
                }
            }
            statisticsFromPageDTO.setCompanyName(compayName);
            statisticsDTOMap.put(STATISTICS_SELECT_CONDITION,statisticsFromPageDTO);
            statisticsDTOMap.put(RECEIVEDCOMBINATION,payCombinationList);
            return statisticsDTOMap;
        }
    }

    /**
     * 判断类型和项目是否在收款中
     * @param collectionMap
     * @param projectItem
     * @param dictDataItem
     * @param staCollection
     */
    private void judgeTheCollectionOwnTheTypeAndProject(Map<String, Object> collectionMap, SaleProjectManage projectItem, SysDictData dictDataItem, StatisticsFromPageDTO staCollection) {
        for (StatisticsFromPageDTO collectionItem:
                (Collection<? extends StatisticsFromPageDTO>) collectionMap.get(CONTENT_OF_FORM)) {
            if (collectionItem.getProjectId().equals(projectItem.getId())
                    && StringUtils.equals(collectionItem.getCostProperty(),dictDataItem.getValue())){
                staCollection.setCollectionMainId(collectionItem.getCollectionMainId());
                staCollection.setCostProperty(dictDataItem.getValue());
                staCollection.setProjectId(projectItem.getId());
                staCollection.setMoney(collectionItem.getMoney());
                break;
            }
        }
    }
    /**
     * 判断类型和项目是否在常规收款中
     * @param commonReceivedMap
     * @param projectItem
     * @param dictDataItem
     * @param staCommonReceived
     */
    private void judgeTheCommonReceivedOwnTheTypeAndProject(Map<String, Object> commonReceivedMap, SaleProjectManage projectItem, SysDictData dictDataItem, StatisticsFromPageDTO staCommonReceived) {
        for (StatisticsFromPageDTO commonReceivedItem :
                (Collection<? extends StatisticsFromPageDTO>) commonReceivedMap.get(CONTENT_OF_FORM)) {
            if (commonReceivedItem.getProjectId().equals(projectItem.getId())
                    && StringUtils.equals(commonReceivedItem.getCostProperty(), dictDataItem.getValue())) {
                staCommonReceived.setCommonReceivedMainId(commonReceivedItem.getCommonReceivedMainId());
                staCommonReceived.setCostProperty(dictDataItem.getValue());
                staCommonReceived.setProjectId(projectItem.getId());
                staCommonReceived.setMoney(commonReceivedItem.getMoney());
                break;
            }
        }
    }
    /**
     * 常规收款查找
     * projectId(项目Id);costProperty（收入性质）;
     * payCompany(公司value)收款所属单位;
     * BeginDate(开始时间); EndDate(结束时间);
     * 返回 money
     */
    @Override
    public Map<String,Object> commonReceivedCount(StatisticsFromPageDTO statisticsFromPageDTO) {
        List<FinCommonReceivedAttach> commonReceivedAttachList= Lists.newArrayList();
        try{
            commonReceivedAttachList=iFinCommonReceivedAttachDao.findByStatistics(statisticsFromPageDTO);
        }catch (Exception e){
            logger.error("财务统计 常规收款查找失败"+e);
        }
        Map<String,Object> commonReceivedMap= Maps.newHashMap();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getWhetherSelectProject())){
            commonReceivedMap = getCommonReceivedByProject(commonReceivedAttachList);
        }else {
            commonReceivedMap = getCommonReceivedByType(commonReceivedAttachList);
        }
        return commonReceivedMap;
    }

    /**
     * 根据 类别 返回常规收款
     * @param commonReceivedAttachList
     * @return
     */
    public Map<String,Object> getCommonReceivedByType(List<FinCommonReceivedAttach> commonReceivedAttachList){
        Set<Integer> costPropertySet = Sets.newHashSet();
        for (FinCommonReceivedAttach attachItem:commonReceivedAttachList) {
            costPropertySet.add(Integer.valueOf(attachItem.getCostProperty()));
        }
        List<StatisticsFromPageDTO> costPropertyList= Lists.newArrayList();
        for (Integer costProperty:costPropertySet) {
            StatisticsFromPageDTO staCommonReceivedAttach=new StatisticsFromPageDTO();
            Double receivedAttachCountMoney=0.00;
            Set<String> mainId=Sets.newHashSet();
            Set<String> projectName=Sets.newHashSet();
            for (FinCommonReceivedAttach attachItem:commonReceivedAttachList) {
                //判断收款类型 和 项目ID
                if (StringUtils.equals(attachItem.getCostProperty(),String.valueOf(costProperty))){
                    if (StringUtils.isNotBlank(attachItem.getMoney())){
                        receivedAttachCountMoney+=Double.valueOf(attachItem.getMoney());
                        //将主表主键放入集合中
                        mainId.add(String.valueOf(attachItem.getId()));
                        projectName.add(attachItem.getProjectManage().getName());
                    }
                }
            }
            if (receivedAttachCountMoney>0.00){
                staCommonReceivedAttach.setCommonReceivedMainId(StringUtils.join(mainId.toArray(),";"));
                staCommonReceivedAttach.setProjectName(StringUtils.join(projectName.toArray()));
                staCommonReceivedAttach.setCostProperty(String.valueOf(costProperty));
                staCommonReceivedAttach.setMoney(receivedAttachCountMoney);
                costPropertyList.add(staCommonReceivedAttach);
            }
        }
        Map<String,Object> commonReceivedMap= Maps.newHashMap();
        commonReceivedMap.put(GENERAL_ID_SET,costPropertySet);
        commonReceivedMap.put(CONTENT_OF_FORM,costPropertyList);
        return commonReceivedMap;
    }
    /**
     * 根据 项目 返回常规收款
     * @param commonReceivedAttachList
     * @return
     */
    public Map<String,Object> getCommonReceivedByProject(List<FinCommonReceivedAttach> commonReceivedAttachList) {
        //将有有效值的项目ID 和 付款类型的ID 分别放入两个set中
        Set<Integer> projectIdReceivedSet = Sets.newHashSet();
        Set<Integer> costPropertySet = Sets.newHashSet();
        for (FinCommonReceivedAttach attachItem:commonReceivedAttachList) {
            projectIdReceivedSet.add(attachItem.getProjectManageId());
            costPropertySet.add(Integer.valueOf(attachItem.getCostProperty()));
        }
        List<StatisticsFromPageDTO> costPropertyList= Lists.newArrayList();
        for (Integer projectId:projectIdReceivedSet) {
            for (Integer costProperty:costPropertySet) {
                StatisticsFromPageDTO staCommonReceivedAttach=new StatisticsFromPageDTO();
                Double receivedAttachCountMoney=0.00;
                Set<String> mainId=Sets.newHashSet();
                Set<String> projectName=Sets.newHashSet();
                for (FinCommonReceivedAttach attachItem:commonReceivedAttachList) {
                    //判断收款类型 和 项目ID
                    if (StringUtils.equals(attachItem.getCostProperty(),String.valueOf(costProperty))
                            && attachItem.getProjectManageId().equals(projectId)){
                        if (StringUtils.isNotBlank(attachItem.getMoney())){
                            receivedAttachCountMoney+=Double.valueOf(attachItem.getMoney());
                            //将主表主键放入集合中
                            mainId.add(String.valueOf(attachItem.getId()));
                            projectName.add(attachItem.getProjectManage().getName());
                        }
                    }
                }
                if (receivedAttachCountMoney>0.00){
                    staCommonReceivedAttach.setCommonReceivedMainId(StringUtils.join(mainId.toArray(),";"));
                    staCommonReceivedAttach.setProjectId(projectId);
                    staCommonReceivedAttach.setProjectName(StringUtils.join(projectName.toArray()));
                    staCommonReceivedAttach.setCostProperty(String.valueOf(costProperty));
                    staCommonReceivedAttach.setMoney(receivedAttachCountMoney);
                    costPropertyList.add(staCommonReceivedAttach);
                }
            }
        }
        Map<String,Object> commonReceivedMap= Maps.newHashMap();
        commonReceivedMap.put(PROJECT_ID_SET,projectIdReceivedSet);
        commonReceivedMap.put(GENERAL_ID_SET,costPropertySet);
        commonReceivedMap.put(CONTENT_OF_FORM,costPropertyList);
        return commonReceivedMap;
    }

    /**
     * 收款查找
     * projectId(项目id);costProperty（收入性质）;
     * payCompany(公司value)收款所属单位;
     * attach.collection_date(收款时间)；
     * collection_bill(收款金额)
     * BeginDate(开始时间); EndDate(结束时间);
     * @param statisticsFromPageDTO
     * @return
     */
    public Map<String,Object> collectionCount(StatisticsFromPageDTO statisticsFromPageDTO){
        List<FinCollectionAttach> collectionAttachList=Lists.newArrayList();
        try{
            collectionAttachList=iFinCollectionAttachDao.findByStatistics(statisticsFromPageDTO);
        }catch (Exception e){
            logger.error("财务统计 收款表查找失败"+e);
        }
        Map<String,Object> collectionMap = Maps.newHashMap();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getWhetherSelectProject())){
            collectionMap=getCollectionByProject(collectionAttachList);
        }else {
            collectionMap=getCollectionByType(collectionAttachList);
        }
        return collectionMap;
    }
    /**
     * 根据 项目 返回 收款
     * @param collectionList
     * @return
     */
    public Map<String,Object> getCollectionByProject(List<FinCollectionAttach> collectionList){
        //将有有效值的项目ID 和 付款类型的ID 分别放入两个set 中
        Set<Integer> projectIdCollectionSet = Sets.newHashSet();
        Set<String> costPropertySet = Sets.newHashSet();
        for (FinCollectionAttach collectionAttachItem:collectionList) {
            projectIdCollectionSet.add(collectionAttachItem.getFinCollection().getProjectId());
            costPropertySet.add(collectionAttachItem.getFinCollection().getCollectionType());
        }
        List<StatisticsFromPageDTO> costPropertyList= Lists.newArrayList();
        for (Integer projectId:projectIdCollectionSet) {
            for (String costProperty:costPropertySet) {
                StatisticsFromPageDTO staCollectionAttach=new StatisticsFromPageDTO();
                Double collectionCountMoney=0.00;
                Set<String> mainId=Sets.newHashSet();
                Set<String> projectName=Sets.newHashSet();
                for (FinCollectionAttach collectionAttachItem:collectionList) {
                    //判断收款类型 和 项目ID
                    if (StringUtils.equals(collectionAttachItem.getFinCollection().getCollectionType(),String.valueOf(costProperty))
                            && collectionAttachItem.getFinCollection().getProjectId().equals(projectId)){
                        if (collectionAttachItem.getCollectionBill()>0&&collectionAttachItem.getCollectionBill()!=null){
                            collectionCountMoney+=Double.valueOf(collectionAttachItem.getCollectionBill());
                            //将主表主键放入集合中
                            mainId.add(String.valueOf(collectionAttachItem.getId()));
                            projectName.add(collectionAttachItem.getProjectManage().getName());
                        }
                    }
                }
                if (collectionCountMoney>0.00){
                    staCollectionAttach.setCollectionMainId(StringUtils.join(mainId.toArray(),";"));
                    staCollectionAttach.setProjectId(projectId);
                    staCollectionAttach.setProjectName(StringUtils.join(projectName.toArray()));
                    staCollectionAttach.setCostProperty(String.valueOf(costProperty));
                    staCollectionAttach.setMoney(collectionCountMoney);
                    costPropertyList.add(staCollectionAttach);
                }
            }
        }
        Map<String,Object> collectionMap= Maps.newHashMap();
        collectionMap.put(PROJECT_ID_SET,projectIdCollectionSet);
        collectionMap.put(GENERAL_ID_SET,costPropertySet);
        collectionMap.put(CONTENT_OF_FORM,costPropertyList);
        return collectionMap;
    }

    /**
     * 根据 类型 返回 收款
     * @param collectionList
     * @return
     */
    public Map<String,Object> getCollectionByType(List<FinCollectionAttach> collectionList){
        Set<Integer> costPropertySet = Sets.newHashSet();
        for (FinCollectionAttach collectionAttachItem:collectionList) {
            costPropertySet.add(Integer.valueOf(collectionAttachItem.getFinCollection().getCollectionType()));
        }
        List<StatisticsFromPageDTO> costPropertyList= Lists.newArrayList();
        for (Integer costProperty:costPropertySet) {
            StatisticsFromPageDTO staCollectionAttach=new StatisticsFromPageDTO();
            Double collectionCountMoney=0.00;
            Set<String> mainId=Sets.newHashSet();
            Set<String> projectName=Sets.newHashSet();
            for (FinCollectionAttach collectionAttachItem:collectionList) {
                //判断收款类型 和 项目ID
                if (StringUtils.equals(collectionAttachItem.getFinCollection().getCollectionType(),String.valueOf(costProperty))){
                    if (collectionAttachItem.getCollectionBill()>0&&collectionAttachItem.getCollectionBill()!=null){
                        collectionCountMoney+=Double.valueOf(collectionAttachItem.getCollectionBill());
                        //将主表主键放入集合中
                        mainId.add(String.valueOf(collectionAttachItem.getId()));
                        projectName.add(collectionAttachItem.getProjectManage().getName());
                    }
                }
            }
            if (collectionCountMoney>0.00){
                staCollectionAttach.setCollectionMainId(StringUtils.join(mainId.toArray(),";"));
                staCollectionAttach.setProjectName(StringUtils.join(projectName.toArray()));
                staCollectionAttach.setCostProperty(String.valueOf(costProperty));
                staCollectionAttach.setMoney(collectionCountMoney);
                costPropertyList.add(staCollectionAttach);
            }
        }
        Map<String,Object> collectionMap= Maps.newHashMap();
        collectionMap.put(GENERAL_ID_SET,costPropertySet);
        collectionMap.put(CONTENT_OF_FORM,costPropertyList);
        return collectionMap;
    }
    /**
     * 单条记录详细查询
     * @param statisticsFromPageDTO
     * @return
     */
    @Override
    public CrudResultDTO singleDetail(StatisticsFromPageDTO statisticsFromPageDTO) {
        List<SingleDetail> singleDetailList=Lists.newArrayList();
        if (!StringUtils.equals(statisticsFromPageDTO.getCommonReceivedMainId(),REPRSENT_NULL)){
            String[] commonReceivedMainId=statisticsFromPageDTO.getCommonReceivedMainId().split(";");
            try {
                List<SingleDetail> commonReceivedByIdList
                        = iFinCommonReceivedAttachDao.findCommonReceivedByIdList(Arrays.asList(commonReceivedMainId));
                singleDetailList.addAll(commonReceivedByIdList);
            }catch (Exception e){
                logger.error("财务统计(收款) 常规收款附表查找失败");
            }
        }
        if (!StringUtils.equals(statisticsFromPageDTO.getCollectionMainId(),REPRSENT_NULL)){
            String[] collectionMainId=statisticsFromPageDTO.getCollectionMainId().split(";");
            try {
                List<SingleDetail> collectionByIdList
                        = iFinCollectionAttachDao.findCollectionByIdList(Arrays.asList(collectionMainId));
                singleDetailList.addAll(collectionByIdList);
            }catch (Exception e){
                logger.error("财务统计(收款)  收款附表查找失败");
            }
        }
        Map<String,Object> singleDetailMap=Maps.newHashMap();
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getProjectName())){
            singleDetailMap.put(SINGLE_DETAIL_PROJECT_NAME,statisticsFromPageDTO.getProjectName());
        }
        if (StringUtils.isNotBlank(statisticsFromPageDTO.getTypeName())){
            singleDetailMap.put(SINGLE_DETAIL_TYPE_NAME,statisticsFromPageDTO.getTypeName());
        }
        singleDetailMap.put(CONTENT_OF_FORM,singleDetailList);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,singleDetailMap);
        return result;
    }
    
	@Override
	public void exportDetails(HttpServletRequest request, HttpServletResponse response, Map<String, String> param) {
		List<SingleDetail> singleDetailList=Lists.newArrayList();
        if (!StringUtils.equals(param.get("commonReceivedMainId"),REPRSENT_NULL)){
            String[] commonReceivedMainId=param.get("commonReceivedMainId").split(";");
            try {
                List<SingleDetail> commonReceivedByIdList
                        = iFinCommonReceivedAttachDao.findCommonReceivedByIdList(Arrays.asList(commonReceivedMainId));
                singleDetailList.addAll(commonReceivedByIdList);
            }catch (Exception e){
                logger.error("财务统计(收款) 常规收款附表查找失败");
            }
        }
        if (!StringUtils.equals(param.get("collectionMainId"),REPRSENT_NULL)){
            String[] collectionMainId=param.get("collectionMainId").split(";");
            try {
                List<SingleDetail> collectionByIdList
                        = iFinCollectionAttachDao.findCollectionByIdList(Arrays.asList(collectionMainId));
                singleDetailList.addAll(collectionByIdList);
            }catch (Exception e){
                logger.error("财务统计(收款)  收款附表查找失败");
            }
        }
        String title="";
        if(!StringUtils.isEmpty(param.get("beginDate"))&&!StringUtils.isEmpty(param.get("endDate"))){
        	title=param.get("beginDate")+"至"+param.get("endDate")+param.get("typeName");
        }else{
        	title=param.get("typeName");
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
        if (paramMap.get("payCompany")!=null&&!paramMap.get("payCompany").equals("")) {
            jsonObj.put("payCompany", paramMap.get("payCompany"));
        }else {
            jsonObj.put("payCompany","");
        }
        jsonObj.put("deptId",paramMap.get("deptId"));
        jsonObj.put("investId",paramMap.get("investId"));
        jsonObj.put("projectId",paramMap.get("projectId"));
        jsonObj.put("userId",paramMap.get("userId"));
        jsonObj.put("costProperty", paramMap.get("costProperty"));
        try {
            if (paramMap.get("deptName")!=null&&!paramMap.get("deptName").equals("")){
                jsonObj.put("deptName", URLDecoder.decode(String.valueOf(paramMap.get("deptName")),"UTF-8"));
            }else {
                jsonObj.put("deptName","");
            }
            if (paramMap.get("projectName")!=null&&!paramMap.get("projectName").equals("")){
                jsonObj.put("projectName",URLDecoder.decode(String.valueOf(paramMap.get("projectName")),"UTF-8"));
            }else {
                jsonObj.put("projectName","");
            }
            if (paramMap.get("userName")!=null&&!paramMap.get("userName").equals("")){
                jsonObj.put("userName",URLDecoder.decode(String.valueOf(paramMap.get("userName")),"UTF-8"));
            }else {
                jsonObj.put("userName","");
            }
        } catch (UnsupportedEncodingException e) {
            logger.error("财务统计 导出Excel时，中文转码错误"+e);
        }
        CrudResultDTO crudResultDTO = this.searchByStatistics(jsonObj);
        Map<String,Object>result= (Map<String, Object>) crudResultDTO.getResult();
        StatisticsFromPageDTO statisticsFromPageDTO= (StatisticsFromPageDTO) result.get(STATISTICS_SELECT_CONDITION);
        Context context =new Context();
        context.putVar("beginDate",paramMap.get("beginDate"));
        context.putVar("endDate",paramMap.get("endDate"));
        context.putVar("payCompany",paramMap.get("payCompany"));
        context.putVar("deptName",statisticsFromPageDTO.getDeptName());
        context.putVar("projectName",statisticsFromPageDTO.getCompanyName());
        context.putVar("userName",statisticsFromPageDTO.getUserName());


        context.putVar("dataList",result.get(RECEIVEDCOMBINATION));

        ExcelUtil.export("statisticsPay.xls", out, context);
    }
}
