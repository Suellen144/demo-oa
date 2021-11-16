<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/dist/css/skins/_all-skins.min.css">
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
}

.secondMsg {
	position: relative;
	z-index: 2;
}

.thirdMsg {
	position: relative;
	top: 0px
}

.mFormOpe {
	position: absolute;
	top: 0px;
	right: 8px;
	z-index: 9;
}
</style>

</head>
<body class="hold-transition skin-blue sidebar-mini">
	<!-- Site wrapper -->

	<!-- Content Header (Page header) -->
	<section class="content-header">
		<span style="font-size: 20px; font-weight: bold;">付款申请表</span>
	</section>

	<!-- Main content -->
	<section class="content">
		<!-- Default box -->
		<div class="box box-primary tbspace">
			<form id="form1">
				<input type="hidden" id="currStatus" name="currStatus"
					value="${map.business.status }"> <input type="hidden"
					id="taskId" name="taskId" value="${map.task.id}"> <input
					type="hidden" id="operStatus" value="">
				<c:if
					test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请') }">
					<input type="hidden" id="approver" name="approver"
						value="${map.initiator.name }">
				</c:if>
				<c:if
					test="${map.business.userId ne sessionScope.user.id or (map.task.name ne '提交申请') }">
					<input type="hidden" id="approver" name="approver"
						value="${sessionScope.user.name }">
				</c:if>

				<input type="hidden" id="isHandler" value="${map.isHandler}">
				<input type="hidden" id="taskName" value="${map.task.name}">
				<input type="hidden" id="barginManageId" name="barginManageId" value="${map.business.barginManageId}">
				<input type="hidden" id="barginProcessInstanceId" value="${map.business.barginManage.processInstanceId}">
				<input type="hidden" id="id" name="id" value="${map.business.id}">
				<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments}">
				<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName}">
				<input type="hidden" id="deptId" name="deptId" value="${map.business.deptId}">
				<input type="hidden" id="userId" name="userId" value="${map.business.userId}">
				<input type="hidden" id="currUserId" value="${sessionScope.user.id }" readonly>
				<input type="hidden" id="issubmit" name="issubmit" value="">
				<ul class="mForm">
					<c:choose>
						<c:when
							test="${(map.task.name eq '提交申请' or (map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '财务' and map.initiator.isSkip eq '1')) and map.business.userId eq sessionScope.user.id }">
							<li class="clearfix">
								<ul class="mForm" id="ulForm">
									<li class="clearfix" id="accordion">
										<div class="col-xs-12">
											<div class="mFormName">发起人</div>
											<div class="mFormMsg">
												<input type="text" name="name" class="longInput"
													value="${map.business.sysUser.name }" readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">申请日期</div>
											<div class="mFormMsg">
												<input type="text" id="applyTime" class="longInput"
													name="applyTime"
													value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />"
													style="color: gray;" readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">所属单位</div>
											<div class="mFormMsg clearfix">
												<div style="float: right;">
													<c:if
														test="${map.business.dept.name ne '东北办事处' and map.business.dept.name ne '沈阳办事处'}">
														<select name="title" style="text-align: right !important;"
															class="mSelect firstSelect">
															<custom:dictSelect type="流程所属公司"
																selectedValue="${map.business.title }" />
														</select>
														<c:if test="${map.business.dept.name ne '总经理'}">
															<input type="text" class="longInput" style="width: 50px"
																value="${map.business.dept.name}" readonly>
														</c:if>
													</c:if>
													<c:if
														test="${map.business.dept.name eq '东北办事处' or map.business.dept.name eq '沈阳办事处'}">
														<input name="title" value="10" type="hidden">
														<custom:getDictKey type="流程所属公司" value="10" />
														<input type="text" class="longInput"
															value="${map.business.dept.name }" readonly>
													</c:if>
												</div>
											</div>
										</div>
									</li>
									<li class="clearfix" id="accordion">
										<div class="col-xs-12">
											<div class="mFormName">收款单位</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="collectCompany"
													id="collectCompany" value="${map.business.collectCompany}">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">开户行</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="bankAddress"
													id="bankAddress" value="${map.business.bankAddress }">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">账号</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="bankAccount"
													id="bankAccount" value="${map.business.bankAccount}">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">付款类型</div>
											<div class="mFormMsg" style="height:40px">
												<select name="payType" class="mSelect" style="height:38px">
												<custom:dictSelect
														type="付款类型" selectedValue="${map.business.payType}" />
												</select>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">用途</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="purpose"
													id="purpose" value="${map.business.purpose }">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">申请金额</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="applyMoney"
													id="applyMoney"
													value="<fmt:formatNumber value='${map.business.applyMoney}' pattern='0.00' />"
													onblur="initInputBlur()">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">合同管理</div>
											<div class="mFormMsg" style="height:40px">
												<div style="float: right; width: auto; height: 39px">
													<div style="float: right;">
														<input type="button" class="longInput" id="viewBarginBtn"
															value="查看合同详细" onclick="viewBargin()"
															style="display: none;">
													</div>
													<div style="float: right;">
														<input type="button" class="longInput" value="关联合同"
															onclick="openBargin()"
															style="border: none; display: inline;">
													</div>
												</div>
											</div>
										</div>
									</li>
									<li class="clearfix parentli" name="node">
										<div class="col-xs-12">
											<div class="mFormName">关联合同</div>
											<div class="mFormMsg firstMsg">
												<div class="mFormShow secondMsg" onclick="changeImage(this)"
													href="#intercityCost" data-toggle="collapse"
													data-parent="#accordion">
													<div class="mFormSeconMsg">
														<span>${map.business.barginManage.barginName }</span>
													</div>
													<div class="mFormArr current">
														<img src="<%=base%>/static/dist/img/oa/arr.png" alt="">
													</div>
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
															<div class="mFormXSMsg"
																style="font-size: 12px; color: gray;">
																<input type="text" class="longInput"
																	name="projectManageName" id="projectManageName"
																	value="${map.business.projectManage.name }" readonly>
															</div>
														</div>
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">合同总额</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" name="totalMoney"
																	id="totalMoney"
																	value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />">
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</li>

									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">申请比例</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="applyProportion" id="applyProportion" value="${map.business.applyProportion}" readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">发票已收</div>
											<div class="mFormMsg"
												style="text-align: right; min-height: 40px !important; line-height: 40px">
												<select name="invoiceCollect" id="invoiceCollect" onchange="change(this)" class="mSelect">
												<custom:dictSelect type="发票收取状态" selectedValue="${map.business.invoiceCollect}"/></select>
											</div>
										</div>
									</li>
									<li class="clearfix showOrHidden" >
										<div class="col-xs-12">
											<div class="mFormName">发票金额</div>
											<div class="mFormMsg">
												<input type="text"  class="longInput" name="invoiceMoney"  id ="invoiceMoney" value="<fmt:formatNumber value='${map.business.invoiceMoney}' pattern='0.00' />">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">附件</div>
											<div class="mFormMsg">
												<div class="mFormShow">
													<div class="mFormSeconMsg">
														<a href="javascript:void(0);"
															onclick="downloadAttach(this)"
															value="${map.business.attachments }" target='_blank'>
															<input type="text" class="longInput" id="showName"
															name="showName" value="${map.business.attachName }"
															style="text-align: left;" readonly>
														</a>
													</div>
													<div class="mFormArr">
														<input type="file" id="file" name="file"
															style="display: none;">
														<c:if test="${not empty map.business.attachments }">
															<a href="javascript:void(0);"
																style="float: right; margin-left: 10px; margin-right: 20px"
																onclick="deleteAttach(this)"
																value="${map.business.attachments }">删除</a>
														</c:if>
														<img src="<%=base %>/static/dist/img/oa/upload.png" alt="" onclick="$('#file').click()">
													</div>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</li>
						</c:when>

						<c:otherwise>
							<li class="clearfix">
								<ul class="mForm" id="ulForm">
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">发起人</div>
											<div class="mFormMsg">
												<input type="text" name="name" class="longInput"
													value="${map.business.sysUser.name }" readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">申请日期</div>
											<div class="mFormMsg">
												<input type="text" id="applyTime" class="longInput"
													name="applyTime"
													value="<fmt:formatDate value="${map.business.applyTime }" pattern="yyyy-MM-dd" />"
													style="color: gray;" readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">所属单位</div>
											<div class="mFormMsg clearfix">
												<div style="float: right;line-height: 40px">
													<c:if
														test="${map.business.dept.name ne '东北办事处' and map.business.dept.name ne '沈阳办事处'}">
														<custom:getDictKey type="流程所属公司"
															value="${map.business.title }" />
														<c:if test="${map.business.dept.name ne '总经理'}">
															<input type="text" style="width: 50px" class="longInput"
																value="${map.business.dept.name}" readonly>
														</c:if>
													</c:if>
													<c:if
														test="${map.business.dept.name eq '东北办事处' or map.business.dept.name eq '沈阳办事处'}">
														<input name="title" value="10" type="hidden">
														<custom:getDictKey type="流程所属公司" value="10" />
														<input type="text" style="width: 50px" class="longInput"
															value="${map.business.dept.name }" readonly>
													</c:if>
												</div>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">收款单位</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="collectCompany"
													id="collectCompany" value="${map.business.collectCompany}">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">开户行</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="bankAddress"
													id="bankAddress" value="${map.business.bankAddress }">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">账号</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="bankAccount"
													id="bankAccount" value="${map.business.bankAccount}">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">付款类型</div>
											<div class="mFormMsg"
												style="text-align: right; min-height: 40px !important; line-height: 40px">
												<custom:getDictKey type="付款类型"
													value="${map.business.payType}" />
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">用途</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="purpose"
													id="purpose" value="${map.business.purpose }">
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">申请金额</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="applyMoney"
													id="applyMoney"
													value="<fmt:formatNumber value='${map.business.applyMoney}' pattern='0.00' />"
													readonly>
											</div>
										</div>
									</li>
									<li class="clearfix parentli" name="node">
										<div class="col-xs-12">
											<div class="mFormName">关联合同</div>
											<div class="mFormMsg firstMsg">
												<div class="mFormShow secondMsg" onclick="changeImage(this)"
													href="#intercityCost" data-toggle="collapse"
													data-parent="#accordion">
													<div class="mFormSeconMsg">
														<span>${map.business.barginManage.barginName}</span>
													</div>
													<div class="mFormArr current">
														<img src="<%=base%>/static/dist/img/oa/arr.png" alt="">
													</div>
												</div>
												<div class="mFormToggle panel-collapse collapse thirdMsg"
													id="intercityCost">
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">合同编号</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" id="barginCode"
																	value="${map.business.barginManage.barginCode}"
																	readonly>
															</div>
														</div>
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">合同名称</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" id="barginName"
																	value="${map.business.barginManage.barginName}"
																	readonly>
															</div>
														</div>
													</div>
													<div class="mFormToggleConn">
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">所属项目</div>
															<div class="mFormXSMsg"
																style="font-size: 12px; color: gray;">
																<input type="text" class="longInput"
																	name="projectManageId" id="projectManageId"
																	value="${map.business.projectManageId }"
																	style="display: none;" readonly> <input
																	type="text" class="longInput" name="projectManageName"
																	id="projectManageName"
																	value="${map.business.projectManage.name }" readonly>
																</td>
															</div>
														</div>
														<div class="mFormXSToggleConn">
															<div class="mFormXSName">合同总额</div>
															<div class="mFormXSMsg">
																<input type="text" class="longInput" name="totalMoney"
																	id="totalMoney"
																	value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />">
																<input type="hidden" class="longInput"
																	name="barginTotalMoney" id="barginTotalMoney"
																	value="<fmt:formatNumber value='${map.business.barginManage.totalMoney}' pattern='0.00' />">
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12" style="margin-top:40px">
											<div class="mFormName" style="margin-top:-40px">合同管理</div>
											<div class="mFormMsg">
													<div style="float: right; width: auto; height: 38px;margin-top:-39px;">
													<div style="float: right;">
														<input type="button" class="longInput" id="viewBarginBtn"
															value="查看合同详细" onclick="viewBargin()"
															style="display: none;">
													</div>
													<div style="float: right;">
														<input type="button" class="longInput" value="关联合同"
															onclick="openBargin()"
															style="border: none; display: inline;">
													</div>
												</div>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">申请比例</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="applyProportion"
													id="applyProportion"
													value="${map.business.applyProportion}" readonly>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">发票已收</div>
											<div class="mFormMsg"
												style="text-align: right; min-height: 40px !important; line-height: 40px">
												<input type="hidden" name="invoiceCollect"
													id="invoiceCollect" value="${map.business.invoiceCollect }"
													readonly>
												<custom:getDictKey type="发票收取状态"
													value="${map.business.invoiceCollect}" />
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12 showOrHidden" >
											<div class="mFormName">发票金额</div>
											<div class="mFormMsg">
												<input type="text" class="longInput" name="invoiceMoney"
													id="invoiceMoney" readonly
													value="<fmt:formatNumber value='${map.business.invoiceMoney}' pattern='0.00' />">
											</div>
										</div>
									</li>
									<li class="clearfix"><c:choose>
											<c:when test="${map.isHandler and map.task.name eq '财务' }">
												<div class="col-xs-12">
													<div class="mFormName">发票实收</div>
													<div class="mFormMsg">
														<textarea name="actualInvoiceStatus"
															id="actualInvoiceStatus"
															value="${map.business.actualInvoiceStatus}">${map.business.actualInvoiceStatus}</textarea>
													</div>
												</div>

											</c:when>
											<c:when
												test="${(map.task.name eq '总经理')  or (map.task.name eq '出纳') or map.business.status eq '5'}">
												<div class="col-xs-12">
													<div class="mFormName">发票实收</div>
													<div class="mFormMsg">
														<textarea name="actualInvoiceStatus"
															id="actualInvoiceStatus" value="" readonly>${map.business.actualInvoiceStatus}</textarea>
													</div>
												</div>
											</c:when>
										</c:choose></li>
									<li class="clearfix"><c:if
											test="${map.isHandler and map.task.name eq '出纳'}">
											<div class="mFormToggleConn">
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">实际金额</div>
													<div class="mFormXSMsg">
														<input type="text" class="longInput" name="place"
															class="longInput" value="${business.place }"
															onchange="changeText(this,value)">
													</div>
												</div>
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">实际日期</div>
													<div class="mFormXSMsg">
														<textarea name="projectName" onclick="openProject(this)"
															readonly>${business.project.name }</textarea>
														<input type="hidden" name="projectId"
															value="${business.project.id }">
													</div>
												</div>
											</div>
										</c:if> <c:if test="${ map.business.status eq '5'}">
											<div class="mFormToggleConn">
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">实际金额</div>
													<div class="mFormXSMsg">
														<input type="text" class="longInput" name="actualPayMoney"
															id="actualPayMoney"
															value="<fmt:formatNumber value='${map.business.actualPayMoney}' pattern='0.00' />"
															readonly>
													</div>
												</div>
												<div class="mFormXSToggleConn">
													<div class="mFormXSName">实际日期</div>
													<div class="mFormXSMsg">
														<input class="longInput" type="text" name="actualPayDate"
															value='<fmt:formatDate value="${map.business.actualPayDate }" pattern="yyyy-MM-dd"/>'
															readonly>
													</div>
												</div>
											</div>
										</c:if></li>

									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">备注</div>
											<div class="mFormMsg">
												<textarea id="remark" name="remark" readonly>${map.business.remark}</textarea>
											</div>
										</div>
									</li>
									<li class="clearfix">
										<div class="col-xs-12">
											<div class="mFormName">附件</div>
											<div class="mFormMsg">
												<div class="mFormShow">
													<div class="mFormSeconMsg">
														<a href="javascript:void(0);"
															onclick="downloadAttach(this)"
															value="${map.business.attachments }" target='_blank'>
															<input type="text" id="showName" class="longInput" name="showName"
															value="${map.business.attachName }"  style="font-size: 12px;color: gray;text-align: left;"
															readonly>
														</a>
													</div>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</li>
						</c:otherwise>
					</c:choose>
					<li class="clearfix">
						<div class="col-xs-12" >
							<div class="mFormName" >批注</div>
							<div class="mFormMsg" style="height:40px">
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
						test="${map.business.userId eq sessionScope.user.id and ((map.task.name eq '部门经理' and map.initiator.isSkip ne '1' ) or (map.task.name eq '财务' and map.initiator.isSkip eq '1'))}">
						<button type="button" id="submitBtn" class="btn btn-primary"
							onclick="approve('提交')">提交</button>
						<button id="cancelBtn" type="button" class="btn btn-warning"
							onclick="approve('取消申请')">取消申请</button>
					</c:if>

					<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
						<button type="button" class="btn btn-primary"
							onclick="approve('同意')">同意</button>
						<button type="button" class="btn btn-warning"
							onclick="approve('不同意')">不同意</button>
					</c:if>
					<c:if
						test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
						<button id="reapplyBtn" type="button" class="btn btn-primary"
							onclick="approve('重新申请')">重新申请</button>
						<button id="cancelBtn" type="button" class="btn btn-warning"
							onclick="approve('取消申请')">取消申请</button>
					</c:if> --%>
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

	<div id="projectDialog"></div>
	<div id="barginDialog"></div>

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

	<!-- ./wrapper -->
	<%@ include file="../../common/footer.jsp"%>

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
	<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
	<script type="text/javascript"
		src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
	<script type="text/javascript"
		src="<%=base%>/views/manage/finance/pay/js/mobileprocess.js"></script>
	<!-- 全局变量 -->
	<script type="text/javascript">
		var variables = JSON.parse('${map.jsonMap.variables}');
	</script>
</body>
</html>

