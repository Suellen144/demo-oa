<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<style type="text/css">
#dataTable_info, #dataTable_paginate {
	display: none;
}
 a{
            color: #8A8A8A;
            cursor: pointer;
        }
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">公共信息</li>
		<li class="active">公司通讯录</li>
	</ol>
</header>

<div class="wrapper">
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
               		  <ul class="nav navbar-nav navbar-left" id="tabUl">
              		  </ul>
              		  <select style="display: none;" name="title" id="title"><custom:dictSelect type="论坛版块" /></select>
					</div>
					<form>
						<input type="hidden" id="forumId" value="${map.tab }">
						<input type="hidden" id="status" value="${map.status }">
					</form>
<div class="panel panel-default" id="main" style="width: 70%;margin:1% 2% 5% 1%;float: left;">
    <div class="panel-heading" style="background-color: white">
        <a style="margin-right: 2%;<c:if test="${map.status eq 2 }">color: #3c8dbc;font-weight: bold;</c:if>"  href="javascript:selectStatus(2)">置顶</a><a style="margin-right: 2%;<c:if test="${map.status eq 1 }">color: #3c8dbc;font-weight: bold;</c:if>" href="javascript:selectStatus(1)">加精</a>
    </div>
<ul class="list-group" id="postUl" style="width: 100%">
	<c:forEach items="${postList }" var="post">
	<li class="list-group-item">
		<div style="height: 50px">
		<div style="float: left;width: 6%;margin: 0px 8px 0px 5px">
		<img width="50px" height="50px" src="<%=base%>/${post.user.photo }" class="img-rounded">
		</div>
		<div style="width: 80%;float: left;margin-left:15px;">
		<a href="<%=base%>/manage/office/review/findById?id=${post.id }">${post.title }</a><br/>
		<div>
		<a><span class="label label-default" >
			<%-- <select class="form-control" name="forumId" id="title"><custom:dictSelect type="论坛版块" /></select> --%>
			<custom:getDictKey type="论坛版块" value="${post.forumId }"/>
		</span></a>&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0);"><span ><strong>${post.user.name }</strong></span></a>&nbsp;&nbsp;&nbsp;
		<small class="text-muted"><fmt:formatDate value="${post.applyTime }" pattern="yyyy-MM-dd" /></small>
		<c:if test="${post.user.id eq  sessionScope.user.id &&  sessionScope.user.id != 2 } ">
				<a href="javascript:deletePost(${post.id })" style="margin-left: 60%">删除</a>
		</c:if>
		<c:if test="${sessionScope.user.id eq 2 }">
				<c:choose>
					<c:when test="${post.status eq 2 }">
							<a href="javascript:updateStatus(${post.id },1)" style="margin-left: 45%;font-weight: bold;">加精</a>
					</c:when>
					<c:when test="${post.status eq 1 }">
							<a href="javascript:updateStatus(${post.id },2)" style="margin-left: 45%;font-weight: bold;">置顶</a>
					</c:when>
					<c:otherwise>
							<a href="javascript:updateStatus(${post.id },2)" style="margin-left: 38%;font-weight: bold;">置顶</a>
							<a href="javascript:updateStatus(${post.id },1)" style="margin-left: 3%;font-weight: bold;">加精</a>
					</c:otherwise>
				</c:choose>		
				<c:choose>
					<c:when test="${post.audit eq 1 }">
						<a href="javascript:updateAudit(${post.id },0)" style="margin-left: 3%;font-weight: bold;">通过</a>
						<a href="javascript:deletePost(${post.id })" style="margin-left: 3%;font-weight: bold;">删除</a>
					</c:when>
					<c:otherwise>
						<a href="javascript:updateAudit(${post.id },1)" style="margin-left: 3%;font-weight: bold;">撤销</a>
						<a href="javascript:deletePost(${post.id })" style="margin-left: 3%;font-weight: bold;">删除</a>
					</c:otherwise>
				</c:choose>
		</c:if>
		</div>
		</div>
		<div style="width: 5%;float: right;text-align: center">
		<span class="badge">${post.replyCount }</span>
		</div>
		</div>
		</li>
		</c:forEach>
</ul>

</div>
<div class="panel panel-default" id="sidebar2" style="width: 20%;margin:1% 2% 1% 0%;float: right">
        <div class="panel-heading" style="background-color: white;text-align: center">
           
        </div>
        <ul class="list-group" style="width: 100%">
            <li class="list-group-item"><a href="${pageContext.request.contextPath }/manage/office/review/new">创作新主题</a></li>
            <li class="list-group-item"><a href="">0条未读提醒</a></li>
            <li class="list-group-item"><a href="">积分:</a></li>
        </ul>
    </div>
				</div>
				<!-- /.box -->
			</div>
		</div>
	</section>
</div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/office/post/js/list.js"></script>
</body>
</html>