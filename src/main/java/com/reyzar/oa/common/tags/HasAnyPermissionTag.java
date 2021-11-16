package com.reyzar.oa.common.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;

/**
 * @ClassName: HasAnyPermissionTag
 * @Description: 扩展Shiro标签，实现判断任意符合权限
 * @author Lin
 * @date 2017年2月28日 上午11:03:18
 * 
 */
@SuppressWarnings("serial")
public class HasAnyPermissionTag extends BodyTagSupport {
	
	private String name;
	public void setName(String name) {
		this.name = name;
	}

	public HasAnyPermissionTag() {}
	
	@Override  
    public int doAfterBody() throws JspException {  
        return SKIP_BODY;  
    }
	
    @Override  
    public int doEndTag() throws JspException {  
    	boolean hasAnyPermissions = false;
		try {
			Subject subject = SecurityUtils.getSubject();
			if (subject != null) {
				for( String permission : name.split(",") ) {
					if( subject.isPermitted(permission.trim()) ) {
						hasAnyPermissions = true;
						break;
					}
				}
			}
			
			if(hasAnyPermissions) { // 有权限则输出标签体
				JspWriter out = pageContext.getOut();
				BodyContent bodyContent = this.getBodyContent();
				out.print(bodyContent.getString());
			}
		} catch(Exception e) {}
		
        return EVAL_PAGE;  
    }  
	
}
