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
    <h2>服务器错误，请联系管理员！</h2>
    <pre>错误信息：
<%= exception.getMessage()%></pre>

	<div>
		<a href="javascript:history.go(-1);" style="font-size:2em; font-weight:bold;">点击返回</a>
	</div>
</div>
</body>
</html>
