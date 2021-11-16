package com.reyzar.oa.common.dict.cache;

import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.reyzar.oa.common.dict.entity.DictData;
import com.reyzar.oa.common.dict.entity.DictType;
import com.reyzar.oa.common.util.SpringContextUtils;
import com.reyzar.oa.domain.SysDictData;
import com.reyzar.oa.domain.SysDictType;
import com.reyzar.oa.service.sys.ISysDictDataService;
import com.reyzar.oa.service.sys.ISysDictTypeService;

/** 
* @ClassName: DictionaryCache 
* @Description: 数据字典缓存
* @author Lin 
* @date 2016年11月1日 下午3:52:35 
*  
*/
public class DictionaryCache {

    /**
     *  所有类型，对应的数据字典项
     */
    public static Map<String, List<DictData>> dictDataObjMap = Maps.newHashMap();
            
    /**
     * 类型与字典项  由List 转成Map（key,value）
     */
    public static Map<String, Map<String, String>> dictDataMap = Maps.newHashMap();
    public static Map<String, Map<String, String>> temp = Maps.newHashMap();
    
    /**
     * 初始化字典缓存
     * */
    public static void initCache() {
    	dictDataObjMap.clear();
    	dictDataMap.clear();
    	temp.clear();
    	
    	ISysDictTypeService dictTypeService = SpringContextUtils.getBean(ISysDictTypeService.class);
    	ISysDictDataService dictDataService = SpringContextUtils.getBean(ISysDictDataService.class);
    	
    	List<SysDictType> dictTypeList = dictTypeService.findAll();
    	List<SysDictData> dictDataList = dictDataService.findAll();
    	
    	Map<Integer, List<SysDictData>> tempDictDataMap = Maps.newHashMap();
    	for(SysDictData dictData : dictDataList) {
    		List<SysDictData> list = tempDictDataMap.get(dictData.getTypeid());
    		if(list == null) {
    			list = Lists.newArrayList();
    		}
    		list.add(dictData);
    		tempDictDataMap.put(dictData.getTypeid(), list);
    	}
    	
    	for(SysDictType sdt : dictTypeList) {
    		List<SysDictData> dataList = tempDictDataMap.get(sdt.getId());
    		
    		if(dataList != null) {
    			DictType dictType = new DictType();
    			dictType.setId(sdt.getId());
    			dictType.setKey(sdt.getName());
    			dictType.setParentId(sdt.getParentId());
    			dictType.setValue(sdt.getId());
    			dictType.setRemark(sdt.getRemark());
    			
    			for(SysDictData sdd : dataList) {
    				DictData dictData = new DictData();
        			dictData.setId(sdd.getId());
        			dictData.setKey(sdd.getName());
        			dictData.setValue(sdd.getValue());
        			dictData.setRemark(sdd.getRemark());
        			dictData.setTypeValue(sdt.getId());
        			dictData.setIsdeleted(sdd.getIsdeleted());
        			dictData.setDictType(dictType);
        			
        			List<DictData> list = dictDataObjMap.get(dictType.getKey());
        			Map<String, String> map = dictDataMap.get(dictType.getKey());
        			Map<String, String> map2 = temp.get(dictType.getKey());
        			if(list == null) {
        				list = Lists.newArrayList();
        			}
        			if(map == null) {
        				map = Maps.newLinkedHashMap();
        			}
        			if (map2 == null) {
						map2 = Maps.newLinkedHashMap();
					}
        			
        			list.add(dictData);
        			dictDataObjMap.put(dictType.getKey(), list);
        			
        			map.put(dictData.getKey(), dictData.getValue());
        			if (dictData.getIsdeleted() == null) {
        				map2.put(dictData.getKey(), dictData.getValue());
					}
        			dictDataMap.put(dictType.getKey(), map);
        			temp.put(dictType.getKey(), map2);
    			}
    			
    			dictType.setDictDataList(dictDataObjMap.get(dictType.getKey()));
    		}
    	}
    }
    
    public static Map<String, String> getDictDataByDictType(String type) {
    	return dictDataMap.get(type);
    }
    
    public static Map<String, String> getDictDataByDictTypeNotAll(String type) {
    	return temp.get(type);
    }
}
