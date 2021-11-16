package com.reyzar.oa.dao;

import java.util.List;
import java.util.Map;

import com.reyzar.oa.domain.Organization;
import org.apache.ibatis.annotations.Param;

import com.reyzar.oa.common.annotation.MyBatisDao;
import com.reyzar.oa.domain.SysDept;

@MyBatisDao
public interface ISysDeptDao {

	public List<SysDept> findProjectTeam(String parentId);

	public List<SysDept> findByParentidAndIsCompany(String parentId);

	public List<SysDept> findByOrganization(@Param("companyId")String companyId,@Param("isDelete")String isDelete);

	public void updateNodeLinksById(Map<String, String> param);

	public void saveDept(Map<String, String> param);

	public void updateDept(Map<String, String> param);

	public List<SysDept> findDeptByNameAndId(@Param("name")String name , @Param("id")String id);

	public SysDept selectByDateAndGenerateKpi();

	public void recoveryOrganizationById(Integer id);

	public int updateByDeteleId(Integer id);

	public int delByDeteleId(Integer id);

	public List<SysDept> findAll();
	
	public List<SysDept> findAllByMetting();
	
	public SysDept findById(Integer id);
	
	public List<SysDept> findByUserId(Integer userId);
	
	public List<SysDept> findByParentid(Integer parentId);

	public List<SysDept> findByParentid2(Integer parentId);

	public List<SysDept> findByParentidAndCompany(@Param("parentId")Integer parentId,@Param("isCompany")Integer isCompany);
	
	public SysDept findByCode(String code);
	
	public List<SysDept> findByIds(@Param("idList") List<Integer> idList);
	
	public List<SysDept> findChilrenByNodelinksLike(Integer id);
	
	public List<SysDept> findByLevel(Integer level);
	
	public void save(SysDept dept);
	
	public void update(SysDept dept);
	
	public int delete(Integer id);

	public int revokeByDeptList(List<SysDept> deptList);
	
	public int deletetrueByDeptList(List<SysDept> deptList);
	
	public void setNullByUserid(Integer userId);
	
	public List<Map<String, Object>> getMaxCode();
	
	public int checkCode(@Param("id") Integer id, @Param("code") String code);

	public SysDept findByName(@Param("name")String name,@Param("id")Integer id);

	public int checkLevelIsOne(Integer id);

	public String findNameByID(Integer id);
	
	public List<SysDept> findByGenerateKpi();
	
	public List<SysDept> getDeptAndPosition(@Param("id") Integer id,@Param("isDeleted") String isDelete);

	public List<SysDept> getDeptAndPosition2(@Param("id") Integer id,@Param("isDeleted") String isDelete);
	
	public List<SysDept> findByDeleteAndId(@Param("isDeleted") String isDelete ,@Param("companyId")String companyId);
	
	public SysDept findByNameByisDeleted(String name);

}