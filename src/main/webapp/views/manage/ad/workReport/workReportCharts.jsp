<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<style>
.box-body table {
	border: 1px solid #fefefe;
	width: 65%;
}
.box-body th {
	background-color: #ebebeb;
	border: 1px solid #ccc !important;
	padding: 3px 3px;
}
.box-body table tr>td {
	border: 1px solid #ccc !important;
	padding: 3px 3px
}

#searchForm label {
	float: left; 
	line-height: 2.5em;
	margin-left: 1.5em;
	margin-right: 10px; 
}
</style>
</head>
<body>
<div class="wrapper">
	<!-- Main content -->
	<section class="content rlspace">
		<div class="row" style="background-color:#fff;">
			<div class="col-md-12">
				<div class="box box-primary">
					<div class="box-header">
						<!-- 搜索条件 -->
						<form id="searchForm" class="form-inline" role="form">
							<input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }" />
							<table>
								<tr>
									<td>
										<label for="year" class="control-label">年</label> 
										<div class="spinner" style="display:table;">  
										    <div class="input-group-btn-vertical">  
												<button class="btn btn-default" type="button" onclick="yearOp(this, '-')"><i class="fa fa-minus"></i></button>  
											    <input type="text" id="year" name="year" class="form-control" value="<fmt:formatDate value="${currDate}" pattern="yyyy" />" style="width:5em; background-color:inherit; text-align:center;" readonly>  
										    	<button class="btn btn-default" type="button" onclick="yearOp(this, '+')"><i class="fa fa-plus"></i></button>  
										    </div>  
										</div>  
									</td>
									<td>
										<label for="month" class="control-label">月</label> 
										<select id="month" name="month" class="form-control">
											<option>全部</option>
											<fmt:formatDate value="${currDate}" pattern="M" var="currMonth" />
											<c:forEach begin="1" end="12" var="month">
												<option value="${month }" <c:if test="${month eq currMonth }">selected</c:if>>${month }</option>
											</c:forEach>
										</select>
									</td>
									<td>
										<label for="number" class="control-label">周数</label> 
										<select id="number" name="number" class="form-control">
											<option>全部</option>
											<c:forEach begin="1" end="5" var="number">
												<option value="${number }">${number }</option>
											</c:forEach>
										</select>
									</td>
									<td>
										<c:if test="${not empty deptList }">
											<label for="deptId" class="control-label">部门</label> 
											<select id="deptId" name="deptId" class="form-control">
												<c:forEach items="${deptList }" var="dept">
													<option value="${dept.id }">${dept.name }</option>
												</c:forEach>
											</select>
										</c:if>
										
										<button type="button" class="btn btn-primary" onclick="search()" style="margin-left:10px;">统计</button>
										<button type="reset" class="btn btn-default" style="margin-left:10px;">清空</button>
									</td>
								</tr>
							</table>
						</form>
					</div>
				</div>
			</div>
			
			<section class="col-md-6 connectedSortable ui-sortable">
				<div class="box box-info">
					<div class="box-body">
						<div id="chartContainer" style="min-width:350px;width: 100%; min-height: 200px; height: auto;"></div>
					</div>
				</div>
			</section>
			<section class="col-md-6 connectedSortable ui-sortable">
				<div class="box box-info">
					<div class="box-header with-border">
			   			<h3 class="box-title"></h3>
			    	</div>
					<div class="box-body">
			             <table id="leave_table">
			             	<thead>
			             		<tr>
				             		<th>姓名</th>
				             		<th>请假时长</th>
			             		</tr>
			             	</thead>
			             	<tbody></tbody>
			             	<tfoot style="font-weight:bold;">
			             		<tr><td>总计</td><td></td></tr>
			             	</tfoot>
			             </table>
					</div>
				</div>
			</section>
		</div>
	</section>
</div>

<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/echarts/echarts.common.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/workReport/js/workReportCharts.js"></script>
</body>
</html>