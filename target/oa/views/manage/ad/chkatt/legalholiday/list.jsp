<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<style type="text/css">

#legWorksTable {
	width: 100%;
	border: none;
	margin: 5px 20px;
}
#legWorksTable td {
	border: solid #999 1px;
	padding: 5px;
	text-align: center;
}
#legWorksTable th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
#legWorksTable td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

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
		<li class="active">行政管理</li>
		<li class="active">假日管理</li>
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
									<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toAdd()">假日添加</button></td>
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
									<th>假日名称</th>
									<th>所属月份</th>
									<th>开始时间</th>
									<th>结束时间</th>
									<th>法定</th>
									<th>法定天数</th>
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

<!-- Modal -->
<div class="modal fade" id="legWorkModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-sm-15" style="width:90%;min-height: 30%">
      	<div class="modal-content">
		  <div class="modal-header"></div>
         <div class="modal-body" id = "modal-body" style="max-height:500px;">
         </div>
         
         <div class="modal-footer" id ="button">
         		<!-- <button type="button" class="btn btn-default" id = "delete" >删除</button> -->
       			<!-- <button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button> -->
         </div>
      </div>
	</div>
</div>

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/legalholiday/js/list.js"></script>
</body>
</html>