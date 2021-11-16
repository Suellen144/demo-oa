var messageList = [];
var messageType = {"0":"工作提醒", "1":"流程提醒", "2":"公告信息", "3":"消息提醒"};
var messageTimeout = null; // 消息的定时对象
var timeout = 5000; // 默认5秒隐藏提示弹窗
var browserInfo = {}; // 浏览器名和版本号
var isHasNotice = false; // 是否拥有访问信息发布的权限
var isHasTodo = true;  // 是否拥有访问待办事项的权限

function forward(url) {
	$("#contentFrame").attr("src", url);
}

$("#contentFrame").on('load', function(){
	$(window).scrollTop(0);
	changeFrameHeight();
})

function changeFrameHeight(){
    var ifm= document.getElementById("contentFrame"); 
    ifm.height=document.documentElement.clientHeight;

}

window.onresize=function(){  
     changeFrameHeight();  

} 
function isNull(str){    	
		if (str == '' || str == undefined || str == 'undefined'|| str == null || str == 'null' || str=='NULL')
			return true;
		return false;  		
}


$(document).ready(function() {
	/*initMenu();*/
	/*initTodo();*/
	initEvent();
	/*initNotice();*/
	initWebSocket();
	/*initIFrameHeight();*/
	initHomePage();
	initBrowserInfo();
	initFileUpload();
	monitorMenu()
});


function monitorMenu () {
	if(window.screen.width < 769){
		$(".main-sidebar").css("padding-top","50px")
		$(".treeview-menu").find("li ul li").each(function(index,ele){
			$(this).click(function(){
				if($(this).children().length < 2 && $(this).get(0).tagName == "LI"){
					$("body").removeClass('sidebar-open')
					$("body").addClass('sidebar-collapse')
					
				}
			})

		});
	}
	
	
}

function initMenu() {
	var menuList = getMenuList();
	var menuTree = buildMenu(menuList, "#");
	sortMenu(menuTree[0].children);
	$(".sidebar-menu").html(buildMenuHTML(menuTree));
	$(".sidebar-menu").find("a:first").hide();
	
	// 依靠菜单链接而非菜单名来判断是否拥有该菜单访问权限
	$(menuList).each(function(index, menu) {
		if(menu.url == "/manage/office/noitce/toList") {
			isHasNotice = true;
		}
		/*if(menu.url == "/manage/office/pendflow/toList") {
			isHasTodo = true;
		}*/
	});
}

function sortMenu(menuList) {
	menuList.sort( compare("sort") );
	$(menuList).each(function(index, menu) {
		if(menu.children != null && menu.children.length > 0) {
			sortMenu(menu.children);
		}
	});
}

function compare(propertyName) {
	return function(object1, object2) {
		var value1 = object1[propertyName];
		var value2 = object2[propertyName];
		if (value2 < value1) {
			return -1;
		} else if (value2 > value1) {
			return 1;
		} else {
			return 0;
		}
	}
}

function getMenuList1() {
	var menuList = [];
	$.ajax({
		url: "getMenuList",
		async: false,
		dataType: "json",
		success: function(data) {
			menuList = data;
		},
		error: function(data) {
			bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
		}
	});
	
	return menuList;
}

function buildMenu(menuList, pid) {
	var result = [], temp;
	for(var i in menuList){
	    if(menuList[i].parent == pid){
	        result.push(menuList[i]);
	        temp = buildMenu(menuList, menuList[i].id);           
	        if(temp.length > 0){
	            menuList[i].children = temp;
	        }           
	    }       
	}
	
	return result;
}

function buildMenuHTML(menuTree) {
	var html = [];
	
	$(menuTree).each(function(index, obj) {
		if(obj.children == null 
				|| typeof obj.children == "undefined") {
			html.push("<li>");
			if(obj.url == null || obj.url == "") {
				html.push("<a href=\"javascript:;\"");
			} else {
				html.push("<a href=\"javascript:forward('"+base);
				html.push(obj.url);
				html.push("');\">");
			}
			var icon = (typeof obj.icon=="undefined" || obj.icon==null) ? 'fa fa-circle-o' : obj.icon;
			html.push("<i class='"+icon+"'></i> ");
			html.push(obj.text);
			html.push("</a></li>");
		} else {
			var childHtml = buildMenuHTML(obj.children);
			if(index == 0) {
				html.push("<li class='active'>")
			} else {
				html.push("<li>");
			}
			html.push("<a href=\"javascript:forward('"+base);
			html.push(obj.url);
			html.push("');\">");
			if(typeof obj.icon != "undefined" && obj.icon != null) {
				html.push("<i class='"+obj.icon+"'></i> ");
			}
			if(obj.parent != "#") {
				html.push("<i class='fa fa-angle-left pull-right'></i> ");
				html.push(obj.text);
			} else {
				html.push("<i class=''></i> ");
				html.push("");
			}
			html.push("</a>");
			html.push("<ul class='treeview-menu'>")
			html.push(childHtml);
			html.push("</ul>");
			html.push("</li>")
		}
	});
	
	return html.join("");
}

function toUserDetail() {
	var url = base + "/manage/sys/user/toDetail";
	forward(url);
}

function toChangePwd() {
	var url = base + "/manage/sys/user/toChangePwd";
	forward(url);
}

function initTodo() {
	$.ajax({
		url: base+"/manage/office/pendflow/getTodoList",
		dataType: "json",
		success: function(data) {
			if(isHasTodo) {
				if(!isNull(data) && data.length > 0) {
					$("#taskQuantity").text(data.length);
				} else {
					$("#taskQuantity").text("");
				}
			} else {
				$("#taskQuantity").text("");
				$("#taskQuantity").parent("a").attr("href", "javascript:void(0);");
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
		}
	});
}

function buildTodoHTML(data) {
	var html = [];

	html.push('<li>');
	html.push('	<a href="#">');
	html.push('		<div class="pull-left">');
	html.push('		</div>');
	html.push('		<h4>');
	html.push(			data.processName);
	html.push('		</h4>');
	html.push('	</a>');
	html.push('</li>');
	
	return html.join("");
}

function refreshInfo(obj) {
	$(obj).find("small").text(new Date().pattern("yyyy-MM-dd HH:mm:ss"));
}

function initEvent() {
	$("#dropDownMenu").mouseleave(function() {
		$(this).trigger("click");
	});
	
	$("#dropDownSetting").mouseleave(function() {
		$(this).trigger("click");
	});
}

function initHomePage() {
	$("ul.sidebar-menu").find("li").each(function(index, li) {
		if($(li).children("a").attr("href").indexOf("toPersonHome") > -1) {
			var href = $(li).children("a").attr("href");
			href = href.replace("javascript:forward('", "");
			href = href.replace("');", "");
			forward(href);
			return false;
		}
	});
}

function initNotice(){
	$.ajax({
		url: base+"/manage/office/noitce/getUnreadCount",
		success: function(data) {
			if(isHasNotice) {
				var url = "javascript:forward('"+web_ctx+"/manage/office/noitce/toList');";
				var count = "";
				if(!isNull(data) && data > 0){
					url = "javascript:forward('"+web_ctx+"/manage/office/noitce/toList?isRead=0');";
					count = data;
				}
				$("#noticeQuantity").text(count);
				$("#noticeQuantity").parent("a").attr("href", url);
			} else {
				$("#noticeQuantity").text("");
				$("#noticeQuantity").parent("a").attr("href", "javascript:void(0);");
			}
		},
		error: function(data) {
			bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
		}
	});
}

var webSocket = null;
function initWebSocket() {
	webSocket = $.initWebSocket({
		"onMessage": message
	});
}

function send(msg) {
	webSocket.send(msg);
}

function message(ev) {
	var remoteMessage = {}; // 收集新来的消息
	if(ev.data != null && $.trim(ev.data) != "") {
		var json = JSON.parse(ev.data);
		remoteMessage = json;
		
		if(!messageList[remoteMessage.id]) {
			var text = []
			var href = "";
			var clickFunc = "javascritp:void(0);";
			var title = "";
			var longTitle = "";
			// 标题
			if(remoteMessage.title.length > 20) {
				title = remoteMessage.title.substring(0,20) + "...";
				longTitle = remoteMessage.title;
			} else {
				title = remoteMessage.title;
			}
			// 推送类型
			if(remoteMessage.pushType == "1") {
				href = remoteMessage.forwardUrl;
			} else {
				href = "javascritp:void(0);";
				clickFunc = "showMsgContent("+remoteMessage.id+")";
			}
			
			text.push("<li style='border-bottom: 1px solid #4a4a4a;'>");
			text.push("<a title='"+longTitle+"' href='"+href+"' onclick='"+clickFunc+"'>");
			text.push(title);
			text.push("<span style='float:right;color:#bfab3f;'>"+messageType[remoteMessage.noticeType]+"</span>");
			text.push("</a>");
			text.push("</li>");
			
			$("#messageListPanel").find("ul.list-unstyled").prepend(text.join(""));
			$("#messageListPanel").show();
			
			$("#control-sidebar-msglist-tab").find("ul.control-sidebar-menu").prepend(text.join(""));
			
			messageList[remoteMessage.id] = remoteMessage;
			startTimeout();
		}
		
	}
	
}

function showMsgContent(msgId) {
	var message = messageList[msgId];
	$("#msgModal").find("div.modal-body").html(message.content);
	$("#msgModal").modal("show");
}

function startTimeout() {
	destroyTimeout();
	messageTimeout = setTimeout("messageHide()", timeout);
}

function destroyTimeout() {
	if(messageTimeout != null) {
		clearTimeout(messageTimeout);
	}
}

function messageHide() {
	$("#messageListPanel").hide();
	//$("#messageListPanel").fadeOut(3000);
}

function initIFrameHeight() {
	$("#contentFrame").height($("div.content-wrapper").height()-6);
	
	window.onresize = function() {
		var height = $("div.content-wrapper").height()
		$("#contentFrame").height(height-6);
	}
}

function logout() {
	localStorage.setItem( 'reyzar_datatables', "" ); // 清除datatables的分页数据
	window.location.href = "logout";
}

function backPage() {
	window.history.back(-1);
}


function initBrowserInfo() {
	var ua = navigator.userAgent.toLowerCase();
	var re =/(msie|firefox|chrome|opera|version).*?([\d.]+)/;
	var m = ua.match(re);
	browserInfo.browser = m[1].replace(/version/, "'safari");
	browserInfo.browser = browserInfo.browser == "msie" ? "ie" : browserInfo.browser;
	browserInfo.version = m[2];
}

/**
 * 获取浏览器名与版本号
 * @return browserInfo 
 *			browserInfo.browser：浏览器名
 *			browserInfo.version：版本号
 */
function getBrowserInfo() {
	return $.extend(true, {}, browserInfo);
}

function popWindow() {
	$("#encryptionKeyFile").trigger("click");
}
// 初始化导入授权上传文件方法
function initFileUpload() {
	$('#encryptionKeyFile').fileupload({
		url: base+'/manage/importEncryptionKey',
        dataType: 'json',
        maxFileSize: 200, // 200字节
        acceptFileTypes: /(txt)$/i,
        messages: {
        	maxFileSize: '文件大小最大为200字节！',
        	acceptFileTypes: '请导入txt文件类型的密钥！'
        },
        add: function (e, data) {
        	var $this = $(this);
        	data.process(function() {
        		return $this.fileupload('process', data);
        	}).done(function(){
        		data.submit();
        	}).fail(function() {
        		var errorMsg = [];
        		$(data.files).each(function(index, file) {
        			errorMsg.push(file.error);
        		});
        		bootstrapAlert("提示", errorMsg.join("<br/>"), 400, null);
        	});
        },
        done: function (e, data) {
        	if( data.result.code != 1 ) {
        		bootstrapAlert("提示", data.result.result, 400, null);
        	} else {
        		window.frames["contentFrame"].location.reload();
        	}
        }
    });
}