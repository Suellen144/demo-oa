package com.reyzar.oa.service.finance.impl;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dto.BarginProfitDTO;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.dto.StatiscsBarginOtherDTO;
import com.reyzar.oa.common.dto.StatisticsBarginDTO;
import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.common.util.ExcelUtil;
import com.reyzar.oa.common.util.ExportexcelUtil;
import com.reyzar.oa.common.util.StringUtils;
import com.reyzar.oa.dao.IFinCommonPayAttachDao;
import com.reyzar.oa.dao.IFinCommonReceivedAttachDao;
import com.reyzar.oa.dao.IFinPayAttachDao;
import com.reyzar.oa.dao.IFinReimburseAttachDao;
import com.reyzar.oa.dao.IFinTravelreimburseAttachDao;
import com.reyzar.oa.dao.ISaleBarginManageDao;
import com.reyzar.oa.dao.ISaleProjectManageDao;
import com.reyzar.oa.dao.ISysDictDataDao;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinPay;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.SaleProjectManage;
import com.reyzar.oa.domain.SingleDetail;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.service.finance.IFinStatisticsBarginService;
import org.apache.log4j.Logger;
import org.jxls.common.Context;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;


@Service
public class FinStatisticsBarginServiceImpl implements IFinStatisticsBarginService {
	
    private final Logger logger = Logger.getLogger(FinStatisticsBarginServiceImpl.class);
    
    //表的内容
    private static final String CONTENT_OF_FORM="contentOfForm";

    //Map的内容
    private static final String MAP_CONTENT = "mapContent";
    
    //projectIdSet 集合
    private static final String MAP_PROJECTID_SET = "mapProjectIdSet";
    
    //页面穿回来的字符串为"0" 就代表为空
    private static final String REPRSENT_NULL="0";
    
    @Autowired
    ISaleBarginManageDao iSaleBarginManageDao;
    @Autowired
    ISaleProjectManageDao projectDao;
    @Autowired
    ISysDictDataDao sysDictDataDao;
    
    //付款附表
    @Autowired
    IFinPayAttachDao iFinPayAttachDao;
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
    
    /**
     * 根据页面选择的信息，进行查找(其他合同：劳动合同、合作协议、通讯录)
     * @param json
     * @return
     */
    @Override
    public CrudResultDTO searchByStatistics(JSONObject json) {
        // 从页面获取的搜索条件
        StatisticsBarginDTO statisticsBarginDTO = json.toJavaObject(StatisticsBarginDTO.class);
        Map<String,Object> sumMap = Maps.newHashMap();
        List<String> barginTypeList = Lists.newArrayList();
        if (statisticsBarginDTO.getBarginType() != null && statisticsBarginDTO.getBarginType().length != 0){
            barginTypeList = Arrays.asList(statisticsBarginDTO.getBarginType());
        }else{
        	barginTypeList.add("L");
			barginTypeList.add("S");
			barginTypeList.add("B");
        	barginTypeList.add("C");
        	barginTypeList.add("M");
        }
        sumMap = sumByBargin(statisticsBarginDTO,barginTypeList);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,sumMap);
        return result;
    }

    /**
     * 根据页面选择的信息，进行查找(其他合同：采购合同、销售合同)
     * @param json
     * @return
     */
    @Override
    public CrudResultDTO searchOtherByStatistics(JSONObject json) {
        // 从页面获取的搜索条件
        StatisticsBarginDTO statisticsBarginDTO = json.toJavaObject(StatisticsBarginDTO.class);
        Map<String,Object> sumMap = Maps.newHashMap();
        List<String> barginTypeList = Lists.newArrayList();
        if (statisticsBarginDTO.getBarginType() != null && statisticsBarginDTO.getBarginType().length != 0){
            barginTypeList = Arrays.asList(statisticsBarginDTO.getBarginType());
        }else{
        	barginTypeList.add("B");
        	barginTypeList.add("S");
        }
        sumMap = barginCountOther(statisticsBarginDTO);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS,sumMap);
        return result;
    }

    /**
     * 根据 合同 对合同 进行遍历
     * @param statisticsBarginDTO
     * @return
     */
    public Map<String,Object> sumByBargin(StatisticsBarginDTO statisticsBarginDTO, List<String> barginTypeList){
        Map<String,Object> mapOfBagin = Maps.newHashMap();
        mapOfBagin = barginCount(statisticsBarginDTO, barginTypeList);
        return mapOfBagin;
    }

    /**
     * 根据 项目 对合同 进行遍历
     * @param statisticsBarginDTO
     * @return
     */
//    public Map<String,Object> sumByProject(StatisticsBarginDTO statisticsBarginDTO){
//        Map<String,Object> mapOfProject = Maps.newHashMap();
//        mapOfProject = barginCount(statisticsBarginDTO);
//        return mapOfProject;
//    }

    /**
     * 根据页面的条件进行查找
     *
     * @param statisticsBarginDTO
     * @return
     */
    public Map<String,Object> barginCount(StatisticsBarginDTO statisticsBarginDTO, List<String> barginTypeList){
        List<Integer> barginList = Lists.newArrayList();
        List<String> payCompanyList = Lists.newArrayList();
        //判断 合同，合同类型，所属公司是否为空
        if (StringUtils.isNotBlank(statisticsBarginDTO.getBarginId())){
            String[] barginId = statisticsBarginDTO.getBarginId().split(",");
            List<String> barginIdListOfString = Arrays.asList(barginId);
            for (String bargin:barginIdListOfString) {
                barginList.add(Integer.valueOf(bargin.trim()));
            }
        }
        if (statisticsBarginDTO.getPayCompany() != null && statisticsBarginDTO.getPayCompany().length != 0){
            //因为广东睿哲(value='0')改名位 睿哲科技(value='11') 部分老数据 title 都是 0
            //因为 asList,没有重写 add()和remove()方法
            for(int i=0; i<statisticsBarginDTO.getPayCompany().length; i++){
                payCompanyList.add(statisticsBarginDTO.getPayCompany()[i]);
                if (StringUtils.equals(statisticsBarginDTO.getPayCompany()[i],"11")){
                    payCompanyList.add("0");
                }
            }
        }
       /* */

        List<SaleBarginManage> saleBarginManageList = Lists.newArrayList();
        try{
            saleBarginManageList =
                    iSaleBarginManageDao.findByStatistics(statisticsBarginDTO, barginList,payCompanyList,barginTypeList);
        }catch (Exception e){
            logger.error("财务合同统计  合同表查找失败"+e);
        }
        Map<String,Object> BarginMap = Maps.newHashMap();
        BarginMap = barginCountByBargin(saleBarginManageList);
        return BarginMap;
    }

    /**
     * 根据页面的条件进行查找
     *
     * @param statisticsBarginDTO
     * @return
     */
    public Map<String,Object> barginCountOther(StatisticsBarginDTO statisticsBarginDTO){
        List<Integer> barginList = Lists.newArrayList();
        List<String> payCompanyList = Lists.newArrayList();
        //判断 合同，合同类型，所属公司是否为空
        if (StringUtils.isNotBlank(statisticsBarginDTO.getBarginId())){
            String[] barginId = statisticsBarginDTO.getBarginId().split(",");
            List<String> barginIdListOfString = Arrays.asList(barginId);
            for (String bargin:barginIdListOfString) {
                barginList.add(Integer.valueOf(bargin.trim()));
            }
        }
        if (statisticsBarginDTO.getPayCompany() != null && statisticsBarginDTO.getPayCompany().length != 0){
            //因为广东睿哲(value='0')改名位 睿哲科技(value='11') 部分老数据 title 都是 0
            //因为 asList,没有重写 add()和remove()方法
            for(int i = 0; i<statisticsBarginDTO.getPayCompany().length; i++){
                payCompanyList.add(statisticsBarginDTO.getPayCompany()[i]);
                if (StringUtils.equals(statisticsBarginDTO.getPayCompany()[i],"11")){
                    payCompanyList.add("0");
                }
            }
        }
       /* */

        List<StatiscsBarginOtherDTO> saleBarginManageListB = Lists.newArrayList();
        List<StatiscsBarginOtherDTO> saleBarginManageListS = Lists.newArrayList();
        List<StatiscsBarginOtherDTO> saleColletion = Lists.newArrayList();
        List<StatiscsBarginOtherDTO> salePay = Lists.newArrayList();
        try{
            saleBarginManageListB =
                    iSaleBarginManageDao.findByOtherStatisticsB(statisticsBarginDTO, payCompanyList);
            saleBarginManageListS = iSaleBarginManageDao.findByOtherStatisticsS(statisticsBarginDTO, payCompanyList);
            
            saleColletion = iSaleBarginManageDao.findByColleaction();
            salePay = iSaleBarginManageDao.findByPay();
            
         /*   System.out.println("采购合同总数："+saleBarginManageListB.size()+";销售合同总数"+saleBarginManageListS.size());
            System.out.println("付款条数："+salePay.size()+";收款总数"+saleColletion.size());*/
        }catch (Exception e){
            logger.error("财务合同统计  合同表查找失败"+e);
        }
        Map<String,Object> BarginMap = Maps.newHashMap();
        
        if(saleBarginManageListS.size() > 0 && saleColletion.size() > 0){
        	for (StatiscsBarginOtherDTO statiscsBarginOtherDTO : saleBarginManageListS) {
				for (StatiscsBarginOtherDTO statiscsDTO : saleColletion) {
					if(statiscsDTO.getProjectManageId().equals(statiscsBarginOtherDTO.getProjectManageId())){
			    		statiscsBarginOtherDTO.setReceivedMoney(statiscsDTO.getReceivedMoney());
			    		statiscsBarginOtherDTO.setInvoiceMoney(statiscsDTO.getInvoiceMoney());
			    		break;
					}else{
						statiscsBarginOtherDTO.setReceivedMoney(0.00);
			    		statiscsBarginOtherDTO.setInvoiceMoney(0.00);
					}
				}
			}
        }
        
        if(saleBarginManageListB.size() > 0 && salePay.size() > 0){
        	for (StatiscsBarginOtherDTO statiscsBarginOtherDTO : saleBarginManageListB) {
				for (StatiscsBarginOtherDTO statiscsDTO : salePay) {
					if(statiscsDTO.getProjectManageId().equals(statiscsBarginOtherDTO.getProjectManageId())){
						if((statiscsDTO.getPayMoney() == null || statiscsDTO.getPayMoney() == 0) && (statiscsDTO.getPayBill() != null || statiscsDTO.getPayBill() != 0)) {
							statiscsBarginOtherDTO.setPayMoney(statiscsDTO.getPayBill());
						}else {
							statiscsBarginOtherDTO.setPayMoney(statiscsDTO.getPayMoney());
						}
			    		statiscsBarginOtherDTO.setPayReceivedInvoice(statiscsDTO.getPayReceivedInvoice());
			    		break;
					}else{
						statiscsBarginOtherDTO.setPayMoney(0.00);
			    		statiscsBarginOtherDTO.setPayReceivedInvoice(0.00);
					}
				}
			}
        }
        BarginMap = barginCountOtherByBargin(saleBarginManageListB,saleBarginManageListS);
        return BarginMap;
    }

    public Map<String,Object> barginCountByBargin(List<SaleBarginManage> saleBarginManageLists){
        Map<String,Object> barginCountByBarginMap = Maps.newHashMap();
        barginCountByBarginMap.put(MAP_CONTENT, saleBarginManageLists);
        return barginCountByBarginMap;
    }
    
    /**
     * 根据合同返回合同内容
     * @param saleBarginManageList
     * @return
     */
    public Map<String,Object> barginCountOtherByBargin(List<StatiscsBarginOtherDTO> saleBarginManageListB, List<StatiscsBarginOtherDTO> saleBarginManageListS){
        Map<String,Object> barginCountByBarginMap = Maps.newHashMap();
        List<StatiscsBarginOtherDTO> list = Lists.newArrayList();
        //销售合同
        for (int i = 0; i < saleBarginManageListS.size(); i++) {
			for (int j = 0; j < saleBarginManageListB.size(); j++) {
				if(saleBarginManageListS.get(i).getProjectManageId().equals(saleBarginManageListB.get(j).getProjectManageId())){
					list.add(createBarginOtherDTO(saleBarginManageListS.get(i),saleBarginManageListB.get(j)));
				}
			}
		}
        List<StatiscsBarginOtherDTO> list2 = Lists.newArrayList();
        for (StatiscsBarginOtherDTO statiscsBarginOtherDTO : saleBarginManageListS) {
        	boolean flag = true;
        	for (StatiscsBarginOtherDTO statiscsBarginOtherDTO1 : list) {
				if(statiscsBarginOtherDTO1.getProjectManageId().equals(statiscsBarginOtherDTO.getProjectManageId())){
					flag = false;
					break;
				}
			}
			if(flag){
				list2.add(createBarginOtherDTO(statiscsBarginOtherDTO, null));
			}
		}
        for (StatiscsBarginOtherDTO statiscsBarginOtherDTO : saleBarginManageListB) {
        	boolean flag = true;
			for (StatiscsBarginOtherDTO statiscsBarginOtherDTO1 : list) {
			if(statiscsBarginOtherDTO1.getProjectManageId().equals(statiscsBarginOtherDTO.getProjectManageId())){
				flag = false;
				break;
				}
			}
			if(flag){
				list2.add(createBarginOtherDTO(null, statiscsBarginOtherDTO));
			}
		}
        list.addAll(list2);
        
     /*   System.out.println(list.size());*/
        
        /*List<StatiscsBarginOtherDTO> result=Lists.newArrayList();
        
       	if(saleBarginManageResult.size()>0){
        	for (SaleBarginManage saleBarginManage : saleBarginManageResult) {
				for (StatiscsBarginOtherDTO statiscsBarginOtherDTO : list) {
					if(statiscsBarginOtherDTO.getProjectManageId().equals(saleBarginManage.getProjectManageId())){
						result.add(statiscsBarginOtherDTO);
						break;
					}
				}
			}
        }*/
        
        barginCountByBarginMap.put(MAP_CONTENT, list);
        return barginCountByBarginMap;
    }

    public StatiscsBarginOtherDTO createBarginOtherDTO(StatiscsBarginOtherDTO saleBarginManageListS, StatiscsBarginOtherDTO saleBarginManageListB){
    	StatiscsBarginOtherDTO statiscsBarginOtherDTO = new StatiscsBarginOtherDTO();
    	if(saleBarginManageListS != null){
    		statiscsBarginOtherDTO.setTotalMoneyS(saleBarginManageListS.getTotalMoneyS());
    		statiscsBarginOtherDTO.setReceivedMoney(saleBarginManageListS.getReceivedMoney());
    		statiscsBarginOtherDTO.setUnreceivedMoney(saleBarginManageListS.getTotalMoneyS() - saleBarginManageListS.getReceivedMoney());
    		statiscsBarginOtherDTO.setInvoiceMoney(saleBarginManageListS.getInvoiceMoney());
    		statiscsBarginOtherDTO.setAdvancesReceived(saleBarginManageListS.getTotalMoneyS() - saleBarginManageListS.getInvoiceMoney());
    		statiscsBarginOtherDTO.setAccountReceived(saleBarginManageListS.getInvoiceMoney() - saleBarginManageListS.getReceivedMoney());
    	}else{
    		statiscsBarginOtherDTO.setTotalMoneyS(0.00);
    		statiscsBarginOtherDTO.setReceivedMoney(0.00);
    		statiscsBarginOtherDTO.setUnreceivedMoney(0.00);
    		statiscsBarginOtherDTO.setInvoiceMoney(0.00);
    		statiscsBarginOtherDTO.setAdvancesReceived(0.00);
    		statiscsBarginOtherDTO.setAccountReceived(0.00);
    	}
    	
    	if(saleBarginManageListB != null){
    		statiscsBarginOtherDTO.setTotalMoneyB(saleBarginManageListB.getTotalMoneyB());
    		statiscsBarginOtherDTO.setPayMoney(saleBarginManageListB.getPayMoney());
    		statiscsBarginOtherDTO.setUnpayMoney(saleBarginManageListB.getTotalMoneyB() - saleBarginManageListB.getPayMoney());
    		statiscsBarginOtherDTO.setUnReceivedInvoice(saleBarginManageListB.getTotalMoneyB() - saleBarginManageListB.getPayReceivedInvoice());
    		statiscsBarginOtherDTO.setPayReceivedInvoice(saleBarginManageListB.getPayReceivedInvoice());
    		statiscsBarginOtherDTO.setPayUnreceivedInvoice(saleBarginManageListB.getPayMoney() - saleBarginManageListB.getPayReceivedInvoice());
    	}else{
    		statiscsBarginOtherDTO.setTotalMoneyB(0.00);
    		statiscsBarginOtherDTO.setPayMoney(0.00);
    		statiscsBarginOtherDTO.setUnpayMoney(0.00);
    		statiscsBarginOtherDTO.setUnReceivedInvoice(0.00);
    		statiscsBarginOtherDTO.setPayReceivedInvoice(0.00);
    		statiscsBarginOtherDTO.setPayUnreceivedInvoice(0.00);
    	}
    	
		if(saleBarginManageListS != null && saleBarginManageListB != null){
			statiscsBarginOtherDTO.setProjectManageId(saleBarginManageListB.getProjectManageId());
			statiscsBarginOtherDTO.setProjectManage(saleBarginManageListB.getProjectManage());
		}else if(saleBarginManageListS != null){
			statiscsBarginOtherDTO.setProjectManageId(saleBarginManageListS.getProjectManageId());
			statiscsBarginOtherDTO.setProjectManage(saleBarginManageListS.getProjectManage());
		}else{
			statiscsBarginOtherDTO.setProjectManageId(saleBarginManageListB.getProjectManageId());
			statiscsBarginOtherDTO.setProjectManage(saleBarginManageListB.getProjectManage());
		}
    	return statiscsBarginOtherDTO;
    }

    //根据项目ID查找每一个合同，及每个合同对应的收付款的金额总计
	@Override
	public CrudResultDTO searchOtherByProjectId(@RequestBody JSONObject json) {
		 StatisticsBarginDTO statisticsBarginDTO = json.toJavaObject(StatisticsBarginDTO.class);
		 int projectId = statisticsBarginDTO.getProjectId();
		
		 SaleProjectManage projectManage = projectDao.findById(projectId);
		 List<String> payCompanyList = Lists.newArrayList();
		
		 if (statisticsBarginDTO.getPayCompany() != null && statisticsBarginDTO.getPayCompany().length != 0){
	            //因为广东睿哲(value='0')改名位 睿哲科技(value='11') 部分老数据 title 都是 0
	            //因为 asList,没有重写 add()和remove()方法
	            for(int i=0;i<statisticsBarginDTO.getPayCompany().length;i++){
	                payCompanyList.add(statisticsBarginDTO.getPayCompany()[i]);
	                if (StringUtils.equals(statisticsBarginDTO.getPayCompany()[i],"11")){
	                    payCompanyList.add("0");
	                }
	            }
	        }
		
		//销售合同
		List<SaleBarginManage> barginS = Lists.newArrayList();
		//采购合同
		List<SaleBarginManage> barginB = Lists.newArrayList();
			
		barginS = iSaleBarginManageDao.findOtherByProjectIdS(statisticsBarginDTO,payCompanyList);
		barginB = iSaleBarginManageDao.findOtherByProjectIdB(statisticsBarginDTO,payCompanyList);
		
		double sellTotal = 0;
		double BuyerTotal = 0;
		
		if(barginS.size() > 0){
			for (SaleBarginManage saleBarginManage : barginS) {
				double applyMoney = 0;
				double billMoney = 0;
				if(saleBarginManage.getTotalMoney() == null){
					saleBarginManage.setTotalMoney(0.00);
				}
				if(saleBarginManage.getCollectionList().size()>0){
					for (FinCollection collection : saleBarginManage.getCollectionList()) {
							applyMoney += Double.parseDouble(collection.getApplyPay());
							if(collection.getBill() == null||"".equals(collection.getBill())){
								collection.setBill(0.00);
							}
							billMoney += collection.getBill();
					}
				}
				saleBarginManage.setReceivedMoney(applyMoney);
				saleBarginManage.setUnreceivedMoney(
						(double)Math.round((saleBarginManage.getTotalMoney()-applyMoney) * 100) / 100);
				saleBarginManage.setInvoiceMoney(billMoney);
				saleBarginManage.setAccountReceived((double)Math.round((billMoney-applyMoney) * 100) / 100);//已开票未收款
				saleBarginManage.setAdvancesReceived(
						(double)Math.round((saleBarginManage.getTotalMoney()-billMoney) * 100) / 100);
				sellTotal += saleBarginManage.getTotalMoney();
			}
		}
		
		if(barginB.size() > 0){
			for (SaleBarginManage saleBarginManage : barginB) {
				double actualPay = 0;
				double invoiceMoney = 0;
				if(saleBarginManage.getTotalMoney() == null){
					saleBarginManage.setTotalMoney(0.00);
				}
				if(saleBarginManage.getPayList().size() > 0){
					for (FinPay pay : saleBarginManage.getPayList()) {
						if(pay.getActualPayMoney() == null||"".equals(pay.getActualPayMoney())){
							pay.setActualPayMoney(0.00);
						}
						if(pay.getInvoiceMoney() == null||"".equals(pay.getInvoiceMoney())){
							pay.setInvoiceMoney(0.00);
						}
						if(pay.getPayBill() != 0) {
							actualPay += pay.getPayBill();
						}else{
							actualPay += pay.getActualPayMoney();
						}
						invoiceMoney += pay.getInvoiceMoney();
					}
				}
				saleBarginManage.setPayMoney(actualPay);
				saleBarginManage.setUnpayMoney(
						(double)Math.round((saleBarginManage.getTotalMoney()-actualPay) * 100) / 100);
				saleBarginManage.setPayReceivedInvoice((double) Math.round(invoiceMoney * 100) / 100);
				saleBarginManage.setUnInvoice(
						(double)Math.round((saleBarginManage.getTotalMoney()-invoiceMoney) * 100) / 100);
				saleBarginManage.setPayUnreceivedInvoice(
						(double)Math.round((actualPay-invoiceMoney) * 100) / 100);
				/*BuyerTotal += saleBarginManage.getTotalMoney();*/
			}
		}
		
		BuyerTotal += ((iSaleBarginManageDao.findPayByProjectIdAndType(projectId) + iSaleBarginManageDao.findCommonByProjectIdAndType(projectId) + iSaleBarginManageDao.findReimburseByProjectIdAndType(projectId) + iSaleBarginManageDao.findTravelByProjectIdAndType(projectId)) * 100) / 100;
		
		double sum = (double)Math.round((iSaleBarginManageDao.findPayByProjectId(projectId) + iSaleBarginManageDao.findCommonByProjectId(projectId) + iSaleBarginManageDao.findReimburseByProjectId(projectId) + iSaleBarginManageDao.findTravelByProjectId(projectId)) * 100) / 100;
		
		double huZhuan = (double)Math.round((iSaleBarginManageDao.findCommonByProjectIdAndTypes(projectId) + iSaleBarginManageDao.findCommonByProjectIdAndTypes(projectId) + iSaleBarginManageDao.findReimburseByProjectIdAndTypes(projectId) + iSaleBarginManageDao.findCommonByProjectIdAndTypes(projectId)) * 100) / 100;
		
		BarginProfitDTO barginProfitDTO = new BarginProfitDTO();
		barginProfitDTO.setSellTotal(sellTotal);
		barginProfitDTO.setBuyerTotal(BuyerTotal);
		barginProfitDTO.setFee(sum - huZhuan);
				/*(double)Math.round((iSaleBarginManageDao.findPayByProjectId(projectId) + iSaleBarginManageDao.findCommonByProjectId(projectId) + iSaleBarginManageDao.findReimburseByProjectId(projectId) + iSaleBarginManageDao.findTravelByProjectId(projectId)) * 100) / 100);*/
		/*barginProfitDTO.setMargin(
				(double)Math.round((barginProfitDTO.getSellTotal() - barginProfitDTO.getBuyerTotal()-barginProfitDTO.getFee()) * 100) / 100);*/
		barginProfitDTO.setMargin(
				(double)Math.round((barginProfitDTO.getSellTotal() - barginProfitDTO.getFee()) * 100) / 100);
		barginProfitDTO.setProjectName(projectManage.getName());
		Map<String,Object> barginCountByBarginMap = Maps.newHashMap();
	    barginCountByBarginMap.put("barginB", barginB);
	    barginCountByBarginMap.put("barginS", barginS);
	    barginCountByBarginMap.put("barginProfitDTO", barginProfitDTO);
	    /*barginCountByBarginMap.put("feeInfoList", feeInfoList);*/
	    CrudResultDTO crudResultDTO = new CrudResultDTO(CrudResultDTO.SUCCESS, barginCountByBarginMap);
		return crudResultDTO;
	}
	
	//根据项目ID查找每一个合同，及每个合同对应的付款的详情
	@Override
	public CrudResultDTO searchInfoByProjectId(StatisticsFromPageDTO statisticsFromPageDTO) {
		//项目Id
		int projectId = statisticsFromPageDTO.getProjectId();
		List<SingleDetail> singleDetailList = Lists.newArrayList();
		//查询付款信息
		List<SingleDetail> payByProjectId = iFinPayAttachDao.findPayByProjectId(projectId);
		//查询通用报销信息
		List<SingleDetail> reimburseByProjectId = iFinReimburseAttachDao.findReimburseByProjectId(projectId);
		//查询差旅报销信息
		List<SingleDetail> travelByProjectId = iFinTravelreimburseAttachDao.findByTravelByProjectId(projectId);
		//查询常规付款信息
		List<SingleDetail> commonPayByProjectId = iFinCommonPayAttachDao.findCommonPayByProjectId(projectId);
		singleDetailList.addAll(payByProjectId);
		singleDetailList.addAll(reimburseByProjectId);
		singleDetailList.addAll(travelByProjectId);
		singleDetailList.addAll(commonPayByProjectId);
		Map<String,Object> singleDetailMap = Maps.newHashMap();
		singleDetailMap.put(CONTENT_OF_FORM, singleDetailList);
        CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, singleDetailMap);
		return result;
	}
	
	@Override
	public void exportDetails(HttpServletRequest request, HttpServletResponse response, Map<String, String> param) {
		List<SingleDetail> singleDetailList = Lists.newArrayList();
		if (!StringUtils.equals(param.get("projectId"), REPRSENT_NULL)){
			int projectId = Integer.parseInt(param.get("projectId"));
      		//查询付款信息
      		List<SingleDetail> payByProjectId = iFinPayAttachDao.findPayByProjectId(projectId);
      		//查询通用报销信息
      		List<SingleDetail> reimburseByProjectId = iFinReimburseAttachDao.findReimburseByProjectId(projectId);
      		//查询差旅报销信息
      		List<SingleDetail> travelByProjectId = iFinTravelreimburseAttachDao.findByTravelByProjectId(projectId);
      		//查询常规付款信息
      		List<SingleDetail> commonPayByProjectId = iFinCommonPayAttachDao.findCommonPayByProjectId(projectId);
      		singleDetailList.addAll(payByProjectId);
      		singleDetailList.addAll(reimburseByProjectId);
      		singleDetailList.addAll(travelByProjectId);
      		singleDetailList.addAll(commonPayByProjectId);
		}
        //导出
		try {
			ExportexcelUtil.expRptDataToExcel(response, this.getClass().getResource("doc/exportDetails.xls"), singleDetailList, "项目支出详情");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void exportExcel(ServletOutputStream outputStream, Map<String, Object> paramMap) {
		StatisticsBarginDTO statisticsBarginDTO = new StatisticsBarginDTO();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Map<String, Object> params = Maps.newHashMap();
		params.put("typeid", 17);
		List<SysDictData> sysDictDatas = sysDictDataDao.findByPage(params);
		String projectName = "";
		if(paramMap.get("beginDate") != null && !"".equals(paramMap.get("beginDate"))){
			try {
				statisticsBarginDTO.setBeginDate(simpleDateFormat.parse((String) paramMap.get("beginDate")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		if(paramMap.get("endDate") != null && !"".equals(paramMap.get("endDate"))){
			try {
				statisticsBarginDTO.setEndDate(simpleDateFormat.parse((String) paramMap.get("endDate")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		if(paramMap.get("projectId") != null && !"".equals(paramMap.get("projectId"))){
			statisticsBarginDTO.setProjectId(Integer.parseInt((String) paramMap.get("projectId")));
			int projectId = Integer.parseInt((String) paramMap.get("projectId"));
			SaleProjectManage saleProjectManage = projectDao.findById(projectId);
			projectName = saleProjectManage.getName();
		}
		String company = "";
		String strCompany = (String) paramMap.get("strCompany");
		if(strCompany != null && !"".equals(strCompany)){
			String[] payCompany = strCompany.split(",");
			statisticsBarginDTO.setPayCompany(payCompany);
			for (int i = 0; i < payCompany.length; i++) {
				for (SysDictData dictData :sysDictDatas ) {
					if(dictData.getValue().equals(payCompany[i])){
						company += dictData.getName()+",";
					}
				}
			}
		}
		System.out.println("拼接之后的数据:"+company);
		try {
			Map<String,Object> sumMap = barginCountOther(statisticsBarginDTO);
		    Context context =new Context();
		    context.putVar("beginDate", paramMap.get("beginDate"));
		    context.putVar("endDate", paramMap.get("endDate"));
		    context.putVar("company", company);
		    context.putVar("projectName", projectName);
		    context.putVar("dataList",sumMap.get(MAP_CONTENT));

		    ExcelUtil.export("statisBargin.xlsx", outputStream, context);
		} catch (Exception e) {
				e.printStackTrace();
		}
	}
    
    /**
     * 根据项目返回合同内容
     * @param saleBarginManageList
     * @return
     */
//    public Map<String,Object> barginCountByProject(List<SaleBarginManage> saleBarginManageList){
//        Set<Integer> projectIdSet = Sets.newHashSet();
//        for (SaleBarginManage saleBarginItems:saleBarginManageList) {
//            projectIdSet.add(saleBarginItems.getProjectManageId());
//        }
//        List<SaleBarginManage> saleBarginManageByProjectList = Lists.newArrayList();
//        for (Integer projectId:projectIdSet) {
//            for (SaleBarginManage saleBarginItems:saleBarginManageList) {
//                if (projectId.equals(saleBarginItems.getProjectManageId())){
//                    saleBarginManageByProjectList.add(saleBarginItems);
//                }
//            }
//        }
//        Map<String,Object> barginCountByProjectMap = Maps.newHashMap();
//
//        barginCountByProjectMap.put(MAP_CONTENT,saleBarginManageByProjectList);
//        barginCountByProjectMap.put(MAP_PROJECTID_SET,projectIdSet);
//        return barginCountByProjectMap;
//    }
}
