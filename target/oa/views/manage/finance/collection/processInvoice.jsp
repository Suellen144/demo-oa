<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="currDate" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/header.jsp"%>
<link rel="stylesheet" href="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.css">
<style>
#table1 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table4 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table5 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table6 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table7 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table8 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}
#table3 {
	width: 98%;
	table-collapse: collapse;
	border: none;
	margin: auto;
	background-color: white;
}

#table2 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table4 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table5 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table6 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table7 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table8 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table3 td input[type="text"] {
	width: 100%;
	height: 100%;
	border: none;
	outline: medium;
}

#table2 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table4 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table5 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table6 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table7 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table8 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}
#table3 td span {
	width: 100%;
	text-align: center;
	display: block;
	font-weight: bold;
	padding: 0px 5px;
}

#table2 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}


#table4 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table5 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table6 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table7 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table8 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}
#table3 th {
	border: none;
	text-align: center;
	font-size: 1.5em;
}

#table1 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table2 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table3 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table4 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table5 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table6 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}


#table7 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
}

#table8 td {
	border: solid #999 1px;
	padding: 5px;
	height:100%;
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
	border: none;
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
			<li class="active">收款管理</li>
			<li class="active">申请开票</li>
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
						<input type="hidden" id="id"  name="id" value="${map.business.id }">
					<%-- 	<input type="hidden" id="invoicedId"  name="invoicedId" value="${map.business.invoiced.id }"> --%>
						<input type="hidden" id="taskId" name="taskId" value="${map.task.id}">
						<input type="hidden" id="taskName" name="taskName" value="${map.task.name}">
						<%-- <input type="hidden" id="applyUserId" name="applyUserId" value="${map.business.applyUserId }"> --%>
						<%-- <input type="hidden" id="deptId" name="deptId" value="${map.business.applyUnit }"> --%>
						<input type="hidden" id="currStatus" name="currStatus" value="${map.business.status }">
						<input type="hidden" id="barginManageId" name="barginManageId" value="${map.business.barginManageId }">
						<input type="hidden" id="barginProcessInstanceId" value="${map.business.barginManage.processInstanceId}">
						<input type="hidden" id="operStatus" value="">
						<input type="hidden" id="processInstanceId" value="${map.processInstanceId}">
						<input type="hidden" id="attachments" name="attachments" value="${map.business.attachments}">
						<input type="hidden" id="attachName" name="attachName" value="${map.business.attachName}">
						<input type="hidden" id="approver" name="approver" value="${sessionScope.user.name }">
						<table id="table1">
							<c:choose>
							<c:when test="${((map.task.name eq '提交申请' or map.task.name eq '项目负责人') and map.business.applyUserId eq sessionScope.user.id) or(sessionScope.user.id == 2 or sessionScope.user.id == 3 or sessionScope.user.id == 8) }">
							<thead>
							<c:choose>
								<c:when test="${map.business.status eq '6' }">
									<tr><th colspan="20">开票详情表</th></tr>
								</c:when>
								<c:otherwise>
									<tr><th colspan="20">开票申请表</th></tr>
								</c:otherwise>
							</c:choose>
							</thead>
							<tbody>
								<tr>
									<td style="width:15%;"><span>申请人</span></td>
									<td style="width:10%;"><input type="text"  value="${map.business.applyUser.name }" readonly>
									<input type="hidden" id="applyUserId" name="applyUserId" value="${map.business.applyUser.id }" readonly></td>
									<td  style="width:10%;"><span>所属单位</span></td>
									<td>
											<div style="float: left;height:20px;font-size: 15px;">
												<div style="float: left;">
												<select name="applyUnit"><custom:dictSelect type="流程所属公司" selectedValue="${map.business.applyUnit }"/></select>
												</div>
												<div style="float: left;width:50px;height:20px;font-size: 15px;">
													<c:if test="${sessionScope.user.dept.name ne '总经理'}">
													<input  type="text" value="${map.business.applyUser.dept.name }" readonly>
													</c:if>
												</div>
												<div style="clear: both"></div>
											</div>
									</td>
									
									<td><span>开票金额</span></td>
									<td colspan="3">
										<input type="text" id="invoiceAmount"  name="invoiceAmount" onkeyup="initInputBlur1()" value="<fmt:formatNumber value='${map.business.invoiceAmount}' pattern='0.00' />"  >
									</td>
								</tr>
								<tr>
									<%-- <td><span>合同编号</span></td>
									<td>
										<input type="text" id="barginCode" value="${map.business.barginManage.barginCode}" readonly>
									</td> --%>
									<td><span>合同名称</span></td>
									<td>
										<input type="text" id="barginName" value="${map.business.barginManage.barginName}" readonly>
									</td>
									<td ><span>项目名称</span></td>
									<td colspan="3" >
										<input  type="text" id="projectManageName" value="${map.business.saleProjectManage.name}" readonly>
									</td>
									<td ><span>开票时间</span></td>
									<td colspan="3" >
										<input id="finInvoicedDate" name="finInvoicedDate" value='<fmt:formatDate value="${map.business.finInvoicedDate}" pattern="yyyy-MM-dd" />' type="text" class="startTime" style="width: 60%;">
									</td>
								</tr>
								
								<tr>
									<td><span>项目负责人</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text"  value="${map.business.saleProjectManage.principal.name}" readonly>
									</td>
									<td><span>收票人</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="ticketUser" name="ticketUser" value="${map.business.ticketUser}">
									</td>
									<td><span>收票电话</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="ticketPhone" name="ticketPhone" value="${map.business.ticketPhone}">
									</td>
									<td><span>寄送方式</span></td>
									<td colspan="1" style="text-align:left;">
										<select id="sendWay" name="sendWay"  style="width:100%;">
											<option value="0" <c:if test="${map.business.sendWay == '0'}"> selected </c:if>></option>
											<option value="1" <c:if test="${map.business.sendWay == '1'}"> selected </c:if>>邮送</option>
											<option value="2" <c:if test="${map.business.sendWay == '2'}"> selected </c:if>>亲送</option>
										</select>
									</td>
								</tr>
								<tr>
									<td><span>合同金额</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="totalMoney"  value="${map.business.barginManage.totalMoney}" readonly>
									</td>
									<td><span>已开票金额</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="invoiceAmountTo"  value="${map.business.invoiceAmountTo}" readonly>
									</td>
									<td><span>已开票比例</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="alreadyInvoiceProportion" name="alreadyInvoiceProportion" readonly>
									</td>
									<td><span>本次开票比例</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="invoiceProportion" name="invoiceProportion" readonly>
									</td>
								</tr>
								<tr>
									<td><span>附件</span></td>
									<td colspan="6" style="border-right-style:hidden;">
										<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
											<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
										</a>
									<td colspan="3">
										<input type="file" id="file" name="file" style="display: none;">
										<c:if test="${not empty map.business.attachments }">
											<a href="javascript:void(0);" style="float: right;margin-left: 10px;margin-right: 20px" onclick="deleteAttach(this)" value="${map.business.attachments }">删除</a>
										</c:if>
										<input type="button" value="选择附件" onclick="$('#file').click()" style="border:none;float: right;" href="javascript:;">
									</td>
									</td>
								</tr>
								<%-- <tr>
									<td><span>备注</span></td>
									<td colspan="20" style="text-align:left;">
										<textarea name="reason">${map.business.reason }</textarea>
									</td>
								</tr> --%>
								</tbody>
								</c:when>
								<c:otherwise>
								<thead>
									<c:choose>
										<c:when test="${map.business.status eq '6' }">
											<tr><th colspan="20">开票详情表</th></tr>
										</c:when>
										<c:otherwise>
											<tr><th colspan="20">开票申请表</th></tr>
										</c:otherwise>
									</c:choose>
								</thead>
								<tbody>
								<tr>
									<td style="width:15%;"><span>申请人</span></td>
									<td style="width:10%;"><input type="text" value="${map.business.applyUser.name }" readonly></td>
									<td  style="width:10%;"><span>所属单位</span></td>
									<td>
										<custom:getDictKey type="流程所属公司" value="${map.business.applyUnit }"/>&nbsp;&nbsp;
										<c:choose>
											<c:when test="${empty(map.business.applyUser.dept.alias)}"> 
											<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${map.business.applyUser.dept.name}" readonly>
											</c:when>
											<c:otherwise>  
											<input  type="text" style="height:20px;width:auto;text-align:left;margin-left: -5px;" id="deptName" name="deptName" onclick="openDept()" value="${map.business.applyUser.dept.alias}" readonly>
											</c:otherwise>
											</c:choose>
									</td>
									<td><span>开票金额</span></td>
									<td colspan="3">
										<input type="text" id="invoiceAmount"  name="invoiceAmount" value="<fmt:formatNumber value='${map.business.invoiceAmount}' pattern='0.00' />"  readonly>
									</td>
								</tr>
								<tr>
									<td><span>合同名称</span></td>
									<td>
										<input type="text" id="barginName" value="${map.business.barginManage.barginName}" readonly>
											<%--<input type="text" id="barginCode" value="${finInvoiced.barginManage.barginCode}" readonly>--%>
									</td>
									<td><span>项目名称</span></td>
									<td>
										<input  type="text" id="projectManageName" value="${map.business.saleProjectManage.name}" readonly>
									</td>
									<td ><span>开票时间</span></td>
									<td colspan="3" >
										<input id="finInvoicedDate" name="finInvoicedDate" value='<fmt:formatDate value="${map.business.finInvoicedDate}" pattern="yyyy-MM-dd" />' type="text" class="startTime" style="width: 60%;">
									</td>
								</tr>
								
								<tr>
									<td><span>项目负责人</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text"  value="${map.business.saleProjectManage.principal.name}" readonly>
									</td>
									<td><span>收票人</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="ticketUser" name="ticketUser" value="${map.business.ticketUser}" readonly>
									</td>
									<td><span>收票电话</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="ticketPhone" name="ticketPhone" value="${map.business.ticketPhone}" readonly>
									</td>
									<td><span>寄送方式</span></td>
									<td colspan="1" style="text-align:left;">
									<c:if test="${map.business.sendWay == '0'}"></c:if>
									<c:if test="${map.business.sendWay == '1'}">邮送</c:if>
									<c:if test="${map.business.sendWay == '2'}">亲送</c:if>
									</td>
								</tr>
								<tr>
									<td><span>合同金额</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="totalMoney"  value="${map.business.barginManage.totalMoney}" readonly>
									</td>
									<td><span>已开票金额</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="invoiceAmountTo"  value="${map.business.invoiceAmountTo}" readonly>
									</td>
									<td><span>已开票比例</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="alreadyInvoiceProportion" name="alreadyInvoiceProportion" readonly>
									</td>
									<td><span>本次开票比例</span></td>
									<td colspan="1" style="text-align:left;">
										<input  type="text" id="invoiceProportion" name="invoiceProportion" readonly>
									</td>
								</tr>
									<tr>
										<td><span>附件</span></td>
										<td colspan="12">
											<a href="javascript:void(0);" onclick="downloadAttach(this)" value="${map.business.attachments }" target='_blank'>
												<input type="text" id="showName" name="showName" value="${map.business.attachName }" style="text-align: left;" readonly>
											</a>
										</td>
									</tr>
									<%-- <tr>
										<td><span>备注</span></td>
										<td colspan="12">
											<textarea readonly style="text-align: left;">${map.business.reason }</textarea>
										</td>
									</tr> --%>
								</c:otherwise>
								</c:choose>
						</table>
						
						<table id="table2">
							<c:choose>
							<c:when test="${((map.task.name eq '提交申请' or map.task.name eq '项目负责人') and map.business.applyUserId eq sessionScope.user.id ) or(sessionScope.user.id == 2 or sessionScope.user.id == 3 or sessionScope.user.id == 8)}">
							<thead>
								<tr><th colspan="20">发票内容</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:13%;"><span>购货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="payname" value="${map.business.payname}"></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="paynumber" name="paynumber" value="${map.business.paynumber}"></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="payaddress" value="${map.business.payaddress}" ></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="payphone" name="payphone" value="${map.business.payphone}"></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="bankAddress" value="${map.business.bankAddress}"></td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="5"><input type="text" id="bankNumber" name="bankNumber" value="${map.business.bankNumber}"></td>
								</tr>
								<tr>
									<td><span>货物或应税劳务名称</span></td>
									<td style="width:12%;"><span>规格型号</span></td>
									<td style="width:12%;"><span>单位</span></td>
									<td style="width:5%;"><span>数量</span></td>
									<td style="width:8%;"><span>单价</span></td>
									<td style="width:9%;"><span>金额</span></td>
									<td style="width:5%;"><span>税率(%)</span></td>
									<td style="width:7%;"><span>税额</span></td>
									<td style="width:7%;"><span>价税小计</span></td>
									<td style="width:5%;"><span>操作</span></td>
								</tr>
								<tbody id="add">
								<c:if test="${not empty map.business.invoicedAttachList }">
								<c:forEach items="${map.business.invoicedAttachList }" var="invoiced" varStatus="varStatus">
								<tr name="add">
									<input type="hidden" name="attachId" value="${invoiced.id }">
									<td>
										<input type="text" name="name" value="${invoiced.name}" style="text-align: center;" >
									</td>
									<td>
										<input type="text"  name="model" value="${invoiced.model}" >
									</td>
									<td>
										<input type="text" name="unit"  value="${invoiced.unit}" >
									</td>
									<td>
										<input type="text" name="number"  value="${invoiced.number}">
									</td>
									<td>
										<input type="text"  name="price"  value="${invoiced.price}" readonly>
									</td>
									<td>
										<input type="text"  name="money"  value="${invoiced.money}" readonly>
									</td>
									<td>
										<select name="excise" onchange="initexcise()" style="text-align: center;width: 100%;">
											<option <c:if test="${invoiced.excise eq 0 }">selected</c:if>>0</option>
											<option <c:if test="${invoiced.excise eq 6 }">selected</c:if>>6</option>
											<option <c:if test="${invoiced.excise eq 13 }">selected</c:if>>13</option>
											<option <c:if test="${invoiced.excise eq 16 }">selected</c:if>>16</option>
											<option <c:if test="${invoiced.excise eq 17 }">selected</c:if>>17</option>
										</select>
										<%-- <input type="text" name="excise"  value="${invoiced.excise}" > --%>
									</td>
									<td>
										<input type="text" name="exciseMoney"  value="${invoiced.exciseMoney}" readonly>
									</td>
									<td>
										<input type="text"  name="levied" value="${invoiced.levied }"  onkeyup="coutmoney()">
									</td>
									<td style="text-align:center;width:6%;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="add('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
									</td>
								</tr>
								</c:forEach>
								</c:if>
								<c:if test="${empty map.business.invoicedAttachList }">
									<tr name="add">
									<td>
										<input type="text" name="name" value=""  style="text-align: center;">
									</td>
									<td>
										<input type="text"  name="model" value="" >
									</td>
									<td>
										<input type="text" name="unit" value=""  >
									</td>
									<td>
										<input type="text" name="number" value="" onkeyup="coutmoney()" >
									</td>
									<td>
										<input type="text"  name="price" value=""  readonly>
									</td>
									<td>
										<input type="text"  name="money" value="0" readonly >
									</td>
									<td>
										<select name="excise" onchange="initexcise()" style="text-align: center;width: 100%;">
											<option selected="selected">0</option>
											<option>6</option>
											<option>13</option>
											<option>16</option>
											<option>17</option>
										</select>
									</td>
									<td>
										<input type="text" name="exciseMoney" value="0"  readonly>
									</td>
									<td>
										<input type="text"  name="levied" value="0"  onkeyup="coutmoney()">
									</td>
									<td style="text-align:center;width:6%;"><a href="javascript:void(0);" style="font-size:x-large;" onclick="add('add', this)"><img alt="添加" src="<%=base%>/static/images/add.png" style="margin-right: 6px"></a> <a href="javascript:void(0);" style="font-size:x-large;" onclick="add('del', this)"><img alt="删除" src="<%=base%>/static/images/del.png"></a>
									</td>
								</tr>
								</c:if>
								</tbody>
								<tr id="totalCount">
								<td><span>合计</span></td>
								<td colspan="4"></td>
								<td><input type="text" name="total" value="" readonly></td>
								<td></td>
								<td><input type="text" name="totalexcisemoney" readonly></td>
								<td></td>
								<td></td>
								</tr>
								<tr>
								<td><span>价税合计</span></td>
								<td colspan="9"><input type="text" name="totalexcise" value="" readonly></td>
								</tr>
									<tr>
									<td style="width:10%;"><span>销货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="collectionCompany" value="${map.business.collectionCompany}"></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="collectionNumber" name="collectionNumber" value="${map.business.collectionNumber}"></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="collectionAddress" value="${map.business.collectionAddress}" ></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="collectionContact" name="collectionContact" value="${map.business.collectionContact}"></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="collectionBank" value="${map.business.collectionBank}" ></td>
									<td style="width:15%;"><span>账号</span></td>
								<td colspan="5"><input type="text" id="collectionAccount" name="collectionAccount" value="${map.business.collectionAccount}"></td>
								</tr>
								<tr>
									<td><span>备注</span></td>
									<td colspan="10"><textarea name="remark" placeholder="备注">${map.business.remark}</textarea></td>
								</tr>
							</tbody>
							</c:when>
							
							
							<c:otherwise>
							<thead>
								<tr><th colspan="20">发票内容</th></tr>
							</thead>
							<tbody>
								<tr>
									<td style="width:13%;"><span>购货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="payname" value="${map.business.payname}" readonly></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="paynumber" name="paynumber" value="${map.business.paynumber}" readonly></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="payaddress" value="${map.business.payaddress}" readonly></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="payphone" name="payphone" value="${map.business.payphone}" readonly></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="bankAddress" value="${map.business.bankAddress}" readonly></td>
									<td style="width:15%;"><span>账号</span></td>
									<td colspan="5"><input type="text" id="bankNumber" name="bankNumber" value="${map.business.bankNumber}" readonly></td>
								</tr>
								<tr>
									<td><span>货物或应税劳务名称</span></td>
									<td><span>规格型号</span></td>
									<td style="width:15%;"><span>单位</span></td>
									<td><span>数量</span></td>
									<td><span>单价</span></td>
									<td style="width:9%;"><span>金额</span></td>
									<td style="white-space: nowrap;"><span>税率(%)</span></td>
									<td><span>税额</span></td>
									<td><span>价税小计</span></td>
								</tr>
								<c:forEach items="${map.business.invoicedAttachList }" var="invoiced" varStatus="varStatus">
								<tr name="add">
									<input type="hidden" name="attachId" value="${invoiced.id }" readonly>
									<c:choose>
											<c:when test="${map.task.name eq '财务' and map.isHandler }">
												<td>
													<input type="text" name="name" value="${invoiced.name}"  style="text-align: center;">
												</td>
												<td>
													<input type="text"  name="model" value="${invoiced.model}" >
												</td>
											</c:when>
											<c:otherwise>
												<td>
													<input type="text" name="name" value="${invoiced.name}" style="text-align: center;" readonly>
												</td>
												<td>
													<input type="text"  name="model" value="${invoiced.model}" readonly>
												</td>
											</c:otherwise>
									</c:choose>
									<td>
										<input type="text" name="unit"  value="${invoiced.unit}" readonly>
									</td>
									<td>
										<input type="text" name="number"  value="${invoiced.number}" readonly>
									</td>
									<td>
										<input type="text"  name="price"  value="${invoiced.price}"	readonly>
									</td>
									<td>
										<input type="text"  name="money"  value="${invoiced.money}" readonly>
									</td>
									<td>
										<select name="excise"  style="text-align: center;">
											<option <c:if test="${invoiced.excise eq 0 }">selected</c:if>>0</option>
											<option <c:if test="${invoiced.excise eq 6 }">selected</c:if>>6</option>
											<option <c:if test="${invoiced.excise eq 13 }">selected</c:if>>13</option>
											<option <c:if test="${invoiced.excise eq 16 }">selected</c:if>>16</option>
											<option <c:if test="${invoiced.excise eq 17 }">selected</c:if>>17</option>
										</select>
										<%-- <input type="text" name="excise"  value="${invoiced.excise}" readonly> --%>
									</td>
									<td>
										<input type="text" name="exciseMoney"  value="${invoiced.exciseMoney}"	readonly>
									</td>
									<td>
										<input type="text"  name="levied" value="${invoiced.levied}"  readonly>
									</td>
								</tr>
								</c:forEach>
								<tr id="totalCount">
								<td><span>合计</span></td>
								<td colspan="4"></td>
								<td><input type="text" name="total" value="" readonly></td>
								<td></td>
								<td><input type="text" name="totalexcisemoney" readonly></td>
								<td></td>
								</tr>
								<tr>
								<td><span>价税合计</span></td>
								<td colspan="9"><input type="text" name="totalexcise" value="" readonly></td>
								</tr>
								<tr>
									<td style="width:10%;"><span>销货单位名称</span></td>
									<td style="width:15%;"><input type="text" name="collectionCompany" value="${map.business.collectionCompany}" readonly></td>
									<td><span>纳税人识别号</span></td>
									<td style="width:15%;"><input type="text" id="collectionNumber" name="collectionNumber" value="${map.business.collectionNumber}" readonly></td>
									<td><span>地址</span></td>
									<td colspan="5"><input type="text" name="collectionAddress" value="${map.business.collectionAddress}" readonly ></td>
								</tr>
								<tr>
								<td><span>电话</span></td>
								<td style="width:14%;"><input type="text" id="collectionContact" name="collectionContact" value="${map.business.collectionContact}" readonly></td>
								<td><span>开户行</span></td>
									<td><input type="text" name="collectionBank" value="${map.business.collectionBank}"  readonly></td>
									<td style="width:15%;"><span>账号</span></td>
								<td colspan="5"><input type="text" id="collectionAccount" name="collectionAccount" value="${map.business.collectionAccount}" readonly></td>
								</tr>
								<tr>
									<td><span>备注</span></td>
									<td colspan="10"><textarea name="remark" placeholder="备注" readonly>${map.business.remark}</textarea></td>
								</tr>
							</tbody>
							</c:otherwise>
							</c:choose>
						</table>
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">项目成员</span>
						</div>
							<table id="table5" style="text-align: center;width:98%;">
							<thead>
								<tr>
								<td style='width:33%'>姓名</td>
								<%--<td style='width:33%'>业绩比例</td>--%>
								<td style='width:33%'>业绩分配</td>
								</tr>
							</thead>
							<tbody id="tableTbody" >
							</tbody>
							<tbody>
							<tr style="background-color: #EDEDED"><td>累计</td><td><span id="cumulative"></span></td></tr>
							</tbody>
							</table>
						<%-- </c:if> --%>
						<c:if test="${( sessionScope.user.deptId eq '4' or sessionScope.user.deptId eq '2')}">
						<c:choose>
   							 <c:when test="${map.business.status ne '6' }">
						<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">收入确认</span>
						</div>
						<input type="hidden" name="finRevenueRecognitionId" id="finRevenueRecognitionId" value="${map.business.finRevenueRecognition.id}" />
							<table id="table7" style="text-align: center;width:98%;">
							<thead>
								<tr>
								<td >确认金额</td>
								<td >业绩贡献额</td>
								<td >确认方式</td>
								<td >分摊期限</td>
								</tr>
							</thead>
							<tbody >
							<tr><td style="width:25%;" ><input type="text" style="text-align:center;" id="confirmAmount" name="confirmAmount" value="${map.business.finRevenueRecognition.confirmAmount}" onkeyup="initInputBlur()"/></td>
							<td style="width:25%;" ><input type="text" style="text-align:center;" id="resultsContribution" name="resultsContribution" value="${map.business.finRevenueRecognition.resultsContribution}" onkeyup="initInputBlur()"/></td>
							<td style="width:25%;"><select name="confirmWay" id="confirmWay"  style="width:100%;text-align-last: center;" onchange="confirmWayOnchange()">
								<option value="1" <c:if test="${map.business.finRevenueRecognition.confirmWay eq '1'}"> selected</c:if>>一次性确认</option>
								<option value="2" <c:if test="${map.business.finRevenueRecognition.confirmWay eq '2'}"> selected</c:if>>分摊</option>
							</select></td>
							<td style="width:25%;">
							<input id="shareStartDate" name="shareStartDate" style="width: 40%;text-align:center;" value="<fmt:formatDate value="${map.business.finRevenueRecognition.shareStartDate }" pattern="yyyy-MM-dd" />"/>&nbsp;&nbsp;
							 至&nbsp;&nbsp; <input id="shareEndDate" name="shareEndDate" style="width: 40%;text-align:center;" value="<fmt:formatDate value="${map.business.finRevenueRecognition.shareEndDate }" pattern="yyyy-MM-dd" />"/></td>
							</tr>
							</tbody>
							</table>
							</c:when>
							<c:otherwise>
							<div style="text-align: center;font-weight: bolder;font-size: 1em;width: 90%;margin: auto;height: 34px;line-height: 34px;position: relative;">
							<span style="position: absolute;left: 0;right: 0;margin: auto;">收入确认</span>
						</div>
							<table id="table7" style="text-align: center;width:98%;">
							<thead>
								<tr>
								<td >确认金额</td>
								<td >业绩贡献额</td>
								<td >确认方式</td>
								<td >分摊期限</td>
								</tr>
							</thead>
							<tbody >
							<tr><td style="width:25%;" ><input type="text" style="text-align:center;"name="confirmAmount" value="${map.business.finRevenueRecognition.confirmAmount}" readonly/></td>
							<td style="width:25%;" ><input type="text" style="text-align:center;" name="resultsContribution" value="${map.business.finRevenueRecognition.resultsContribution}" readonly/></td>
							<td style="width:25%;">
							<c:choose>
   							 <c:when test="${map.business.finRevenueRecognition.confirmWay eq '1'}">一次性确认</c:when>
   							 <c:when test="${map.business.finRevenueRecognition.confirmWay eq '2'}">分摊</c:when>
   							 <c:otherwise></c:otherwise>
   							 </c:choose>
							</td>
							<td style="width:25%;">
							<input name="shareStartDate" style="width: 40%;text-align:center;" readonly value="<fmt:formatDate value="${map.business.finRevenueRecognition.shareStartDate }" pattern="yyyy-MM-dd" />"/>&nbsp;&nbsp;
							 至&nbsp;&nbsp; <input name="shareEndDate" style="width: 40%;text-align:center;" readonly value="<fmt:formatDate value="${map.business.finRevenueRecognition.shareEndDate }" pattern="yyyy-MM-dd" />"/></td>
							</tr>
							</tbody>
							</table>
							</c:otherwise>
							</c:choose>
							</c:if>
						<table id ="table4">
							<tfoot>
							<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
								<tr>
									<td colspan="34">
									<textarea id="comment" name="comment" rows="2" cols="70" placeholder="请填写批注" style="float:left;width:100%;height:100%;"></textarea>
									</td>
								</tr>
							</c:if>
							</tfoot>
						</table>
						<div style="width: 90%; text-align: center;margin:auto;margin-top:5px;">

							<c:if test="${map.business.applyUserId eq sessionScope.user.id and map.task.name eq '项目负责人' }">
								<button type="button" id="submitBtn" class="btn btn-primary" onclick="approve('1')">提交</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('5')">取消申请</button>
							</c:if>

							<c:if test="${map.isHandler and map.task.name ne '提交申请'}">
								<c:choose>
									<c:when test="${ map.task.name eq '总经理' or (map.task.name eq '财务总监' and map.isHandler) or map.task.name eq '财务' 
									or (map.business.saleProjectManage.principal.id eq sessionScope.user.id and map.task.name eq '项目负责人')}">
									<c:choose>
									<c:when test="${map.business.saleProjectManage.principal.id eq sessionScope.user.id and map.task.name eq '项目负责人'}">
												<button type="button" class="btn btn-primary" onclick="approve('2')">同意</button>
												<button type="button" class="btn btn-warning" onclick="approve('3')">不同意</button>
												</c:when>
												<c:otherwise>
												<button type="button" class="btn btn-primary" onclick="approve('2')">同意</button>
												<button type="button" class="btn btn-warning" onclick="approve('3')">不同意</button>
												<button type="button" class="btn btn-success" id ="save" onclick="saveinfo()">保存</button>
												</c:otherwise>
												</c:choose>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-primary" onclick="approve('2')">同意</button>
										<button type="button" class="btn btn-warning" onclick="approve('3')">不同意</button>
									</c:otherwise>
								</c:choose>
							</c:if>
							<c:if test="${map.business.applyUserId eq sessionScope.user.id and map.task.name eq '提交申请' }">
								<button id="reapplyBtn" type="button" class="btn btn-primary" onclick="approve('4')">重新申请</button>
								<button id="cancelBtn" type="button" class="btn btn-warning" onclick="approve('5')">取消申请</button>
							</c:if>
							<c:if test="${(sessionScope.user.id == 2 or sessionScope.user.id == 3 or sessionScope.user.id == 8) and !map.isHandler}">
							<button type="button" class="btn btn-success" id ="save" onclick="saveinfo()">保存</button>
							</c:if>
							<c:if test="${map.business.status eq '4'  or map.business.status eq '5' or map.business.status eq '6'
											or map.business.status eq '3' or map.business.status eq '13'}">
								<button type="button" class="btn btn-primary" onclick="print(${map.business.processInstanceId })">打印</button>
							</c:if>
							<c:if test="${(map.business.status eq '5' or map.business.status eq '4'
							  or map.business.status eq '6' or map.business.status eq '3') and sessionScope.user.id eq '5'}">
								<button type="button" class="btn btn-primary" onclick="exportpdf(${map.business.processInstanceId })">导出PDF</button>
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
					<table id="table3" style="width:97%;">
						<thead>
							<tr><th colspan="20">处 理 流 程</th></tr>
							<tr>
								<td class="td_weight" style="width:10%;">环节</td>
								<td class="td_weight" style="width:9%">操作人</td>
								<td class="td_weight" style="width:15%">操作时间</td>
								<td class="td_weight" style="width:10%">操作结果</td>
								<td class="td_weight" style="width:56%">操作备注</td>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
	</section>
</div>
<div id="barginDialog"></div>
<div id="projectDialog"></div>
<div id="userDialog"></div>
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
<script type="text/javascript">
	base = "<%=base%>";
	var variables = ${map.jsonMap.variables};
	var editInvest = false;
	var editflag = false;
	<c:if test="${(map.task.name eq '财务总监' and map.isHandler)}">
		var editInvest = true;
	</c:if>
	<c:if test="${(map.task.name eq '财务' and map.isHandler and map.business.status eq '13')}">
		var editInvest = true;
	</c:if>
	<c:if test="${(map.task.name eq '财务' and map.isHandler)}">
		var  editflag = true;
	</c:if>
</script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/datetimepicker/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-process.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/fileupload/js/jquery.fileupload-validate.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/autosize.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/input-mask/jquery.inputmask.bundle.min.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/common/js/searchDialog.js"></script>
<script type="text/javascript" src="<%=base%>/static/plugins/contextmenu/jquery.contextMenu.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/formUtils.js"></script>
<script type="text/javascript" src="<%=base%>/common/js/activiti.js"></script>
<script type="text/javascript" src="<%=base%>/views/manage/finance/collection/js/processInvoice.js"></script>
<script type="text/javascript" src="<%=base%>/static/js/layer/layer.js"></script>

</body>
</html>