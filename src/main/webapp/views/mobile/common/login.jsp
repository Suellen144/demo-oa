<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String base = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- UC强制全屏 -->
	<meta name="full-screen" content="yes">
	<!-- QQ强制全屏 -->
	<meta name="x5-fullscreen" content="true">
    <title>睿哲办公系统</title>
    <link rel="stylesheet" href="<%=base%>/static/mobile/css/cssreset.css">
    <link rel="stylesheet" href="<%=base%>/static/mobile/css/m_login.css">
    <script src="<%=base%>/static/mobile/js/rem.js"></script>

</head>
<body>
	<div id="main">
		<div id="h_title">
			<h1>欢迎使用！</h1>
			<h2>睿哲办公系统</h2>
		</div>
		<form id='mobilefrom'>
			<ul>
				<li>
					<p>登录账号</p>
					<input type="text" name="username" id="username" placeholder="请输入登录账号" autocomplete="off"/>
				</li>
				<li>
					<p>密码</p>
					<input type="password" name="password" id="password" placeholder="请输入登录密码" autocomplete="off" autocomplete="new-password"/>
				</li>
				<li>
					<input type="button" name="" id="" value="登录" onclick='loginsub()'/>
				</li>
			</ul>
		</form>
	</div>
	<footer>©睿哲科技股份有限公司 2012-2019</footer>
</body>
</html>
<script src="<%=base%>/static/js/jQuery-2.2.0.min.js"></script>
<script src="<%=base%>/static/mobile/js/layer/layer.js"></script>

<script>
	var base = '<%=base%>';
	function loginsub() {
		var formStr =  $("#mobilefrom").serializeArray();
		if(formStr[0].value.length <= 0 ){
			layer.msg('请输入登录账号')
			return false
		}else if(formStr[1].value.length <= 0 ){
			layer.msg('请输入登录密码')
			return false
		}else{
			$.ajax({
		        url: base+'/manage/login',
		        type: "post",
		        dataType: "json",
		        data: $("#mobilefrom").serialize(),
		        success: function (data) {			 	
		            if(data.check) {
		            	/* location.href = base+'/manage/mIndex' */
		            	location.href = base+'/manage/main2'
		            } else {
		            	layer.msg(data.errorMsg)
		            } 
		        }
		    });	
		}
		return false;
	}
	
	var h = window.innerHeight;
	var myInput = document.getElementById('username');

	myInput.addEventListener('focus',handler,false);

	function handler(){
	    $('body').height(h);
	    $('footer').css('bottom','0')
	}

</script>