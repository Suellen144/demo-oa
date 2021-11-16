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
		<li class="active">流水号管理</li>
		
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
							 <table id="searchTable">
								<tr>
									<c:choose>
										<c:when test="${(not empty  sessionScope.user.dept.name) and (sessionScope.user.dept.name == '行政部') }">
												<shiro:hasPermission name="sale:bargin:apply">
											 	<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toAddOrEdit()" style="height: 35px;text-align: center;">添加合同</button></td>
												</shiro:hasPermission>
										</c:when>
										<c:otherwise>
											<td><button id="addBtn" type="button" class="btn btn-primary" onclick="toAddOrEdit()" style="height: 35px;text-align: center;">添加合同</button></td>
										</c:otherwise>
									</c:choose>
									<td><label for="fuzzyContent" class="control-label" style="margin-left: 8px">搜索内容</label></td>
									<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配" style="margin-left: 8px"></td>
								
								
									<td><label for="status" class="control-label" style="margin-left: 8px">审批环节</label></td>
									<td> 
										<select id="status" name="status" class="form-control" style="margin-left: 8px">
											<option value=" "></option>
											<option value="1">部门经理审批</option>
											<option value="14">项目负责人审批</option>
											<option value="2">财务审批</option>
											<option value="12">财务总监审批</option>
											<option value="3">总经理审批</option>
											<option value="4">出纳审批</option>
											<option value="5">已归档</option>
											<option value="11">作废</option>
										</select>
									</td>
								<td><label for="roleName_duplicate" class="control-label" style="margin-left: 8px">合同期限</label></td>
								<td>
										<input class="form-control" id="startTime" name="startTime" placeholder="开始时间" style="background-color: inherit;margin-left: 8px"" readonly>
											<span style="margin-left: 4px">到</span>
										<input class="form-control" id="endTime" name="endTime" placeholder="结束时间" style="background-color: inherit;margin-left: 4px"" readonly>
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
									<!-- <th>所属部门</th> -->
									<th style="width: 7%">流程发起人</th>
									<th style="width: 6%">合同类型</th>
									<th style="width: 6%">合同编号</th>
									<th style="width: 6%">合同名称</th>
									<th style="width: 6%">合同金额</th>
									<th style="width: 6%">所属项目</th>
									<th>签订单位</th>
									<th style="width: 8%">发起时间</th>
									<th style="width: 7%">审批状态</th>
									<th style="width: 6%">纸质合同</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
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
<script type="text/javascript" src="<%=base%>/views/manage/sale/barginManage/js/list.js"></script>
</body>
</html>