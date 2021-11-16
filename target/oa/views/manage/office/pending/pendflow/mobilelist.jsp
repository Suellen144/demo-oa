<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
	<style>
		/*待办事务列表*/
		.todoLiBox {
			width: 100%;
			height: auto;
			background-color: #fff;
			border: 1px solid #edf2f6;
			border-radius: 5px;
			box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
			margin-bottom: 20px;
		}

		.todoLiHead {
			width: 100%;
			height: 50px;
			line-height: 50px;
			border-bottom: 1px solid #edf2f6;
			padding: 0 15px
		}

		.todoLiHead img {
			width: 30px;
			display: inline-block;
			margin-bottom: 5px;
			margin-right: 15px;
		}

		.todoLiHead span {
			font-size: 16px;
			color: #333;
		}

		.todoLiHead i {
			font-size: 12px;
			font-style: normal;
			color: #999;
			float: right;
		}

		.todoLiConn {
			width: 100%;
			height: auto;
		}

		.todoLiConnL {
			width: 50%;
			padding: 15px 0;
			border-right: 1px solid #edf2f6;
			float: left;
		}

		.todoLiConnR {
			width: 50%;
			padding: 15px 0;
			float: right;
		}

		.todoLiConnTit {
			width: 100%;
			line-height: 14px;
			color: #999;
			font-size: 14px;
			text-align: center;
			padding-bottom: 10px;
		}

		.todoLiConnMsg {
			width: 100%;
			line-height: 18px;
			color: #3c8dbc;
			font-size: 18px;
			text-align: center;
		}
	</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">待办事宜</li>
	</ol>
</header>

<div class="content-wrapper">
	<!-- Main content -->
	<section class="content" id = "dataTable">
		<input id="userId" name="userId" value="${sessionScope.user.id}" type="hidden">
	</section>
</div>

<%@ include file="../../../common/footer.jsp"%>
<script src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/office/pending/pendflow/js/mobilelist.js"></script>
<script type="text/javascript">
var flag = '<shiro:hasPermission name="off:pendflow:approveall">true</shiro:hasPermission>';
var approve = '<shiro:hasPermission name="ad:kpi:approve">true</shiro:hasPermission>';
var deptId= ${deptid};
</script>
</body>
</html>