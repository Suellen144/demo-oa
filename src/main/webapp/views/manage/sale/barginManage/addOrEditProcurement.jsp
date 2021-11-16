<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<%=base%>/static/plugins/datatables/dataTables.bootstrap.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1 , #table2{
	width: 90%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td , #table2 td{
	border: solid #999 1px;
	padding: 5px;
}
#table1 thead th , #table2 thead th{
	border: none;
}

select{
  appearance:none;
  -moz-appearance:none;
  -webkit-appearance:none;
  border: none;
}

/* IE10以上生效 */
select::-ms-expand { 
	display: none; 
}

#table1 td input[type="text"] ,#table2 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	text-align:center;
	outline: medium;
}
#table1 td span ,#table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th,#table2 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
}
</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">流水号管理</li>
			<li class="active">添加收票记录</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					
					<form id="form1" style="vertical-align: middle;text-align: center">
						<input type="hidden" id="barginManageId" name="barginManageId" value="${barginManageId}">
						<input type="hidden" id="createBy" name="createBy" value="${createBy}">
						<input type="hidden" id="createDate" name="createDate" value='<fmt:formatDate value="${createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>'>
						<input type="hidden" id="ticketUserId" name="ticketUserId" value="${ticketUserId}">
						<input type="hidden" id="id" name="id" value="${saleTicketConfirmation.id}">
						<table id="table1">
							<div style="text-align: center;font-weight: bolder;font-size: 1.5em;">
								<thead>
									<tr><th colspan="20">收票记录</th></tr>
								</thead>
							</div>
							<tbody>
								<tr>
									<td style="width: 10%" class="td_weight"><span>收票时间</span></td>
									<td ><input type="text" name="ticketDate" id ="ticketDate" value='<fmt:formatDate value="${saleTicketConfirmation.ticketDate }" pattern="yyyy-MM-dd" />' readonly></td>
									<td class="td_weight" style="width: 10%"><span>收票额</span></td>
									<td><input type="text" name="ticketLines"  id ="ticketLines" value="${saleTicketConfirmation.ticketLines}"></td>
									<td  class="td_weight" style="width: 10%"><span>税率</span></td>
									<td  colspan="8"><input type="text" name="rate"  id ="rate" value="${saleTicketConfirmation.rate}" onchange="trigger()" title="0%"></td>
									<td  class="td_weight" style="width: 10%"><span>抵扣额</span></td>
									<td><input type="text" name="deductionLines"  id ="deductionLines" value="${saleTicketConfirmation.deductionLines}"></td>
								</tr>
							</tbody>
						</table>
						<div style="width: 52%; text-align: center;margin:auto;margin-top:5px;">
						<!-- <button type="button" class="btn btn-primary" onclick="submitInfo()" >保存</button> -->
							<button type="button" class="btn btn-primary" onclick="submitInfo()" >提交</button>
							<button  type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
			<div class="col-md-12">
				<div class="box box-primary tbspace">
					<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">收票记录</span>
						</div>
					<table id="table2" style="text-align: center;width:90%;">
					<thead>
						<tr>
						<td >收票时间</td>
						<td >收票人</td>
						<td >收票额</td>
						<td >税率</td>
						<td >抵扣额</td>
						</tr>
					</thead>
					<tbody>
					</tbody>
					</table>
					</div>
					</div>
		</div>
	</section>
</div>
<div id="userDialog"></div>
<div id="projectDialog"></div>
<%@ include file="../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/jquery.dataTables.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datatables/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/page.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/sale/barginManage/js/addOrEditProcurement.js"></script>
</body>
</html>