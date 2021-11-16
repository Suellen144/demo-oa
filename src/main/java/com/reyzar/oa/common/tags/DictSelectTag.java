package com.reyzar.oa.common.tags;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import com.reyzar.oa.common.dict.cache.DictionaryCache;

/** 
* @ClassName: DictSelectTag 
* @Description: TODO
* @author Lin 
* @date 2016年11月2日 上午10:40:49 
*  
*/
public class DictSelectTag extends SimpleTagSupport {

	private String type;
	private String selectedValue;
	
	@Override
	public void doTag() throws IOException {
		Map<String, String> dictDataMap = DictionaryCache.getDictDataByDictTypeNotAll(type);
		if(dictDataMap != null && dictDataMap.size() > 0) {
			JspWriter out = getJspContext().getOut();
			StringBuffer sb = new StringBuffer();
			selectedValue = selectedValue == null ? "" : selectedValue.trim();
			
			Set<String> keys = dictDataMap.keySet();
			for(String key : keys) {
				sb.append("<option value=\"");
				sb.append(dictDataMap.get(key));
				if(!"".equals(selectedValue)
						&& dictDataMap.get(key).equals(selectedValue) ) {
					sb.append("\" selected>");
				} else {
					sb.append("\">");
				}
				sb.append(key);
				sb.append("</option>");
			}
			
			out.println(sb.toString());
		}
		
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setSelectedValue(String selectedValue) {
		this.selectedValue = selectedValue;
	}
	
}
