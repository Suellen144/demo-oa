<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<style>
.box-body table {
	border: 1px solid #fefefe;
	width: 60%;
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
						<table>
							<tr>
								<td>
									<label for="year" class="control-label" style="float: left; margin-right:10px; line-height: 2.5em;">年</label> 
									<input class="form-control" id="year" name="year" value="<fmt:formatDate value="${currDate}" pattern="yyyy" />" placeholder="年"> 
									<input type="hidden" id="account" name="account" value="" />
								</td>
								<td>
									<label for="month" class="col-sm-2 control-label" style="float: left; margin-right:10px; line-height: 2.5em;">月</label> 
									<select id="month" class="form-control">
										<option value="01">1</option>
										<option value="02">2</option>
										<option value="03">3</option>
										<option value="04">4</option>
										<option value="05">5</option>
										<option value="06">6</option>
										<option value="07">7</option>
										<option value="08">8</option>
										<option value="09">9</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
									</select>
								</td>
								<td>
									<label for="dept" class="" style="float: left; margin-right:10px; line-height: 2.5em;">部门</label> 
									<select id="dept" name="dept" class="form-control" style=""></select>
								</td>
								<td>
									<button type="button" class="btn btn-primary" onclick="search()" style="margin-left:10px;">统计</button>
									<button type="button" class="btn btn-default" onclick="clearForm()" style="margin-left:10px;">清空</button>
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
				             		<th>请假时长(天)</th>
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

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/echarts/echarts.common.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/messageBox.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/chkattRecord/js/leaveCharts.js"></script>
</body>
</html>