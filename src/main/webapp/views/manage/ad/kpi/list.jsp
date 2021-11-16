<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>

.control-label {
	padding-left: 1em;
	padding-right: 0.5em;
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
							<div class="form-group">
								<td><label for="fuzzyContent" class="control-label">搜索内容</label></td>
								<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配"></td>
							</div>
							<td><label for="roleName_duplicate" class="control-label">考核月份</label></td>
							<div  class="form-group">
									<input class="form-control" id="beginDate" name="beginDate" placeholder="开始月份" style="background-color: inherit;" readonly>
										<span>到</span>
									<input class="form-control" id="endDate" name="endDate" placeholder="结束月份" style="background-color: inherit;" readonly>
							</div>
							<shiro:hasAnyRoles name="deptadmin,boss">
								<div class="form-group">
									<td><label for="isDelete" class="control-label">是否离职</label></td>
									<td>
											<select id="selectIsDelete" name="selectIsDelete" class="form-control">
													<option value="0">否</option>
													<option value="1">是</option>
												</select>
									</td>
								</div>
							</shiro:hasAnyRoles>
							<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
							<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
							</form>
					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>部门</th>
									<th>姓名</th>
									<th>考核月份</th>
									<th>公司考评</th>
									<th>公司奖惩</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/kpi/js/list.js"></script>
</body>
</html>