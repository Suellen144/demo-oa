<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<style>
#myTab>li.active a{
	background-color: #3c8dbc;	
	color: white;
	font-weight: bold;
}

.modal-dialog {
	width: auto;
	max-width: 50%;
	height: auto;
	max-height: 60%;
}
.modal-body table{
	font-size:12px;
	empty-cells:show; 
	border-collapse: collapse;
	margin:0 auto;
}
.modal-body table th{
	white-space: nowrap;
}
.modal-body table td{
	white-space: nowrap;
}
.modal-body label {
	padding: 4px 10px;
}
.modal-body label span {
	font-weight: normal;
}
#weeklyReportTable td {
	border-bottom: 1px solid #ccc;
}
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">公共信息</li>
		<li class="active">文件管理</li>
	</ol>
</header>
<div class="wrapper">
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
						<shiro:hasPermission name="ad:filemanage:upload">
							<button class="btn btn-primary" onclick="toAddOrEdit('')">上传文件</button>
						</shiro:hasPermission>
					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th style="width:30%;">文件名</th>
								<!-- 	<th style="width:30%;">路径</th> -->
									<th style="width:20%;">修改时间</th>
									<th style="width:10%;">操作</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>
<div style="display: none;" id="hiddenDownLoad"><i class="glyphicon glyphicon-save" ></i></div>
<div style="display: none;" id="hiddenDelete"><i class="fa fa-fw fa-trash-o fa-lg "></i></div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/filemanage/js/list.js"></script>
</body>
</html>