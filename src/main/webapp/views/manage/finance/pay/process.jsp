<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<style>
#table1, #table2 {
	width: 90%;
	text-align:center;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table1 td, #table2 td {
	border: solid #999 1px;
	padding: 5px;
}
#table1 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	text-align:center;
	outline: medium;
}
#table1 td span, #table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table1 th, #table2 th {
	border: solid #999 1px;
	text-align: center;
	font-size: 1.5em;
}
#table1 thead th {
	border: none;
}
textarea {
	width: 100%;
	resize: none;
	border: none;
	outline: medium;
}

.td {
	width: 120px;
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

</style>
</head>
<body style="min-width:1100px;overflow:auto;font-size:small;">
<body>
<div class="wrapper">
	<header>
		<ol class="breadcrumb">
			<li class="active">主页</li>
			<li class="active">财务管理</li>
			<li class="active">付款管理</li>
			<li class="active">付款流程审批</li>
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
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
						<input type="hidden" id="operStatus" value="">
						<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${map.initiator.name }">
						</c:if>
						<c:if test="${map.business.userId ne sessionScope.user.id or (map.task.name ne '提交申请') }">
							<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
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
						<input type="hidden"  id ="currUserId" value="${sessionScope.user.id }"readonly>
						<input type="hidden" id="issubmit" name="issubmit" value="">

						<div style="text-align: center;font-weight: bolder;font-size: 1.5em;">
							<thead>
							<c:choose>
								<c:when test="${map.business.status eq '5' }">
									<tr><th colspan="12">付款详情表</th></tr>
								</c:when>
								<c:otherwise>
									<tr><th colspan="12">付款申请表</th></tr>
								</c:otherwise>
							</c:choose>
							</thead>
						</div>
						<table id="table1">
						<c:choose>
							<c:when test="${((map.task.name eq '提交申请' or map.task.name eq '部门经理') and map.business.userId eq sessionScope.user.id ) or(sessionScope.user.id == 2 )}">
							<tbody>
								<tr>
									<td class="td"><span>发起人</span></td>
									<td style="width: 24%"><input type="text"  id ="name" value="${map.business.sysUser.name }"readonly></td>
									<td class="td"><span>所属单位</span></td>
									<td colspan="3" style="line-height:inherit;text-align:left;font-size:14px;">
										<c:if test="${map.business.dept.name ne '东北办事处' and map.business.dept.name ne '沈阳办事处'}">
											<select name="title" style="height:20px;"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.title }"/></select>
											<c:if test="${map.business.dept.name ne '总经理'}">
												<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${map.business.dept.name}" readonly>
											</c:if>
										</c:if>
										<c:if test="${map.business.dept.name eq '东北办事处' or map.business.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
											<input  type="text"  style="height:20px;width:auto;text-align:left;" value="${map.business.dept.name }" readonly>
										</c:if>
									</td>
									<td class="td"><span>发起时间</span></td>
									<td  colspan="7" style="width: 25%"><input type="text" name="applyTime"  id ="applyTime" value='<fmt:formatDate value="${map.business.createDate}" pattern="yyyy-MM-dd" />' readonly></td>
								</tr>
								<tr>
									<td><span>合同编号</span></td>
									<td>
										<input type="text"  id ="barginCode" value="${map.business.barginManage.barginCode }" readonly>
									</td>
									<td><span>合同名称</span></td>
									<td colspan="3"><input type="text"  id ="barginName" value="${map.business.barginManage.barginName }" readonly></td>
									<td><span>所属项目</span></td>
									<td  colspan="7"><input type="text" name="projectManageId"  id ="projectManageId" value="${map.business.projectManageId }" style="display: none;"  readonly>
										<input type="text" name="projectManageName"  id ="projectManageName" value="${map.business.projectManage.name }" readonly onclick="openProject()"></td>
								</tr>
								<tr>
									<td><span>收款单位</span></td>
									<td><input type="text" name="collectCompany"  id ="collectCompany" value="${map.business.collectCompany}"></td>
									<td><span>开户行</span></td>
									<td  colspan="3"><input type="text" name="bankAddress"  id ="bankAddress" value="${map.business.bankAddress }">
									<td><span>账号</span></td>
									<td colspan="7"><input type="text" name="bankAccount"  id ="bankAccount" value="${map.business.bankAccount}"></td>
								</tr>
								<tr>
									<td><span>付款类型</span></td>
									<td>
										<select name="payType" style="height:100%;width:100%;text-align-last:center;"><custom:dictSelect type="付款类型" selectedValue="${map.business.payType}"/></select>
									</td>
									<td><span>用途</span></td>
									<td  colspan="3"><input type="text" name="purpose"  id ="purpose" value="${map.business.purpose }" >
									<td  style="width: 10%" ><span>发票是否已收</span></td>

									<td colspan="4">
										<select name="invoiceCollect" id="invoiceCollect" onchange="change(this)"  style="height:100%;width:100%;text-align-last:center;"><custom:dictSelect type="发票收取状态" selectedValue="${map.business.invoiceCollect}"/></select>
									</td>

									<td id="invoice" style="display: none;"><span>发票金额</span></td>
									<td id="money" style="display: none;"><input type="text" style="text-align:right;" name="invoiceMoney"  id ="invoiceMoney" value="<fmt:formatNumber value='${map.business.invoiceMoney}' pattern='0.00' />"></td>
								</tr>
								<tr>
									<td><span>合同总金额</span></td>
									<td><input type="text" name="totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />" ></td>
									<td><span>申请金额</span></td>
									<td colspan="3"><input type="text" name="applyMoney"  id ="applyMoney" value="<fmt:formatNumber value='${map.business.applyMoney}' pattern='0.00' />" onblur="initInputBlur()"></td>
									<td><span>申请比例</span></td>
									<td colspan="7"><input type="text" name="applyProportion"  id ="applyProportion" value="${map.business.applyProportion}" readonly></td>
								</tr>

								<tr>
									<td><span>费用类型</span></td>
									<td>
										<select name="reimburseType" style="height:100%;width:100%;text-align-last:center;"><custom:dictSelect type="通用报销类型" selectedValue="${map.business.reimburseType}"/></select>
									</td>
									<td><span>合同管理</span></td>
									<td  colspan="10" style="text-align:left;">
									<input type="button" value="关联合同" onclick="openBargin()" style="border:none;">
									<input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="display: none;border: none">
									</td>
								</tr>
								<tr>
									<td><span>付款事由</span></td>
									<td colspan="20"><textarea id="cause" name="cause" rows="2" style="width: 100%;">${map.business.cause}</textarea></td>
								</tr>
								<tr>
									<td><span>备注</span></td>
									<td colspan="20"><textarea id="remark" name="remark" rows="2" style="width: 100%;">${map.business.remark}</textarea></td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="9" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
										</a>
										<td colspan="5">
											<input type="file" id="file" name="file" style="display: none;">
											<c:if test="${not empty map.business.attachments }">
												<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
											</c:if>
											<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
										</td>
									</td>
								</tr>
							</c:when>


						<c:otherwise>
							<tr>
								<tr>
								<td class="td"><span>发起人</span></td>
								<td style="width: 23%"><input type="text"  id ="name" value="${map.business.sysUser.name }" readonly></td>
								<td class="td"><span>所属单位</span></td>
								<td colspan="3" style="line-height:inherit;text-align:left;font-size:14px;">
										<c:if test="${map.business.dept.name ne '东北办事处' and map.business.dept.name ne '沈阳办事处'}">
											<custom:getDictKey type="流程所属公司" value="${map.business.title }"/>
											<c:if test="${map.business.dept.name ne '总经理'}">
												<input type="text" style="margin-left:-5px;height:20px;width:auto;text-align:left;" value="${map.business.dept.name}" readonly>
											</c:if>
										</c:if>
										<c:if test="${map.business.dept.name eq '东北办事处' or map.business.dept.name eq '沈阳办事处'}">
											<input name="title" value="10" type="hidden">
											<custom:getDictKey type="流程所属公司" value="10"/>
											<input  type="text"  style="height:20px;width:auto;text-align:left;" value="${map.business.dept.name }" readonly>
										</c:if>
									</td>
								<td class="td"><span>发起时间</span></td>
								<td  colspan="7" style="width: 25%"><input type="text" name="applyTime"  id ="applyTime" value='<fmt:formatDate value="${map.business.createDate }" pattern="yyyy-MM-dd" />' readonly></td>
								</tr>
								<tr>
									<td><span>合同编号</span></td>
									<td><input type="text"  id ="barginCode" value="${map.business.barginManage.barginCode}" readonly>
									</td>
									<td><span>合同名称</span></td>
									<td colspan="3"><input type="text"  id ="barginName" value="${map.business.barginManage.barginName}" readonly></td>
									<td><span>所属项目</span></td>
									<td  colspan="7"><input type="text" name="projectManageId"  id ="projectManageId" value="${map.business.projectManageId }" style="display: none;"  readonly>
										<input type="text" name="projectManageName"  id ="projectManageName" value="${map.business.projectManage.name }"  onclick="openProject()" readonly></td>
								</tr>


								<tr>
									<td><span>收款单位</span></td>
									<td><input type="text" name="collectCompany"  id ="collectCompany" value="${map.business.collectCompany}" readonly></td>
									<td><span>开户行</span></td>
									<td  colspan="3"><input type="text" name="bankAddress"  id ="bankAddress" value="${map.business.bankAddress }" readonly>
									<td><span>账号</span></td>
									<td colspan="7"><input type="text" name="bankAccount"  id ="bankAccount" value="${map.business.bankAccount}" readonly></td>
								</tr>
								<tr>
									<td><span>付款类型</span></td>
										<shiro:hasPermission name="fin:pay:saveinfo">
												<td>
													<select name="payType" style="height:100%;width:100%;text-align-last:center;"><custom:dictSelect type="付款类型" selectedValue="${map.business.payType}"/></select>
												</td>
										</shiro:hasPermission>
										<shiro:lacksPermission name="fin:pay:saveinfo">
											<td>
												<custom:getDictKey type="付款类型" value="${map.business.payType}"/>
											</td>
										</shiro:lacksPermission>
									<td><span>用途</span></td>
									<td  colspan="3"><input type="text" name="purpose"  id ="purpose" value="${map.business.purpose }" readonly>
									<td><span>发票是否已收</span></td>
									<td colspan="4">
										<shiro:hasRole name="finance">
											<c:choose>
												<c:when test="${map.business.status eq '2'}">
													<select name="invoiceCollect" id="invoiceCollect" onchange="change(this)"   style="height:100%;width:100%;text-align-last:center;">
														<custom:dictSelect type="发票收取状态" selectedValue="${map.business.invoiceCollect}"/>
													</select>
												</c:when>
												<c:otherwise>
													<input type="hidden" name="invoiceCollect"  id ="invoiceCollect" value="${map.business.invoiceCollect }" readonly>
													<custom:getDictKey type="发票收取状态" value="${map.business.invoiceCollect}"/>
												</c:otherwise>
											</c:choose>
										</shiro:hasRole>
										<shiro:lacksRole name="finance">
											<input type="hidden" name="invoiceCollect"  id ="invoiceCollect" value="${map.business.invoiceCollect }" readonly>
											<custom:getDictKey type="发票收取状态" value="${map.business.invoiceCollect}"/>
										</shiro:lacksRole>
									</td>
									<td id="invoice" style="display: none;"><span>发票金额</span></td>
									<shiro:hasRole name="finance">
										<c:choose>
											<c:when test="${map.business.status eq '2'}">
												<td id="money" style="display: none;"><input type="text" style="text-align:right;" name="invoiceMoney"  id ="invoiceMoney" value="<fmt:formatNumber value='${map.business.invoiceMoney}' pattern='0.00' />"></td>
											</c:when>
											<c:otherwise>
												<td id="money" style="display: none;"><input type="text" style="text-align:right;" name="invoiceMoney"  id ="invoiceMoney" readonly value="<fmt:formatNumber value='${map.business.invoiceMoney}' pattern='0.00' />"></td>
											</c:otherwise>
										</c:choose>
									</shiro:hasRole>
									<shiro:lacksRole name="finance">
										<td id="money" style="display: none;"><input type="text" style="text-align:right;" name="invoiceMoney"  id ="invoiceMoney" readonly value="<fmt:formatNumber value='${map.business.invoiceMoney}' pattern='0.00' />"></td>
									</shiro:lacksRole>
								</tr>
								<tr>
									<td><span>合同总金额</span></td>
									<td>
										<input type="text" name="totalMoney"  id ="totalMoney" value="<fmt:formatNumber value='${map.business.totalMoney}' pattern='0.00' />" readonly>
										<input type="hidden" name="barginTotalMoney"  id ="barginTotalMoney" value="<fmt:formatNumber value='${map.business.barginManage.totalMoney}' pattern='0.00' />" >
									</td>
									<td><span>申请金额</span></td>
									<td colspan="3"><input type="text" name="applyMoney"  id ="applyMoney" value="<fmt:formatNumber value='${map.business.applyMoney}' pattern='0.00' />" readonly></td>
									<td><span>申请比例</span></td>
									<td colspan="7"><input type="text" name="applyProportion"  id ="applyProportion" value="${map.business.applyProportion}" readonly></td>
								</tr>

								<c:choose>
									<c:when test="${map.isHandler and map.task.name eq '财务' }">
										<tr>
											<td><span>发票实收取情况</span></td>
											<td colspan="12"><textarea  name="actualInvoiceStatus"  id ="actualInvoiceStatus" value="${map.business.actualInvoiceStatus}">${map.business.actualInvoiceStatus}</textarea></td>
										</tr>
									</c:when>
									<c:when test="${(map.task.name eq '总经理')  or (map.task.name eq '出纳') or map.business.status eq '5'}">
										<tr>
											<td><span>发票实收取情况</span></td>
											<td colspan="12"><textarea  name="actualInvoiceStatus"  id ="actualInvoiceStatus" value="" readonly>${map.business.actualInvoiceStatus}</textarea></td>
										</tr>
									</c:when>
								</c:choose>

								<tr>
									<td><span>费用类型</span></td>
                                    <shiro:hasPermission name="fin:pay:saveinfo">
												<td>
													<select name="reimburseType" style="height:100%;width:100%;text-align-last:center;"><custom:dictSelect type="通用报销类型" selectedValue="${map.business.reimburseType}"/></select>
												</td>
                                    </shiro:hasPermission>
										<shiro:lacksPermission name="fin:pay:saveinfo">
										<c:choose>
											<c:when test="${map.isHandler and map.task.name eq '财务' }">
												<td>
													<select name="reimburseType" style="height:100%;width:100%;text-align-last:center;"><custom:dictSelect type="通用报销类型" selectedValue="${map.business.reimburseType}"/></select>
												</td>
											</c:when>
											<c:otherwise>
												 <td>
                                                	<custom:getDictKey type="通用报销类型" value="${map.business.reimburseType}"/>
                                           		 </td>
											</c:otherwise>
										</c:choose>
                                        </shiro:lacksPermission>
									<td><span>合同管理</span></td>
									<td colspan="10" style="text-align:left;">
									<input type="button" id="viewBarginBtn" value="查看合同详细" onclick="viewBargin()" style="display: none;">
									</td>
								</tr>

								<tr>
									<c:choose>
										<c:when test="${map.isHandler and map.task.name eq '出纳'}">
											<%-- <td><span>实际付款金额</span></td>
											<td><input type="text" name="actualPayMoney" onkeyup = "initCompareTheAmount()"  id ="actualPayMoney" value="<fmt:formatNumber value='${map.business.actualPayMoney}' pattern='0.00' />"></td>
											<td><span>实际付款日期</span></td>
											<td colspan="10"><input type="text" name="actualPayDate" readonly id ="actualPayDate" value='<fmt:formatDate value="${map.business.actualPayDate}" pattern="yyyy-MM-dd"/>' ></td> --%>
											<tr>
												<td  colspan="3" ><span>实际付款日期</span></td>
												<td  colspan="7"><span>实际付款金额</span></td>
												<td  colspan="3"><span>操作</span></td>
											</tr>
											<tbody id="node">
											<c:if test="${not empty map.business.payAttachList }">
											<c:forEach items="${map.business.payAttachList }" var="business" varStatus="varStatus">
											<tr name="node">
												<input type="hidden" name="businessId" value="${business.id}" readonly>
												<td colspan="3" style="height:100%;text-align:center;">
													<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" 	value="<fmt:formatDate value="${business.payDate }" pattern="yyyy-MM-dd" />"   readonly>
												</td>
												<td  colspan="7">
													<input type="text" style="text-align:center;" id="actualPayMoney" name="payBill" onkeyup = "initCompareTheAmount()" value="${business.payBill}">
												</td>
												<td colspan="3" style="text-align:center;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)">
												<img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
											</tr>
											</c:forEach>
											</c:if>
											<c:if test="${empty map.business.payAttachList }">
											<tr name="node">
												<input type="hidden" name="businessId" value="${map.business.id}" readonly>
												<td colspan="3" style="height:100%;text-align:center;">
													<c:if test="${empty map.business.actualPayMoney}">
														<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM-dd" />" >
													</c:if>
													<c:if test="${not empty map.business.actualPayMoney}">
														<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" value="<fmt:formatDate value="${map.business.actualPayDate}" pattern="yyyy-MM-dd" />" >
													</c:if>
												</td>
												<td  colspan="7">
													<input type="text" style="text-align:center;" id="actualPayMoney"  name="payBill" onkeyup = "initCompareTheAmount()" value="<fmt:formatNumber value='${map.business.applyMoney}' pattern='0.00' />">
												</td>
												<td colspan="3" style="text-align:center;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="node('add', this)">
												<img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="node('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a></td>
											</tr>
											</c:if>
											</tbody>
										</c:when>
										<c:when test="${ map.business.status eq '5'}">
											<c:if test="${sessionScope.user.id eq '3'}">
												<tr>
													<td  colspan="5" ><span>实际付款日期</span></td>
													<td  colspan="8"><span>实际付款金额</span></td>
												</tr>
												<tbody id="node">
													<c:if test="${not empty map.business.payAttachList }">
														<c:forEach items="${map.business.payAttachList }" var="business" varStatus="varStatus">
															<tr name="node">
																<input type="hidden" name="businessId" value="${business.id}" readonly>
																<td colspan="5" style="height:100%;text-align:center;">
																	<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" value="<fmt:formatDate value="${business.payDate }" pattern="yyyy-MM-dd" />"   readonly>
																</td>
																<td  colspan="8">
																	<input type="text" style="text-align:center;" id="actualPayMoney" name="payBill" onkeyup = "initCompareTheAmount()" value="${business.payBill}">
																</td>
															</tr>
														</c:forEach>
													</c:if>
													<c:if test="${empty map.business.payAttachList }">
														<tr name="node">
															<input type="hidden" name="businessId" value="${map.business.id}" readonly>
															<td colspan="5" style="height:100%;text-align:center;">
																<c:if test="${empty map.business.actualPayMoney}">
																	<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM-dd" />" >
																</c:if>
																<c:if test="${not empty map.business.actualPayMoney}">
																	<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" value="<fmt:formatDate value="${map.business.actualPayDate}" pattern="yyyy-MM-dd" />" >
																</c:if>
															</td>
															<td  colspan="8">
																<input type="text" style="text-align:center;" id="actualPayMoney"  name="payBill" onkeyup = "initCompareTheAmount()" value="<fmt:formatNumber value='${map.business.applyMoney}' pattern='0.00' />">
															</td>
														</tr>
													</c:if>
												</tbody>
												<%-- <td><span>实际付款金额</span></td>
												<td><input type="text" name="actualPayMoney"  id ="actualPayMoney" value="<fmt:formatNumber value='${map.business.actualPayMoney}' pattern='0.00' />"></td>
												<td><span>实际付款日期</span></td>
												<td colspan="10"><input type="text" name="actualPayDate"  id ="actualPayDate" value='<fmt:formatDate value="${map.business.actualPayDate}" pattern="yyyy-MM-dd"/>' ></td> --%>
											</c:if>
											<c:if test="${sessionScope.user.id ne '3'}">
												<tr>
													<td  colspan="5" ><span>实际付款日期</span></td>
													<td  colspan="8"><span>实际付款金额</span></td>
												</tr>
												<tbody id="node">
													<c:if test="${not empty map.business.payAttachList }">
														<c:forEach items="${map.business.payAttachList }" var="business" varStatus="varStatus">
															<tr name="node">
																<input type="hidden" name="businessId" value="${business.id}" readonly>
																<td colspan="5" style="height:100%;text-align:center;">
																	<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" 	value="<fmt:formatDate value="${business.payDate }" pattern="yyyy-MM-dd" />"   readonly>
																</td>
																<td  colspan="8">
																	<input type="text" style="text-align:center;" id="actualPayMoney" name="payBill" onkeyup = "initCompareTheAmount()" value="${business.payBill}">
																</td>
															</tr>
														</c:forEach>
													</c:if>
													<c:if test="${empty map.business.payAttachList }">
														<tr name="node">
															<input type="hidden" name="businessId" value="${map.business.id}" readonly>
															<td colspan="5" style="height:100%;text-align:center;">
																<c:if test="${empty map.business.actualPayMoney}">
																	<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" value="<fmt:formatDate value="${currDate}" pattern="yyyy-MM-dd" />" >
																</c:if>
																<c:if test="${not empty map.business.actualPayMoney}">
																	<input type="text" style="text-align:center;" id="actualPayDate" name="payDate" class="payDate" value="<fmt:formatDate value="${map.business.actualPayDate}" pattern="yyyy-MM-dd" />" readonly>
																</c:if>
															</td>
															<td  colspan="8">
																<input type="text" style="text-align:center;" id="actualPayMoney"  name="payBill" onkeyup = "initCompareTheAmount()" value="<fmt:formatNumber value='${map.business.applyMoney}' pattern='0.00' />" readonly>
															</td>
														</tr>
													</c:if>
												</tbody>
												<%-- <td><span>实际付款金额</span></td>
												<td><input  type="text" name="actualPayMoney"  id ="actualPayMoney" value="<fmt:formatNumber value='${map.business.actualPayMoney}' pattern='0.00' />" readonly></td>
												<td><span>实际付款日期</span></td>
												<td colspan="10"><input style="width: 100%; text-align: center;" type="text" name="actualPayDate"   value='<fmt:formatDate value="${map.business.actualPayDate }" pattern="yyyy-MM-dd"/>' readonly></td> --%>
											</c:if>
										</c:when>
									</c:choose>

								</tr>
								<tr>
									<td><span>付款事由</span></td>
									<td colspan="20"><textarea id="cause" name="cause" rows="2" style="width: 100%;">${map.business.cause}</textarea></td>
								</tr>
								<tr>
									<td><span>备注</span></td>
									<td colspan="20"><textarea id="remark" name="remark" rows="2" style="width: 100%;" readonly>${map.business.remark}</textarea></td>
								</tr>
								<c:choose>
									<c:when test="${(map.task.name eq '财务' and map.isHandler)}">
								<tr>
									<td><span>附件</span></td>
									<td colspan="9" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
										</a>
										<td colspan="5">
											<input type="file" id="file" name="file" style="display: none;">
											<c:if test="${not empty map.business.attachments }">
												<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
											</c:if>
											<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
										</td>
									</td>
								</tr>
								</c:when>
								<c:otherwise>
								<tr>
									<td><span>附件</span></td>
									<td colspan="12">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
										</a>
									</td>
								</tr>
								</c:otherwise>
								</c:choose>
						</c:otherwise>
					</c:choose>
					<tfoot>
						<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
							<tr>
								<td colspan="34">
									<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:70%;height:100%;"></textarea>
								</td>
							</tr>
						</c:if>
					</tfoot>
					</tbody>
					</table>
						<div style="width: 100%; text-align: center;margin-top: 6px" class="form-group" >
							<c:if test="${map.business.userId eq sessionScope.user.id and (map.task.name eq '部门经理')}">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve('提交')">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
								<c:choose>
									<c:when test="${(map.task.name eq '出纳' and map.isHandler)}">
										<span id="billHidden" hidden>
											<button type="button" class="btn btn-primary" onclick="approve('同意')">同意</button>
										</span>
										<button type="button" class="btn btn-warning" onclick="approve('不同意')">不同意</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-primary" onclick="approve('同意')">同意</button>
										<button type="button" class="btn btn-warning" onclick="approve('不同意')">不同意</button>
									</c:otherwise>
								</c:choose>
							</c:if>
								<shiro:hasPermission name="fin:pay:saveinfo">
									<button id="saveBtn" type="button" class="btn btn-primary" onclick="save(1)">保存</button>
								</shiro:hasPermission>
							<c:if test="${sessionScope.user.id eq '5' or sessionScope.user.id eq '8' or sessionScope.user.id eq '3'}">
											<button type="button" class="btn btn-primary" onclick="exportpdf(${map.business.processInstanceId })">导出PDF</button>
							</c:if>
							<c:if test="${(sessionScope.user.id == 3 or sessionScope.user.id == 2  ) and !map.isHandler}">
								<button id="updateFormBtn" type="button" class="btn btn-primary" onclick="updateForm()">保存</button>
							</c:if>
							<c:if test="${map.business.userId eq sessionScope.user.id and map.task.name eq '提交申请' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve('重新申请')">保存并提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('取消申请')">取消申请</button>
							</c:if>
							<button type="button" class="btn btn-default" onclick="javascript:window.history.back(-1)">返回</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</section>
	<section class="content rlspace">
		<div class="row">
			<div class="col-md-12">
				<div class="box box-primary tbspace">
					<table id="table2" style="width:90%;">
						<thead>
							<tr><th colspan="20" style="text-align: center;font-weight: bolder;font-size: 1.5em;">处 理 流 程</th></tr>
							<tr style="font-weight: bolder;">
								<td  style="width:10%;">环节</td>
								<td  style="width:9%">操作人</td>
								<td  style="width:15%">操作时间</td>
								<td  style="width:10%">操作结果</td>
								<td  style="width:56%">操作备注</td>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="projectDialog"></div>
<div id="barginDialog"></div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="barginDetailModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:80%; height: 80%;">
    	<div class="modal-content" style="height:100%;">
        	<div class="modal-header">
            	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            	<h4 class="modal-title" id="myModalLabel">合同详情</h4>
         	</div>
	        <div class="modal-body" style="height:75%;">
	        	<iframe id="barginDetailFrame" name="barginDetailFrame" width="100%" frameborder="no" scrolling="auto" style="height:100%;"></iframe>
			</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal -->
<%@ include file="../../common/footer.jsp"%>
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
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>

<script type="text/javascript" src="<%=base%>/views/manage/finance/pay/js/process.js"></script>
<script type="text/javascript">
	base = "<%=base%>";
	var variables = ${map.jsonMap.variables};

	var isCashier = false;
	//当流程处于“已归档”且登录用户为“出纳”
// 	if(${sessionScope.user.id eq '3' and map.business.status eq '5'}){
// 	    isCashier = true;
// 	}
	var userId=${sessionScope.user.id};
	var status=${map.business.status};
	
	if(userId==3&&status==5){
		isCashier = true;
	}
	
	var isCashierTask = false;
	//当流程处于出纳环节
// 	if(${map.business.status eq '4'}){
// 	    isCashierTask = true;
// 	}
	if(status==4){
		isCashierTask = true;
	}
	
	//已归档 
	if(status==5){
		$("#saveBtn").hide();
	//	$("#updateFormBtn").hide();
	}
</script>
</body>
</html>