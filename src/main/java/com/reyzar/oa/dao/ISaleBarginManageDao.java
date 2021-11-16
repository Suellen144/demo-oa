package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;
import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.common.dto.StatiscsBarginOtherDTO;
import com.reyzar.oa.common.dto.StatisticsBarginDTO;
import com.reyzar.oa.domain.SaleBarginManage;
import com.reyzar.oa.domain.ValidationJump;

import org.apache.ibatis.annotations.Param;


@MyBatisDao
public interface ISaleBarginManageDao {
	
	public List<SaleBarginManage> findAll();
	
	public SaleBarginManage findById(Integer id);
	
	public void save(SaleBarginManage saleProjectManageAttach);
	
	public void update(SaleBarginManage saleProjectManageAttach);
	
	public void deleteById(Integer id);

	public void insertAll(List<SaleBarginManage> saleProjectManageAttachLis);

	public void batchUpdate(List<SaleBarginManage> updateList);

	public void deleteByIdList(List<Integer> delList);
	
	public void deleteByAttachList(List<SaleBarginManage> delList);

	public List<SaleBarginManage> findByBarginName(SaleBarginManage projectManageAttach);

	public Page<SaleBarginManage> findByPage(Map<String, Object> params);
	
	public Page<SaleBarginManage> findByPageNew(Map<String, Object> params);

	public Page<SaleBarginManage> findByPage1(Map<String, Object> params);
	
	public Page<SaleBarginManage> findByOne(Map<String, Object> params);

	public String findMaxNum(String type);

	public Page<SaleBarginManage> getBarginListForDialog(Map<String, Object> params);

	public List<SaleBarginManage> findByProjectManageId(Integer projectManageId);

	public List<SaleBarginManage> findByProjectIdAndType(Integer projectManageId);

	public List<SaleBarginManage> findByStatistics(@Param(value = "statisticsBarginDTO")
														   StatisticsBarginDTO statisticsBarginDTO,
												   @Param(value = "barginList") List<Integer> barginList,
												   @Param(value = "payCompanyList") List<String> payCompanyList,
												   @Param(value = "barginTypeList") List<String> barginTypeList);

	public List<StatiscsBarginOtherDTO> findByOtherStatisticsB(@Param(value = "statisticsBarginDTO") StatisticsBarginDTO statisticsBarginDTO,@Param(value = "payCompanyList") List<String> payCompanyList);
	
	public List<StatiscsBarginOtherDTO> findByOtherStatisticsS(@Param(value = "statisticsBarginDTO") StatisticsBarginDTO statisticsBarginDTO,@Param(value = "payCompanyList") List<String> payCompanyList);
	
	public List<SaleBarginManage> findProjectId(@Param(value = "statisticsBarginDTO") StatisticsBarginDTO statisticsBarginDTO,@Param(value = "payCompanyList") List<String> payCompanyList);
	
	public List<StatiscsBarginOtherDTO> findByColleaction();
	
	public List<StatiscsBarginOtherDTO> findByPay();
	
	public List<SaleBarginManage> findBarginBySale();
	
	public List<SaleBarginManage> findOtherByProjectIdS(@Param(value = "statisticsBarginDTO")
	   StatisticsBarginDTO statisticsBarginDTO,@Param(value = "payCompanyList") List<String> payCompanyList);
	
	public List<SaleBarginManage> findOtherByProjectIdB(@Param(value = "statisticsBarginDTO")
	   StatisticsBarginDTO statisticsBarginDTO,@Param(value = "payCompanyList") List<String> payCompanyList);
	
	/* 存货类别查询开始 */
	public Double findPayByProjectIdAndType(Integer projectId);
	
	public Double findCommonByProjectIdAndType(Integer projectId);
	
	public Double findReimburseByProjectIdAndType(Integer projectId);
	
	public Double findTravelByProjectIdAndType(Integer projectId);
	/* 存货类别查询结束 */
	
	/* 互转类别查询开始 */
	public Double findPayByProjectIdAndTypes(Integer projectId);
	
	public Double findCommonByProjectIdAndTypes(Integer projectId);
	
	public Double findReimburseByProjectIdAndTypes(Integer projectId);
	
	public Double findTravelByProjectIdAndTypes(Integer projectId);
	/* 互转类别查询结束 */
	
	public Double findPayByProjectId(Integer projectId);
	
	public Double findCommonByProjectId(Integer projectId);
	
	public Double findReimburseByProjectId(Integer projectId);
	
	public Double findTravelByProjectId(Integer projectId);
	
	public List<ValidationJump> findByValidationJump(@Param(value = "processInstanceId") String processInstanceId);
	
	SaleBarginManage findByContractAmount(@Param(value = "projectId") Integer projectId);
	
	SaleBarginManage findByIncome(@Param(value = "projectId") Integer projectId);
	
	SaleBarginManage findByChannelHave(@Param(value = "projectId") Integer projectId);
	
	SaleBarginManage findByIncomeBargin(Integer id);
	
	SaleBarginManage findByChannelHaveBargin(Integer id);
}