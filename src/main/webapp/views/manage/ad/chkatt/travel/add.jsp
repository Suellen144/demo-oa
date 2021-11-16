<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../../common/header.jsp"%>
	<link rel="stylesheet"
		  href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
	<style>
		#table1 {
			width: 90%;
			table-collapse: collapse;
			border: none;
			margin: auto;
		}

		#table1 td {
			border: solid #999 1px;
			padding: 5px;
			text-align: center;
		}

		#table1 td input[type="text"] {
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
		}

		#table1 td span {
			padding: 0px 15px;
		}

		#table1 th {
			text-align: center;
			font-size: 1.5em;
		}

		textarea {
			resize: none;
			border: none;
			outline: medium;
			width: 100%;
		}

		select {
			appearance: none;
			-moz-appearance: none;
			-webkit-appearance: none;
			border: none;
		}

		/* IE10以上生效 */
		select::-ms-expand {
			display: none;
		}

		.td_weight {
			font-weight: bold;
		}

		.nest_td {
			padding: 0px !important;
		}

		.nest_td table {
			width: 100% !important;
		}

		.nest_td td {
			border: none !important;
		}

		.nest_td input[type="text"] {
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
		}

		td.nest_td_left {
			border-right: solid #999 1px !important;
			width: 30% !important;
		}
	</style>
</head>
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">行政管理</li>
			<li class="active">出差管理</li>
			<li class="active">申请出差</li>
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
						<input type="hidden" id="attachments" name="attachments">
						<input type="hidden" id="flagId" value="${sessionScope.user.id }">
						<input type="hidden" id="attachName" name="attachName">
						<input type="hidden" id="isProcess" name="isProcess" value="1">
						<select id="vehicle_hidden" style="display: none;">
							<custom:dictSelect type="出差管理交通工具" />
						</select>

						<table id="table1">
							<thead>
							<tr>
								<th colspan="20">出差申请表</th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<td style="width: 25%;" class="td_weight"><span>出差人员</span></td>
								<td style="width: 25%;"><input type="text" id="travelerName" name="travelerName"
															   value="${sessionScope.user.name }"></td>
								<td style="width: 30%;" class="td_weight"><span>申请日期</span></td>
								<td style="width: 20%;" colspan="2"><input type="text"
																		   id="applyTime" name="applyTime" readonly></td>
							</tr>
							<tr>
								<td class="td_weight"><span>单位</span></td>
								<td style="width:20%;font-size:14px;text-align:left;white-space:nowrap ;">
									<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
										<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" /></select>
										<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
											<input type="text" style="margin-left:-5px;height:20px;width:auto;" value="${sessionScope.user.dept.name }" readonly>
										</c:if>
									</c:if>
									<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
										<input name="title" value="10" type="hidden">
										<custom:getDictKey type="流程所属公司" value="10"/>
										<input  type="text"  style="height:20px;width:auto;" value="${sessionScope.user.dept.name }" readonly>
									</c:if>
								</td>
								<td class="td_weight"><span>费用预算</span></td>
								<td colspan="2"><input type="text" id="budget"
													   name="budget"></td>
							</tr>
							<tr>
								<td class="td_weight"><span>出差日期</span></td>
								<td colspan="2" class="nest_td">
									<table>
										<tr>
											<td class="nest_td_left td_weight"><span>出差地点</span></td>
											<td class="td_weight"><span>出差事由</span></td>
										</tr>
									</table>
								</td>
								<td class="td_weight"><span>交通工具</span></td>
								<td class="td_weight"><span>操作</span></td>
							</tr>
							<c:forEach begin="1" end="1" var="index">
								<tr name="node">
									<td style="padding: 0px;"><input name="beginDate"
																	 type="text" class="beginDate"
																	 style="width: 43%; text-align: center;" readonly> 至 <input
											name="endDate" type="text" class="endDate"
											style="width: 43%; text-align: center;" readonly></td>
									<td colspan="2" class="nest_td">
										<table>
											<tr>
												<td class="nest_td_left"><input type="text"
																				name="place"></td>
												<td><input type="text" name="task"/></td>
											</tr>
										</table>
									</td>
									<td><select name="vehicle"">
										<custom:dictSelect type="出差管理交通工具" />
										</select></td>
									<td>
										<c:if test="${index eq 1 }">
											<a href="javascript:void(0);" onclick="node('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png"></a></a>
										</c:if>
										<c:if test="${index lt 1 }">
											<a href="javascript:void(0);" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
										</c:if>
									</td>
								</tr>
							</c:forEach>

							<tr>
								<td class="td_weight">备注</td>
								<td colspan="20"><textarea id="comment" name="comment"
														   rows="2" style="width: 100%;"></textarea></td>
							</tr>
							<tr>
								<td class="td_weight"><span>附件</span></td>
								<td colspan="2" style="border-right: none;"><input
										type="text" id="showName" name="showName" value="" readonly>
								<td colspan="4" style="border-left: none;"><input
										type="file" id="file" name="file" style="display: none;">
									<input type="button" value="选择附件"
										   onclick="$('#file').click()"
										   style="border: none; float: right;" href="javascript:;">
								</td>
								</td>
							</tr>
							</tbody>
						</table>
						<div style="width: 90%; text-align: center;margin:auto;margin-top:5px;">
							<button type="button" class="btn btn-primary" onclick="save()">提交</button>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
</div>

<%@ include file="../../../common/footer.jsp"%>
<!-- 全局变量 -->
<script type="text/javascript">
    base = "<%=base%>";
</script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>

<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript"
		src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript"
		src="<%=base%>/views/manage/ad/chkatt/travel/js/add.js"></script>
</body>
</html>
