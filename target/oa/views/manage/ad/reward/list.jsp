<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
							<c:if test="${sessionScope.user.id eq 2 }">														
								<input type="text" size="18" class='starttime' style="width:180px; text-align:center;float:left;line-height: 28px;border: 1px solid #ddd;border-radius: 3px;cursor: pointer;" value="" readonly>
								<span style="float:left;line-height: 30px;padding: 0 8px;">~</span>
								<input type="text" size="18" class='endtime' style="width:180px; text-align:center;float:left;line-height: 28px;border: 1px solid #ddd;border-radius: 3px;cursor: pointer;" value="" readonly>														
								<button id="addBtn" type="button" class="btn btn-primary" onclick="toAdd()" style="float:left;padding: 4px 12px;margin-left:10px">添加</button>
							</c:if>
						</form>
					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>发起日期</th>
									<th>标题</th>
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

<script type="text/javascript" src="<%=base%>/views/manage/ad/reward/js/list.js"></script>
</body>
</html>