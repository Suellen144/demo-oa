package com.reyzar.oa.common.msgsys;

import com.alibaba.fastjson.JSON;
import com.reyzar.oa.common.dto.CrudResultDTO;
import com.reyzar.oa.common.msgsys.dao.IConMessageNoticeDao;
import com.reyzar.oa.common.msgsys.entity.ConMessageNoticeEntity;
import com.reyzar.oa.common.util.SpringContextUtils;

/** 
* @ClassName: MessageSystemUtils 
* @Description: 消息推送系统工具类
* @author Lin 
* @date 2016年8月17日 下午12:15:32 
*  
*/
public class MessageSystemUtils {

	private final static IConMessageNoticeDao messageNoticeDao = 
			SpringContextUtils.getBean(IConMessageNoticeDao.class);
	
	/**
	 * 保存或修改推送消息对象
	 * */
	public static CrudResultDTO saveOrUpdate(ConMessageNoticeEntity messageEntity) {
		CrudResultDTO result = new CrudResultDTO(CrudResultDTO.SUCCESS, "保存成功！");
		try {
			if(messageEntity != null) {
				if(messageEntity.getId() != null) {
					messageNoticeDao.update(messageEntity);
				} else {
					messageNoticeDao.save(messageEntity);
				}
			} else {
				result = new CrudResultDTO(CrudResultDTO.FAILED, "The object is null!");
			}
		} catch(Exception e) {
			result = new CrudResultDTO(CrudResultDTO.EXCEPTION, e.getMessage());
		}
		
		return result;
	}
	
	/**
	 * 查找与业务有关联的消息对象
	 * */
	public static ConMessageNoticeEntity findByRelId(String relId) {
		return messageNoticeDao.findByRelId(relId);
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
		WebClientUtils.sendMessage(account, message);
	}
	
	/**
	* @Title: sendToAll
	* @Description: 发送消息给所有客户端
	* @param message 推送消息
	* @return void
	* @throws
	 */
	public static void sendToAll(String message) {
		WebClientUtils.sendToAll(message);
	}
	
	/**
	* @Title: isOnline
	* @Description: 判断用户是否在线
	* @return boolean true 在线 
	* 				  false 离线
	* @throws
	 */
	public static boolean isOnline(String account) {
		return WebClientUtils.isOnline(account);
	}
	
	public static void sendMessageForJson(String account, Object message) {
		String json = JSON.toJSONString(message);
		WebClientUtils.sendMessage(account, json);
	}
}
