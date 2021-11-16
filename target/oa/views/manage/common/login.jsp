<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="header.jsp"%>
    <link rel="stylesheet" href="<%=base%>/static/css/login.css">
</head>
<body>
<div id="mian">			
	<div class="loginBox">
        <div class="loginLogo">
            <i class="logo"></i>
            <span class="logoTxt">睿哲办公平台</span>
        </div>
        <form id="form1"  method="post" class="loginForm">
        	<div class="loginIn">
	            <div class="inI">	                
	                <input type="text" id="username" name="username" placeholder="请输入用户名"/>
	            </div>
	            <div class="inI">	       
	                <input type="password" id="password" name="password" placeholder="请输入密码"/>
	            </div>
	            <input type="button" class="loginBtn" value="登录" id=""  onclick="loginsub()"/>
	        </div>
        </form>
    </div>
</div>

<footer class="loginf">
    版权所有©睿哲科技股份有限公司 2012-2019。保留一切权利。
</footer>

<script src="<%=base%>/static/js/jQuery-2.2.0.min.js"></script>
<script src="<%=base%>/static/bootstrap/js/bootstrap.min.js"></script>
<script src="<%=base%>/static/js/layer/layer.js"></script>



<script type="text/javascript">
var base = '<%=base%>';

if(window != top) {
	top.location.href = location.href; 
}

$(document).ready(function () {
  	//添加回车响应事件
	$(document).keydown(function(event){
    	var curkey = event.which;
    	if(curkey == 13){
    		loginsub();
    	}
    });
});

function loginsub() {
	var formStr =  $("#form1").serializeArray();
	var isok='${isok}';
	if(isok == 1){
		layer.msg('手机端暂未开放')
		return false
	}else if(formStr[0].value.length <= 0 ){
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
	        data: $("#form1").serialize(),
	        success: function (data) {			 	
	            if(data.check) {
	            	location.href = base+'/manage/main'
	            } else {
	            	layer.msg(data.errorMsg)
	            } 
	        }
	    });	
	}
	return false;
}

</script>
</body>
</html>