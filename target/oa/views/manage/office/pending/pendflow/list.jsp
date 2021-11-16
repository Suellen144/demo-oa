<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
</head>
<body>
<header>
	<ol class="breadcrumb">
		<li class="active">主页</li>
		<li class="active">待办事宜</li>
	</ol>
</header>

<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<div class="col-xs-12">
				<div class="box box-primary">
					<shiro:hasPermission name="off:pendflow:approveall">
					<div class="box-header" id="checkall" style="display:none;">
						 <button id="check" class="btn btn-primary" style="padding:5px;" onclick="checked()">全选</button>
						 <button id="uncheck" class="btn btn-primary" style="padding:5px;display:none;" onclick="unchecked()">取消全选</button> 
						 <button id="approveBtn" class="btn btn-primary" style="float: left;padding:5px;margin-right:5px;" onclick="approveall()">审批选中流程</button>
					</div>
					</shiro:hasPermission>
					<div class="box-header">
					</div>
					<!-- /.box-header -->
					<div class="box-body">
						<table id="dataTable" class="table table-bordered table-hover">
							<thead>
								<tr>
									<shiro:hasPermission name="off:pendflow:approveall">
									<th>当前环节</th>
									</shiro:hasPermission>
									<th>流程</th>
									<th>单号</th>
									<th>发起人</th>
									<th>发起时间</th>
								<%-- 	<c:if test="${sessionScope.user.id eq '27' }">
										<th>助手审核状态</th>
									</c:if> --%>
								</tr>
							</thead>
							<tbody>
								<input id="userId" name="userId" value="${sessionScope.user.id}" type="hidden">
								<%-- <c:forEach items="${resultList}" var="obj">
								<tr>
									<td>${obj.processName}</td>
									<td>${obj.initiator.name}</td>
									<td><fmt:formatDate value="${obj.task.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
									<td>
										<c:if test="${obj.processName=='请假流程'}"><a href="javascript:void(0);" onclick="gotoProcess('leave', ${obj.processInstanceId});">处理任务</a></c:if>
										<c:if test="${obj.processName=='出差流程'}"><a href="javascript:void(0);" onclick="gotoProcess('travel', ${obj.processInstanceId});">处理任务</a></c:if>
										<c:if test="${obj.processName=='出差报销流程'}"><a href="javascript:void(0);" onclick="gotoProcess('travelReimburse', ${obj.processInstanceId});">处理任务</a></c:if>
										<c:if test="${obj.processName=='通用报销流程'}"><a href="javascript:void(0);" onclick="gotoProcess('reimburse', ${obj.processInstanceId});">处理任务</a></c:if>
										<c:if test="${obj.processName=='信息发布流程'}"><a href="javascript:void(0);" onclick="gotoProcess('notice', ${obj.processInstanceId});">处理任务</a></c:if>
									</td>
								</tr>
								</c:forEach> --%>
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

<%@ include file="../../../common/footer.jsp"%>
<script src="<%=base%>/common/js/stringUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/office/pending/pendflow/js/list.js"></script>
<script type="text/javascript">
var flag = '<shiro:hasPermission name="off:pendflow:approveall">true</shiro:hasPermission>';
var approve = '<shiro:hasPermission name="ad:kpi:approve">true</shiro:hasPermission>';
var deptId= ${deptid};
var userid= ${userid};
</script>
</body>
</html>