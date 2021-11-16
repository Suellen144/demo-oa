<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/header.jsp"%>
	<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
	<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">项目管理</li>
		<li class="active">项目业绩管理</li>

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
							<input type="hidden"  id ="currUserId" value="${sessionScope.user.id }"readonly>
								<td><label for="roleName_duplicate" class="control-label" style="margin-left: 8px">业绩分配起止时间</label></td>
								<td>
									<input class="form-control" id="startTime" name="startTime" placeholder="开始时间" style="background-color: inherit;margin-left: 8px" readonly>
									<span style="margin-left: 4px">到</span>
									<input class="form-control" id="endTime" name="endTime" placeholder="结束时间" style="background-color: inherit;margin-left: 4px" readonly>
								</td>
								<td><button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button></td>
								<td><button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button></td>
								<%--<span style="display: inline-block;width:58px;height: 36.67px;" title="导出Excel" class="btn btn-primary  fa fa-x fa-cloud-download" onclick="exportExcel()" ></span>--%>
						</form>
					</div>
					<div class="box-body">
							<table id="dataTable2" class="table table-bordered table-hover" style="text-align: center;">
								<thead>
									<tr>
										<th style="width: 25%;text-align:center">公司名</th>
										<th style="width: 25%;text-align:center">睿哲科技股份有限公司</th>
										<th style="width: 25%;text-align:center">业绩分配起止时间</th>
										<th style="width: 25%;text-align:center"></th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
							<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
								<span style="position: absolute;left: 0;right: 0;margin: auto;">人员业绩贡献表</span>
							</div>
							<table id="dataTable" class="table table-bordered table-hover">
								<thead>
									<tr>
										<th>部门</th>
										<th>姓名</th>
										<th>岗位</th>
										<th>本次业绩贡献额</th>
										<th>本次业绩排名</th>
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

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/projectApplication/js/achievementList.js"></script>

</body>
</html>