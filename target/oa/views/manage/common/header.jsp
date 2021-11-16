<% String base = request.getContextPath(); %>
<% String pageTitle = new String("睿哲办公系统".getBytes("ISO-8859-1"), "UTF-8"); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/custom/tags" %>
<%@ taglib prefix="custom" uri="http://www.reyzar.com/oa/tags" %>

<meta http-equiv="Content-Type" content="text/html; charset=GB2312" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<meta name="renderer" content="webkit"><meta http-equiv="X-UA-Compatible" content="IE=8,IE=9,IE=10" />
<meta http-equiv="Expires" content="0"><meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Cache-Control" content="no-store">
<title><%=pageTitle%></title>
<link rel="shortcut icon" href="<%=base%>/static/images/reyzar_favicon.ico"/>
<!-- Style -->
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/font-awesome.min.css">
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/font-awesome-dark.min.css">
<link rel="stylesheet" href="<%=base%>/static/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="<%=base%>/static/AdminLTE/css/AdminLTE.css">
<link rel="stylesheet" href="<%=base%>/common/style/custom.css">

<link rel="stylesheet" href="<%=base%>/static/css/cssreset.css">
