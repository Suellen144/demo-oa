package com.reyzar.oa.common.msgsys;

import java.util.Map;

import org.apache.log4j.Logger;

import com.google.common.collect.Maps;
import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: WebClientUtils 
* @Description: 消息推送工具类
* @author Lin 
* @date 2016年7月13日 下午2:22:27 
*  
*/
public class WebClientUtils {

	private static Logger logger = Logger.getLogger(WebClientUtils.class);
	
	private static Map<String, MessageSystemEndpoint> connections = Maps.newHashMap();
	
	public static void addWebClient(MessageSystemEndpoint webClient, SysUser user) {
		connections.put(user.getAccount(), webClient);
		logger.info("added websocket for user<" + user.getAccount() + ">.");
	}
	
	public static void removeWebClient(String account) {
		connections.remove(account);
		logger.info("removed user<" + account + "> on websocket.");
	}
	
	/**
	* @Title: sendMessage
	* @Description: 推送消息给指定用户
	* @param account 用户账号
	* @param message 推送消息
	* @return void
	* @throws
	 */
	public static void sendMessage(String account, String message) {
		MessageSystemEndpoint webClient = connections.get(account);
		if(webClient != null) {
			try {
				webClient.sendMessage(message);
				logger.info("send message to user :" + account + " the message: " + message);
			} catch (Exception e) {
				logger.info("occurred error! send message to user<"+account+"> error message: " + e.getMessage());
				connections.remove(webClient);
				webClient.close();
			}
		}
	}
	
	/**
	* @Title: sendToAll
	* @Description: 发送消息给所有客户端
	* @param message 推送消息
	* @return void
	* @throws
	 */
	public static void sendToAll(String message) {
		for(MessageSystemEndpoint webClient : connections.values()) {
			try {
				webClient.sendMessage(message);
			} catch (Exception e) {
				logger.info("occurred error when send message! error message: " + e.getMessage());
				connections.remove(webClient);
				webClient.close();
			}
		}
	}
	
	/**
	* @Title: isOnline
	* @Description: 判断用户是否在线
	* @return boolean true 在线 
	* 				  false 离线
	* @throws
	 */
	public static boolean isOnline(String account) {
		return connections.containsKey(account);
	}
}

