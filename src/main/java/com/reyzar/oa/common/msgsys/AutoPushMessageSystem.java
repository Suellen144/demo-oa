package com.reyzar.oa.common.msgsys;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.reyzar.oa.common.dto.MessageNotifyDTO;
import com.reyzar.oa.common.msgsys.dao.IConMessageNoticeDao;
import com.reyzar.oa.common.msgsys.entity.ConMessageNoticeEntity;
import com.reyzar.oa.domain.SysUser;
import com.reyzar.oa.service.sys.ISysUserService;

/** 
* @ClassName: AutoPushMessageSystem 
* @Description: 定时扫描消息表，自动推送消息
* @author Lin 
* @date 2016年8月17日 上午10:51:06 
*  
*/
@Component
@Lazy(value=false)
public class AutoPushMessageSystem {
	
	@Autowired
	private IConMessageNoticeDao messageNoticeDao;
	@Autowired ISysUserService userService;

	@Scheduled(cron="0 0/3 * * * ?")
	public void beginPush() {
		List<ConMessageNoticeEntity> messageList = messageNoticeDao.findNotEnd();
		List<ConMessageNoticeEntity> needSaveList = Lists.newArrayList();
		
		for(ConMessageNoticeEntity message : messageList) {
			Set<String> accountSet = getMessageAccount(message);
			boolean sendMore = false; // 为true时表示至少发送给一个用户
			
			for(String account : accountSet) {
				if(MessageSystemUtils.isOnline(account)) {
					
					MessageNotifyDTO dto = new MessageNotifyDTO();
					dto.setId(message.getId());
					dto.setInitiatorId(message.getInitiator());
					dto.setInitiator(userService.findById(message.getInitiator()));
					dto.setTitle(message.getTitle());
					dto.setContent(message.getContent());
					dto.setPushType(message.getPushType());
					dto.setForwardUrl(message.getForwardUrl());
					dto.setNoticeType(message.getNoticeType());
					dto.setCreateBy(message.getCreateBy());
					dto.setCreateDate(message.getCreateDate());
					dto.setUpdateBy(message.getUpdateBy());
					dto.setUpdateDate(message.getUpdateDate());
					
					MessageSystemUtils.sendMessageForJson(account, dto);
					sendMore = true;
				}
			}
			
			// 如果是计数结束的则需要修改计数数据
			if( sendMore && message.getPushCount() != null 
					&& message.getPushCount() > 0 ) {
				message.setPushCount(message.getPushCount() - 1);
				needSaveList.add(message);
			}
		}
		
		for(ConMessageNoticeEntity entity : needSaveList) {
			MessageSystemUtils.saveOrUpdate(entity);
		}
	}
	
	/**
	* @Title: getMessageAccount
	* @Description: 获取将要接收消息的帐号集合
	* @param @param message
	* @return Set<String>
	* @throws
	 */
	public Set<String> getMessageAccount(ConMessageNoticeEntity message) {
		Set<String> accountSet = Sets.newHashSet();
		
		if("0".equals(message.getPushTarget())) { // 推送给指定用户（多个）
			// 根据用户ID获取用户帐号的集合
			if(message.getUsers() != null && !"".equals(message.getUsers().trim())) {
				String[] userIds = message.getUsers().split(",");
				List<Integer> userIdList = Lists.newArrayList();
				for(String userid : userIds) {
					userIdList.add(Integer.valueOf(userid));
				}
				
				List<SysUser> userList = userService.findByUserIds(userIdList);
				if(userList != null) {
					for(SysUser user : userList) {
						accountSet.add(user.getAccount());
					}
				}
			}
		} else if("1".equals(message.getPushTarget())) { // 推送给指定部门
			// 根据部门ID获取用户帐号的集合
			if(message.getDepts() != null && !"".equals(message.getDepts().trim())) {
				String[] deptIds = message.getDepts().split(",");
				List<Integer> deptIdList = Lists.newArrayList();
				for(String deptid : deptIds) {
					deptIdList.add(Integer.valueOf(deptid));
				}
				
				List<SysUser> userList = userService.findByDeptIds(deptIdList);
				if(userList != null) {
					for(SysUser user : userList) {
						accountSet.add(user.getAccount());
					}
				}
			}
		} else if("2".equals(message.getPushTarget())) { // 推送给全公司
			List<SysUser> userList = userService.findAll();
			if(userList != null) {
				for(SysUser user : userList) {
					accountSet.add(user.getAccount());
				}
			}
		}
		
		return accountSet;
	}
}
