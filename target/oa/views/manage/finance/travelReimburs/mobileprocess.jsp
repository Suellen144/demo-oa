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

		/* IE10以上生效 */
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
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">报销</li>
			<li class="active">出差报销</li>
			<li class="active">报销处理</li>
		</ol>
	</header>

	<section class="content-header">
		<span style="font-size:20px;font-weight: bold;">差旅报销单</span>
		<span style="font-size:smaller;font-weight:normal;position:absolute;/*right:2.5em;*/line-height:2em;">(报销单号：${map.business.orderNo })</span>
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
						<c:when test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or map.task.name eq '部门经理') }">
						<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:when>
						<c:otherwise>
						<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						</c:otherwise>
						</c:choose>

						<table id="table1" >
							<%-- 可以提交的部分 --%>
							<c:choose>
							<c:when test="${ ((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id and map.business.assistantStatus ne '1') or
							((map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler)}">
							<tbody>
							<select id="conveyance_hidden" style="display:none;">
								<custom:dictSelect type="出差报销交通工具"/>
							</select>
							<select id="conveyance1_hidden" style="display: none">
								<custom:dictSelect type="市内交通费交通工具"/>
							</select>

							<!-- 报销人相关 -->
							<ul class="mForm">
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">出差人员</div>
										<div class="mFormMsg">
											<input type="text" id="name" name="name" class="longInput" value="${map.business.name }">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">提交日期</div>
										<div class="mFormMsg">
											<input type="text" id="applyTime" class="longInput"  name="applyTime" style="text-align: right"  value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName" >单位</div>
										<div class="mFormMsg clearfix">
											<div style="float: right;">
												<select name="title"  style="float: left" class="mSelect firstSelect"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
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
								<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">费用归属</div>
										<div class="mFormMsg">
											<select  type="text" class="longInput"  name="investId" value=" "></select>
										</div>
									</div>
								</li>
								</c:if>

								<li class="clearfix" id="accordion">
									<div class="col-xs-12">
										<div class="mFormName">领款人</div>
										<div class="mFormMsg">
											<input type="text"name="payee" value="${map.business.payee }" style="text-align: right" class="longInput" >
										</div>
									</div>
								</li>

								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">银行卡号</div>
										<div class="mFormMsg">
											<input type="text"  class="longInput" name="bankAccount"  style="text-align: right" value="${map.business.bankAccount }" >
										</div>
									</div>
								</li>
								<li class="clearfix" id="accordion">
									<div class="col-xs-12">
										<div class="mFormName">开户行名称</div>
										<div class="mFormMsg">
											<input type="text" class="longInput" name="bankAddress" style="text-align: right" value="${map.business.bankAddress }" >
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">实报金额</div>
										<div class="mFormMsg">
											<p class="longInput" style="margin: 0;padding: 0">
												<span id="actReimburseTotal">${map.business.total }</span>
												(<span id="costcn"></span>)
											</p>
										</div>
									</div>
								</li>
								<!-- 城际交通费 -->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue" data-toggle="collapse" data-target="#intercityCost">城际交通费</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="添加">
													</div>
												</c:if>
											</div>
												<%--此处为大项分类--%>
											<div class="mFormToggle" id="intercityCost">
													<%--此处为每个大项分类下单条详情--%>
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '0' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
															</c:if>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">日期</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">交通工具</div>
																	<div class="expenseConn">
																		<select name="conveyance" style="width:100%;test-align-last:center">
																			<custom:dictSelect type="出差报销交通工具" selectedValue="${travelreimburseAttach.conveyance }" />
																		</select>
																	</div>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">出发地</div>
																	<div class="expenseConn">
																		<input type="text" name="startPoint" class="longInput" value="${travelreimburseAttach.startPoint }">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">目的地</div>
																	<div class="expenseConn">
																		<input type="text" name="destination"  class="longInput" value="${travelreimburseAttach.destination }">
																	</div>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">项目</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">费用</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">实报</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">事由</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">明细</div>
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
								<!-- 住宿费 -->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#stayCost">住宿费</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="添加">
													</div>
												</c:if>
											</div>
											<div class="mFormToggle" id="stayCost">
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '1' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
															</c:if>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">日期</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">地点</div>
																	<div class="expenseConn">
																		<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">天*房</div>
																<div class="expenseConn">
																	<input type="text" name="dayRoom" class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">项目</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">费用</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">实报</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">事由</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">明细</div>
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

								<!-- 市内交通费 -->

								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#cityCost">市内交通费</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="添加">
													</div>
												</c:if>
											</div>
											<div class="mFormToggle" id="cityCost">
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '2' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
																<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
															</c:if>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">日期</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">地点</div>
																	<div class="expenseConn">
																		<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
																	</div>
																</div>
																<c:if test="${not empty travelreimburseAttach.conveyance}">
																	<div class="expenseLi-half">
																		<div class="expenseName">交通工具</div>
																		<div class="expenseConn">
																			<select name="conveyance" style="width:100%;test-align-last:center">
																				<custom:dictSelect type="市内交通费交通工具" selectedValue="${travelreimburseAttach.conveyance }" />
																			</select>
																		</div>
																	</div>
																</c:if>
															</div>
															<div class="expenseLi">
																<div class="expenseName">项目</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">费用</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">实报</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">事由</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">明细</div>
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

								<!-- 接待餐费-->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#receiveCost">接待餐费</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="添加">
													</div>
												</c:if>
											</div>
											<div class="mFormToggle" id="receiveCost">
												<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
													<c:if test="${travelreimburseAttach.type eq '3' }">
														<div class="expenseBox" name="node">
															<input type="hidden" name="id" value="${travelreimburseAttach.id }">
															<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">日期</div>
																	<div class="expenseConn">
																		<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">地点</div>
																	<div class="expenseConn">
																		<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
																	</div>
																</div>
															</div>

															<div class="expenseLi">
																<div class="expenseName">项目</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>

															<div class="expenseLi clearfix">
																<div class="expenseLi-half">
																	<div class="expenseName">费用</div>
																	<div class="expenseConn">
																		<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
																	</div>
																</div>
																<div class="expenseLi-half">
																	<div class="expenseName">实报</div>
																	<div class="expenseConn">
																		<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
																	</div>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">项目</div>
																<div class="expenseConn">
																	<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
																	<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">事由</div>
																<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
																</div>
															</div>
															<div class="expenseLi">
																<div class="expenseName">明细</div>
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

								<!-- 补贴 -->
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#subsidy">补贴</div>
										<div class="mFormMsg">
											<div class="mFormShow">
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
												<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
													<div class="mFormOpe" onclick="node('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="添加">
													</div>
												</c:if>
											</div>
										</div>
										<div class="mFormToggle" id="subsidy">
											<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
												<c:if test="${travelreimburseAttach.type eq '4' }">
													<div class="expenseBox" name="node">
														<input type="hidden" name="id" value="${travelreimburseAttach.id }">
														<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
															<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
														</c:if>
														<div class="expenseLi clearfix">
															<div class="expenseLi-half">
																<div class="expenseName">出发日期</div>
																<div class="expenseConn">
																	<input type="text" name="beginDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />" readonly>
																</div>
															</div>
															<div class="expenseLi-half">
																<div class="expenseName">离开日期</div>
																<div class="expenseConn">
																	<input type="text" name="endDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />" readonly>
																</div>
															</div>
														</div>

														<div class="expenseLi clearfix">
															<div class="expenseLi-half">
																<div class="expenseName">出差补贴</div>
																<div class="expenseConn">
																	<input type="text" name="foodSubsidy"  class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />">
																</div>
															</div>
															<c:forEach items="${map.business.travelreimburseAttachList }"
																	   var="travelreimburseAttach">
																<c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
																	<div class="expenseLi-half">
																		<div class="expenseName">交通补贴</div>
																		<div class="expenseConn">
																			<input type="text" name="trafficSubsidy"  class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />">
																		</div>
																	</div>
																</c:if>
															</c:forEach>

														</div>


														<div class="expenseLi">
															<div class="expenseName">事由</div>
															<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
															</div>
														</div>
														<div class="expenseLi">
															<div class="expenseName">明细</div>
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
						<div class="mFormName">附件</div>
						<div class="mFormMsg">
							<div class="mFormShow">
								<div class="mFormSeconMsg">
									<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
										<input type="text" id="showName" name="showName"  class="longInput" value="${map.business.attachName }" readonly></a>
								</div>
								<div class="mFormArr">
									<c:if test="${(map.business.status eq '6' or map.business.status eq '7')}">
										<c:if test="${not empty(map.business.attachments)}">
											<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
										</c:if>
									</c:if>
								</div>
							</div>
						</div>
					</div>
				</li>
				<li class="clearfix">
					<div class="col-xs-12">
						<div class="mFormName">出差申请</div>
						<div class="mFormMsg">
							<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
								<input  type="button" class="longInput" value="请选择出差申请" onclick="openTravel()">
							</c:if>
							<span id="selectTravel" name="selectTravel"></span>
						</div>
					</div>
				</li>
				<li class="clearfix">
					<div class="col-xs-12">
						<div class="mFormName">批注</div>
						<div class="mFormMsg">
							<c:if test="${map.task.name ne '提交申请' and map.isHandler }">
								<textarea id="comment" name="comment" rows="2"  placeholder="请填写批注" style="float: left; width: 100%; height: 100%;"></textarea>
							</c:if>
						</div>
					</div>
				</li>
				</ul>
				</tbody>
				</c:when>


					<%-- 审批或者其他人查看的部分 --%>
				<c:otherwise>
					<tbody>
					<ul class="mForm">
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">出差人员</div>
								<div class="mFormMsg">
									<input type="text" id="name" name="name" class="longInput" value="${map.business.name }">
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">提交日期</div>
								<div class="mFormMsg">
									<input type="text" id="applyTime" class="longInput" name="applyTime" value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />" style="color:gray;" readonly>
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName" >单位</div>
								<div class="mFormMsg clearfix">
									<div style="float: right;">
										<select name="title"  style="float: left" class="mSelect firstSelect"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
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
						<c:if test="${((map.task.name eq '经办' or map.task.name eq '部门经理' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">费用归属</div>
									<div class="mFormMsg">
										<select  type="text" style="width: 100%;" name="investId" value=""></select>
									</div>
								</div>
							</li>
						</c:if>

						<li class="clearfix" id="accordion">
							<div class="col-xs-12">
								<div class="mFormName">领款人</div>
								<div class="mFormMsg">
									<input type="text"name="payee" value="${map.business.payee }" class="longInput" >
								</div>
							</div>
						</li>

						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">银行卡号</div>
								<div class="mFormMsg">
									<input type="text"  class="longInput" name="bankAccount" value="${map.business.bankAccount }" >
								</div>
							</div>
						</li>
						<li class="clearfix" id="accordion">
							<div class="col-xs-12">
								<div class="mFormName">开户行名称</div>
								<div class="mFormMsg">
									<input type="text" class="longInput" name="bankAddress"  value="${map.business.bankAddress }" >
								</div>
							</div>
						</li>

						<!-- 城际交通费 -->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#intercityCost">城际交通费</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="添加">
										</div>
									</div>
										<%--此处为大项分类--%>
									<div class="mFormToggle" id="intercityCost">
											<%--此处为每个大项分类下单条详情--%>
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '0' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">日期</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">交通工具</div>
															<div class="expenseConn">
																<select name="conveyance" style="width:100%;test-align-last:center">
																	<custom:dictSelect type="出差报销交通工具" selectedValue="${travelreimburseAttach.conveyance }" />
																</select>
															</div>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">出发地</div>
															<div class="expenseConn">
																<input type="text" name="startPoint" class="longInput" value="${travelreimburseAttach.startPoint }">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">目的地</div>
															<div class="expenseConn">
																<input type="text" name="destination"  class="longInput" value="${travelreimburseAttach.destination }">
															</div>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">项目</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">费用</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">实报</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">事由</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">明细</div>
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
						<!-- 住宿费 -->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#stayCost">住宿费</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="添加">
										</div>
									</div>
									<div class="mFormToggle" id="stayCost">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '1' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">日期</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">地点</div>
															<div class="expenseConn">
																<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">天*房</div>
														<div class="expenseConn">
															<input type="text" name="dayRoom" class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.dayRoom }" pattern="#.##" />">
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">项目</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">费用</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">实报</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">事由</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">明细</div>
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

						<!-- 市内交通费 -->

						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#cityCost">市内交通费</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="添加">
										</div>
									</div>
									<div class="mFormToggle" id="cityCost">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '2' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">日期</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">地点</div>
															<div class="expenseConn">
																<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
															</div>
														</div>
														<c:if test="${not empty travelreimburseAttach.conveyance}">
															<div class="expenseLi-half">
																<div class="expenseName">交通工具</div>
																<div class="expenseConn">
																	<select name="conveyance" style="width:100%;test-align-last:center">
																		<custom:dictSelect type="市内交通费交通工具" selectedValue="${travelreimburseAttach.conveyance }" />
																	</select>
																</div>
															</div>
														</c:if>
													</div>
													<div class="expenseLi">
														<div class="expenseName">项目</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">费用</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">实报</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">事由</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">明细</div>
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

						<!-- 接待餐费-->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#receiveCost">接待餐费</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="添加">
										</div>
									</div>
									<div class="mFormToggle" id="receiveCost">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '3' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>
													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">日期</div>
															<div class="expenseConn">
																<input type="text" name="date" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.date }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">地点</div>
															<div class="expenseConn">
																<input type="text" name="place" class="longInput" value="${travelreimburseAttach.place }" readonly>
															</div>
														</div>
													</div>

													<div class="expenseLi">
														<div class="expenseName">项目</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">费用</div>
															<div class="expenseConn">
																<input type="text" name="cost"  class="longInput" style="text-align:right"  value="<fmt:formatNumber value="${travelreimburseAttach.cost }" pattern="#.##" />">
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">实报</div>
															<div class="expenseConn">
																<input type="text" name="actReimburse" class="longInput" style="text-align:right" value="<fmt:formatNumber value="${travelreimburseAttach.actReimburse }" pattern="#.##" />">
															</div>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">项目</div>
														<div class="expenseConn">
															<input type="hidden" name="projectId"  value="${travelreimburseAttach.projectId }">
															<textarea name="projectName" class="longInput" onclick="openProject(this)" readonly>${travelreimburseAttach.project.name }</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">事由</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">明细</div>
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

						<!-- 补贴 -->
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName blue panel-collapse collapse in" data-toggle="collapse" data-target="#subsidy">补贴</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormArr current">
											<img src="<%=base%>/static/images/arr.png" alt="">
										</div>
										<div class="mFormOpe" onclick="node('add',this)">
											<img src="<%=base%>/static/images/add.png" alt="添加">
										</div>
									</div>
									<div class="mFormToggle" id="subsidy">
										<c:forEach items="${map.business.travelreimburseAttachList }" var="travelreimburseAttach">
											<c:if test="${travelreimburseAttach.type eq '4' }">
												<div class="expenseBox" name="node">
													<input type="hidden" name="id" value="${travelreimburseAttach.id }">
													<div class="expenseDel"><img src="<%=base%>/static/images/del.png" alt="删除" /></div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">出发日期</div>
															<div class="expenseConn">
																<input type="text" name="beginDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.beginDate }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
														<div class="expenseLi-half">
															<div class="expenseName">离开日期</div>
															<div class="expenseConn">
																<input type="text" name="endDate" class="datetimepick longInput" value="<fmt:formatDate value="${travelreimburseAttach.endDate }" pattern="yyyy-MM-dd" />" readonly>
															</div>
														</div>
													</div>

													<div class="expenseLi clearfix">
														<div class="expenseLi-half">
															<div class="expenseName">餐费补贴</div>
															<div class="expenseConn">
																<input type="text" name="foodSubsidy"  style="text-align:right;border:none;"value="<fmt:formatNumber value="${travelreimburseAttach.foodSubsidy }" pattern="#.##" />">
															</div>
														</div>
														<c:forEach items="${map.business.travelreimburseAttachList }"
																   var="travelreimburseAttach">
															<c:if test="${not empty travelreimburseAttach.trafficSubsidy}">
																<div class="expenseLi-half">
																	<div class="expenseName">交通补贴</div>
																	<div class="expenseConn">
																		<input type="text" name="trafficSubsidy"  class="longInput" value="<fmt:formatNumber value="${travelreimburseAttach.trafficSubsidy }" pattern="#.##" />">
																	</div>
																</div>
															</c:if>
														</c:forEach>
													</div>


													<div class="expenseLi">
														<div class="expenseName">事由</div>
														<div class="expenseConn">
																		<textarea class="longInput">
																				${travelreimburseAttach.reason }
																		</textarea>
														</div>
													</div>
													<div class="expenseLi">
														<div class="expenseName">明细</div>
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
								<div class="mFormName">实报金额</div>
								<div class="mFormMsg">
									<input type="text" id="Total" class="longInput" value="¥ ${map.business.total }" readonly />
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">附件</div>
								<div class="mFormMsg">
									<div class="mFormShow">
										<div class="mFormSeconMsg">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName"  class="longInput" value="${map.business.attachName }" readonly></a>
										</div>
										<div class="mFormArr">
											<c:if test="${(map.business.status eq '6' or map.business.status eq '7')}">
												<c:if test="${not empty(map.business.attachments)}">
													<a href="javascript:void(0);" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
												</c:if>
											</c:if>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">出差申请</div>
								<div class="mFormMsg">
									<c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
										<input  type="button" class="longInput" value="请选择出差申请" onclick="openTravel()">
									</c:if>
									<span id="selectTravel" name="selectTravel"></span>
								</div>
							</div>
						</li>
						<li class="clearfix">
							<div class="col-xs-12">
								<div class="mFormName">批注</div>
								<div class="mFormMsg">
									<c:if test="${map.task.name ne '提交申请' and map.isHandler }">
										<textarea id="comment" name="comment" rows="2"  placeholder="请填写批注" style="float: left; width: 100%; height: 100%;"></textarea>
									</c:if>
								</div>
							</div>
						</li>
					</ul>
					</tbody>
				</c:otherwise>
				</c:choose>
				<div class="mformBtnBox">
					<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '部门经理' }">
						<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve(1)">提交</button>
						<button type="button" class="btn btn-primary" onclick="approve(5)">取消申请</button>
					</c:if>
					<%--	<c:if test="${map.isHandler and map.task.name ne '提交申请' and map.task.name ne '部门经理' }">
                            <button type="button" class="btn btn-primary" onclick="save()">保存修改</button>
                        </c:if>--%>

					 <c:if test="${((map.initiator.dept.id ne '3' and map.initiator.dept.id ne '20' and map.initiator.dept.id ne '35' and map.initiator.dept.id ne '36' and map.initiator.dept.id ne '37' and map.initiator.dept.id ne '38' and map.initiator.dept.id ne '39') or (map.initiator.dept.id  eq '3' and map.task.name ne '部门经理') 
                        	or (map.initiator.dept.id eq '20' and map.task.name ne '部门经理') or (map.initiator.dept.id  eq '35' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '36' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '37' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '38' and map.task.name ne '部门经理') or (map.initiator.dept.id eq '39' and map.task.name ne '部门经理'))
                        	and map.isHandler and map.task.name ne '提交申请' }">
						<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
						<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
					</c:if>
					<c:if test="${(map.initiator.dept.id eq '3' or map.initiator.dept.id  eq '20' ) and map.task.name eq '部门经理' and sessionScope.user.id ne '103'  and map.isHandler  and map.business.assistantStatus eq '1'}">
						<button type="button" class="btn btn-primary" onclick="approve(2)">同意</button>
						<button type="button" class="btn btn-warning" onclick="approve(3)">不同意</button>
					</c:if>

					<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
						<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve(4)">保存并提交</button>
						<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve(5)">取消申请</button>
					</c:if>
					<%--<c:if test="${map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11' }">
                        <button type="button" class="btn btn-primary" onclick="print(${map.business.processInstanceId })">打印</button>
                    </c:if>--%>
					<%--<c:if test="${(map.business.status eq '3' or map.business.status eq '4' or map.business.status eq '5' or map.business.status eq '6' or map.business.status eq '11') and sessionScope.user.id eq '5'}">
                        <button type="button" class="btn btn-primary" onclick="exportpdf(${map.business.processInstanceId })">导出PDF</button>
                    </c:if>--%>
					<c:if test="${(map.initiator.dept.id  eq '3' or map.initiator.dept.id  eq '20' or map.initiator.dept.id eq '35'
									or map.initiator.dept.id eq '36' or map.initiator.dept.id eq '37' or map.initiator.dept.id eq '38' or map.initiator.dept.id eq '39')&& map.task.name eq '部门经理'  && map.business.assistantStatus ne '1'}">
						<shiro:hasPermission name="fin:reimburse:assistantAffirm">
							<button type="button" class="btn btn-warning" onclick="assistantAffirm()">助手确认</button>
							<button type="button" class="btn btn-danger" onclick="disagree()">不同意</button>
						</shiro:hasPermission>
					</c:if>
					<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
				</div>
				</table>
				</form>
			</div>
		</div>
</div>
</section>

<section class="content-header">
	<h1>处理流程</h1>
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


<!-- 帮助文本模态框（Modal） -->
<div class="modal fade" id="helpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:92%; height: 80%;">
		<div class="modal-content" style="height:100%;width:100%;overflow: auto;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel" style="font-weight:bold;text-align: center;">差旅报销填写规范</h4>
			</div>
			<div class="modal-body">
				<p>
					<span style="font-size:19px">1</span><span style="font-size:19px;font-family:宋体">、由行政部代订机票，出差人员填写差旅报销单时，须将城际交通往返路线写清楚，金额填</span><span style="font-size:19px">0</span><span style="font-size:19px;font-family:宋体">，明细注明：行政部代订机票，</span><span style="font-family: 宋体; font-size: 19px;">如员工个人购买机票，附件请附上报价单，明细写上机票几折。</span>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695004905.png" _src="http://www.reyzar.com/images/upload/20171011/1507695004905.png"/>
				</p>
				<p>
					<span style="font-size:19px">2</span><span style="font-size:19px;font-family:宋体">、同一天内如果不是直达目的地，需要中转的，中转费用不需要单独加行填写，与当天的交通费用合并填写，明细栏上注明在某某地点某某交通工具中转即可，发票金额与实报金额不一致的请写上发票金额为多少元。</span><img src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png" _src="https://tuchuang001.com/images/2017/10/11/dc4c2f3f7f946b7f094dad30402d1361.png"/>
				</p>
				<p>
					<span style="font-size:19px">3</span><span style="font-size:19px;font-family:宋体">、住宿费：日期填写入住酒店当天（发票一般是离开酒店时开具的），如与其他同事一起住宿请在明细栏写明，住宿由于特殊原因超标，请写明原因。</span>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695286246.png" _src="http://www.reyzar.com/images/upload/20171011/1507695286246.png"/>
				</p>
				<p>
					<span style="font-size:19px;font-family:宋体"><span style="font-size:19px;font-family: &#39;Calibri&#39;,sans-serif">4</span><span style="font-size:19px;font-family:宋体">、</span>市内交通费用的填报：同一天在同一个城市产生的公交地铁打的可写在一起</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:宋体">在明细写清楚路线金额（</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family: 宋体">地方</span><span style="font-size: 19px;font-family: Arial, sans-serif;color: rgb(51, 51, 51)">→</span><span style="font-size:19px">XX</span><span style="font-size:19px;font-family:宋体">地方</span><span style="font-size:19px">+</span><span style="font-size:19px;font-family: 宋体">交通工具，如出差期间打的拜访客户的请写明拜访某公司某客户）</span><span style="font-size:19px">,</span><span style="font-size:19px;font-family:宋体">不同时间、不同城市的分开填写，大家选择滴滴出行的，报销时请提供纸质的滴滴发票与行程单，行程单的金额必须与发票金额一致，行程单上须显示具体的起点与终点地址；周六日因公的交通费用请在报销明细上注明是周六日，属于早班机</span><span style="font-size:19px">8</span><span style="font-size:19px;font-family:宋体">点前打的费用与晚班机</span><span style="font-size:19px">11</span><span style="font-size:19px;font-family: 宋体">点后打的费用请在明细注明</span><span style="font-size:19px">(</span><span style="font-size:19px;font-family: 宋体">早班机几点或者晚班机几点</span><span style="font-size:19px">)</span><span style="font-size:19px;font-family: 宋体">。</span>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695342507.png" _src="http://www.reyzar.com/images/upload/20171011/1507695342507.png"/>
				</p>
				<p>
					<img src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" _src="http://www.reyzar.com/images/upload/20171011/1507695378718.png" style="width: 900px; height: 744px;"/><img src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" _src="http://www.reyzar.com/images/upload/20171011/1507695407728.png" style="width: 750px; height: 708px;"/>
				</p>
				<p>
					<span style="font-size:19px">5</span><span style="font-size:19px;font-family:宋体">、补贴：餐费补贴按出差天数填写如发生招待用餐或者参与招待用餐当天不享受餐补。</span>
				</p>
				<p>
					<span style="font-size:19px">6</span><span style="font-size:19px;font-family:宋体">、出差期间产生的与渠道相关的费用（例如餐费、交通、住宿），要归属到渠道商名下的，请单独填写通用报销单，不要与个人产生的费用合在一起在差旅报销单上填写。</span>
				</p>
				<p>
					<span style="font-size:19px">7</span><span style="font-size:19px;font-family:宋体">、外派员工回广州须提前在</span><span style="font-size:19px">OA</span><span style="font-size:19px;font-family:宋体">填写出差申请表，关联出差申请表填写差旅报销单，往返车费由睿哲科技总公司报销，填写报销单时注意单位抬头。</span>
				</p>
				<p></p>
				<p>
					<br/>
				</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<!-- 出差详细模态框（Modal） -->
<div class="modal fade" id="travelDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="travelModalLabel">出差详细</h4>
			</div>
			<div class="modal-body" style="overflow: auto;">
				<iframe id="travelDetailFrame" name="travelDetailFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->

<!-- 流程图模态框（Modal） -->
<div class="modal fade" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; max-height: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					流程图
				</h4>
			</div>
			<div class="modal-body">
				<div id="imgcontainer"></div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<!-- <button type="button" class="btn btn-primary">选择</button> -->
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->




	<%@ include file="../../common/footer.jsp"%>
	<!-- 全局变量 -->
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
        var submitPhase = ""; // 提交阶段，用于判断是重新提交申请、财务修改还是没有表单操作
        <c:if test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
        submitPhase = "resubmit";
        </c:if>
        <c:if test="${(map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler }">
        submitPhase = "othersubmit";
        </c:if>
        <c:if test="${((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id) or ((map.task.name eq '经办' or map.task.name eq '复核' or map.task.name eq '出纳' or map.task.name eq '总经理') and map.isHandler) }">
        editInvest = true;
        </c:if>
	</script>
</body>
</html>