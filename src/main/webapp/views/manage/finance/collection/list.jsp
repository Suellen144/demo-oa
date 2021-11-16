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
		<li class="active">行政管理</li>
		<li class="active">收款管理</li>
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
								<c:if test="${sessionScope.user.id eq '3'}">
									<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toAdd()" style="height: 35px;text-align: center;">添加收款审批</button></td>
								</c:if>
									<td><label for="fuzzyContent" class="control-label" style="margin-left: 10px">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left: 4px"></td>
									<td><label for="status" class="control-label"  style="margin-left: 8px">审批环节</label></td>
									<td>
										<select id="status" name="status" class="form-control" style="margin-left: 4px">
											<option value=" "></option>
											<option value="1">部门经理审批</option>
											<option value="2">财务审批</option>
											<option value="3">总经理审批</option>
											<option value="4">出纳审批</option>
											<option value="5">已归档</option>
										</select>
									</td>
									<td><button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button></td>
									<td><button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button></td>
								</tr>
							</table>
						</form>

					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>部门</th>
									<th>发起人</th>
									<th>合同编号</th>
									<th>项目名称</th>
									<th>付款单位</th>
									<th>申请金额</th>
									<th>发起时间</th>
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

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/list.js"></script>
</body>
</html>