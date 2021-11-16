package com.reyzar.oa.common.tags;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import com.reyzar.oa.common.dict.cache.DictionaryCache;

/** 
* @ClassName: GetDictKeyTag 
* @Description: 根据字典类型与值获取Key
* @author Lin 
* @date 2016年11月3日 上午11:42:50 
*  
*/
public class GetDictKeyTag extends SimpleTagSupport {

	private String type;
	private String value;
	
	@Override
	public void doTag() throws IOException {
		String dictKey = "";
		JspWriter out = getJspContext().getOut();
		type = type != null ? type.trim() : "";
		value = value != null ? value.trim() : "";
		
		if(!"".equals(type) && !"".equals(value)) {
			Map<String, String> dictDataMap = DictionaryCache.getDictDataByDictType(type);
			if(dictDataMap != null && dictDataMap.size() > 0) {
				Set<String> keys = dictDataMap.keySet();
				for(String key : keys) {
					if(dictDataMap.get(key).equals(value)) {
						dictKey = key;
						break ;
					}
				}
			}
		}
		
		out.println(dictKey);
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
}
