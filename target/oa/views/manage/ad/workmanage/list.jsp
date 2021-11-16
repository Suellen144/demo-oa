<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<style type="text/css">
#searchTable label {
	text-align: right;
	line-height:2.5em;
	padding: 0px 0.5em 0px 1em;
}

#table1 , .table2 ,#table3{
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
	background-color: white;
}
#table1 td ,#table3 td,.table4 td  {
	border: solid #999 1px;
	padding: 5px;
}
#table1 td input[type="text"] {
	width: 100%;
/* 	height: 100%; */
	border: none;
	outline: medium;
}
#table1 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th ,#table3 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}

.td_weight{
	font-weight: bold;
}
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">公共信息</li>
		<li class="active">信息发布</li>
	</ol>
</header>
<ul id="myTab" class="nav nav-tabs rlspace">
<%--	<li class="active"><a href="#work" data-toggle="tab">工作登记</a></li>--%>
<%--	<li><a href="#client" data-toggle="tab">客户管理</a></li>--%>
</ul>
<div id="myTabContent" class="tab-content">
<div class="tab-pane fade in active" id="work">
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<input type="hidden" id="userId" name="userId" value="${userId}">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<div class="box-header">
							<form id="searchForm" class="form-inline" role="form">
								<table id="searchTable">
									<tr>
										<td style="padding-right:4px;"><button id="addBtn" type="button"
												class="btn btn-primary" onclick="toAdd()">工作汇报</button></td>
										<td><label for="fuzzyContent" class="control-label">搜索内容</label></td>
										<td><input class="form-control" id="fuzzyContent" name="fuzzyContent" placeholder="内容模糊匹配"></td>
										<td><label for="type" class="control-label">类型</label></td>
										<td>
											<select id="type" name="type" class="form-control" >
												<option value=" "></option>
												<option value="1">商务</option>
												<option value="2">拜访</option>
											</select>
										</td>
										<td><label for="workDate" class="control-label">工作日期</label></td>
										<td><input class="form-control" name="workDate" id="workDate" class="workDate" style="background-color: #fff;text-align: center;" readonly></td>
										<td>
											<button type="button" class="btn btn-primary"
												onclick="drawTable()" style="margin-left: 10px;">搜索</button>
											<button type="button" class="btn btn-default"
												onclick="clearForm()" style="margin-left: 8px;">清空</button>
										</td>
									</tr>
								</table>
							</form>
					</div>
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<th>类型</th>
									<th>部门</th>
									<th>填写人</th>
									<th>状态</th>
									<th>提交时间</th>
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
</div>
<%--<div class="tab-pane fade" id="client">
	<iframe id="client_iframe" name="client_iframe" width="100%"  height="929px" frameborder="no" scrolling="no" src="<%=base%>/manage/ad/clientmanage/toList"></iframe>
</div>--%>
</div>
<!-- Modal -->
<div class="modal fade" id="workBinessModal" tabindex="-1"
	role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			</div>
			<div class="modal-body" style="overflow:auto; padding-top:0px;">
				<form id="form1">
					<table id="table1">
						<thead>
							<tr>
								<th colspan="20"><span id="name" name="name"></span>商务工作汇报详情</th>
							</tr>
						</thead>
						<tbody>
							<tr style="text-align: center;">
								<td  class="td_weight" style="width:25%;"><span>填写日期</span></td>
								<td   style="width:25%;"><div id="applyTime" name="applyTime"></div></td>
								<td class="td_weight" style="width:25%;"><span>单位</span></td>
								<td  style="width:25%;"><div id="deptName" name="deptName" ></div></td>
							</tr>
							<tr>
								<td colspan="8">
									<table style="width:100%; margin:1em 0px;margin-top: 0px;margin-bottom: 0px;" class="table2">
										<thead>
											<tr style="text-align: center;">
												<td class="td_weight" style="width:8%;"><span>日期</span></td>
												<td class="td_weight" style="width:8%;"><span>时长</span></td>
												<td class="td_weight" style="width:10%;"><span>交付日期</span></td>
												<td class="td_weight" style="width:8%;"><span>负责人</span></td>
												<td class="td_weight" style="width:50%;"><span>工作内容</span></td>
												<td class="td_weight" style="width:16%;"><span>备注</span></td>
											</tr>
										</thead>
										<tbody id="buinsessAttachsList"></tbody>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
			<div class="modal-footer"></div>
		</div>
	</div>
</div>


<!-- Modal -->
<div class="modal fade" id="workMarketModal" tabindex="-1"
	role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			</div>
			<div class="modal-body" style="overflow:auto; padding-top:0px;">
				<form id="form2">
					<table id="table3">
						<thead>
							<tr>
								<th colspan="20"><span id="applyName" name="applyName"></span>拜访工作汇报详情</th>
							</tr>
						</thead>
						<tbody>
							<tr style="text-align: center;">
								<td  class="td_weight" style="width:25%;"><span>填写日期</span></td>
								<td  colspan="2" style="width:25%;"><div id="applyDate" name="applyDate"></div></td>
								<td class="td_weight" style="width:25%;"><span>单位</span></td>
								<td  style="width:25%;"><div id="applyDeptName" name="applyDeptName" ></div></td>
							</tr>
							<tr>
								<td colspan="8">
									<table style="width:100%; margin:1em 0px;margin-top: 0px;margin-bottom: 0px" class="table4">
										<thead>
											<tr style="text-align: center;">
												<td class="td_weight" style="width:8%;"><span>日期</span></td>
												<td class="td_weight" style="width:10%;"><span>开始时间</span></td>
												<td class="td_weight" style="width:10%;"><span>结束时间</span></td>
												<td class="td_weight" style="width:10%;"><span>拜访单位</span></td>
												<td class="td_weight" style="width:10%;"><span>客户姓名</span></td>
												<td class="td_weight" style="width:8%;"><span>职务</span></td>
												<td class="td_weight" style="width:10%;"><span>联系方式</span></td>
												<td class="td_weight" style="width:10%;"><span>优先级</span></td>
												<td class="td_weight" style="width:10%;"><span>负责人</span></td>
												<td class="td_weight" style="width:14%;"><span>备注</span></td>
											</tr>
										</thead>
										<tbody id="marketAttachsList"></tbody>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
			<div class="modal-footer"></div>
		</div>
	</div>
</div>

<%@ include file="../../common/footer.jsp"%>
<script>
	var user = ${sessionScope.user.id}
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/dateUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/workmanage/js/list.js"></script>

<script>
	var hasEditPermission = false;
	<shiro:hasPermission name="ad:workmanage:edit">
		hasEditPermission = true;
	</shiro:hasPermission>
</script>

</body>
</html>