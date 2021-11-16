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
		<li class="active">项目管理</li>
		<li class="active">收款申请管理</li>
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
									<td><label for="fuzzyContent" class="control-label" style="margin-left: 10px">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left: 4px"></td>
									<td><label for="status" class="control-label"  style="margin-left: 8px">状态</label></td>
									<td>
										<select id="status" name="status" class="form-control" style="margin-left: 4px">
											<option value="1">收款</option>
											<option value="2">付款</option>
										</select>
									</td>
									<td><button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button></td>
								</tr>
							</table>
						</form>
					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th style="text-align: center;width: 10%">合同编号</th>
									<th style="text-align: center;width: 30%">合同名称</th>
									<th style="text-align: center;width: 30%">所属项目</th>
									<th style="text-align: center;width: 15%">合同总额</th>
									<th style="text-align: center;width: 15%" id="replace">收款金额</th>
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
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/listNew.js"></script>
</body>
</html>