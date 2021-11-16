<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<style type="text/css">
#searchTable tr {
	float: left;
}
#searchTable label {
	text-align: right;
	line-height:2.5em;
	padding: 0px 0.5em 0px 1em;
}

th{
	white-space: nowrap;
}
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">客户管理</li>
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
							<button type="button" class="btn btn-primary" onclick="tooAdd()" style="float:left;margin-right:10px;">添加客户信息</button>
							<div class="form-group">
								<label for="fuzzyContent" class="control-label">搜索内容</label>
								<input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left:10px;">
								<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
								<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
							</div>
							
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th style="width:12%" >客户姓名</th>
									<th style="width:20%">所在单位</th>
									<th style="width:10%">客户职位</th>
									<th style="width:12%">联系方式</th>
									<th style="width:12%">邮箱</th>
									<th>地址</th>
									<th>相关项目</th>
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
<script type="text/javascript" src="<%=base%>/views/manage/ad/clientmanage/js/list.js"></script>
</body>
</html>