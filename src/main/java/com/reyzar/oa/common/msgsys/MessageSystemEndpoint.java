package com.reyzar.oa.common.msgsys;

import java.io.IOException;

import javax.websocket.CloseReason;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.reyzar.oa.domain.SysUser;

/** 
* @ClassName: MessageSystemEndpoint 
* @Description: 消息推送系统WebSocket端点
* @author Lin 
* @date 2016年7月13日 下午2:11:09 
*  
*/
@ServerEndpoint(value="/messageSystem", 
				configurator=SessionConfigurator.class)
public class MessageSystemEndpoint {
	
	private Session session;
	private int count = 0;
	@OnOpen
	public void onOpen(Session session) throws IOException {
		this.session = session;
		WebClientUtils.addWebClient(this, (SysUser)session.getUserProperties().get("user"));
	}

	@OnMessage
	public String onMessage(String message) {
		return message;
	}

	@OnError
	public void onError(Throwable t) {}

	@OnClose
	public void onClose(Session session, CloseReason reason) {
		WebClientUtils.removeWebClient(((SysUser)session.getUserProperties().get("user")).getAccount());
	}
	
	public void sendMessage(String message) throws IOException {
		this.session.getBasicRemote().sendText(message);
	}
	
	public void close() {
		try {
			this.session.close();
		} catch (IOException e) {}
	}
}
