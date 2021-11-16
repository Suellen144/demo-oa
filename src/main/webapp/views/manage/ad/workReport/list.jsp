<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	java.util.Date date = new java.util.Date();
	java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat("yyyy");
	java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MM");
	request.setAttribute("currYear", yearFormat.format(date));
	request.setAttribute("currMonth", monthFormat.format(date));
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/jQueryUI/jquery-ui-1.12.1/jquery-ui.min.css">
<style>
#myTab>li.active a{
	background-color: #3c8dbc;	
	color: white;
	font-weight: bold;
}

#table1 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: 5px 20px;
	background-color: white;
}
#table1 td {
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
#table1 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}

.planText {
	width: 100%;
	height: 150px;
	word-wrap: break-word;
	word-break: break-all;
	overflow-y: auto;
}

#table2 label {
	padding: 0px 0.5em 0px 1em;
}

#workreport_iframe {
	min-height: 600px;
}

/*** 下拉搜索框样式 ***/
.ui-autocomplete {  
    max-height: 250px;  
    overflow-y: auto;  
    overflow-x: hidden;  
    padding-right: 5px;
    border: 1px solid gray;
    background-color: white;
    width: auto;
    display: inline-block;
} 
.ui-autocomplete li {  
    font-size: 16px;  
    list-style-type: none;
}
.ui-widget-content .ui-state-active {
	background: #3c8dbc;
}
</style>
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">工作汇报</li>
	</ol>
</header>

<ul id="myTab" class="nav nav-tabs rlspace">
  		<li class="active"><a href="#list" data-toggle="tab">工作汇报列表</a></li>
<!--    <li><a href="#statistic" data-toggle="tab">工时统计</a></li> -->
   <shiro:hasPermission name="ad:workreport:export">
		<li><a href="#export" data-toggle="tab">工时导出</a></li>
   </shiro:hasPermission>
</ul>
<div id="myTabContent" class="tab-content">
   <div class="tab-pane fade in active" id="list">
      <div class="wrapper">
		<section class="content rlspace">
			<div class="row">
				<div class="col-xs-12">
					<div class="box box-primary">
						<div class="box-header">
							<form id="searchForm" class="form-inline" role="form" onsubmit="return false;">
									<button type="button" class="btn btn-primary" onclick="toAddOrEdit('')" style="float:left;margin-right:10px;">填写工作汇报</button>
								<table id="table2">
									<tr>
										<%--<c:if test="${havePermission eq true }">--%>
											<td>
												<label for="userName" class="control-label">姓名</label>
												<input id="userName" name="userName" class="form-control" style="width:100px;">
											</td>
										<%--</c:if>--%>
										<td>
											<label for="month" class="control-label">月份</label>
											<select id="month" name="month" class="form-control">
												<option></option>
												<c:forEach begin="1" end="12" var="month">
													<option value="${month }">${month }</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<label for="number" class="control-label">周数</label>
											<select id="number" name="number" class="form-control">
												<option></option>
												<c:forEach begin="1" end="5" var="number">
													<option value="${number }">${number }</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<label for="status" class="control-label">审核状态</label>
											<select id="status" name="status" class="form-control">
												<option value="" selected>全部</option>
												<option value="0">未审核</option>
												<option value="1">已审核</option>
											</select>
										</td>
										<td>
											<button type="button" class="btn btn-primary" onclick="drawTable()" style="margin-left:10px;">搜索</button>
											<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
										</td>
									</tr>
								</table>
							</form>
						</div>
						<div class="box-body">
							<table id="dataTable" class="table table-bordered table-hover">
								<thead>
									<tr>
										<th>月份</th>
										<th>周数</th>
										<th>审核状态</th>
										<th>创建时间</th>
										<th>更新时间</th>
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
   </div>
<!--    <div class="tab-pane fade" id="statistic">
      <iframe id="workreport_iframe" name="workreport_iframe" width="100%" height="100%" frameborder="no" scrolling="yes" src="toWorkReportCharts"></iframe>
      <p>待续</p>
   </div> -->
   
   <!-- Excel导出功能 -->
   <shiro:hasPermission name="ad:workreport:export">
		<div class="tab-pane fade" id="export">
			<div style="margin-top: 1em;">
				<iframe id="excelDownload" style="display:none;"></iframe>
				<form id="excelForm" class="form-inline" role="form">
					<table id="table2">
						<tr>
							<td><label for="userName" class="control-label">部门</label></td>
							<td>
								<input class="form-control" id="deptName" name="deptName" onclick="openDialog()" readonly style="background-color:white;">
								<input type="hidden" id="deptId" name="deptId">
							</td>
							
							<td><label for="year" class="control-label">年份</label></td>
							<td>
								<select id="year" name="year" class="form-control">
									<c:forEach begin="2010" end="2100" var="year">
										<c:choose>
											<c:when test="${year ne currYear }">
												<option value="${year }">${year }</option>
											</c:when>
											<c:otherwise>
												<option value="${year }" selected>${year }</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</td>
							
							<td><label for="months" class="control-label">月份</label></td>
							<td>
								<select id="months" name="months" class="form-control">
									<c:forEach begin="1" end="12" var="month">
										<c:choose>
											<c:when test="${month ne currMonth }">
												<option value="${month }">${month }</option>
											</c:when>
											<c:otherwise>
												<option value="${month }" selected>${month }</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</td>
							
							<td>
								<button type="button" class="btn btn-primary" onclick="exportToExcel()" style="margin-left:10px;">导出Excel</button>
							</td>
						</tr>
					</table>
				</form>
	      	</div>
	   </div>
   </shiro:hasPermission>
</div>

<!-- Modal -->
<div class="modal fade" id="workReportModal" tabindex="-1"
	role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">工作汇报详细</h4>
			</div>
			<div class="modal-body" style="overflow:auto; padding-top:0px;">
				<table id="table1">
					<tbody>
						<tr>
							<td colspan="20" style="text-align:center; font-size:1.5em; font-weight:bold;">
								<span id="author_modal" style="display:inline;"></span></span><span id="month_modal" style="display:inline;"></span>月第<span id="number_modal" style="display:inline;"></span>周工作汇报
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<table style="width:100%; margin:1em 0px;">
									<thead>
										<tr>
											<td style="width:13%;"><span>日期</span></td>
											<td style="width:20%;"><span>项目</span></td>
											<td style="width:7%;"><span>工时</span></td>
											<td><span>工作内容</span></td>
										</tr>
									</thead>
									<tbody id="workReportAttach"></tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td style="width:13%;"><span>周计划</span></td>
							<td colspan="3">
								<div id="weekPlan" class="planText"></div>
							</td>
						</tr>
						<tr>
							<td><span>月总结</span></td>
							<td colspan="3">
								<div id="monthSummary" class="planText"></div>
							</td>
						</tr>
						<tr>
							<td><span>月计划</span></td>
							<td colspan="3">
								<div id="monthPlan" class="planText"></div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="modal-footer"></div>
		</div>
	</div>
</div>

<div id="deptDialog"></div>

<%@ include file="../../common/footer.jsp"%>
<script>
var userId = ${sessionScope.user.id};
var canDoCheck = false;
var havePermission = ${havePermission };
var userList = JSON.parse('${userList}');

<shiro:hasPermission name="ad:workreport:check">
	canDoCheck = true;
</shiro:hasPermission>
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/jQueryUI/jquery-ui-1.12.1/jquery-ui.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/workReport/js/list.js"></script>
</body>
</html>