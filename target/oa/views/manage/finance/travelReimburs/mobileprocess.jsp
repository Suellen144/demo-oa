<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/header.jsp"%>
	<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
	<link rel="stylesheet" href="<%=base%>/static/plugins/select2/select2.min.css">
	<link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
	<style>
		#table1, #table2, .tab {
			table-collapse: collapse;
			border: none;
			margin: 5px 20px;
			width: 97%;
		}

		#table1 td:not(.select2), #table2 td, .tab td {
			border: solid #999 1px;
			text-align: center;
		}

		textarea{
			min-height:60px;
		}

		#table1 td input[type="text"], #table2 input[type="text"], .tab td input[type="text"] {
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
		}

		#table1 td input[name="startPoint"],input[name="destination"],input[name="place"],input[name="dayRoom"]{
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
			text-align:center;
		}

		#table1 td input[name="actReimburse"],input[name="cost"]{
			width: 100%;
			height: 100%;
			border: none;
			outline: medium;
			padding-right:5px;
		}

		#table1 td input[name="name"],input[name="date"],input[name="beginDate"],input[name="endDate"],input[name="applyTime"],input[name="conveyanceText"]
		,input[name="payee"],input[name="bankAddress"]{
			text-align:center;
		}


		#table1 td span:not(.select2 span), #table2 td span, .tab td span {
			padding: 0px 6px;
			text-align: center;
		}
		#table1 th, #table2 th, .tab th {
			border: solid #999 1px;
			text-align: center;
			font-size: 1.5em;
		}

		textarea {
			resize: none;
			border: none;
			outline: medium;
			width:100%;
			height: auto;
			overflow: hidden;
		}

		textarea[name="projectName"],textarea[name="reason"],textarea[name="detail"]{
			height:100%;
			padding-top:10px;
			text-align:left;
			min-height: 35px !important;
		}

		select{
			appearance:none;
			-moz-appearance:none;
			-webkit-appearance:none;
			border: none;
			text-align-last:center;
		}

		hr{
			margin-top:0px;
			margin-bottom:0px;
			border-top-color:#999999;
			display:none;
		}

		/* IE10???????????? */
		select::-ms-expand {
			display: none;
		}

		.datetimepick{
			text-align:center;
		}


		.td_one {
			width: 5%;
		}
		.td_two {
			width: 10%;
		}
		.td_three {
			width: 20%;
		}
		.td_right {
			text-align: right;
		}
		.td_weight {
			font-weight: bold;
		}

		.end{
			width:100%;
		}

		.label_title {
			display: block;
			border-bottom: 1px solid white;
			padding: 0.5em;
		}
		.label_item {
			display: block;
			border-bottom: 1px solid white;
			text-align: left;
		}
	</style>
</head>
<body style="overflow:auto;font-size:small;">
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">??????</li>
			<li class="active">????????????</li>
			<li class="active">??????</li>
			<li class="active">????????????</li>
			<li class="active">????????????</li>
		</ol>
	</header>

	<section class="content-header">
		<span style="font-size:20px;font-weight: bold;">???????????????</span>
		<span style="font-size:smaller;font-weight:normal;position:absolute;/*right:2.5em;*/line-height:2em;">(???????????????${map.business.orderNo })</span>
	</section>

	<!-- Main content -->
	<section class="content rlspace">
		<div class="row">
			<!-- left column -->
			<div class="col-md-16">
				<!-- general form elements -->
				<div class="box box-primary tbspace">
					<form id="form1">

						<input type="hidden" id="id" value="${map.business.id }">
						<input type="hidden" id="deptId" name="deptId" value="${map.business.deptId }">
						<input type="hidden" id="userId" name="userId" value="${map.business.userId }">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments }">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName }">
						<input type="hidden" id="travelId" name="travelId" value="${map.business.travelId }">
						<input type="hidden" id="travelProcessInstanceIds" value="">
						<input type="hidden" id="total" name="total" value="${map.business.total }" readonly>
						<input type="hidden" id="totalcn" readonly>
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="encrypted" name="encrypted" value="${map.business.encrypted }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
						<input type="hidden" id="operStatus" value="">
						<input type="hidden" id="assistantStatus" name="assistantStatus" value="${map.business.assistantStatus}">
						<c:choose>
						<c:when test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '????????????' or map.task.name eq '????????????') }">
						<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:when>
						<c:otherwise>
						<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:otherwise>
						</c:choose>

						<table id="table1" >
							<%-- ????????????????????? --%>
							<c:choose>
							<c:when test="${ ((map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id and map.business.assistantStatus ne '1') or
							((map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler)}">
							<tbody>
							<select id="conveyance_hidden" style="display:none;">
								<custom:dictSelect type="????????????????????????"/>
							</select>
							<select id="conveyance1_hidden" style="display: none">
								<custom:dictSelect type="???????????????????????????"/>
							</select>

							<!-- ??????????????? -->
							<ul class="mForm">
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">????????????</div>
										<div class="mFormMsg">
											<input type="text" id="name" name="name" class="longInput" value="${map.business.name }">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">????????????</div>
										<div class="mFormMsg">
											<input type="text" id="applyTime" class="longInput"  name="applyTime" style="text-align: right"  value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName" >??????</div>
										<div class="mFormMsg clearfix">
											<div style="float: right;">
												<select name="title"  style="float: left" class="mSelect firstSelect"><custom:dictSelect type="??????????????????" selectedValue="${map.business.title }"/></select>
												<c:choose>
													<c:when test="${empty(map.business.dept.alias)}">
														<input  type="text" style="width: 60px !important" class="longInput" id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
													</c:when>
													<c:otherwise>
														<input  type="text" style="width: 60px !important" class="longInput" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</div>
								</li>
								<c:if test="${((map.task.name eq '??????' or map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler) }">
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">????????????</div>
										<div class="mFormMsg">
											<select  type="text" class="longInput"  name="investId" value=" "></select>
										</div>
									</div>
								</li>
								</c:if>

								<li class="clearfix" id="accordion">
									<div class="col-xs-12">
										<div class="mFormName">?????????</div>
										<div class="mFormMsg">
											<input type="text"name="payee" value="${map.business.payee }" style="text-align: right" class="longInput" >
										</div>
									</div>
								</li>

								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">????????????</div>
										<div class="mFormMsg">
											<input type="text"  class="longInput" name="bankAccount"  style="text-align: right" value="${map.business.bankAccount }" >
										</div>
									</div>
								</li>
								<li class="clearfix" id="accordion">
									<div class="col-xs-12">
										<div class="mFormName">???????????????</div>
										<div class="mFormMsg">
											<input type="text" class="longInput" name="bankAddress" style="text-align: right" value="${map.business.bankAddress }" >
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">????????????</div>
										<div class="mFormMsg">
											<p class="longInput" style="margin: 0;padding: 0">
												<span id="actReimburseTotal">${map.business.total }</span>
												(<span id="costcn"></span>)
											</p>
										</div>
									</div>
								</li>
								<!-- ??????????????? -->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue" data-toggle="collapse" data-target="#intercityCost">???????????????</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="??????">
													</div>
												</c:if>
											</div>
												<%--?????????????????????--%>
											<div class="mFormToggle" id="intercityCost">
													<%--??????????????????????????????????????????--%>
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '0' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
																<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
															</c:if>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">????????????</div>
																	<div class="expenseConn">
																		<select name="conveyance" style="width:100%;test-align-last:center">
																			<custom:dictSelect type="????????????????????????" selectedValue="${travelreimburseAttach.conveyance }" />
																		</select>
																	</div>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">?????????</div>
																	<div class="expenseConn">
																		<input type="text" name="startPoint" class="longInput" value="${travelreimburseAttach.startPoint }">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">?????????</div>
																	<div class="expenseConn">
																		<input type="text" name="destination"  class="longInput" value="${travelreimburseAttach.destination }">
																	</div>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
																</div>
															</div>

														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>
									</div>
								</li>
								<!-- ????????? -->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#stayCost">?????????</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="??????">
													</div>
												</c:if>
											</div>
											<div class="mFormToggle" id="stayCost">
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '1' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
																<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
															</c:if>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">???*???</div>
																<div class="expenseConn">
																	<input type="text" name="dayRoom" class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
																</div>
															</div>

														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>

									</div>
								</li>

								<!-- ??????????????? -->

								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#cityCost">???????????????</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="??????">
													</div>
												</c:if>
											</div>
											<div class="mFormToggle" id="cityCost">
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '2' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
																<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
															</c:if>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
																	</div>
																</div>
																<c:if test="${not empty travelreimburseAttach.conveyance}">
																	<div class="expenseLi-half">
																		<div class="expenseName">????????????</div>
																		<div class="expenseConn">
																			<select name="conveyance" style="width:100%;test-align-last:center">
																				<custom:dictSelect type="???????????????????????????" selectedValue="${travelreimburseAttach.conveyance }" />
																			</select>
																		</div>
																	</div>
																</c:if>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
																</div>
															</div>

														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>

									</div>
								</li>

								<!-- ????????????-->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#receiveCost">????????????</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="??????">
													</div>
												</c:if>
											</div>
											<div class="mFormToggle" id="receiveCost">
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '3' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
																	</div>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">??????</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">??????</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
																</div>
															</div>
														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>
									</div>
								</li>

								<!-- ?????? -->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#subsidy">??????</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="??????">
													</div>
												</c:if>
											</div>
										</div>
										<div class="mFormToggle" id="subsidy">
											<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
												<c:if test="${travelreimburseAttach.type eq '4' }">
													<div class="expenseBox" name="node">
														<input type="hidden" name="id" value="${travelreimburseAttach.id }">
														<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
															<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
														</c:if>
														<div class="expenseLi clearfix">
															<div class="expenseLi-half">
																<div class="expenseName">????????????</div>
																<div class="expenseConn">
																	<input type="text" name="beginDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />" readonly>
																</div>
															</div>
															<div class="expenseLi-half">
																<div class="expenseName">????????????</div>
																<div class="expenseConn">
																	<input type="text" name="endDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />" readonly>
																</div>
															</div>
														</div>

														<div class="expenseLi clearfix">
															<div class="expenseLi-half">
																<div class="expenseName">????????????</div>
																<div class="expenseConn">
																	<input type="text" name="foodSubsidy"  class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />">
																</div>
															</div>
															<c:forEach items="${map.business.travelreimburseAttachList }"
																	   var="travelreimburseAttach">
																<c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
																	<div class="expenseLi-half">
																		<div class="expenseName">????????????</div>
																		<div class="expenseConn">
																			<input type="text" name="trafficSubsidy"  class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />">
																		</div>
																	</div>
																</c:if>
															</c:forEach>

														</div>


														<div class="expenseLi">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
															</div>
														</div>
														<div class="expenseLi">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
															</div>
														</div>

													</div>
												</c:if>
											</c:forEach>
										</div>
									</div>
				</div>
				</li>

				<li class="clearfix">
					<div class="col-xs-12">
						<div class="mFormName">??????</div>
						<div class="mFormMsg">
							<div class="mFormShow">
								<div class="mFormSeconMsg">
									<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
										<input type="text" id="showName" name="showName"  class="longInput" value="${map.business.attachName }" readonly></a>
								</div>
								<div class="mFormArr">
									<c:if test="${(map.business.status eq '6' or map.business.status eq '7')}">
										<c:if test="${not empty(map.business.attachments)}">
											<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">??????</a>
										</c:if>
									</c:if>
								</div>
							</div>
						</div>
					</div>
				</li>
				<li class="clearfix">
					<div class="col-xs-12">
						<div class="mFormName">????????????</div>
						<div class="mFormMsg">
							<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
								<input  type="button" class="longInput" value="?????????????????????" onclick="openTravel()">
							</c:if>
							<span id="selectTravel" name="selectTravel"></span>
						</div>
					</div>
				</li>
				<li class="clearfix">
					<div class="col-xs-12">
						<div class="mFormName">??????</div>
						<div class="mFormMsg">
							<c:if test="${map.task.name ne '????????????' and map.isHandler }">
								<textarea id="comment" name="comment" rows="2"  placeholder="???????????????" style="float: left; width: 100%; height: 100%;"></textarea>
							</c:if>
						</div>
					</div>
				</li>
				</ul>
				</tbody>
				</c:when>


					<%-- ???????????????????????????????????? --%>
				<c:otherwise>
					<tbody>
					<ul class="mForm">
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">????????????</div>
								<div class="mFormMsg">
									<input type="text" id="name" name="name" class="longInput" value="${map.business.name }">
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">????????????</div>
								<div class="mFormMsg">
									<input type="text" id="applyTime" class="longInput" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName" >??????</div>
								<div class="mFormMsg clearfix">
									<div style="float: right;">
										<select name="title"  style="float: left" class="mSelect firstSelect"><custom:dictSelect type="??????????????????" selectedValue="${map.business.title }"/></select>
										<c:choose>
											<c:when test="${empty(map.business.dept.alias)}">
												<input  type="text" style="width: 60px !important" class="longInput firstInput" id="deptName" name="deptName" onclick="openDept()" value="${map.business.dept.name}" readonly>
											</c:when>
											<c:otherwise>
												<input  type="text" style="width: 60px !important" class="longInput firstInput" id="deptName" name="deptName" onclick="openDept()" value="" readonly>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</li>
						<c:if test="${((map.task.name eq '??????' or map.task.name eq '????????????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler) }">
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">????????????</div>
									<div class="mFormMsg">
										<select  type="text" style="width: 100%;" name="investId" value=""></select>
									</div>
								</div>
							</li>
						</c:if>

						<li class="clearfix" id="accordion">
							<div class="col-xs-12">
								<div class="mFormName">?????????</div>
								<div class="mFormMsg">
									<input type="text"name="payee" value="${map.business.payee }" class="longInput" >
								</div>
							</div>
						</li>

						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">????????????</div>
								<div class="mFormMsg">
									<input type="text"  class="longInput" name="bankAccount" value="${map.business.bankAccount }" >
								</div>
							</div>
						</li>
						<li class="clearfix" id="accordion">
							<div class="col-xs-12">
								<div class="mFormName">???????????????</div>
								<div class="mFormMsg">
									<input type="text" class="longInput" name="bankAddress"  value="${map.business.bankAddress }" >
								</div>
							</div>
						</li>

						<!-- ??????????????? -->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#intercityCost">???????????????</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="??????">
										</div>
									</div>
										<%--?????????????????????--%>
									<div class="mFormToggle" id="intercityCost">
											<%--??????????????????????????????????????????--%>
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '0' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">????????????</div>
															<div class="expenseConn">
																<select name="conveyance" style="width:100%;test-align-last:center">
																	<custom:dictSelect type="????????????????????????" selectedValue="${travelreimburseAttach.conveyance }" />
																</select>
															</div>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">?????????</div>
															<div class="expenseConn">
																<input type="text" name="startPoint" class="longInput" value="${travelreimburseAttach.startPoint }">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">?????????</div>
															<div class="expenseConn">
																<input type="text" name="destination"  class="longInput" value="${travelreimburseAttach.destination }">
															</div>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
														</div>
													</div>

												</div>
											</c:if>
										</c:forEach>
									</div>
								</div>
							</div>
						</li>
						<!-- ????????? -->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#stayCost">?????????</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="??????">
										</div>
									</div>
									<div class="mFormToggle" id="stayCost">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '1' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">???*???</div>
														<div class="expenseConn">
															<input type="text" name="dayRoom" class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
														</div>
													</div>

												</div>
											</c:if>
										</c:forEach>
									</div>
								</div>
							</div>
						</li>

						<!-- ??????????????? -->

						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#cityCost">???????????????</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="??????">
										</div>
									</div>
									<div class="mFormToggle" id="cityCost">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '2' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
															</div>
														</div>
														<c:if test="${not empty travelreimburseAttach.conveyance}">
															<div class="expenseLi-half">
																<div class="expenseName">????????????</div>
																<div class="expenseConn">
																	<select name="conveyance" style="width:100%;test-align-last:center">
																		<custom:dictSelect type="???????????????????????????" selectedValue="${travelreimburseAttach.conveyance }" />
																	</select>
																</div>
															</div>
														</c:if>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
														</div>
													</div>

												</div>
											</c:if>
										</c:forEach>
									</div>
								</div>


							</div>
						</li>

						<!-- ????????????-->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#receiveCost">????????????</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="??????">
										</div>
									</div>
									<div class="mFormToggle" id="receiveCost">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '3' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
															</div>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">??????</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
														</div>
													</div>
												</div>
											</c:if>
										</c:forEach>
									</div>
								</div>
							</div>
						</li>

						<!-- ?????? -->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#subsidy">??????</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="??????">
										</div>
									</div>
									<div class="mFormToggle" id="subsidy">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '4' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="??????" /></div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">????????????</div>
															<div class="expenseConn">
																<input type="text" name="beginDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">????????????</div>
															<div class="expenseConn">
																<input type="text" name="endDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">????????????</div>
															<div class="expenseConn">
																<input type="text" name="foodSubsidy"  style="text-align:right;border:none;"value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />">
															</div>
														</div>
														<c:forEach items="${map.business.travelreimburseAttachList }"
																   var="travelreimburseAttach">
															<c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
																<div class="expenseLi-half">
																	<div class="expenseName">????????????</div>
																	<div class="expenseConn">
																		<input type="text" name="trafficSubsidy"  class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />">
																	</div>
																</div>
															</c:if>
														</c:forEach>
													</div>


													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">??????</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.detail }
																		</textarea>
														</div>
													</div>

												</div>
											</c:if>
										</c:forEach>
									</div>
								</div>

							</div>
						</li>

						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">????????????</div>
								<div class="mFormMsg">
									<input type="text" id="Total" class="longInput" value="?? ${map.business.total }" readonly />
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">??????</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormSeconMsg">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName"  class="longInput" value="${map.business.attachName }" readonly></a>
										</div>
										<div class="mFormArr">
											<c:if test="${(map.business.status eq '6' or map.business.status eq '7')}">
												<c:if test="${not empty(map.business.attachments)}">
													<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">??????</a>
												</c:if>
											</c:if>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">????????????</div>
								<div class="mFormMsg">
									<c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
										<input  type="button" class="longInput" value="?????????????????????" onclick="openTravel()">
									</c:if>
									<span id="selectTravel" name="selectTravel"></span>
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">??????</div>
								<div class="mFormMsg">
									<c:if test="${map.task.name ne '????????????' and map.isHandler }">
										<textarea id="comment" name="comment" rows="2"  placeholder="???????????????" style="float: left; width: 100%; height: 100%;"></textarea>
									</c:if>
								</div>
							</div>
						</li>
					</ul>
					</tbody>
				</c:otherwise>
				</c:choose>
				<div class="mformBtnBox">
					<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '????????????' }">
						<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">??????</button>
						<button type="button" class="btn btn-primary" onclick="approve(5)">????????????</button>
					</c:if>
					<%--	<c:if test="${map.isHandler and map.task.name ne '????????????' and map.task.name ne '????????????' }">
                            <button type="button" class="btn btn-primary" onclick="save()">????????????</button>
                        </c:if>--%>

					 <c:if test="${((map.initiator.dept.id ne '3' and map.initiator.dept.id ne '20' and map.initiator.dept.id ne '35' and map.initiator.dept.id ne '36' and map.initiator.dept.id ne '37' and map.initiator.dept.id ne '38' and map.initiator.dept.id ne '39') or (map.initiator.dept.id  eq '3' and map.task.name ne '????????????') 
                        	or (map.initiator.dept.id eq '20' and map.task.name ne '????????????') or (map.initiator.dept.id  eq '35' and map.task.name ne '????????????') or (map.initiator.dept.id eq '36' and map.task.name ne '????????????') or (map.initiator.dept.id eq '37' and map.task.name ne '????????????') or (map.initiator.dept.id eq '38' and map.task.name ne '????????????') or (map.initiator.dept.id eq '39' and map.task.name ne '????????????'))
                        	and map.isHandler and map.task.name ne '????????????' }">
						<button type="button" class="btn btn-primary" onclick="approve(2)">??????</button>
						<button type="button" class="btn btn-warning" onclick="approve(3)">?????????</button>
					</c:if>
					<c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id  eq '20' ) and map.task.name eq '????????????' and sessionScope.user.id ne '103'  and map.isHandler  and map.business.assistantStatus eq '1'}">
						<button type="button" class="btn btn-primary" onclick="approve(2)">??????</button>
						<button type="button" class="btn btn-warning" onclick="approve(3)">?????????</button>
					</c:if>

					<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '????????????' }">
						<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">???????????????</button>
						<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">????????????</button>
					</c:if>
					<%--<c:if test="${map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11' }">
                        <button type="button" class="btn btn-primary" onclick="print(${map.business.processInstanceId })">??????</button>
                    </c:if>--%>
					<%--<c:if test="${(map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11') and sessionScope.user.id eq '5'}">
                        <button type="button" class="btn btn-primary" onclick="exportpdf(${map.business.processInstanceId })">??????PDF</button>
                    </c:if>--%>
					<c:if test="${(map.initiator.dept.id  eq '3' or map.initiator.dept.id  eq '20' or map.initiator.dept.id eq '35'
									or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39')&& map.task.name eq '????????????'  && map.business.assistantStatus ne '1'}">
						<shiro:hasPermission name="fin:reimburse:assistantAffirm">
							<button type="button" class="btn btn-warning" onclick="assistantAffirm()">????????????</button>
							<button type="button" class="btn btn-danger" onclick="disagree()">?????????</button>
						</shiro:hasPermission>
					</c:if>
					<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">??????</button>
				</div>
				</table>
				</form>
			</div>
		</div>
</div>
</section>

<section class="content-header">
	<h1>????????????</h1>
</section>

<section class="content">
	<div class="box box-primary tbspace">
		<ul class="mForm" id="mForm">
		</ul>
	</div>
</section>
</div>

<div id="deptDialog"></div>
<div id="projectDialog"></div>
<div id="travelDialog"></div>


<!-- ????????????????????????Modal??? -->
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:92%; height: 80%;">
		<div class="modal-content" style="height:100%;width:100%;overflow: auto;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel" style="font-weight:bold;text-align: center;">????????????????????????</h4>
			</div>
			<div class="modal-body">
				<p>
					<span style="font-size:19px">1</span><span style="font-size:19px;font-family:??????">????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">0</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????</span><span style="font-family: ??????; font-size: 19px;">????????????????????????????????????????????????????????????????????????????????????</span>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695004905.png" _src="http://www.reyzar.com/images/upload/20171011/1507695004905.png"/>
				</p>
				<p>
					<span style="font-size:19px">2</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><img src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png" _src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png"/>
				</p>
				<p>
					<span style="font-size:19px">3</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695286246.png" _src="http://www.reyzar.com/images/upload/20171011/1507695286246.png"/>
				</p>
				<p>
					<span style="font-size:19px;font-family:??????"><span style="font-size:19px;font-family: &#39;Calibri&#39;,sans-serif">4</span><span style="font-size:19px;font-family:??????">???</span>???????????????????????????????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:??????">?????????????????????????????????</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family: ??????">??????</span><span style="font-size: 19px;font-family: Arial, sans-serif;color: rgb(51, 51, 51)">???</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family:??????">??????</span><span style="font-size:19px">+</span><span style="font-size:19px;font-family: ??????">???????????????????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span><span style="font-size:19px">8</span><span style="font-size:19px;font-family:??????">??????????????????????????????</span><span style="font-size:19px">11</span><span style="font-size:19px;font-family: ??????">????????????????????????????????????</span><span style="font-size:19px">(</span><span style="font-size:19px;font-family: ??????">????????????????????????????????????</span><span style="font-size:19px">)</span><span style="font-size:19px;font-family: ??????">???</span>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695342507.png" _src="http://www.reyzar.com/images/upload/20171011/1507695342507.png"/>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" _src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" style="width: 900px; height: 744px;"/><img src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" _src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" style="width: 750px; height: 708px;"/>
				</p>
				<p>
					<span style="font-size:19px">5</span><span style="font-size:19px;font-family:??????">??????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
				</p>
				<p>
					<span style="font-size:19px">6</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
				</p>
				<p>
					<span style="font-size:19px">7</span><span style="font-size:19px;font-family:??????">????????????????????????????????????</span><span style="font-size:19px">OA</span><span style="font-size:19px;font-family:??????">?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????</span>
				</p>
				<p></p>
				<p>
					<br/>
				</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<!-- ????????????????????????Modal??? -->
<div class="modal fade" id="travelDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="travelModalLabel">????????????</h4>
			</div>
			<div class="modal-body" style="overflow: auto;">
				<iframe id="travelDetailFrame" name="travelDetailFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<!-- ?????????????????????Modal??? -->
<div class="modal fade" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; max-height: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					?????????
				</h4>
			</div>
			<div class="modal-body">
				<div id="imgcontainer"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
				<!-- <button type="button" class="btn btn-primary">??????</button> -->
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->




	<%@ include file="../../common/footer.jsp"%>
	<!-- ???????????? -->
	<script type="text/javascript">
        base = "<%=base%>";
	</script>
	<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/select2/select2.full.min.js"></script>

	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
	<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>

	<shiro:hasPermission name="fin:travelreimburse:decrypt">
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/crypto-js.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/crypto/aes.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/md5.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/encrypt/aesUtils.js"></script>
	</shiro:hasPermission>

	<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
	<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>

	<script type="text/javascript" src="<%=base%>/views/manage/finance/travelReimburs/js/mobileprocess.js"></script>
	<script>
        var hasDecryptPermission = false;
        <shiro:hasPermission name="fin:travelreimburse:decrypt">
        hasDecryptPermission = true;
        </shiro:hasPermission>

        var variables = ${map.jsonMap.variables};

        var editInvest = false;
        var submitPhase = ""; // ???????????????????????????????????????????????????????????????????????????????????????
        <c:if test="${(map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id }">
        submitPhase = "resubmit";
        </c:if>
        <c:if test="${(map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler }">
        submitPhase = "othersubmit";
        </c:if>
        <c:if test="${((map.task.name eq '????????????' or map.task.name eq '????????????') and map.business.userId eq sessionScope.user.id) or ((map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '??????' or map.task.name eq '?????????') and map.isHandler) }">
        editInvest = true;
        </c:if>
	</script>
</body>
</html>