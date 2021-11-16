<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="header.jsp"%>
    <link rel="stylesheet" href="<%=base%>/static/css/index.css">

   	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
  		<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  	<![endif]-->
  	<style>
  	#mainHeadImg{width: 30px;height: 30px;border-radius: 50%;}
  	.user-footer ul li{list-style:none;width:100%;}
  	.user-footer ul li a{text-align: center;display: inline-block;width: 100%;line-height:45px;color:#333;}
  	.user-footer ul li a:hover{background:#4289FF;color:#fff;}
  	.user-footer ul{padding:0;margin:0;clear: both;overflow: hidden;}
  	.user-footer p{text-align: center; line-height:45px;border-bottom:1px solid #d7d7d7;}
  	.out:before {position: relative;top:5px;}
  	.wheader100 .head-main{width:100%;padding:0 45px;}
  	.content100 {width:100%;padding:0 45px;}
  	</style>
  	
</head>
<body>

<!-- header -->
<header class="main-header">
    <div class="head-main">
        <a href="main">       
            <img class="logo-box" src="<%=base%>/static/images/index/logo.png" alt="睿哲科技">
        </a>

        <ul class="nav navbar-nav navbar-right">
        	<li>
                <a href="javascript:forward(history.go(-1));" id="quit">
                    <i class="nav-icon out fa fa  fa-reply"></i>
                </a>
            </li>
        	
            <li class="dropdown">
            	<a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown"> 
            		<c:if test="${not empty sessionScope.user.photo }">
						<img id="mainHeadImg" src="<%=base%>${sessionScope.user.photo}" class="user-image" alt=" ">
					</c:if> 
					<c:if test="${empty sessionScope.user.photo }">
						<img id="mainHeadImg" src="<%=base%>/static/AdminLTE/img/avatar04.png" class="user-image" alt=" ">
					</c:if>
				</a>
                
                <ul class="dropdown-menu" id="dropDownMenu" style="left:0px;">
					
					<!-- Menu Footer-->
					<li class="user-footer">
						<p>${sessionScope.user.name }</p>
						<ul>
							<li class="pull-left"><a href="javascript:void(0)" onclick="toUserDetail()">个人信息</a></li>
							<shiro:hasAnyPermission name="fin:reimburse:encrypt,fin:reimburse:decrypt,fin:travelreimburse:encrypt,fin:travelreimburse:decrypt">
								<li class="pull-left"><a href="javascript:void(0)" onclick="popWindow()">解锁</a></li>
								<form action="importEncryptionKey" style="display:none;">
									<input type="file" id="encryptionKeyFile" name="encryptionKeyFile" accept="text/plain">
								</form>
							</shiro:hasAnyPermission>
							<li class="pull-left"><a href="javascript:void(0)" onclick="logout()">注销</a></li>
						</ul>
					</li>
				</ul>
                
            </li>
            
            <li>
                <a href="main">
                    <i class="nav-icon home glyphicon glyphicon-home"></i>
                </a>   
            </li>
            <li class="dropdown" id="tableMenu">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="nav-icon more glyphicon glyphicon-option-vertical"></i></a>
                <ul class="dropdown-menu menu-top dropdownMenu"></ul>
            </li>
        </ul>
    </div>
</header>
<!-- 第一块 -->
<section id="content">
    <div class="ifm">
        <iframe id="contentFrame" name="contentFrame" width="100%" frameborder="no" ></iframe>
    </div>
</section>

<footer>
    ©睿哲科技股份有限公司 2012-2019
</footer>

<script src="<%=base%>/static/jquery/jquery-1.11.1/jquery.min.js"></script>
<script src="<%=base%>/static/bootstrap/js/bootstrap.min.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script src="<%=base%>/views/manage/common/js/main.js"></script>
<script src="<%=base%>/common/js/messageBox.js"></script>
<script src="<%=base%>/common/js/webSocket.js"></script>
<script type="text/javascript">
	base = "<%=base%>";
	web_ctx = "<%=base%>"; // 全局变量“应用名称”，所有脚本可用
</script>

<script>
	
	$(function(){
		forward(base+'/manage/sys/user/toPersonHome');
		getMenuList()
		
	})
	
	window.onload = function(){
		setIframeHeight($('#contentFrame')[0]);
        
        $('#contentFrame').each(function (index) {
            var that = $(this);
            (function () {
                setInterval(function () {
                    setIframeHeight(that[0])
                }, 200)
            })(that)
        });
	}
	
	
	function forward(url) {
		$("#contentFrame").attr("src", url);
	}
	
	function toUserDetail() {
		var url = base + "/manage/sys/user/toDetail";
		forward(url);
	}
	
	function setIframeHeight(iframe) {
		
	    if (iframe) {
	        var iframeWin = iframe.contentWindow || iframe.contentDocument.parentWindow;
	        if (iframeWin.document.body) {
	        	if(parseInt(window.document.body.offsetHeight - 160) > parseInt(iframeWin.document.body.scrollHeight)){
	        		iframe.height = parseInt(window.document.body.offsetHeight - 165);	     
	        	}else{
	        		iframe.height = iframeWin.document.body.scrollHeight;
	        	}
	            
	        }
	    }
	};
	
	function logout() {
		localStorage.setItem( 'reyzar_datatables', "" ); // 清除datatables的分页数据
		window.location.href = "logout";
	}
	
	function getMenuList() {
		var menuList = [];
		$.ajax({
			url: "getMenuList",
			async: false,
			dataType: "json",
			success: function(data) {
				$.each(data, function(i,j) {
				
					var html = '';
					if(j.children.length > 0){
						
						$.each(j.children, function(x,y) {
							html += '<li><a tabindex="-1" href="javascript:forward(\''+base+y.url+'\')">'+y.name+'</a></li>';
						});						
						$(".dropdown .menu-top").append('<li class="dropdown-submenu pull-left"><a href="javascript:void(0)" tabindex="-1" class="aTitle lTitle">'+j.text+'</a><ul class="dropdown-menu dropdown-menu-left">'+html+'</ul></li>');
					}else{
						if(j.url != ""){
							$(".dropdown .menu-top").append('<li><a href="javascript:forward(\''+base+j.url+'\')" class="lTitle">'+j.text+'</a></li>')
						}else{
							$(".dropdown .menu-top").append('<li><a href="javascript:void(0)" class="lTitle">'+j.text+'</a></li>')
						}
					}
					
				});
				menuHover();
				clickMenu()
			},
			error: function(data) {
				bootstrapAlert("提示", "获取菜单数据出错！", 400, null);
			}
		});
	}
	
	
	
	function menuHover(){				
		$('.menu-top').find('.lTitle').hover(function(){
			$(this).css({'background':'#4289ff','color':'#fff'})
		},function(){
			$(this).css({'background':'#fff','color':'#333'})
		})
		
		$(".dropdown-menu-left li").hover(function(){			
			$('.menu-top').find('.lTitle').css({'background':'#fff','color':'#333'})
			$(this).parent().parent().find('.aTitle').css({'background':'#4289ff','color':'#fff'})
		},function(){
			$('.menu-top').find('.lTitle').css({'background':'#fff','color':'#333'})
		})
		
		$("#tableMenu").hover(function(){//鼠标悬停触发事件
        	$(".menu-top").show()
        	$(this).addClass("open")
        },function(){
        	$(".menu-top").hide()
        	$(this).removeClass("open")
        });
	}
	
	function clickMenu(){
		$("#tableMenu .menu-top").find('a').each(function(){
			$(this).click(function(){
				if($(this).text() != '办公桌面' && $(this).attr("href") != 'javascript:void(0)'){					
					$(".main-header").addClass('wheader100')
					$("#content").addClass('content100')					
				}else{
					$(".main-header").removeClass('wheader100')
					$("#content").removeClass('content100')
				}
				$("#contentFrame").attr('height','auto')
			})
			
		})
	}
	
</script>

</body>
</html>