package com.reyzar.oa.common.gen;

/** 
* @ClassName: Generator 
* @Description: 代码生成器
* @author Lin 
* @date 2016年5月24日 下午6:20:03 
*  
*/
public class Generator {

	public static void main(String[] args) {
		
		new Generator().onceBuild("ad_client_manage", "AdClientManage");
	}
	
	/**
	 * @Desc 一站式构建，自动生成Entity、Dao、Service、Controller
	 * @param tableName 根据表名生成Entity
	 * @param className 根据此类名生成Entity、Dao等的类名
	 * 			    Entity：className
	 * 				Entity：classNameMapper
	 * 			       Dao: IclassNameDao
	 * 			   Service: IclassNameService & classNameServiceImpl
	 * 			Controller: classNameController
	 * */
	public void onceBuild(String tableName, String className) {
		// 生成Entity
		GenerateTemplate entityGen = new GenerateEntity();
		entityGen.build(tableName, className);
		
		// 生成Mapper
		GenerateTemplate gen = new GenerateMapper();
		gen.build(tableName, className);
		
		// 生成Dao
		GenerateTemplate daoGen = new GenerateDao();
		daoGen.build("I"+className+"Dao");
		
		// 生成Service
		GenerateTemplate serviceGen = new GenerateService();
		serviceGen.build("I"+className+"Service", true);
		
		// 生成Controller
		GenerateTemplate controllerGen = new GenerateController();
		controllerGen.build(className+"Controller");
	}
}
