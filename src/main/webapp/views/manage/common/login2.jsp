<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="header.jsp"%>
<style>
*{ box-sizing:border-box; text-decoration:none; font-family:"Source Han Sans CN"; font-size:14px;}
html{ color:#eef2f5; background:#384556; }
body,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,footer,article,aside,header,section,nav,figure,figcaption,hgroup,button{ margin:0; padding:0; }
body{background-color:#384556;}
ol,ul{ list-style:none; }
input,textarea,select{ font-family:inherit; font-size:inherit; font-weight:inherit; *font-size:100%; }
.clearfix:after{ clear:both; display:block; content:"."; visibility:hidden; line-height:0; font-size:0; height:0; *zoom:1; }

html{ height: 100%;}
body{ height: 100%; background: url(<%=base%>/static/images/login/loginBg.jpg) no-repeat center; background-size: cover;}
.loginWrap{ width: 365px; height: auto; margin: 0 auto; padding-top: 130px;}
.loginTit{ width: 100%; height: 60px; margin-bottom: 45px;}
.loginTitPic{ width: 50%; height: 60px; float: left; border-right: 1px solid #2a4678;}
.loginTitPic img{ height: 60px;}
.loginTitName{ width: 50%; line-height: 60px; text-align: right; font-size: 20px; color: #2a4678; border-left: 1px solid #2a4678; float: left;}
.loginForm{ width: 210px; display: block; margin: 0 auto;}
.loginFormBox{ width: 100%; height: 35px; border: 1px solid #b3b3b3; background-color: #fff; border-radius: 10px; margin-bottom: 10px;}
.formPic{ width: 32px; line-height: 35px; text-align: center; float: left;}
.formPic img{ vertical-align: middle;}
.formInput{ width: 160px; height: 30px; margin: 0 10px 0 38px;}
.formInput input{ width: 100%; height: 30px; line-height: 30px; border: 0; color: #707070; font-size: 14px;outline:medium;}
.formInput .yzBox{ width: 65px;}
.yzPic{ width: 90px; /*height: 20px;*/ margin: 2px 0; float: right;}
.yzPic img{ width: 100%; display: block;}
.formTips{ width: 100%; line-height: 12px; font-size: 12px; font-weight: bold; color: #ff0000;}
.formOther{ width: 100%; line-height: 12px; margin: 10px 0 20px; color: #2a4678; font-size: 12px;}
.formOther input{ width: 12px; height: 12px; margin-right: 5px; vertical-align: bottom;}
.formOther a{ color: #7a7a7a; margin-left: 10px;}
.formLoginBtn{ width: 100%; height: 36px; border: 0; border-radius: 10px; color: #fff; background: url(<%=base%>/static/images/login/btnBg.png) repeat-x;}
.loginCopyright{ width: 100%; line-height: 12px; font-size: 12px; text-align: center; color: #757575; margin-top: 30px;}

</style>
</head>
<body>
	<!-- /container -->
	<div class="loginWrap clearfix">
        <div class="loginTit clearfix">
            <div class="loginTitPic"><img src="<%=base%>/static/images/login/logo.png" /></div>
            <div class="loginTitName">睿哲科技办公平台</div>
        </div>
        <form id="form1" action="<%=base%>/manage/login" method="post" class="loginForm">
            <div class="loginFormBox">
                <div class="formPic"><img src="<%=base%>/static/images/login/icon01.png" /></div>
                <div class="formInput">
                    <input type="text" id="username" name="username" placeholder="账号"  required oninvalid="setCustomValidity('账号不能为空！');" oninput="setCustomValidity('');" autofocus/>
                </div>
            </div>
            <div class="loginFormBox">
                <div class="formPic"><img src="<%=base%>/static/images/login/icon02.png" /></div>
                <div class="formInput">
                    <input type="password" id="password" name="password" placeholder="密码"  required oninvalid="setCustomValidity('密码不能为空！');" oninput="setCustomValidity('');"/>
                </div>
            </div>
            <div class="loginFormBox">
                <div class="formPic"><img src="<%=base%>/static/images/login/icon03.png" /></div>
                <div class="formInput">
					<input type="text" name="validateCode" class="yzBox"  placeholder="验证码" style="ime-mode:disabled;" />
                    <div class="yzPic"><img id="validateCodeImg" style="height: 30px" src="<%=base%>/manage/validateCode"  onclick="javascript:reloadValidateCode();" /></div>
                </div>
            </div>
            <div class="formTips">${errorMsg }</div>
            <div class="formOther">
                <input type="checkbox" id="isRememberMe" name="isRememberMe" value="true"> 记住密码
            </div>
            <button type="button" onclick="login()" class="formLoginBtn">登&nbsp;&nbsp;&nbsp;&nbsp;录</button>
        </form>
        <div class="loginCopyright">版权所有©睿哲科技股份有限公司 2012-2019。保留一切权利。</div>
    </div>

<script type="text/javascript" src="<%=base%>/static/jquery/jquery-1.11.1/jquery.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/jquery/cookie/jquery.cookie.js"></script>
<script>
if(window != top) {
	top.location.href = location.href; 
}

$(document).ready(function () {
    if ($.cookie("isRememberMe") == "true") {
	    $("#isRememberMe").attr("checked", true);
	    $("#username").val($.cookie("username"));
	    $("#password").val($.cookie("password"));
    }
  	//添加回车响应事件
	$(document).keydown(function(event){
    	var curkey = event.which;
    	if(curkey==13){
    		login();
    	}
    });
});

function login() {
	SavePassword();
	$("#form1").submit();
}


function reloadValidateCode(){
    $("#validateCodeImg").attr("src","<%=base%>/manage/validateCode?data=" + new Date() + Math.floor(Math.random()*24));
}


//记住用户名密码
function SavePassword() {
    if ($("#isRememberMe").is(":checked")) {
        var username = $("#username").val();
        var password = $("#password").val();
        $.cookie("isRememberMe", "true", { expires: 7 }); //存储一个带7天期限的cookie
        $.cookie("username", username, { expires: 7 });
        $.cookie("password", password, { expires: 7 });
    } else {
        $.cookie("isRememberMe", "false", { expire: -1 });
        $.cookie("username", "", { expires: -1 });
        $.cookie("password", "", { expires: -1 });
    }
}
</script>
</body>
</html>