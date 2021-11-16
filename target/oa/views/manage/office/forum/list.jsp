<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link href="<%=base%>/static/plugins/permanent-calendar/permanentCalendar.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<%=base%>/static/css/oaMain.css">
<style type="text/css">
#dataTable_info, #dataTable_paginate {
	display: none;
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
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
					<div class="col-md-3">
						<a id="pendflow" href="<%=base%>/manage/office/pendflow/toList">
							<div class="blockBox">
								<div class="blockBoxL">
									<div class="blockBoxTit green">待办任务</div>
									<div class="blockBoxNum green" id="taskQuantity"></div>
								</div>
								<div class="blockBoxR"><img src="<%=base%>/static/images/main/icon03.png" alt=""></div>
							</div>
						</a>
					</div>
					<div class="col-md-3">
						<a id="notice" href="<%=base%>/manage/ad/workReport/toList">
							<div class="blockBox">
								<div class="blockBoxL">
									<div class="blockBoxTit blue">工作汇报</div>
									<div class="blockBoxNum blue"></div>
								</div>
								<div class="blockBoxR"><img src="<%=base%>/static/images/main/functionPic1.png" alt=""></div>
							</div>
						</a>
					</div>
					<div class="col-md-3">
						<a  href="<%=base%>/manage/office/noitce/findPointToList">
							<div class="blockBox">
								<div class="blockBoxL">
									<div class="blockBoxTit orange">待阅通知</div>
									<div class="blockBoxNum orange" id="noticeQuantity"></div>
								</div>
								<div class="blockBoxR"><img src="<%=base%>/static/images/main/icon01.png" alt=""></div>
							</div>
						</a>
					</div>
					<div class="col-md-3">
						<a href="<%=base%>/manage/office/noitce/findDocumentToList">
							<div class="blockBox">
								<div class="blockBoxL">
									<div class="blockBoxTit red">待阅文件</div>
									<div class="blockBoxNum red" id="documentQuantity"></div>
								</div>
								<div class="blockBoxR"><img src="<%=base%>/static/images/main/icon02.png" alt=""></div>
							</div>
						</a>
					</div>
				</div>
	</section>
</div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/office/contacts/js/list.js"></script>
</body>
</html>