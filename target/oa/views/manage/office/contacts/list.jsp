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
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
					 	<!-- 搜索条件 -->
						<form id="searchForm" class="form-inline" role="form">
							<div class="form-group">
								<label for="fuzzyContent" class="control-label">搜索内容</label>
								<input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配">
							</div>
							<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
							<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>部门</th>
									<th>姓名</th>
									<th>职位</th>
									<th>电话</th>
									<th>邮箱</th>
									<th>QQ</th>
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
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/office/contacts/js/list.js"></script>
</body>
</html>