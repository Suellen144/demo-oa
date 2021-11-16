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
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">角色设置</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
			<!-- 		<div class="box-header">
						 <button id="addBtn" class="btn btn-primary" onclick="toAddOrEdit('')">新增</button>
					</div> -->
					<div class="box-header">
						 <form id="searchForm" class="form-inline" role="form">
							 <table id="searchTable">
								<tr>
									<td><button id="addBtn" type="button"  class="btn btn-primary" onclick="toAddOrEdit('')">新增</button></td>
									<td><label for="fuzzyContent" class="control-label">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配"></td>
									<td>
										<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
										<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>角色名</th>
									<th>英文名</th>
									<th>状态</th>
									<th>操作</th>
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
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/sys/role/js/list.js"></script>
</body>
</html>