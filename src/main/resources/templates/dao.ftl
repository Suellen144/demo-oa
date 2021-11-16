package ${packageName};

import java.util.List;

import com.reyzar.oa.common.annotation.MyBatisDao;

import ${entityPackageName};


@MyBatisDao
public interface ${className} {
	
	public List<${entityName}> findAll();
	
	public ${entityName} findById(Integer id);
	
	public void save(${entityName} ${entity});
	
	public void update(${entityName} ${entity});
	
	public void deleteById(Integer id);
}