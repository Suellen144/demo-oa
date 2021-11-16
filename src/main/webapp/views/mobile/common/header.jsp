<% String base = request.getContextPath(); %>
<% String pageTitle = new String("睿哲办公系统".getBytes("ISO-8859-1"), "UTF-8"); %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/custom/tags" %>
<%@ taglib prefix="custom" uri="http://www.reyzar.com/oa/tags" %>

<meta charset="utf-8">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

<!-- UC强制全屏 -->
<meta name="full-screen" content="yes">
<!-- QQ强制全屏 -->
<meta name="x5-fullscreen" content="true">

<title><%=pageTitle%></title>
<link rel="stylesheet" href="<%=base%>/static/mobile/css/cssreset.css">
<link rel="stylesheet" href="<%=base%>/static/mobile/css/iconfont.css" />
<link rel="stylesheet" href="<%=base%>/static/mobile/css/m_footer.css"/>
<script src="<%=base%>/static/mobile/js/rem.js"></script>