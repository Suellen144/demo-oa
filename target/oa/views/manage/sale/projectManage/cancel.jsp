<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">财务管理</li>
		<li class="active">项目管理</li>
		<li class="active">注销管理</li>
	</ol>
	
	<style>
		.blackColor{
			color: #000000;
		}
	</style>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						<form id="searchForm" class="form-inline" role="form">
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<input type="hidden" id="projectId" name="projectId" value="${id}">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								
								<tr>
								
									<th>报销类型</th>
									<th>报销人</th>
									<th>发起时间</th>
									<th>报销单号</th>
									<th>当前环节</th>
									<th>项目名称</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						
					</div>
					<!-- /.box-body -->
				</div>
				<!-- /.box -->
			</div>
		</div>
	</section>
</div>
<div id="projectDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sale/projectManage/js/cancel.js"></script>
</body>
</html>