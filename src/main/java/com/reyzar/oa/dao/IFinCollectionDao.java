package com.reyzar.oa.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.github.pagehelper.Page;
import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.*;
import org.apache.ibatis.annotations.Param;


@MyBatisDao
public interface IFinCollectionDao {

	public FinCollection statisticsRelationship(Integer projectId);

	public int changeData (@Param(value = "id")Integer id ,@Param(value = "purchase")double purchase ,
						   @Param(value = "taxes")double taxes,@Param(value = "relationship")double relationship,
						   @Param(value = "other")double other,@Param(value = "commissionBase")double commissionBase);

	public List<SaleBarginManage> findBarginByProjectId(Integer id);

	public SaleBarginManage findBarginResultsAmountById(Integer id);

	public SaleBarginManage findByChannelHave(Integer id);

	public List<SaleProjectManage> findProjectId(Map<String, Object> paramsMap);

	public List<FinInvoiceProjectMembers> findInvoiceProjectMembersById(Integer id);

	public List<FinRevenueRecognition> findRevenueRecognition(Integer id);

	public List<FinCollection> findCommissionListById(Integer id);

	public SysUser findUserById(Integer id);

	public List<FinInvoiced> findInvoicedById(Integer id);
	
	public Page<FinCollection> findByPage(Map<String, Object> params);

	public List<FinCollection> findAll();
	
	public FinCollection findById(Integer id);
	
	public void save(FinCollection finCollection);
	
	public void update(FinCollection finCollection);
	
	public void batchUpdate(@Param(value="collectionList") List<FinCollection> collectionList);
	
	public void deleteById(Integer id);

	public List<FinCollection> findCollectionInfo(@Param("barginId") Integer barginId, @Param("status") String status);

	public List<FinCollection> findByBarginId(@Param("barginId") Integer barginId);
	
	public List<FinCollection> findByBarginIdAndCreateDate(@Param("barginId") Integer barginId,@Param("createDate") Date createDate);
	
	public Page<FinCollection> findByPageNew(Map<String, Object> params);
	
	public Page<FinCollection> findListByPage(Map<String, Object> params);

	public List<FinCollection> findCollectionByProjectId(int id);

	public List<FinCollection> findCommissionByProjectId(Integer projectId);
}