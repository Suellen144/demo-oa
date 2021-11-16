package ${packageName};

<#list dataMap.fullTypeSet as type>
import ${type};
</#list>

@SuppressWarnings("serial")
public class ${className} extends BaseEntity {

<#list dataMap.fieldList as map>
	private ${map.fieldMeta.fieldType} ${map.fieldName}; // ${map.fieldMeta.remarks}
</#list>

<#list dataMap.fieldList as map>
	public void set${map.fieldName?cap_first}(${map.fieldMeta.fieldType} ${map.fieldName}) {
		this.${map.fieldName} = ${map.fieldName};
	}
	
	public ${map.fieldMeta.fieldType} get${map.fieldName?cap_first}() {
		return this.${map.fieldName};
	}
	
</#list>
}