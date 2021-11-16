<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1 {
	width: 90%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td {
	border: solid #999 1px;
	padding: 5px;
}
#table1 thead th {
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


#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
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
textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
}
</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">请假管理</li>
			<li class="active">申请请假</li>
		</ol>
	</header>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-12">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">
						<input type="hidden" id="userId" name="userId" value="${sessionScope.user.id }">
						<input type="hidden" id="deptId" name="deptId" value="${sessionScope.user.dept.id }">
						<input type="hidden" id="attachments" name="attachments">
						<input type="hidden" id="attachName" name="attachName">
					
						<table id="table1">
							<thead>
								<tr><th colspan="20">请假申请表</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:15%;"><span>姓名</span></td>
									<td style="width:35%;"><input type="text" value="${sessionScope.user.name }" readonly></td>
									<td style="width:15%;"><span>单位</span></td>
									<td style="width:40%;line-height:inherit;text-align:left;">
										<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
											<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" /></select>
											<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
												<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${sessionScope.user.dept.name }" readonly>
											</c:if>
										</c:if>
										<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
											<input  type="text"  style="height:20px;width:auto;text-align:left;" value="${sessionScope.user.dept.name }" readonly>
										</c:if>
									</td>
								</tr>
								<tr>
									<td><span>请假类别</span></td>
									<td>
										<select name="leaveType" style="width:100%;"><custom:dictSelect type="请假类型"/></select>
									</td>
									<td><span>申请时间</span></td>
									<td><input type="text" name="applyTime" value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM-dd" />" readonly></td>
								</tr>
								<tr>
									<td><span>请假时间</span></td>
									<td colspan="20" style="padding-right:30px;">
										自
										<input id="startTime" name="startTime" size="18" class="starttime" style="width:26%;" readonly onchange="checkDate()">
										至
									    <input id="endTime" name="endTime" size="18" class="endtime" style="width:26%;" readonly onchange="checkDate()">
									           共
									    <input id="days" name="days" style="width:3em;" readonly="readonly">
									    <label id="label_days">天</label>
									    <input id="hours" name="hours" style="width:3em;" readonly="readonly">
									    <label id="label_hours">小时</label>
									</td>
								</tr>
								<tr>
									<td><span>请假事由</span></td>
									<td colspan="20"><textarea name="reason" rows="7" cols="70"></textarea></td>
								</tr>
								<tr>
									<td><span>附件</span></td>
										<td style="border-right: none;">
										<input type="text" id="showName" name="showName" value="" readonly>
										<td colspan="4" style="border-left: none;"><input
											type="file" id="file" name="file" style="display: none;">
											<input type="button" value="选择附件"
											onclick="$('#file').click()"
											style="border: none; float: right;" href="javascript:;">
										</td>
										</td>
									</tr>
							</tbody>
						<!-- 	<tfoot>
								<tr>
									<td colspan="20">
										<pre style="text-align:left;color:gray;">备注：
1、病假一天以上需出具医院证明！
2、7.5小时为一个工作日，如请假时长超过7.5小时，请将小时折合为天！</pre>
									</td>
								</tr>
							</tfoot> -->
						</table>
						<div style="width: 52%; text-align: center;margin:auto;margin-top:5px;">
							<button type="button" class="btn btn-primary" onclick="save()" >提交</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<%@ include file="../../../common/footer.jsp"%>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/ad/chkatt/leave/js/add.js"></script>
</body>
</html>