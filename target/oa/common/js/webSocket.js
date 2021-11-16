;(function( $ ) { 
	 $.extend({
	    initWebSocket: function( options ) {
			var webSocket = null;
			var ws = null;
			var methods = {
				"onMessages": []
			};
			var options_ = {
				"onMessage": {}
			};
			$.extend( options_, options );
			methods.onMessages.push(options_.onMessage);
			
			function Construct() {
				var client = new Object();
				
				initWebSocket();
				function initWebSocket() {
					if(ws == null && "WebSocket" in window) {
						try {
							ws = new WebSocket("ws://"+window.location.host+web_ctx+"/messageSystem");
							ws.onopen = open;
							ws.onmessage = message;
							ws.onclose = close; 
							ws.onerror = error;
						} catch(e) {
							console.log(e.message);
						}
					}
				}
				function open() {}
				function close(ev) {console.log("WebSocket Closed!");}
				function error(ev) {console.log("WebSocket Error!");}
				
				function message(ev) {
					var errorMethod = [];
					$(methods.onMessages).each(function(index, method) {
						try {
							method.call(this, ev);
						}catch(e) {
							errorMethod.push(index);
						}
					});
					
					$(errorMethod).each(function(index, arr_inx) {
						methods.onMessages.splice(arr_inx, 1);
					});
				}
				
				client.send = function(message) {
					if(ws != null) {
//						ws.send(message);
						sendMessage(message);
					} else {
						initWebSocket();
//						ws.send(message);
						sendMessage(message);
					}
				}
				
				function sendMessage(msg) {
			        waitForSocketConnection(ws, function() {
			            ws.send(msg);
			        });
			    };
				function waitForSocketConnection(socket, callback){
			        setTimeout(
			            function(){
			                if (socket.readyState === 1) {
			                    if(callback !== undefined){
			                        callback();
			                    }
			                    return;
			                } else {
			                    waitForSocketConnection(socket,callback);
			                }
			            }, 100);
			    };
				
				return client;
			}
			
			function getInstance() {
				if(webSocket == null || webSocket === undefined) {
					webSocket = new Construct();
				}
				return webSocket;
			}
			
			return getInstance();
		}
	 });
})(jQuery);
