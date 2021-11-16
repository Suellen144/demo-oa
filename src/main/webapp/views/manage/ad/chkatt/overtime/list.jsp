<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style type="text/css">
#searchTable tr {
	float: left;
}
#searchTable label {
	text-align: right;
	line-height:2.5em;
	padding: 0px 0.5em 0px 1em;
}

#startTime, #endTime {
	width: 20%;
}
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">行政管理</li>
		<li class="active">加班管理</li>
	</ol>
</header>

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
									<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toAdd()">申请加班</button></td>
									<td><label for="fuzzyContent" class="control-label">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配"></td>
									
									<td><label for="" class="control-label">加班时间</label></td>
									<td>
										<input class="form-control" id="startTime" name="startTime" placeholder="起始时间" style="background-color: inherit;" readonly>
										<span>到</span>
										<input class="form-control" id="endTime" name="endTime" placeholder="结束时间" style="background-color: inherit;" readonly>
										
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
									<th>部门</th>
									<th>发起人</th>
									<th>发起时间</th>
									<th>加班开始时间</th>
									<th>加班结束时间</th>
									<th>时长</th>
									<th>当前环节</th>
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

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/overtime/js/list.js"></script>
</body>
</html>