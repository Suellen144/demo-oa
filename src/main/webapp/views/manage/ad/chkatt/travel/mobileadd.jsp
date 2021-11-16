<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
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

.beginDate{
	width: 25% !important;
}
.endDate{
	width: 25% !important;
}

input[type="text"]{
	border: none;
}

.modal-dialog{
	vertical-align: middle;
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
								<thead>
									<section class="content-header" style="text-align: center;">
										<h1>出差申请表</h1>
									</section>
								</thead>
								<tbody>
								<!-- Main content -->
								<section class="content">
									<!-- Default box -->
										<form id="form1">
											<input type="hidden" id="attachments" name="attachments">
											<input type="hidden" id="attachName" name="attachName">
											<select id="vehicle_hidden" style="display: none;">
												<custom:dictSelect type="出差管理交通工具" />
											</select>
											<ul class="mForm">
												<li class="clearfix" id="accordion">
													<div class="col-xs-12">
														<div class="mFormName">出差人员</div>
														<div class="mFormMsg">
															<input type="text" name="userName" class="longInput" value="${sessionScope.user.name }" readonly>
														</div>
													</div>
												</li>
												<li class="clearfix">
													<div class="col-xs-12">
														<div class="mFormName">申请日期</div>
														<div class="mFormMsg">
															<input type="text" id="applyTime" class="longInput" name="applyTime" readonly>
														</div>
													</div>
												</li>
												<li class="clearfix">
													<div class="col-xs-12">
														<div class="mFormName">单位</div>
														<div class="mFormMsg clearfix">
															<c:if test="${sessionScope.user.dept.name ne '东北办事处' and sessionScope.user.dept.name ne '沈阳办事处'}">
																<select class="mSelect" style="float: left;" name="title"><custom:dictSelect type="流程所属公司" /></select>
																<c:if test="${sessionScope.user.dept.name  ne '总经理'}">
																	<input type="text" class="longInput" style="width: 45px;" value="${sessionScope.user.dept.name }" readonly>
																</c:if>
															</c:if>
															<c:if test="${sessionScope.user.dept.name eq '东北办事处' or sessionScope.user.dept.name eq '沈阳办事处'}">
																<input name="title" value="10" type="hidden">
																<custom:getDictKey type="流程所属公司" value="10"/>
																<input  type="text"  class="longInput" style="width:auto;" value="${sessionScope.user.dept.name }" readonly>
															</c:if>
														</div>
													</div>
												</li>
												<li class="clearfix">
													<div class="col-xs-12">
														<div class="mFormName">费用预算</div>
														<div class="mFormMsg">
															<input type="text" id="budget" class="longInput" name="budget">
														</div>
													</div>
												</li>
												<c:forEach begin="1" end="1" var="index">
													<li class="clearfix parentli" name="node">
														<div class="col-xs-12">
															<div class="mFormName">出差申请</div>
															<div class="mFormMsg">
																<div class="mFormShow" href="#intercityCost" data-toggle="collapse" data-parent="#accordion">
																	<div class="mFormSeconMsg">
																		<span>开始</span> 至 <span>结束</span>
																	</div>
																	<div class="mFormSeconMsg">
																		地点
																	</div>
																	<div class="mFormArr">
																		<img src="<%=base%>/static/images/arr.png" alt="">
																	</div>
																	<c:if test="${index eq 1 }">
																		<div class="mFormOpe" onclick="node('add',this)">
																			<img src="<%=base%>/static/images/add.png" alt="添加">
																		</div>
																	</c:if>
																	<c:if test="${index lt 1 }">
																		<div class="mFormOpe" onclick="node('del',this)">
																			<img src="<%=base%>/static/images/del.png" alt="删除">
																		</div>
																	</c:if>
																</div>
																<div class="mFormToggle panel-collapse collapse" id="intercityCost">
																	<div class="mFormToggleConn">
																		<div class="mFormXSToggleConn">
																			<div class="mFormXSName">出差地点</div>
																			<div class="mFormXSMsg">
																				<input type="text" name="place" class="longInput" onchange="changeText(this,value)">
																			</div>
																		</div>
																		<div class="mFormXSToggleConn">
																			<div class="mFormXSName">交通工具</div>
																			<div class="mFormXSMsg">
																				<select name="vehicle" class="mSelect">
																					<custom:dictSelect type="出差管理交通工具" />
																				</select>
																			</div>
																		</div>
																	</div>
																	<div class="mFormToggleConn">
																		<div class="mFormXSName">出差日期</div>
																		<div class="mFormXSMsg" style="font-size:12px;color: gray;">
																			<input name="beginDate" type="text"  class="beginDate longInput" style="width:20%;text-align: center;"  readonly onchange="changeText1(this,value,1)"/> 至
																			<input name="endDate" type="text"  class="endDate longInput" style="width:20%;text-align: center;"   readonly onchange="changeText1(this,value,2)"/>
																		</div>
																	</div>
																	<div class="mFormToggleConn">
																		<div class="mFormXSName">出差事由</div>
																		<div class="mFormXSMsg">
																			<input type="text" class="longInput" name="task">
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</li>
												</c:forEach>
												<li class="clearfix">
													<div class="col-xs-12">
														<div class="mFormName">备注</div>
														<div class="mFormMsg">
															<textarea id="comment"  name="comment" rows="2" style="width: 100%;"></textarea>
														</div>
													</div>
												</li>
												<li class="clearfix">
													<div class="col-xs-12">
														<div class="mFormName">附件</div>
														<div class="mFormMsg">
															<div class="mFormShow">
																<div class="mFormSeconMsg">
																	<input  type="text" id="showName" name="showName"  readonly></a>
																</div>
																<div class="mFormArr">
																	<input type="file" id="file" name="file" style="display: none;">
																	<img src="../../../static/images/upload.png" alt="" onclick="$('#file').click()">
																</div>
															</div>
														</div>
													</div>
												</li>
											</ul>
										</form>
									</div>
								</section>
								</tbody>
							<div style="width: 90%; text-align: center;margin:auto;margin-top:5px;">
								<button type="button" class="btn btn-primary" onclick="save()">提交</button>
								<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
							</div>
						</form>
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
		src="<%=base%>/views/manage/ad/chkatt/travel/js/mobileadd.js"></script>
</body>
</html>