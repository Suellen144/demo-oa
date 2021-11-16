package com.reyzar.oa;

import java.net.URI;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.shiro.util.ThreadContext;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:spring-context.xml", "classpath:spring-mvc.xml", 
		"classpath:spring-activiti.xml", "classpath:spring-shiro.xml" })
@WebAppConfiguration(value="src/main/webapp")
public abstract class JUnitActionBase {
	
	protected boolean isDetail = true; // 是否打印HTTP请求详细信息 true：是 false：否
	
	@Autowired
	private WebApplicationContext wac;
	private MockMvc mockMvc;
	@Resource
	org.apache.shiro.mgt.SecurityManager securityManager;
	
	@Before
	public void setup() throws Exception {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
		ThreadContext.bind(securityManager);
	}
	
	/*--------------------------HTTP Test Method begin----------------------------------------*/
	/**
	 * 执行HTTP请求，测试Controller，默认GET方法请求
	 * @param url 请求的路径
	 * @return MvcResult 可从中获取response.getContentXXX
	 * 					 	或者Model
	 * @exception Exception
	 * */
	protected MvcResult executeActionForHttpRequest(String url) throws Exception {
		
		return executeActionForHttpRequest(null, url, null);
	}
	
	/**
	 * 执行HTTP请求，测试Controller
	 * @param requestMethod GET或POST
	 * @param url 请求的路径
	 * @return MvcResult 可从中获取response.getContentXXX
	 * 					 	或者Model
	 * @exception Exception
	 * */
	protected MvcResult executeActionForHttpRequest(String requestMethod, 
			String url) throws Exception {
		
		return executeActionForHttpRequest(requestMethod, url, null);
	}
	
	/**
	 * 执行HTTP请求，测试Controller，默认GET方法请求
	 * @param url 请求的路径
	 * @param params 请求参数
	 * @return MvcResult 可从中获取response.getContentXXX
	 * 					 	或者Model
	 * @exception Exception
	 * */
	protected MvcResult executeActionForHttpRequest(String url, 
			Map<String, String[]> params) throws Exception {
		
		return executeActionForHttpRequest(null, url, params);
	}
	
	/**
	 * 执行HTTP请求，测试Controller
	 * @param requestMethod GET或POST
	 * @param url 请求的路径
	 * @param params 请求参数
	 * @return MvcResult 可从中获取response.getContentXXX
	 * 					 	或者Model
	 * @exception Exception
	 * */
	protected MvcResult executeActionForHttpRequest(String requestMethod, 
			String url, Map<String, String[]> params) throws Exception {

		URI uri = new URI(url);
		HttpMethod httpMethod = HttpMethod.GET;
		if("post".equalsIgnoreCase(requestMethod)) {
			httpMethod = HttpMethod.POST;
		}
		
		MockHttpServletRequestBuilder rb = MockMvcRequestBuilders.request(httpMethod, uri);
		if(params != null) {
			Set<String> paramsName = params.keySet();
			for(String paramName : paramsName) {
				rb.param(paramName, params.get(paramName));
			}
		}
		
		// 执行请求操作
		ResultActions resultActions = mockMvc.perform(rb);
		if(isDetail) { // 是否打印请求详细信息
			resultActions.andDo(MockMvcResultHandlers.print());
		}
		return resultActions.andReturn();
		
		/**
		 * 1、mockMvc.perform执行一个请求；
		 * 2、MockMvcRequestBuilders.get("url")构造一个请求
		 * 3、ResultActions.andExpect添加执行完成后的断言
		 * 4、ResultActions.andDo添加一个结果处理器，表示要对结果做点什么事情，比如此处使用MockMvcResultHandlers.print()输出整个响应结果信息。
		 * 5、ResultActions.andReturn表示执行完成后返回相应的结果。
		 * */
/*		MvcResult result = mockMvc.perform(rb)
									.perform(MockMvcRequestBuilders.get("url"))
	            					.andExpect(MockMvcResultMatchers.model().attributeExists("attr"))  
	            					.andDo(MockMvcResultHandlers.print())  
	            					.andReturn();*/
	}
	
	/*--------------------------HTTP Test Method end----------------------------------------*/
	
	
	
	
	
	
	protected MvcResult executeActionForBusiness() {
		
		return null;
	}
}
