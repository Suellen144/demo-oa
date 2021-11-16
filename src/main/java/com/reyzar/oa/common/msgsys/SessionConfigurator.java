package com.reyzar.oa.common.msgsys;

import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;
import javax.websocket.server.ServerEndpointConfig.Configurator;

public class SessionConfigurator extends Configurator {

	@Override
	public void modifyHandshake(ServerEndpointConfig config,
	        HandshakeRequest request, HandshakeResponse response) {
	    config.getUserProperties().put("user", 
	    		((HttpSession)request.getHttpSession()).getAttribute("user"));
	}
}
