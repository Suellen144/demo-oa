<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet"
	href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet"
	href="<%=base%>/static/dist/css/skins/_all-skins.min.css">
<link rel="stylesheet" href="<%=base%>/static/css/oaMobile.css">
<style type="text/css">
textarea[name="projectName"], textarea[name="reason"], textarea[name="remark"]
	{
	padding-top: 5px;
	text-align: left;
	width: 100%;
	color: gray;
	font-size: 12px;
	height: 30px;
	outline: none;
	border: none;
	margin-left: -5px;
}

textarea {
	resize: none;
	outline: medium;
	width: 100%;
}

.firstSelect {
	float: left;
}

.firstInput {
	float: left;
}

.firstMsg {
	position: relative;
	z-index: 9;
}

.secondMsg {
	position: relative;
	z-index: 2;
}

.thirdMsg {
	position: relative;
	top: 0px
}

.mFormName1 {
	width: 40%;
}

.mFormMsg1 {
	width: 100%;
	padding-left: 40%;
}

.mFormXSName {
	width: 60%;
}

.mFormXSMsg {
	width: 200%;
	margin-left: 50%;
}

.mFormOpe {
	position: absolute;
	top: -12px;
	right: 15px;
	z-index: 100;
}

.mFormOpe1 {
	position: absolute;
	top: 10px;
	right: 15px;
	z-index: 100;
}
</style>

</head>
<body class="hold-transition skin-blue sidebar-mini">
	<section class="content-header">
		<span style="font-size: 20px; font-weight: bold;">收款申请表</span>
	</section>
	<section class="content">
		<div class="box box-primary tbspace">
			<form id="form1">
				<input type="hidden" id="id" name="id" value="${map.business.id }">
				<input type="hidden" id="invoicedId" name="invoicedId"
					value="${map.business.invoiced.id }"> <input type="hidden"
					id="taskId" name="taskId" value="${map.task.id}"> <input
					type="hidden" id="taskName" name="taskName"
					value="${map.task.name}"> <input type="hidden" id="userId"
					name="userId" value="${map.business.userId }"> <input
					type="hidden" id="deptId" name="deptId"
					value="${map.business.deptId }"> <input type="hidden"
					id="currStatus" name="currStatus" value="${map.business.status }">
				<input type="hidden" id="barginId" name="barginId"
					value="${map.business.barginId }"> <input type="hidden"
					id="barginProcessInstanceId"
					value="${map.business.barginManage.processInstanceId}"> <input
					type="hidden" id="operStatus" value=""> <input
					type="hidden" id="processInstanceId"
					value="${map.processInstanceId}"> <input type="hidden"
					id="attachments" name="attachments"
					value="${map.business.attachments}"> <input type="hidden"
					id="attachName" name="attachName"
					value="${map.business.attachName}">
				<c:choose>
					<c:when
						test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请' or map.task.name eq '部门经理') }">
						<input type="hidden" id="approver" name="approver"
							value="${map.initiator.name }">
						<input type="hidden" id="emailUid" name="emailUid"
							value="${map.initiator.id}">
					</c:when>
					<c:otherwise>
						<input type="hidden" id="approver" name="approver"
							value="${sessionScope.user.name }">
						<input type="hidden" id="emailUid" name="emailUid"
							value="${sessionScope.user.id}">
					</c:otherwise>
				</c:choose>
				<ul class="mForm">
					<c:choose>
						<c:when
							test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
							<li class="clearfix">
								<ul class="mForm" id="ulForm">
									<li class="clearfix" id="accordion">
										<div class="col-xs-12">
											<div class="mFormName">发起人</div>
											<div class="mFormMsg">
												<input type="text" class="longInput"
													value="${map.business.applicant.name }" readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">提交日期</div>
											<div class="mFormMsg">
												<input type="text" id="applyTime" class="longInput"
													name="applyTime"
													value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />"
													readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">所属单位</div>
											<div class="mFormMsg clearfix">
												<div style="float: right;">
													<select name="title" style="text-align: right !important;"
														class="mSelect firstSelect">
														<custom:dictSelect type="流程所属公司"
															selectedValue="${map.business.title }" />
													</select>
													<c:if test="${sessionScope.user.dept.name ne '总经理'}">
														<input type="text" style="width: 80px;" class="longInput"
															value="${map.business.applicant.dept.name }" readonly>
													</c:if>
												</div>
											</div>
										</div>
									</li>
									<li class="clearfix parentli">
										<div class="col-xs-12">
											<div class="mFormName">关联合同</div>
											<div class="mFormMsg firstMsg">
												<div class="mFormShow firstMsg" onclick="changeImage(this)"
													href="#intercityCost" data-toggle="collapse"
													data-parent="#accordion">
													<div class="mFormArr current">
														<img src="<%=base%>/static/images/arr.png" alt="">
													</div>
												</div>
												<div class="mFormSeconMsg mFormOpe">
													<input type="button" value="请选择合同" onclick="openBargin()"
														style="border: none;"> <span><input
														type="button" id="viewBarginBtn" value="查看合同详细"
														onclick="viewBargin()" style="border: none;"></span>
												</div>
												<div class="mFormToggle panel-collapse collapse thirdMsg"
													id="intercityCost">
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">合同编号</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" id="barginCode"
																	value="${map.business.barginManage.barginCode }"
																	readonly>
															</div>
														</div>
													</div>
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">合同名称</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" id="barginName"
																	value="${map.business.barginManage.barginName }"
																	readonly>
															</div>
														</div>
													</div>
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">所属项目</div>
															<div class="mFormXSMsg" onclick="openProject(this)">
																<input type="hidden" id="projectManageId"
																	name="projectId" value="${map.business.projectId }"
																	readonly> <input type="text" class="longInput"
																	name="projectname"
																	value="${map.business.projectManage.name }" readonly>
															</div>
														</div>
													</div>
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">合同总额</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" name="totalPay"
																	id="totalPay"
																	value="<fmt:formatNumber value='${map.business.totalPay }' pattern='0.00' />"
																	readonly>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</li>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">收款类型</div>
									<div class="mFormMsg" style="height: 40px">
										<select class="mSelect" name="collectionType"><custom:dictSelect
												type="费用性质" selectedValue="${map.business.collectionType }" /></select>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">附件</div>
									<div class="mFormMsg" style="height: 40px; line-height: 30px;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)"
											value="${map.business.attachments }" target='_blank'> <input
											type="text" id="showName" name="showName"
											value="${map.business.attachName }"
											style="outline: 0; border: 0; margin-top: 5px" readonly>
										</a> <input type="file" id="file" name="file"
											style="display: none;">
										<c:if test="${not empty map.business.attachments }">
											<a href="javascript:void(0);"
												style="float: right; margin-left: 10px; margin-right: 20px; margin-top: 5px"
												onclick="deleteAttach(this)"
												value="${map.business.attachments }">删除</a>
										</c:if>
										<input type="button" value="选择附件" onclick="$('#file').click()"
											style="border: none; float: right; margin-top: 5px"
											href="javascript:;">
									</div>
								</div>
							</li>
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">备注</div>
									<div class="mFormMsg">
										<textarea name="reason">${map.business.reason}</textarea>
									</div>
								</div>
							</li>
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">付款单位</div>
									<div class="mFormMsg">
										<input type="text" class="longInput" name="payCompany"
											value="${map.business.payCompany}">
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">申请金额</div>
									<div class="mFormMsg">
										<input type="text" class="longInput" name="applyPay"
											id="applyPay" onkeyup="initInputBlur()"
											value="<fmt:formatNumber value='${map.business.applyPay}' pattern='0.00' />">
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">申请比例</div>
									<div class="mFormMsg">
										<input type="text" class="longInput" name="applyProportion"
											id="applyProportion" value="${map.business.applyProportion}">
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">开具发票</div>
									<div class="mFormMsg"
										style="text-align: right; min-height: 40px !important; line-height: 40px">
										<select name="isInvoiced" id="isInvoiced" class="mSelect"
											onchange="initinvoiced(this)"
											value="${map.business.isInvoiced}">
											<custom:dictSelect type="发票开具"
												selectedValue="${map.business.isInvoiced}" />
										</select>
									</div>
								</div>
							</li>
				</ul>
				</li>
				</c:when>

				<c:otherwise>
					<li class="clearfix">
						<ul class="mForm" id="ulForm">
							<li class="clearfix" id="accordion">
								<div class="col-xs-12">
									<div class="mFormName">发起人</div>
									<div class="mFormMsg">
										<input type="text" class="longInput"
											value="${map.business.applicant.name }" readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">提交日期</div>
									<div class="mFormMsg">
										<input type="text" id="applyTime" class="longInput"
											name="applyTime"
											value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />"
											readonly>
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">所属单位</div>
									<div class="mFormMsg clearfix">
										<div style="float: right;">
											<select name="title" style="text-align: right !important;"
												class="mSelect firstSelect">
												<custom:dictSelect type="流程所属公司"
													selectedValue="${map.business.title }" />
											</select>
											<c:if test="${sessionScope.user.dept.name ne '总经理'}">
												<input type="text" class="longInput" style="width: 80px;"
													value="${map.business.applicant.dept.name }" readonly>
											</c:if>
										</div>
									</div>
								</div>
							</li>
							<li class="clearfix parentli">
								<div class="col-xs-12">
									<div class="mFormName">关联合同</div>
									<div class="mFormMsg firstMsg">
										<div class="mFormShow firstMsg" onclick="changeImage(this)"
											href="#intercityCost" data-toggle="collapse"
											data-parent="#accordion">
											<div class="mFormArr current">
												<img src="<%=base%>/static/images/arr.png" alt="">
											</div>
										</div>
										<div class="mFormSeconMsg mFormOpe">
											<input type="button" id="viewBarginBtn" value="查看合同详细"
												onclick="viewBargin()" style="border: none;">
										</div>
										<div class="mFormToggle panel-collapse collapse thirdMsg"
											id="intercityCost">
											<div class="mFormToggleConn">
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">合同编号</div>
													<div class="mFormXSMsg">
														<input type="text" class="longInput"
															value="${map.business.barginManage.barginCode }" readonly>
													</div>
												</div>
											</div>
											<div class="mFormToggleConn">
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">合同名称</div>
													<div class="mFormXSMsg">
														<input type="text" class="longInput"
															value="${map.business.barginManage.barginName }" readonly>
													</div>
												</div>
											</div>
											<div class="mFormToggleConn">
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">所属项目</div>
													<div class="mFormXSMsg">
														<input type="hidden" id="projectManageId" name="projectId"
															value="${map.business.projectId }" readonly> <input
															type="text" class="longInput" name="projectname"
															value="${map.business.projectManage.name }" readonly>
													</div>
												</div>
											</div>
											<div class="mFormToggleConn">
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">合同总额</div>
													<div class="mFormXSMsg">
														<input type="text" class="longInput" name="totalPay"
															id="totalPay"
															value="<fmt:formatNumber value='${map.business.totalPay }' pattern='0.00' />"
															onkeyup="initInputBlur()">
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</li>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">收款类型</div>
							<div class="mFormMsg" style="height: 40px">
								<c:choose>
									<c:when test="${map.task.name eq '财务' and map.isHandler}">
										<select class="mSelect" name="collectionType"><custom:dictSelect
												type="费用性质" selectedValue="${map.business.collectionType }" /></select>
									</c:when>
									<c:otherwise>
										<input type="text" class="longInput" name="collectionType"
											value="<custom:getDictKey type="费用性质" value ="${map.business.collectionType }"/>"
											readonly>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">附件</div>
							<div class="mFormMsg" style="height: 40px; line-height: 30px;">
								<a href="javascript:void(0);" onclick="downloadAttach(this)"
									value="${map.business.attachments }" target='_blank'> <input
									type="text" id="showName" name="showName"
									value="${map.business.attachName }"
									style="text-align: left; border: 0; outline: 0; margin-top: 5px"
									readonly>
								</a>
							</div>
						</div>
					</li>
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">备注</div>
							<div class="mFormMsg">
								<textarea name="reason" readonly>${map.business.reason}</textarea>
							</div>
						</div>
					</li>
					<li class="clearfix" id="accordion">
						<div class="col-xs-12">
							<div class="mFormName">付款单位</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="payCompany"
									value="${map.business.payCompany}" readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">申请金额</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" readonly name="applyPay"
									id="applyPay" onkeyup="initInputBlur()"
									value="<fmt:formatNumber value='${map.business.applyPay}' pattern='0.00' />">
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12">
							<div class="mFormName">申请比例</div>
							<div class="mFormMsg">
								<input type="text" class="longInput" name="applyProportion"
									id="applyProportion" value="${map.business.applyProportion}"
									readonly>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="col-xs-12 ">
							<div class="mFormName">开具发票</div>
							<div class="mFormMsg"
								style="text-align: right; min-height: 40px !important; line-height: 40px">
								<input type="text" class="longInput"
									value="<custom:getDictKey type="发票开具" value="${map.business.isInvoiced}"/>"
									readonly> <input type="hidden" name="isInvoiced"
									id="isInvoiced" value="${map.business.isInvoiced}">
							</div>
						</div>
					</li>
					<c:choose>
						<c:when test="${(map.task.name eq '财务' and map.isHandler)}">
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">开票金额</div>
									<div class="mFormMsg">
										<input type="text" name="bill" id="bill" class="longInput"
											placeholder="必填项"
											value="<fmt:formatNumber value='${map.business.bill}' pattern='0.00' />">
									</div>
								</div>
							</li>
							<li class="clearfix">
								<div class="col-xs-12">
									<div class="mFormName">开票日期</div>
									<div class="mFormMsg">
										<input type="text" name="billDate" class="billDate longInput"
											placeholder="必填项" readonly
											value="<fmt:formatDate value="${map.business.billDate }" pattern="yyyy-MM-dd" />"></input>
									</div>
								</div>
							</li>
						</c:when>
						<c:otherwise>
							<c:if test="${map.task.name ne '部门经理'}">
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">开票金额</div>
										<div class="mFormMsg">
											<input type="text" name="bill" id="bill" class="longInput"
												placeholder="必填项"
												value="<fmt:formatNumber value='${map.business.bill}' pattern='0.00' />">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">开票日期</div>
										<div class="mFormMsg">
											<input type="text" name="billDate" class="billDate longInput"
												placeholder="必填项" readonly
												value="<fmt:formatDate value="${map.business.billDate }" pattern="yyyy-MM-dd" />"></input>
										</div>
									</div>
								</li>
							</c:if>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${(map.task.name eq '出纳' and map.isHandler)}">
							<c:if test="${empty map.business.collectionAttachList }">
								<ul class="mForm" id="node">
									<li class="clearfix parentli" name="node"><input
										type="hidden" name="businessId" value="" readonly>
										<div class="col-xs-12">
											<div class="mFormName">收款条目</div>
											<div class="mFormMsg firstMsg">
												<div class="mFormShow secondMsg" onclick="changeImage(this)"
													href="#intercityCostI" data-toggle="collapse"
													data-parent="#accordion">
													<div class="mFormSeconMsg"></div>
													<div class="mFormSeconMsg"></div>
													<div class="mFormArr current">
														<img src="<%=base%>/static/images/arr.png" alt="">
													</div>
												</div>
												<div class="mFormOpe1" onclick="node('add',this)">
													<img src="<%=base%>/static/images/add.png" alt="添加">
												</div>
												<div class="mFormToggle panel-collapse collapse thirdMsg"
													id="intercityCostI">
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">收款日期</div>
															<div class="mFormXSMsg">
																<input type="text" class="collectionDate longInput"
																	id="collectionDate" name="collectionDate"
																	class="collectionDate" readonly>
															</div>
														</div>
													</div>
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">收款金额</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" id="collectionBill"
																	name="collectionBill"
																	onkeyup="initCompareBillWithBillCollection()">
															</div>
														</div>
													</div>
												</div>
											</div></li>
								</ul>
							</c:if>
							<c:if test="${not empty map.business.collectionAttachList }">
								<ul class="mForm" id="node">
									<c:forEach items="${map.business.collectionAttachList }"
										var="business" varStatus="varStatus">
										<li class="clearfix parentli" name="node"><input
											type="hidden" name="businessId" value="${business.id}"
											readonly>
											<div class="col-xs-12">
												<div class="mFormName">收款条目</div>
												<div class="mFormMsg firstMsg">
													<div class="mFormShow secondMsg"
														onclick="changeImage(this)"
														href="#intercityCostII${varStatus.index }"
														data-toggle="collapse" data-parent="#accordion">
														<div class="mFormSeconMsg"></div>
														<div class="mFormSeconMsg"></div>
														<div class="mFormArr current">
															<img src="<%=base%>/static/images/arr.png" alt="">
														</div>
													</div>
													<c:if test="${varStatus.last }">
														<div class="mFormOpe1" onclick="node('add',this)">
															<img src="<%=base%>/static/images/add.png" alt="添加">
														</div>
													</c:if>
													<c:if test="${!varStatus.last }">
														<div class="mFormOpe1" onclick="node('del',this)">
															<img src="<%=base%>/static/images/del.png" alt="删除">
														</div>
													</c:if>
													<div class="mFormToggle panel-collapse collapse thirdMsg"
														id="intercityCostII${varStatus.index }">
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">收款日期</div>
																<div class="mFormXSMsg">
																	<input type="text" class="collectionDate longInput"
																		id="collectionDate" name="collectionDate"
																		class="collectionDate"
																		value="<fmt:formatDate value="${business.collectionDate }" pattern="yyyy-MM-dd" />"
																		readonly>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">收款金额</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput"
																		id="collectionBill" name="collectionBill"
																		onkeyup="initCompareBillWithBillCollection()"
																		value="${business.collectionBill}">
																</div>
															</div>
														</div>
													</div>
												</div>
											</div></li>
									</c:forEach>
								</ul>
							</c:if>
						</c:when>
						<c:otherwise>
							<c:if test="${not empty map.business.collectionAttachList }">
								<ul class="mForm" id="node">
									<c:forEach items="${map.business.collectionAttachList }"
										var="business" varStatus="varStatus">
										<li class="clearfix parentli" name="node"><input
											type="hidden" name="businessId" value="${business.id}"
											readonly>
											<div class="col-xs-12">
												<div class="mFormName">收款条目</div>
												<div class="mFormMsg firstMsg">
													<div class="mFormShow secondMsg"
														onclick="changeImage(this)"
														href="#intercityCostII${varStatus.index }"
														data-toggle="collapse" data-parent="#accordion">
														<div class="mFormSeconMsg"></div>
														<div class="mFormSeconMsg"></div>
														<div class="mFormArr current">
															<img src="<%=base%>/static/images/arr.png" alt="">
														</div>
													</div>
													<div class="mFormToggle panel-collapse collapse thirdMsg"
														id="intercityCostII${varStatus.index }">
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">收款日期</div>
																<div class="mFormXSMsg">
																	<input type="text" class="collectionDate longInput"
																		id="collectionDate" name="collectionDate"
																		class="collectionDate"
																		value="<fmt:formatDate value="${business.collectionDate }" pattern="yyyy-MM-dd" />"
																		readonly>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">收款金额</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput"
																		id="collectionBill" name="collectionBill"
																		onkeyup="initCompareBillWithBillCollection()"
																		value="${business.collectionBill}" readonly>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div></li>
									</c:forEach>
								</ul>
							</c:if>
						</c:otherwise>
					</c:choose>
					</ul>
					</li>
				</c:otherwise>
				</c:choose>


				<li class="clearfix" id="billnote">
					<div class="col-xs-12"
						style="height: 40px !important; font-size: 16px; font-weight: bold; line-height: 40px">
						<center>发票内容</center>
					</div>
				</li>
				<c:choose>
					<c:when
						test="${(map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id }">
						<li class="clearfix" id="billnote1">
							<ul class="mForm" id="billUl">
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">购货单位名称</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="payname"
												value="${map.business.invoiced.payname}">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">纳税人识别号</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" id="paynumber"
												name="paynumber" value="${map.business.invoiced.paynumber}">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">地址</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="payaddress"
												value="${map.business.invoiced.payaddress}">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">电话</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="payphone"
												id="payphone" value="${map.business.invoiced.payphone}">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">开户行</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="bankAddress"
												value="${map.business.invoiced.bankAddress}">
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">账号</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" id="bankNumber"
												name="bankNumber"
												value="${map.business.invoiced.bankNumber}">
										</div>
									</div>
								</li>
								<c:if test="${not empty map.business.invoicedAttachList }">
									<ul class="mForm" id="add">
										<c:forEach items="${map.business.invoicedAttachList }"
											var="invoiced" varStatus="varStatus">
											<li class="clearfix parentli" name="add">
												<div class="col-xs-12">
													<div class="mFormName">货物单详情</div>
													<div class="mFormMsg firstMsg">
														<div class="mFormShow secondMsg"
															onclick="changeImage(this)"
															href="#intercityCostIII${varStatus.index }"
															data-toggle="collapse" data-parent="#accordion">
															<div class="mFormSeconMsg">
																<span></span>
															</div>
															<div class="mFormArr current">
																<img src="<%=base%>/static/images/arr.png" alt="">
															</div>
														</div>
														<c:if test="${varStatus.last }">
															<div class="mFormOpe1" onclick="add('add',this)">
																<img src="<%=base%>/static/images/add.png" alt="添加">
															</div>
														</c:if>
														<c:if test="${!varStatus.last }">
															<div class="mFormOpe1" onclick="add('del',this)">
																<img src="<%=base%>/static/images/del.png" alt="删除">
															</div>
														</c:if>
														<div class="mFormToggle panel-collapse collapse thirdMsg"
															id="intercityCostIII${varStatus.index }">

															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">货物或应税劳务名称</div>
																	<div class="mFormXSMsg">
																		<input type="hidden" name="attachId"
																			value="${invoiced.id }"> <input type="text"
																			class="longInput" name="name"
																			value="${invoiced.name}">
																	</div>
																</div>
															</div>
															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">规格型号</div>
																	<div class="mFormXSMsg">
																		<input type="text" class="longInput" name="model"
																			value="${invoiced.model}">
																	</div>
																</div>
															</div>

															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">单位</div>
																	<div class="mFormXSMsg">
																		<input type="text" class="longInput" name="unit"
																			value="${invoiced.unit}">
																	</div>
																</div>
															</div>
															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">数量</div>
																	<div class="mFormXSMsg">
																		<input type="text" class="longInput" name="number"
																			value="${invoiced.number}" onkeyup="coutmoney()">
																	</div>
																</div>
															</div>

															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">单价</div>
																	<div class="mFormXSMsg">
																		<input type="text" class="longInput" name="price"
																			value="${invoiced.price}" readonly>
																	</div>
																</div>
															</div>
															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">金额</div>
																	<div class="mFormXSMsg">
																		<input type="text" class="longInput" readonly
																			name="money" value="${invoiced.money}">
																	</div>
																</div>
															</div>

															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">税率</div>
																	<div class="mFormXSMsg">
																		<select name="excise" onchange="initexcise()"
																			class="mSelect">
																			<option
																				<c:if test="${invoiced.excise eq 0 }">selected</c:if>>0</option>
																			<option
																				<c:if test="${invoiced.excise eq 6 }">selected</c:if>>6</option>
																			<option
																				<c:if test="${invoiced.excise eq 16 }">selected</c:if>>16</option>
																			<option
																				<c:if test="${invoiced.excise eq 17 }">selected</c:if>>17</option>
																		</select>
																	</div>
																</div>
															</div>
															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">税额</div>
																	<div class="mFormXSMsg">
																		<input type="text" class="longInput"
																			name="exciseMoney" readonly
																			value="${invoiced.exciseMoney}">
																	</div>
																</div>
															</div>
															<div class="mFormToggleConn">
																<div class="mFormXSToggleConn">
																	<div class="mFormXSName">价税小计</div>
																	<div class="mFormXSMsg">
																		<input type="text" name="levied" class="longInput"
																			value="${invoiced.levied}" onkeyup="coutmoney()">
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
											</li>
										</c:forEach>
									</ul>
								</c:if>
								<c:if test="${empty map.business.invoicedAttachList }">
									<ul class="mForm" id="add">
										<li class="clearfix parentli" name="add">
											<div class="col-xs-12">
												<div class="mFormName">货物单详情</div>
												<div class="mFormMsg firstMsg">
													<div class="mFormShow secondMsg"
														onclick="changeImage(this)" href="#intercityCostVII"
														data-toggle="collapse" data-parent="#accordion">
														<div class="mFormSeconMsg">
															<span></span>
														</div>
														<div class="mFormArr current">
															<img src="<%=base%>/static/images/arr.png" alt="">
														</div>
													</div>
													<div class="mFormOpe1" onclick="add('add',this)">
														<img src="<%=base%>/static/images/add.png" alt="添加">
													</div>
													<div class="mFormToggle panel-collapse collapse thirdMsg"
														id="intercityCostVII">

														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">货物或应税劳务名称</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="name">
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">规格型号</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="model">
																</div>
															</div>
														</div>

														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">单位</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="unit">
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">数量</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="number"
																		onkeyup="coutmoney()">
																</div>
															</div>
														</div>

														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">单价</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="price"
																		readonly>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">金额</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="money" value="0"
																		readonly>
																</div>
															</div>
														</div>

														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">税率</div>
																<div class="mFormXSMsg">
																	<select name="excise" onchange="initexcise()"
																		class="mSelect">
																		<option selected="selected">0</option>
																		<option>6</option>
																		<option>16</option>
																		<option>17</option>
																	</select>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">税额</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="exciseMoney" value="0"
																		readonly>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">价税小计</div>
																<div class="mFormXSMsg">
																	<input type="text" name="levied" class="longInput"
																		value="" onkeyup="coutmoney()">
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</li>
									</ul>
								</c:if>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">金额合计</div>
										<div class="mFormMsg">
											<input type="text" class="longInput" name="total" value=""
												readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">税额合计</div>
										<div class="mFormMsg">
											<input type="text" class="longInput" name="totalexcisemoney" value="0"
												readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">价税合计</div>
										<div class="mFormMsg">
											<input type="text" class="longInput" name="totalexcise"
												value="" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix parentli">
									<div class="col-xs-12">
										<div class="mFormName">销货单位</div>
										<div class="mFormMsg firstMsg">
											<div class="mFormShow secondMsg" onclick="changeImage(this)"
												href="#intercityCostIV" data-toggle="collapse"
												data-parent="#accordion">
												<div class="mFormSeconMsg">
													<!-- <span><input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="border:none;display:none;"></span> -->
												</div>
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
											</div>
											<div class="mFormToggle panel-collapse collapse thirdMsg"
												id="intercityCostIV">

												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">销货单位名称</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionCompany"
																value="${map.business.invoiced.collectionCompany}">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">纳税人识别号</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																id="collectionNumber" name="collectionNumber"
																value="${map.business.invoiced.collectionNumber}">
														</div>
													</div>
												</div>

												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">地址</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionAddress"
																value="${map.business.invoiced.collectionAddress}">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">电话</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																id="collectionContact" name="collectionContact"
																value="${map.business.invoiced.collectionContact}">
														</div>
													</div>
												</div>

												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">开户行</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionBank"
																value="${map.business.invoiced.collectionBank}">
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">账号</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																id="collectionAccount" name="collectionAccount"
																value="${map.business.invoiced.collectionAccount}">
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">备注</div>
										<div class="mFormMsg">
											<textarea name="remark" placeholder="备注"
												style="padding-top: 12px">${map.business.invoiced.remark}</textarea>
										</div>
									</div>
								</li>
							</ul>
						</li>
					</c:when>
					<c:otherwise>
						<li class="clearfix" id="billnote1">
							<ul class="mForm" id="billUl">
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">购货单位名称</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="payname"
												value="${map.business.invoiced.payname}" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">纳税人识别号</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="paynumber"
												value="${map.business.invoiced.paynumber}" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">地址</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="payaddress"
												value="${map.business.invoiced.payaddress}" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">电话</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="payphone"
												value="${map.business.invoiced.payphone}" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">开户行</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="bankAddress"
												value="${map.business.invoiced.bankAddress}" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">账号</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="bankNumber"
												value="${map.business.invoiced.bankNumber}" readonly>
										</div>
									</div>
								</li>
								<ul class="mForm" id="add">
									<c:forEach items="${map.business.invoicedAttachList }"
										var="invoiced" varStatus="varStatus">
										<li class="clearfix parentli" name="add">
											<div class="col-xs-12">
												<div class="mFormName">货物单详情</div>
												<div class="mFormMsg firstMsg">
													<div class="mFormShow secondMsg"
														onclick="changeImage(this)"
														href="#intercityCostV${varStatus.index}"
														data-toggle="collapse" data-parent="#accordion">
														<div class="mFormSeconMsg">
															<span></span>
														</div>
														<div class="mFormArr current">
															<img src="<%=base%>/static/images/arr.png" alt="">
														</div>
													</div>
													<div class="mFormToggle panel-collapse collapse thirdMsg"
														id="intercityCostV${varStatus.index}">
														<c:choose>
															<c:when test="${map.task.name eq '财务' and map.isHandler }">
																<div class="mFormToggleConn">
																	<div class="mFormXSToggleConn">
																		<div class="mFormXSName">货物或应税劳务名称</div>
																		<div class="mFormXSMsg">
																			<input type="hidden" name="attachId"
																				value="${invoiced.id }"> <input type="text"
																				class="longInput" name="name"
																				value="${invoiced.name}">
																		</div>
																	</div>
																</div>
																<div class="mFormToggleConn">
																	<div class="mFormXSToggleConn">
																		<div class="mFormXSName">规格型号</div>
																		<div class="mFormXSMsg">
																			<input type="text" class="longInput" name="model"
																				value="${invoiced.model}">
																		</div>
																	</div>
																</div>
															</c:when>
															<c:otherwise>
																<div class="mFormToggleConn">
																	<div class="mFormXSToggleConn">
																		<div class="mFormXSName">货物或应税劳务名称</div>
																		<div class="mFormXSMsg">
																			<input type="hidden" name="attachId"
																				value="${invoiced.id }"> <input type="text"
																				class="longInput" name="name"
																				value="${invoiced.name}" readonly>
																		</div>
																	</div>
																</div>
																<div class="mFormToggleConn">
																	<div class="mFormXSToggleConn">
																		<div class="mFormXSName">规格型号</div>
																		<div class="mFormXSMsg">
																			<input type="text" class="longInput" name="model"
																				value="${invoiced.model}" readonly>
																		</div>
																	</div>
																</div>
															</c:otherwise>
														</c:choose>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">单位</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="unit"
																		value="${invoiced.unit}" readonly>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">数量</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="number"
																		value="${invoiced.number}" readonly>
																</div>
															</div>
														</div>

														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">单价</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="price"
																		value="${invoiced.price}" readonly>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">金额</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="money"
																		value="${invoiced.money}" readonly>
																</div>
															</div>
														</div>

														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">税率</div>
																<div class="mFormXSMsg">
																	<select name="excise" class="mSelect">
																		<option
																			<c:if test="${invoiced.excise eq 0 }">selected</c:if>>0</option>
																		<option
																			<c:if test="${invoiced.excise eq 6 }">selected</c:if>>6</option>
																		<option
																			<c:if test="${invoiced.excise eq 17 }">selected</c:if>>17</option>
																	</select>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">税额</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="exciseMoney"
																		value="${invoiced.exciseMoney}" readonly>
																</div>
															</div>
														</div>
														<div class="mFormToggleConn">
															<div class="mFormXSToggleConn">
																<div class="mFormXSName">价税小计</div>
																<div class="mFormXSMsg">
																	<input type="text" class="longInput" name="levied"
																		value="${invoiced.levied}" readonly>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</li>
									</c:forEach>
								</ul>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">金额合计</div>
										<div class="mFormMsg">
											<input type="text" class="longInput" name="totalexcisemoney"
												readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName mFormName1">税额合计</div>
										<div class="mFormMsg mFormMsg1">
											<input type="text" class="longInput" name="totalexcise"
												value="" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">价税合计</div>
										<div class="mFormMsg">
											<input type="text" class="longInput" name="totalexcise"
												value="" readonly>
										</div>
									</div>
								</li>
								<li class="clearfix parentli">
									<div class="col-xs-12">
										<div class="mFormName">销货单位</div>
										<div class="mFormMsg firstMsg">
											<div class="mFormShow secondMsg" onclick="changeImage(this)"
												href="#intercityCostVI" data-toggle="collapse"
												data-parent="#accordion">
												<div class="mFormSeconMsg">
													<!-- <span><input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="border:none;display:none;"></span> -->
												</div>
												<div class="mFormArr current">
													<img src="<%=base%>/static/images/arr.png" alt="">
												</div>
											</div>
											<div class="mFormToggle panel-collapse collapse thirdMsg"
												id="intercityCostVI">
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">销货单位名称</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionCompany"
																value="${map.business.invoiced.collectionCompany}"
																readonly>
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">纳税人识别号</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionNumber"
																value="${map.business.invoiced.collectionNumber}"
																readonly>
														</div>
													</div>
												</div>

												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">地址</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionAddress"
																value="${map.business.invoiced.collectionAddress}"
																readonly>
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">电话</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionContact"
																value="${map.business.invoiced.collectionContact}"
																readonly>
														</div>
													</div>
												</div>

												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">开户行</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionBank"
																value="${map.business.invoiced.collectionBank}" readonly>
														</div>
													</div>
												</div>
												<div class="mFormToggleConn">
													<div class="mFormXSToggleConn">
														<div class="mFormXSName">账号</div>
														<div class="mFormXSMsg">
															<input type="text" class="longInput"
																name="collectionAccount"
																value="${map.business.invoiced.collectionAccount}"
																readonly>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</li>
								<li class="clearfix">
									<div class="col-xs-12">
										<div class="mFormName">备注</div>
										<div class="mFormMsg">
											<textarea name="remark" placeholder="备注" readonly
												style="padding-top: 12px">${map.business.invoiced.remark}</textarea>
										</div>
									</div>
								</li>
							</ul>
						</li>
					</c:otherwise>
				</c:choose>

				<li class="clearfix">
					<div class="col-xs-12">
						<div class="mFormName">批注</div>
						<div class="mFormMsg" style="height: 40px">
							<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
								<textarea id="comment" name="comment" rows="2" cols="70"
									placeholder="请填写批注"
									style="float: left; width: 70%; height: 100%;"></textarea>
							</c:if>
						</div>
					</div>
				</li>
				</ul>

				<div class="mformBtnBox">
					<%-- <c:if
						test="${map.business.userId eq sessionScope.user.id and map.task.name eq '部门经理' }">
						<button type="button" id="submitBtn" class="btn btn-primary"
							onclick="approve('1')">提交</button>
						<button id="cancelBtn" type="button" class="btn btn-warning"
							onclick="approve('5')">取消申请</button>
					</c:if>

					<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
						<c:choose>
							<c:when test="${ map.task.name eq '总经理'}">
								<c:choose>
									<c:when test="${map.business.isInvoiced eq '1'}">
										<button type="button" class="btn btn-primary"
											onclick="approve('2')">同意</button>
										<button type="button" class="btn btn-warning"
											onclick="approve('3')">不同意</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-primary"
											onclick="approve('2')">确认</button>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:when test="${(map.task.name eq '出纳' and map.isHandler)}">
								<span id="billHidden" hidden>
									<button type="button" class="btn btn-primary"
										onclick="approve('2')">同意</button>
								</span>
								<button type="button" class="btn btn-warning"
									onclick="approve('3')">不同意</button>
								<button type="button" class="btn btn-success" onclick="save()">保存</button>
							</c:when>
							<c:when test="${(map.task.name eq '财务' and map.isHandler)}">
								<!-- <span id="notEqual" hidden>
											<button type="button"  class="btn btn-primary" onclick="approve('2')" >同意</button>
										</span> -->
								<span>
									<button type="button" class="btn btn-primary"
										onclick="approve('2')">同意</button>
								</span>
								<button type="button" class="btn btn-warning"
									onclick="approve('3')">不同意</button>
							</c:when>
							<c:otherwise>
								<button type="button" class="btn btn-primary"
									onclick="approve('2')">同意</button>
								<button type="button" class="btn btn-warning"
									onclick="approve('3')">不同意</button>
							</c:otherwise>
						</c:choose>
					</c:if>

					<c:if
						test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
						<button id="reapplyBtn" type="button" class="btn btn-primary"
							onclick="approve('4')">重新申请</button>
						<button id="cancelBtn" type="button" class="btn btn-warning"
							onclick="approve('5')">取消申请</button>
					</c:if>
					<c:if
						test="${map.business.status eq '3'  or map.business.status eq '4' or map.business.status eq '5'
											or map.business.status eq '2'}">
						<button type="button" class="btn btn-primary"
							onclick="print(${map.business.processInstanceId })">打印</button>
					</c:if>
					<c:if
						test="${(map.business.status eq '3' or map.business.status eq '4' 
							  or map.business.status eq '5' or map.business.status eq '2') and sessionScope.user.id eq '5'}">
						<button type="button" class="btn btn-primary"
							onclick="exportpdf(${map.business.processInstanceId })">导出PDF</button>
					</c:if>
					 --%>
					<button type="button" class="btn btn-default"
						onclick="javascript:window.history.back(-1)">返回</button>
				</div>
			</form>
		</div>
		<!-- /.box -->
	</section>
	<!-- /.content -->
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
	<!-- /.content-wrapper -->

	<div id="barginDialog"></div>
	<div id="projectDialog"></div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="barginDetailModal" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog" style="width: 80%; height: 80%;">
			<div class="modal-content" style="height: 100%;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">合同详情</h4>
				</div>
				<div class="modal-body" style="height: 75%;">
					<iframe id="barginDetailFrame" name="barginDetailFrame"
						width="100%" frameborder="no" scrolling="auto"
						style="height: 100%;"></iframe>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal -->
	<!-- /.modal -->

	<!-- ./wrapper -->
	<%@ include file="../../common/footer.jsp"%>
	<script type="text/javascript">
	var base = "<%=base%>";
	var variables = ${map.jsonMap.variables};
	var editInvest = false;
	var editflag = false;
	<c:if test="${(map.task.name eq '出纳' and map.isHandler)}">
		var editInvest = true;
	</c:if>
	<c:if test="${(map.task.name eq '财务' and map.isHandler)}">
		var  editflag = true;
	</c:if>
</script>

	<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript"
		src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
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

	<script type="text/javascript"
		src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
	<script type="text/javascript"
		src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
	<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
	<script type="text/javascript"
		src="<%=base%>/views/manage/finance/collection/js/mobileprocess.js"></script>
	<!-- 全局变量 -->

</body>
</html>

