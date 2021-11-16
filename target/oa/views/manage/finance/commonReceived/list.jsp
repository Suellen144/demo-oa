<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
</head>
<body>
<header>
<!-- 	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">流水号管理</li>
		
	</ol> -->
</header>
<style>
#myTab>li.active a{
	background-color: #3c8dbc;	
	color: white;
	font-weight: bold;
}
</style>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						 <form id="searchForm" class="form-inline" role="form">
							 <table id="searchTable">
								<tr>
									<td><label for="fuzzyContent" class="control-label" style="margin-left: 10px">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left: 4px"></td>
									<td><select name="payCompany"  id="payCompany" class="form-control" onchange="drawTable()"><option  value=""></option><custom:dictSelect type="流程所属公司" selectedValue=""/></select></td>
								<td><button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button></td>
								<td><button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button></td>
								<td><button id="addBtn" type="button" class="btn btn-primary" onclick="add()" style="height: 35px;margin-left:10px;text-align: center;">添加常规收款</button></td>
							</tr>
						</table>
					</form>
						
					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>所属部门</th>
									<th>申请人</th>
									<th>所属月份</th>
									<th>收款单位</th>
									<th>发起时间</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
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
<script type="text/javascript" src="<%=base%>/views/manage/finance/commonReceived/js/list.js"></script>
</body>
</html>