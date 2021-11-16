<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String base = request.getContextPath(); %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>睿哲办公系统</title>
<link type="text/css" rel="stylesheet" href="<%=base %>/static/css/errorPage.css" />
<link rel="shortcut icon" href="<%=base %>/static/images/reyzar_favicon.ico">
</head>

<body>
<div class="error-container">
	<h1><img src="<%=base %>/static/images/warning.png">出错了</h1>
    <h2>Session 已过期！</h2>
    <!-- <div class="error-actions">
   	  <a href="#" class="error-btn">返回上级</a>
      <a href="#" class="error-btn gr-btn">返回首页</a>
    </div> -->
</div>
</body>
</html>
