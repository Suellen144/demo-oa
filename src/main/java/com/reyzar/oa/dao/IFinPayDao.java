package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.common.dto.StatisticsFromPageDTO;
import com.reyzar.oa.domain.SingleDetail;
import org.apache.ibatis.annotations.Param;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.FinCollection;
import com.reyzar.oa.domain.FinPay;


@MyBatisDao
public interface IFinPayDao {
	
	public FinPay findById(Integer id);
	
	public void save(FinPay finPay);
	
	public void update(FinPay finPay);
	
	public void deleteById(Integer id);

	public Page<FinPay> findByPage(Map<String, Object> params);

	public Page<FinPay> findByOne(Map<String, Object> params);

	public Page<FinPay> findByPage2(Map<String, Object> params);

	public Page<FinPay> findByOne2(Map<String, Object> params);
	
	public Page<FinPay> findByPageNew(Map<String, Object> params);

	public List<FinPay> findPayInfo(@Param("barginManageId") Integer barginManageId, @Param("status") String status);

	//查找已付总金额
	public Double findPayMoney(Integer id);
	
	//计算已付总金额
	public FinPay findPayMoneyNew(Integer barginManageId);

	public Double findPayReceivedInvoice(Integer id);

	//根据页面的限制条件查找 已付金额
	public List<FinPay> findPayByStatistics(StatisticsFromPageDTO statisticsFromPageDTO);

	//查找广东睿哲的数据
	public List<FinPay> findPayByTitleISZero(StatisticsFromPageDTO statisticsFromPageDTO);

	public List<SingleDetail> findPayByIdList(List<String> finpayMainId);
	
	public List<FinPay> findByBarginId(@Param("barginId") Integer barginId);
	
	public void batchUpdate(@Param(value="payList") List<FinPay> payList);
	
	public List<SingleDetail> findStatisticsList(SingleDetail singleDetail);
	
	public List<FinPay> findFinPayByStatis(StatisticsFromPageDTO statisticsFromPageDTO);
	
}